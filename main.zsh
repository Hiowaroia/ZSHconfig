# ==============================================================================
# 1. HISTORY & SHELL OPTIONS
# ==============================================================================

# --- Command History ---
# Define where and how many terminal commands are saved in memory and on disk.
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000

# --- Shell Behaviors ---
# Beep on input errors in the Zsh line editor.
setopt beep
# Allow dynamic variable evaluation in the prompt (required for custom themes).
setopt PROMPT_SUBST

# ==============================================================================
# 2. AUTO-COMPLETION
# ==============================================================================

# Initialize the advanced Zsh tab-completion system.
autoload -Uz compinit
compinit

# Define the target file for Zsh's built-in compinstall tool.
zstyle :compinstall filename "$HOME/.zshrc"

# ==============================================================================
# 3. ENVIRONMENT VARIABLES
# ==============================================================================

# Set micro as the default text editor for system commands (like git or visudo).
export EDITOR=micro

# Enables true colour for Micro
export "MICRO_TRUECOLOR=1"

# ==============================================================================
# 4. EXTERNAL CONFIGURATIONS & MODULES
# ==============================================================================
# The configuration is split into separate files to keep .zshrc clean and readable.

# Load custom command shortcuts (aliases).
source "$HOME/.zsh/aliases.zsh"

# Load the visual layout and logic for the terminal prompt.
source "$HOME/.zsh/prompt.zsh"

# Load keyboard shortcuts.
# Note: This file uses `bindkey` commands to map specific keystrokes
# (e.g., Ctrl+Arrow, Home/End, Delete) to terminal actions.
source "$HOME/.zsh/keybinds.zsh"

# Load community plugins (e.g., syntax highlighting, autosuggestions).
source "$HOME/.zsh/plugins.zsh"

# ==============================================================================
# 5. STARTUP COMMANDS
# ==============================================================================

# Display system information script upon opening a new terminal session.
fastfetch --config shorty
