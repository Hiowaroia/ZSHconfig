# ==============================================================================
# Prompt & right-aligned timestamp
# ==============================================================================

# Needed so ${...} variables in PROMPT are evaluated on every redraw.
setopt PROMPT_SUBST

# Over SSH: green + "SSH" text. Locally: magenta + icon.
if [[ -n $SSH_CLIENT || -n $SSH_TTY || -n $SSH_CONNECTION ]]; then
  HOST_COLOR="#5CFF5C"
  PROMPT_LABEL="SSH"
else
  HOST_COLOR="#FF5CFF"
  PROMPT_LABEL=""
fi

PROMPT='%F{${HOST_COLOR}}%n@%m %h %~ %f
%B%F{#5C5CFF}${PROMPT_LABEL}%f%b %F{${HOST_COLOR}}%# %f'

# --- Timestamp line after each executed command ---
autoload -Uz add-zsh-hook
typeset -g _ts_cmd_ran=0

# Runs before a command: remember that one was executed.
_ts_preexec() { _ts_cmd_ran=1 }

# Runs before the prompt: print a right-aligned time (skipped on empty Enter).
_ts_precmd() {
  (( _ts_cmd_ran )) || return
  _ts_cmd_ran=0

  local text="[Timestamp: %*]"
  local evaluated="${(%):-$text}"   # expand %* to HH:MM:SS
  print -P "%F{${HOST_COLOR}}${(l:$COLUMNS:)evaluated}%f"   # pad to the right edge
}

add-zsh-hook preexec _ts_preexec
add-zsh-hook precmd _ts_precmd
