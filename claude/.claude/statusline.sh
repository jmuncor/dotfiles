#!/usr/bin/env bash
# Claude Code status line.
# Segments: model · effort | git(branch*↑↓) worktree +dirs | context% raw-tokens
#           | rate-limits 5h/7d (+reset) | cost $ + burn $/hr
# Reads session JSON from stdin (https://code.claude.com/docs/en/statusline)

input=$(cat)

# --- grab everything in one jq pass -----------------------------------------
# Join with US (\x1f), a non-whitespace control char. Unlike a tab it never
# collapses empty fields in `read`, and it can't show up in a real value.
IFS=$'\x1f' read -r \
  MODEL EFFORT SIZE USED_IN USED_OUT USEDPCT \
  CWD SID WORKTREE ADDED \
  H5_PCT H5_RESET D7_PCT D7_RESET \
  COST DURMS <<<"$(
  printf '%s' "$input" | jq -r '
    [ .model.display_name // .model.id // "?"
    , (.effort.level // "")
    , (.context_window.context_window_size // 200000)
    , (.context_window.total_input_tokens  // 0)
    , (.context_window.total_output_tokens // 0)
    , (.context_window.used_percentage
        // (100 - (.context_window.remaining_percentage // 100)))
    , (.workspace.current_dir // .cwd // "")
    , (.session_id // "")
    , (.workspace.git_worktree // "")
    , ((.workspace.added_dirs // []) | length)
    , (.rate_limits.five_hour.used_percentage // "")
    , (.rate_limits.five_hour.resets_at // "")
    , (.rate_limits.seven_day.used_percentage // "")
    , (.rate_limits.seven_day.resets_at // "")
    , (.cost.total_cost_usd // 0)
    , (.cost.total_duration_ms // 0)
    ] | map(tostring) | join("")'
)"

# numeric guards (empty -> safe defaults so the math never errors out)
SIZE=${SIZE:-200000}; USED_IN=${USED_IN:-0}; USED_OUT=${USED_OUT:-0}
USEDPCT=${USEDPCT:-0}; ADDED=${ADDED:-0}; COST=${COST:-0}; DURMS=${DURMS:-0}

# --- ANSI helpers ---
R=$'\033[0m'; B=$'\033[1m'; DIM=$'\033[2m'
GRN=$'\033[32m'; YEL=$'\033[33m'; RED=$'\033[31m'; CYN=$'\033[36m'; MAG=$'\033[35m'

group() {   # 54213 -> 54,213
  awk -v n="$1" 'BEGIN{ s=sprintf("%d",n); o="";
    while(length(s)>3){o=","substr(s,length(s)-2)o; s=substr(s,1,length(s)-3)} printf "%s%s",s,o }'
}
pctcolor() { # used% -> green<60, yellow<85, red
  if   [ "${1%.*}" -lt 60 ]; then printf '%s' "$GRN"
  elif [ "${1%.*}" -lt 85 ]; then printf '%s' "$YEL"
  else printf '%s' "$RED"; fi
}
reset_clock() { # unix-epoch [day] -> 3:45pm, or "Wed 3:45pm" with day flag
  local e=${1%.*}; [ -n "$e" ] || return
  # GNU date (Linux) uses -d @epoch; BSD date (macOS) uses -r epoch. Try both.
  local t; t=$(date -d "@$e" "+%l:%M%p" 2>/dev/null || date -r "$e" "+%l:%M%p" 2>/dev/null) || return
  t="${t// /}"; t=$(printf '%s' "$t" | tr '[:upper:]' '[:lower:]')
  local d=""
  [ -n "$2" ] && d="$(date -d "@$e" "+%a" 2>/dev/null || date -r "$e" "+%a" 2>/dev/null) "
  printf '%s%s' "$d" "$t"
}

SEGS=()

# 7) git branch / dirty / ahead-behind (cached per session, 3s TTL) -----------
git_info() {
  [ -n "$CWD" ] || return
  local cache="${TMPDIR:-/tmp}/cc-sl-git-${SID:-x}"
  if [ -f "$cache" ]; then
    local age=$(( $(date +%s) - $(stat -c %m "$cache" 2>/dev/null || stat -f %m "$cache" 2>/dev/null || echo 0) ))
    [ "$age" -lt 3 ] && { cat "$cache"; return; }
  fi
  local out
  out=$(
    cd "$CWD" 2>/dev/null || exit 0
    git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
    b=$(git branch --show-current 2>/dev/null)
    [ -z "$b" ] && b=$(git rev-parse --short HEAD 2>/dev/null)
    d=""; [ -n "$(git status --porcelain 2>/dev/null)" ] && d="*"
    ab=$(git rev-list --count --left-right '@{upstream}...HEAD' 2>/dev/null)
    t=""
    if [ -n "$ab" ]; then
      read -r behind ahead <<<"$ab"
      [ "${ahead:-0}" -gt 0 ] 2>/dev/null && t+="↑${ahead}"
      [ "${behind:-0}" -gt 0 ] 2>/dev/null && t+="↓${behind}"
    fi
    printf '%s%s%s' "$b" "$d" "${t:+ $t}"
  )
  printf '%s' "$out" >"$cache"
  printf '%s' "$out"
}
GIT=$(git_info)
gseg=""
[ -n "$GIT" ] && gseg="${CYN}⎇ ${GIT}${R}"
# 4) worktree + added dirs
[ -n "$WORKTREE" ] && gseg+="${gseg:+ }${MAG}⑂${WORKTREE}${R}"
[ "${ADDED:-0}" -gt 0 ] 2>/dev/null && gseg+="${gseg:+ }${DIM}+${ADDED}dir${R}"
[ -n "$gseg" ] && SEGS+=("$gseg")

# model + effort --------------------------------------------------------------
seg="${MODEL}${R}"
[ -n "$EFFORT" ] && seg+=" ${DIM}·${EFFORT}${R}"
SEGS+=("$seg")

# context: used% colored + raw tokens ----------------------------------------
USED=$(( USED_IN + USED_OUT ))
if   [ "${USEDPCT%.*}" -lt 15 ]; then CC=$GRN
elif [ "${USEDPCT%.*}" -lt 60 ]; then CC=$YEL
else CC=$RED; fi
SEGS+=("${CC}${USEDPCT%.*}% used${R}  ${DIM}$(group "$USED")/$(group "$SIZE") tokens${R}")

# 1b) rate limits 5h / 7d (Pro/Max only; absent for API) ----------------------
rl=""
if [ -n "$H5_PCT" ]; then
  rl="$(pctcolor "$H5_PCT")5h ${H5_PCT%.*}%${R}"
  c=$(reset_clock "$H5_RESET"); [ -n "$c" ] && rl+="${DIM} ${c}${R}"
fi
if [ -n "$D7_PCT" ]; then
  rl+="${rl:+ ${DIM}·${R} }$(pctcolor "$D7_PCT")7d ${D7_PCT%.*}%${R}"
  c=$(reset_clock "$D7_RESET" day); [ -n "$c" ] && rl+="${DIM} ${c}${R}"
fi
[ -n "$rl" ] && SEGS+=("$rl")

# --- join with a padded separator -------------------------------------------
out=""
for s in "${SEGS[@]}"; do out+="${out:+  ${DIM}|${R}  }$s"; done
printf '%b\n' "$out"
