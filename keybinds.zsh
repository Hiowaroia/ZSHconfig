# ==============================================================================
# ZLE keybindings: movement, selection, Delete/Home/End
# Normal (^[[) and application-mode (^[O) sequences are both bound, so this
# works across terminals (Kitty, WezTerm, TTY).
# ==============================================================================

# --- Selection widgets (set mark if needed, then move) ---
# Dot-prefixed widgets bypass autosuggestions, so selecting never accepts it.
select-backward-char() { (( REGION_ACTIVE )) || zle set-mark-command; zle .backward-char }
select-forward-char()  { (( REGION_ACTIVE )) || zle set-mark-command; zle .forward-char }
select-backward-word() { (( REGION_ACTIVE )) || zle set-mark-command; zle .backward-word }
select-forward-word()  { (( REGION_ACTIVE )) || zle set-mark-command; zle .forward-word }
select-to-line-start() { (( REGION_ACTIVE )) || zle set-mark-command; zle .beginning-of-line }
select-to-line-end()   { (( REGION_ACTIVE )) || zle set-mark-command; zle .end-of-line }

# --- Movement widgets (clear selection, then move) ---
deselect-backward-char()   { REGION_ACTIVE=0; zle backward-char }
deselect-forward-char()    { REGION_ACTIVE=0; zle forward-char }
deselect-backward-word()   { REGION_ACTIVE=0; zle backward-word }
deselect-forward-word()    { REGION_ACTIVE=0; zle forward-word }
deselect-beginning-of-line() { REGION_ACTIVE=0; zle beginning-of-line }
deselect-end-of-line()     { REGION_ACTIVE=0; zle end-of-line }

# --- Delete / Backspace remove the selection if there is one ---
backspace-or-delete-selection() {
  if (( REGION_ACTIVE )); then zle kill-region; else zle backward-delete-char; fi
}
delete-or-delete-selection() {
  if (( REGION_ACTIVE )); then zle kill-region; else zle delete-char; fi
}

# --- Typing replaces the selection ---
replace-selection-self-insert() {
  (( REGION_ACTIVE )) && zle kill-region
  zle .self-insert
}

zle -N select-backward-char
zle -N select-forward-char
zle -N select-backward-word
zle -N select-forward-word
zle -N select-to-line-start
zle -N select-to-line-end
zle -N deselect-backward-char
zle -N deselect-forward-char
zle -N deselect-backward-word
zle -N deselect-forward-word
zle -N deselect-beginning-of-line
zle -N deselect-end-of-line
zle -N backspace-or-delete-selection
zle -N delete-or-delete-selection
zle -N self-insert replace-selection-self-insert

# --- Bindings ---

# Left / Right
for k in '^[[D' '^[OD'; do bindkey $k deselect-backward-char; done
for k in '^[[C' '^[OC'; do bindkey $k deselect-forward-char;  done

# Ctrl + Left / Right
bindkey '^[[1;5D' deselect-backward-word
bindkey '^[[1;5C' deselect-forward-word

# Home / End
for k in '^[[H' '^[OH' '^[[1~'; do bindkey $k deselect-beginning-of-line; done
for k in '^[[F' '^[OF' '^[[4~'; do bindkey $k deselect-end-of-line;       done

# Shift + Left / Right / Home / End: select
bindkey '^[[1;2D' select-backward-char
bindkey '^[[1;2C' select-forward-char
bindkey '^[[1;2H' select-to-line-start
bindkey '^[[1;2F' select-to-line-end

# Ctrl + Shift + Left / Right: select by word
bindkey '^[[1;6D' select-backward-word
bindkey '^[[1;6C' select-forward-word

# Backspace / Delete
bindkey '^?'      backspace-or-delete-selection
bindkey '^[[3~'   delete-or-delete-selection

# Ctrl + Backspace / Delete (if the terminal sends these)
bindkey '^H'      backward-kill-word
bindkey '^[[3;5~' kill-word

unset k
