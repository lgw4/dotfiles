import { Plugin } from "@opencode/plugin/tui"
import type { ModelInfo, SessionMessageInfo } from "@opencode/client"
import { createMemo, Show } from "solid-js"

/**
 * Context Bar
 *
 * Renders a context-window usage bar at the top of the session sidebar's
 * content area (via `prepend`): directly under the session title, above the
 * built-in Context block. Reads the same data the built-in block uses, so
 * the two always agree.
 *
 * Customization points are the three constants below.
 */

/** Bar width in terminal cells. Sidebar content width is about 37 cells. */
const BAR_WIDTH = 24
/** Percent at which the bar switches to the warning color. */
const WARN_AT = 70
/** Percent at which the bar switches to the error color. */
const ERROR_AT = 90

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
    <Show when={bar()}>
      {(value) => (
        <text wrapMode="none">
          <span style={{ fg: value().color }}>{"█".repeat(value().filled)}</span>
          <span style={{ fg: theme.text.muted }}>{"░".repeat(BAR_WIDTH - value().filled)}</span>
          <span style={{ fg: theme.text.muted }}>{` ${value().percent}%`}</span>
        </text>
      )}
    </Show>
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
