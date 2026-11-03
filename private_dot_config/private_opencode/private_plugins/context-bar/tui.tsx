import { Plugin } from "@opencode/plugin/tui"
import type { ModelInfo, SessionMessageInfo, UsageLimitsInfo } from "@opencode/client"
import { createMemo, createSignal, For, onCleanup, onMount, Show } from "solid-js"

/**
 * Usage Bars
 *
 * Renders the OpenCode Go allowance meters and the context-window usage bar
 * at the top of the session sidebar's content area (via `prepend`): directly
 * under the session title, above the built-in Context block. Go comes first
 * so the subscription meters stay above the per-session bar.
 *
 * Both bars live in one contribution because slot placements have no order
 * control: two plugins that both prepend render in plugin enable order, which
 * is the alphabetical order of their directories.
 *
 * Customization points are the constants below.
 */

/** Context bar width in terminal cells. Sidebar content width is about 37 cells. */
const BAR_WIDTH = 24
/** Percent at which a bar switches to the warning color. */
const WARN_AT = 70
/** Percent at which a bar switches to the error color. */
const ERROR_AT = 90
/** Go meter bar width, shorter than the context bar to leave room for labels. */
const GO_BAR_WIDTH = 18
/** Width of the Go meter label column, before its trailing space. */
const GO_LABEL_WIDTH = 7
/** How often the Go meters refresh while the sidebar is open. */
const GO_REFRESH_MS = 120_000

/**
 * Mirrors the TUI's own contextUsage(): the step whose tokens fill the
 * context window now is the latest assistant message with usage, after the
 * last completed compaction and before the revert boundary.
 *
 * Reimplemented here because the originals live outside the plugin API:
 * packages/tui/src/util/session.ts and packages/client/src/solid/usage.ts.
 */
function contextUsage(
  messages: ReadonlyArray<SessionMessageInfo>,
  models: ReadonlyArray<ModelInfo> | undefined,
  boundary?: string,
): { tokens: number; percent: number | undefined } | undefined {
  const boundaryIndex = boundary ? messages.findIndex((message) => message.id === boundary) : -1
  if (boundary && boundaryIndex === -1) return undefined
  const end = boundaryIndex === -1 ? messages.length : boundaryIndex

  let compactionIndex = -1
  for (let index = end - 1; index >= 0; index--) {
    const message = messages[index]
    if (message.type === "compaction" && message.status === "completed") {
      compactionIndex = index
      break
    }
  }

  for (let index = end - 1; index > compactionIndex; index--) {
    const message = messages[index]
    if (message.type !== "assistant" || !message.tokens) continue
    const tokens =
      message.tokens.input +
      message.tokens.output +
      message.tokens.reasoning +
      message.tokens.cache.read +
      message.tokens.cache.write
    if (tokens <= 0) return undefined
    const model = models?.find(
      (candidate) => candidate.providerID === message.model?.providerID && candidate.id === message.model?.id,
    )
    const limit = model?.limit?.context
    return { tokens, percent: limit ? Math.round((tokens / limit) * 100) : undefined }
  }
  return undefined
}

type GoMeter = { label: string; percent: number; limited: boolean }

function goMeters(info: UsageLimitsInfo): GoMeter[] {
  const go = info.go
  if (!go) return []
  return [
    { label: "5-hour", percent: go.rolling.percent, limited: go.rolling.limited },
    { label: "Weekly", percent: go.weekly.percent, limited: go.weekly.limited },
    { label: "Monthly", percent: go.monthly.percent, limited: go.monthly.limited },
  ]
}

/**
 * The OpenCode Go allowance meters: rolling (5-hour), weekly, and monthly.
 *
 * Data comes from the server's usage-limits endpoint, which reads the
 * OpenCode Console workspace this location is signed in to. It returns null
 * without a Console sign-in, so the block asks for one instead of showing
 * empty bars.
 */
function GoUsage(props: { context: Plugin.Context }) {
  const theme = props.context.theme
  const [info, setInfo] = createSignal<UsageLimitsInfo | null>()

  const load = () => {
    const location = props.context.location ?? props.context.data.location.default()
    void props.context.client.experimental.usage.limits({ location })
      .then((response) => setInfo(response.data))
      .catch(() => undefined)
  }

  onMount(() => {
    load()
    const timer = setInterval(load, GO_REFRESH_MS)
    onCleanup(() => clearInterval(timer))
    // Usage moves with each completed turn; refresh then rather than only on the timer.
    onCleanup(props.context.data.on("session.execution.succeeded", () => load()))
  })

  const rows = createMemo(() => {
    const value = info()
    return value ? goMeters(value) : []
  })

  // Nothing to show while loading. Once loaded, null means no Console sign-in
  // (ask for one) and an info without Go meters means the workspace has no Go
  // allowance (hide the block rather than leave a bare header).
  const visible = createMemo(() => {
    const value = info()
    return value === undefined ? false : value === null || value.go !== undefined
  })

  return (
    <Show when={visible()}>
      <box>
        <text fg={theme.text.base}>
          <b>Go</b>
        </text>
        <Show when={info()} fallback={<text fg={theme.text.muted}>Sign in to Console with /connect</text>}>
          <For each={rows()}>
            {(meter) => {
              const percent = Math.min(100, Math.max(0, Math.round(meter.percent)))
              const filled = Math.round((percent / 100) * GO_BAR_WIDTH)
              const color =
                meter.limited || percent >= ERROR_AT
                  ? theme.text.feedback.error.base
                  : percent >= WARN_AT
                    ? theme.text.feedback.warning.base
                    : theme.hue.accent[500]
              return (
                <text wrapMode="none">
                  <span style={{ fg: theme.text.muted }}>{`${meter.label.padEnd(GO_LABEL_WIDTH)} `}</span>
                  <span style={{ fg: color }}>{"█".repeat(filled)}</span>
                  <span style={{ fg: theme.text.muted }}>{"░".repeat(GO_BAR_WIDTH - filled)}</span>
                  <span style={{ fg: theme.text.muted }}>{` ${percent}%`}</span>
                </text>
              )
            }}
          </For>
        </Show>
      </box>
    </Show>
  )
}

export function ContextBar(props: { context: Plugin.Context; sessionID: string }) {
  const theme = props.context.theme

  const usage = createMemo(() => {
    const messages = props.context.data.session.message.list(props.sessionID) ?? []
    const session = props.context.data.session.get(props.sessionID)
    const models = props.context.data.location.model.list(session?.location)
    return contextUsage(messages, models, session?.revert?.messageID)
  })

  const bar = createMemo(() => {
    const state = usage()
    // A bar needs a scale; without the model's context limit there is none.
    // The built-in Context block still shows the raw token count in that case.
    if (!state || state.percent === undefined) return undefined
    const percent = state.percent
    const filled = Math.round((Math.min(100, Math.max(0, percent)) / 100) * BAR_WIDTH)
    const color =
      percent >= ERROR_AT
        ? theme.text.feedback.error.base
        : percent >= WARN_AT
          ? theme.text.feedback.warning.base
          : theme.hue.accent[500]
    return { percent, filled, color }
  })

  return (
    <>
      <GoUsage context={props.context} />
      <Show when={bar()}>
        {(value) => (
          <text wrapMode="none">
            <span style={{ fg: value().color }}>{"█".repeat(value().filled)}</span>
            <span style={{ fg: theme.text.muted }}>{"░".repeat(BAR_WIDTH - value().filled)}</span>
            <span style={{ fg: theme.text.muted }}>{` ${value().percent}%`}</span>
          </text>
        )}
      </Show>
    </>
  )
}

export default Plugin.define({
  id: "research.context-bar",
  setup(context) {
    context.ui.slot({
      prepend: "sidebar.content",
      render: (props) => <ContextBar context={context} sessionID={props.sessionID} />,
    })
  },
})
