import { Plugin } from "@opencode/plugin/tui"
import type { ModelInfo, SessionMessageInfo, UsageLimitsInfo } from "@opencode/client"
import { createMemo, createSignal, For, onCleanup, onMount, Show } from "solid-js"

/**
 * Usage Bars
 *
 * Renders the OpenCode Go allowance meters and the context-window usage bar
 * at the top of the session sidebar's content area (via `prepend`): directly
 * under the session title. The built-in Context block is disabled in
 * cli.json so these labeled bars replace it. Go Limits comes first so the
 * subscription meters stay above the per-session bar.
 *
 * Both bars live in one contribution because slot placements have no order
 * control: two plugins that both prepend render in plugin enable order, which
 * is the alphabetical order of their directories.
 *
 * Customization points are the constants below.
 */

/** Bar width in terminal cells. Sidebar content width is about 37 cells. */
const BAR_WIDTH = 18
/** Width of the label column, before its trailing space. */
const LABEL_WIDTH = 7
/** Width of the right-aligned percentage field, sized for "100%". */
const PERCENT_WIDTH = 4
/** Percent at which a bar switches to the warning color. */
const WARN_AT = 70
/** Percent at which a bar switches to the error color. */
const ERROR_AT = 90
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

/**
 * One bar row. The label column and percentage field are fixed width, so
 * every row ends its bar and its percentage in the same terminal column.
 */
function UsageBar(props: {
  theme: Plugin.Context["theme"]
  percent: number
  limited?: boolean
  label: string
}) {
  const percent = Math.min(100, Math.max(0, Math.round(props.percent)))
  const filled = Math.round((percent / 100) * BAR_WIDTH)
  const color =
    props.limited || percent >= ERROR_AT
      ? props.theme.text.feedback.error.base
      : percent >= WARN_AT
        ? props.theme.text.feedback.warning.base
        : props.theme.hue.accent[500]
  return (
    <text wrapMode="none">
      <span style={{ fg: props.theme.text.muted }}>{`${props.label.padEnd(LABEL_WIDTH)} `}</span>
      <span style={{ fg: color }}>{"█".repeat(filled)}</span>
      <span style={{ fg: props.theme.text.muted }}>{"░".repeat(BAR_WIDTH - filled)}</span>
      <span style={{ fg: props.theme.text.muted }}>{` ${`${percent}%`.padStart(PERCENT_WIDTH)}`}</span>
    </text>
  )
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
          <b>Go Limits</b>
        </text>
        <Show when={info()} fallback={<text fg={theme.text.muted}>Sign in to Console with /connect</text>}>
          <For each={rows()}>
            {(meter) => (
              <UsageBar
                theme={theme}
                label={meter.label}
                percent={meter.percent}
                limited={meter.limited}
              />
            )}
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
    return { percent: state.percent }
  })

  return (
    <>
      <GoUsage context={props.context} />
      <Show when={bar()}>
        {(value) => <UsageBar theme={theme} label="Context" percent={value().percent} />}
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
