#!/bin/bash
set -euo pipefail

HOOKS_DIR="$(cd "$(dirname "$0")" && pwd)"
CONFIG="$HOOKS_DIR/config/hooks-config.json"

input=$(cat)
[ -z "$input" ] && exit 0

event=$(echo "$input" | jq -r '.hook_event_name // empty')
[ -z "$event" ] && exit 0

# Check if this hook is disabled
disabled=$(jq -r --arg key "disable${event}Hook" '.[$key] // false' "$CONFIG")
[ "$disabled" = "true" ] && exit 0

# Determine sound name
sound_name=""
case "$event" in
    SessionStart)     sound_name="sessionstart" ;;
    SessionEnd)       sound_name="sessionend" ;;
    UserPromptSubmit) sound_name="userpromptsubmit" ;;
    PreToolUse)       sound_name="pretooluse" ;;
    PostToolUse)      sound_name="posttooluse" ;;
    Notification)     sound_name="notification" ;;
    Stop)             sound_name="stop" ;;
    SubagentStop)     sound_name="subagentstop" ;;
    PreCompact)       sound_name="precompact" ;;
    *) exit 0 ;;
esac

# Special sound for git commit
if [ "$event" = "PreToolUse" ]; then
    tool=$(echo "$input" | jq -r '.tool_name // empty')
    if [ "$tool" = "Bash" ]; then
        cmd=$(echo "$input" | jq -r '.tool_input.command // empty')
        if echo "$cmd" | grep -q 'git commit'; then
            sound_name="pretooluse-git-committing"
        fi
    fi
fi

# Play sound (fire and forget)
folder="${sound_name%%-*}"
sound_dir="$HOOKS_DIR/sounds/$folder"
for ext in wav mp3; do
    file="$sound_dir/$sound_name.$ext"
    if [ -f "$file" ]; then
        afplay "$file" &
        exit 0
    fi
done
