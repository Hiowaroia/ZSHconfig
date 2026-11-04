# ==============================================================================
# ZSH Plugin Management (Arch Linux Native Packages)
# ==============================================================================

# Define a temporary variable pointing to the standard Arch Linux directory
# where pacman installs ZSH plugins
plugins_dir=/usr/share/zsh/plugins

# ------------------------------------------------------------------------------
# 1. Zsh Autosuggestions (Fish-like history suggestions)
# ------------------------------------------------------------------------------

# By default, zsh-autosuggestions accepts a suggestion when you press Right Arrow.
# Because you rebound Right Arrow to your custom 'deselect-forward-char' widget
# in the keybinds config, you must explicitly tell the plugin to accept
# suggestions when that custom widget fires.
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS+=(deselect-forward-char)

# Similarly, tell the plugin to partially accept a suggestion (word-by-word)
# when you press Ctrl + Right Arrow (which triggers 'deselect-forward-word')[cite: 1].
ZSH_AUTOSUGGEST_PARTIAL_ACCEPT_WIDGETS+=(deselect-forward-word)

# Check if the autosuggestions script exists and is readable (-r) before sourcing it.
# This prevents shell startup errors if the package is uninstalled or missing.
if [[ -r $plugins_dir/zsh-autosuggestions/zsh-autosuggestions.zsh ]]; then
  source $plugins_dir/zsh-autosuggestions/zsh-autosuggestions.zsh
fi

# ------------------------------------------------------------------------------
# 2. Zsh Syntax Highlighting
# ------------------------------------------------------------------------------

# Check and load the syntax highlighting plugin.
# CRITICAL: This must always be the absolute LAST plugin sourced in your overall ZSH
# configuration. It needs to intercept and wrap all previously defined ZLE
# widgets to properly analyze and highlight syntax as you type.
if [[ -r $plugins_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]]; then
  source $plugins_dir/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ------------------------------------------------------------------------------
# 3. Environment Cleanup
# ------------------------------------------------------------------------------

# Remove the temporary directory variable from memory so it doesn't pollute
# your global shell environment variables.
unset plugins_dir
