import { Plugin } from "@opencode/plugin/tui"
import type { UsageLimitsInfo } from "@opencode/client"
import { createMemo, createSignal, For, onCleanup, onMount, Show } from "solid-js"

/**
 * Go Usage
 *
 * Renders the OpenCode Go allowance meters at the top of the session
 * sidebar, above the context bar: rolling (5-hour), weekly, and monthly.
 *
 * Data comes from the server's usage-limits endpoint, which reads the
 * OpenCode Console workspace this location is signed in to. It returns
 * null without a Console sign-in, so the block asks for one instead of
 * showing empty bars.
 *
 * Customization points are the constants below.
 */

/** Bar width in terminal cells. Sidebar content width is about 37 cells. */
const BAR_WIDTH = 18
/** Percent at which a bar switches to the warning color. */
const WARN_AT = 70
/** Percent at which a bar switches to the error color. */
const ERROR_AT = 90
/** How often to refresh while the sidebar is open. */
const REFRESH_MS = 120_000
/** Width of the meter label column, before its trailing space. */
const LABEL_WIDTH = 7

type Meter = { label: string; percent: number; limited: boolean }

function meters(info: UsageLimitsInfo): Meter[] {
  const go = info.go
  if (!go) return []
  return [
    { label: "5-hour", percent: go.rolling.percent, limited: go.rolling.limited },
    { label: "Weekly", percent: go.weekly.percent, limited: go.weekly.limited },
    { label: "Monthly", percent: go.monthly.percent, limited: go.monthly.limited },
  ]
}

export function GoUsage(props: { context: Plugin.Context }) {
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
    const timer = setInterval(load, REFRESH_MS)
    onCleanup(() => clearInterval(timer))
    // Usage moves with each completed turn; refresh then rather than only on the timer.
    onCleanup(props.context.data.on("session.execution.succeeded", () => load()))
  })

  const rows = createMemo(() => {
    const value = info()
    return value ? meters(value) : []
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
              const filled = Math.round((percent / 100) * BAR_WIDTH)
              const color =
                meter.limited || percent >= ERROR_AT
                  ? theme.text.feedback.error.base
                  : percent >= WARN_AT
                    ? theme.text.feedback.warning.base
                    : theme.hue.accent[500]
              return (
                <text wrapMode="none">
                  <span style={{ fg: theme.text.muted }}>{`${meter.label.padEnd(LABEL_WIDTH)} `}</span>
                  <span style={{ fg: color }}>{"█".repeat(filled)}</span>
                  <span style={{ fg: theme.text.muted }}>{"░".repeat(BAR_WIDTH - filled)}</span>
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

export default Plugin.define({
  id: "research.go-usage",
  setup(context) {
    context.ui.slot({
      prepend: "sidebar.content",
      render: () => <GoUsage context={context} />,
    })
  },
})
