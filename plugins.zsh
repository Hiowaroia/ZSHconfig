# ==============================================================================
# Plugins (Arch packages)
# Load after keybinds.zsh. Syntax highlighting must stay the LAST plugin.
# ==============================================================================

plugins_dir=/usr/share/zsh/plugins

# --- zsh-autosuggestions ---
# Accept the suggestion on the custom widgets bound in keybinds.zsh:
# Right (full), End (full), Ctrl+Right (word).
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS+=(deselect-forward-char deselect-end-of-line)
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(deselect-forward-word)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)

# Bind widgets once instead of on every prompt (faster). If you change the
# widget lists later, run `_zsh_autosuggest_bind_widgets` or restart zsh.
ZSH_AUTOSUGGEST_MANUAL_REBIND=1

if [[ -r $plugins_dir/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source $plugins_dir/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# --- zsh-syntax-highlighting (must be last) ---
if [[ -r $plugins_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source $plugins_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

unset plugins_dir
