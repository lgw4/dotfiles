#!/usr/bin/env sh
# restore-default-model.sh — SessionStart hook for Claude Code.
#
# Typed `/model <name>` (and the picker's Enter) persists itself as the new
# default by writing the "model" key in ~/.claude/settings.json (v2.1.153+).
# This hook undoes an accidental save so the NEXT session starts on opusplan
# again. It cannot change the model of the session that just started; settings
# are snapshotted before SessionStart hooks fire.
#
# For a session-only model switch that never touches the default, use the
# /model picker and press `s` instead of Enter.
#
# To change the real default, edit DEFAULT_MODEL here, or remove this hook
# from the "hooks" key in ~/.claude/settings.json.

set -eu

DEFAULT_MODEL="opusplan"
SETTINGS="$HOME/.claude/settings.json"

if [ ! -f "$SETTINGS" ]; then
  exit 0
fi

current=$(jq -r '.model // ""' "$SETTINGS")
if [ "$current" = "$DEFAULT_MODEL" ]; then
  exit 0
fi

tmp=$(mktemp "$SETTINGS.XXXXXX")
jq --arg m "$DEFAULT_MODEL" '.model = $m' "$SETTINGS" > "$tmp"
mv "$tmp" "$SETTINGS"
printf '{"systemMessage": "Default model restored to %s for future sessions"}\n' "$DEFAULT_MODEL"
