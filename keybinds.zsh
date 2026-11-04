# ==============================================================================
# ZSH Line Editor (ZLE) Keybindings & Text Selection
# ==============================================================================

# --- Jump by word (Ctrl + Left / Right) ---
# Note: These initial bindings are technically overridden by the "Cancel selection"
# section below, which adds deselect functionality to the exact same keycodes.
bindkey '^[[1;5D' backward-word
bindkey '^[[1;5C' forward-word

# --- Select by word (Ctrl + Shift + Left / Right) ---
# Function to highlight text word-by-word moving backward
select-backward-word() {
  # If a selection (region) is NOT already active, set the mark (start selection)
  (( REGION_ACTIVE )) || zle set-mark-command
  # Move the cursor backward by one word, highlighting the text in between
  zle backward-word
}

# Function to highlight text word-by-word moving forward
select-forward-word() {
  (( REGION_ACTIVE )) || zle set-mark-command
  zle forward-word
}

# Register the shell functions as interactive ZLE widgets so they can be bound to keys
zle -N select-backward-word
zle -N select-forward-word

# Bind Ctrl + Shift + Left/Right to the custom selection widgets
bindkey '^[[1;6D' select-backward-word
bindkey '^[[1;6C' select-forward-word

# --- Cancel selection on normal movement ---
# Wrappers for standard movement that disable the selection highlight first
deselect-backward-char() { REGION_ACTIVE=0; zle backward-char }
deselect-forward-char()  { REGION_ACTIVE=0; zle forward-char }
deselect-backward-word() { REGION_ACTIVE=0; zle backward-word }
deselect-forward-word()  { REGION_ACTIVE=0; zle forward-word }

# Register the deselect functions as ZLE widgets
zle -N deselect-backward-char
zle -N deselect-forward-char
zle -N deselect-backward-word
zle -N deselect-forward-word

# Bind standard Left/Right arrows to clear selection and move by one character
# Both standard ANSI (^[[D) and Application mode (^[OD) escape sequences are bound
# to ensure compatibility across different terminal emulators (like WezTerm vs standard TTY)
bindkey '^[[D' deselect-backward-char
bindkey '^[OD' deselect-backward-char
bindkey '^[[C' deselect-forward-char
bindkey '^[OC' deselect-forward-char

# Bind Ctrl + Left/Right to clear selection and move by word
# (This overrides the basic backward-word/forward-word bound at the top of the file)
bindkey '^[[1;5D' deselect-backward-word
bindkey '^[[1;5C' deselect-forward-word

# --- Backspace deletes selection ---
# Overrides standard backspace to delete the entire highlighted block if one exists
backspace-or-delete-selection() {
  if (( REGION_ACTIVE )); then
    # If text is selected, delete the entire highlighted region
    zle kill-region
  else
    # Otherwise, perform a standard single-character backspace
    zle backward-delete-char
  fi
}

# Register the backspace replacement as a ZLE widget
zle -N backspace-or-delete-selection

# Bind the standard Backspace key (^?) to the custom widget
bindkey '^?' backspace-or-delete-selection
