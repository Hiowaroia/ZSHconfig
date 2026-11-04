# ==============================================================================
# Primary Prompt (PS1) Configuration & Theming
# ==============================================================================

# Enable variable and command substitution in the prompt string.
# This is required so variables like ${HOST_COLOR} are evaluated dynamically
# every time the prompt is drawn, rather than just once at startup.
setopt PROMPT_SUBST

# Check if the shell is connected via an active SSH session
# (SSH_CLIENT and SSH_TTY are environment variables set by the SSH daemon)
if [[ -n "$SSH_CLIENT" || -n "$SSH_TTY" ]]; then
  HOST_COLOR="#5CFF5C"    # Green color to indicate remote connection
  SSH_LABEL=" SSH"       # Include explicit 'SSH' text alongside the nerd font icon
else
  HOST_COLOR="#FF5CFF"    # Pink/Magenta color for local sessions
  SSH_LABEL=""           # Show just the icon for local sessions
fi

PROMPT='%F{${HOST_COLOR}}%n@%m %h %~ %f
%B%F{#5C5CFF}${SSH_LABEL}%f%b %F{${HOST_COLOR}}%# %f'


# ==============================================================================
# Right-Aligned Execution Timestamp (Precmd/Preexec Hooks)
# ==============================================================================

# Load Zsh's hook management utility securely (-U ignores aliases, -z uses zsh style)
autoload -Uz add-zsh-hook

# Declare a global (-g) variable to track if a command was actually executed
typeset -g command_was_run=0

# Hook function triggered just BEFORE a command is executed
mark_command_run() {
  command_was_run=1
}

# Hook function triggered just BEFORE the prompt is re-drawn on the screen
timestamp_after_command() {
  # If no command was run (e.g., user just pressed Enter on an empty line), exit early
  (( command_was_run )) || return

  # Reset the tracker for the next prompt cycle
  command_was_run=0

  # Define the timestamp string format (%* outputs current time as HH:MM:SS)
  local text="[Timestamp: %*]"

  # The (%) expansion flag forces Zsh to evaluate prompt escapes inside the string.
  # This converts the "%*" part of the string into the actual current time.
  local evaluated_text="${(%):-$text}"

  # The (l:$COLUMNS:) expansion flag pads the text to the left with spaces until
  # the total length equals the current width of the terminal ($COLUMNS).
  # This pushes the timestamp perfectly flush against the right edge of the window.
  local padded_text="${(l:$COLUMNS:)evaluated_text}"

  # Print the resulting padded string using prompt escapes (-P) and matching colors
  print -P "%F{${HOST_COLOR}}${padded_text}%f"
}

# Register the functions to their respective automated Zsh hooks
add-zsh-hook preexec mark_command_run
add-zsh-hook precmd timestamp_after_command
