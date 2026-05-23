#!/usr/bin/env bash
# Stop hook: catch calendar-time work estimates ("3 hours", "a few days") in
# Claude's last assistant turn and ask it to redo the line in tokens.
#
# AI work isn't honestly measured in human calendar time. The only honest
# units are tokens (in + out) and how close to context/rate limits you're
# running. If Claude slips into "this'll take 2 weeks", bounce it.

set -uo pipefail

input="$(cat)"

# Prevent recursion: if we already blocked once this turn, don't re-trigger.
stop_hook_active="$(printf '%s' "$input" | jq -r '.stop_hook_active // false')"
if [[ "$stop_hook_active" = "true" ]]; then
  exit 0
fi

transcript_path="$(printf '%s' "$input" | jq -r '.transcript_path // empty')"
if [[ -z "$transcript_path" || ! -f "$transcript_path" ]]; then
  exit 0
fi

# Pull text from the most recent assistant turn only — scanning the whole
# transcript would re-fire on old offending lines forever.
last_assistant_text="$(
  tac "$transcript_path" \
    | jq -r 'select(.type == "assistant") | .message.content[]? | select(.type == "text") | .text' 2>/dev/null \
    | awk 'NR==1{block=$0; next} /^$/{print block; exit} {block=block"\n"$0} END{print block}'
)"

if [[ -z "$last_assistant_text" ]]; then
  exit 0
fi

# Match work-duration phrasing: an estimate verb / hedge near a calendar
# unit. Requiring an estimate context word ("take", "spend", "about", ...)
# keeps casual mentions ("3 days ago", "the 1990s") from tripping it.
pattern='\b(take[sn]?|takes|took|taking|spend(s|ing)?|spent|need(s|ed|ing)?|require(s|d|ment)?|estimate[sd]?|approximate(ly)?|about|roughly|around|maybe|probably|likely|in)\b[^.!?\n]{0,80}\b([0-9]+|a|an|few|couple|several|many)\s+(minute|hour|day|week|month|year)s?\b'

offending="$(printf '%s\n' "$last_assistant_text" | grep -iEo "$pattern" | head -3 || true)"
if [[ -z "$offending" ]]; then
  exit 0
fi

# exit 2 + stderr feeds the message back to Claude as blocking feedback.
{
  echo "Calendar-time estimate detected in your response:"
  while IFS= read -r line; do
    [[ -z "$line" ]] && continue
    printf '  - "%s"\n' "$line"
  done <<< "$offending"
  echo
  echo "AI work is not measured in hours/days/weeks. Redo the offending sentence(s) using:"
  echo "  - tokens consumed so far (input + output, approximate is fine)"
  echo "  - percentage of the context window used"
  echo "  - or 'one more turn' / 'a few tool calls' if the unit is steps, not time"
  echo "Do not restate calendar time. Just rewrite the line(s) and continue."
} >&2
exit 2
