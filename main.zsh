# ==============================================================================
# Main config (~/.zshrc)
# ==============================================================================

# Profiling: uncomment, restart zsh, then run `zprof`.
# zmodload zsh/zprof

# --- History ---
HISTFILE=~/.histfile
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS HIST_IGNORE_SPACE HIST_REDUCE_BLANKS SHARE_HISTORY

# --- Shell options ---
unsetopt beep
setopt AUTO_CD INTERACTIVE_COMMENTS

# --- Completion ---
# Rebuild the dump at most once a day, otherwise use the cache.
# After installing new packages: rm ~/.zcompdump && exec zsh
autoload -Uz compinit
_zcd=(${ZDOTDIR:-$HOME}/.zcompdump(N.mh+24))
if (( $#_zcd )); then compinit; else compinit -C; fi
unset _zcd

zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# --- Environment ---
export EDITOR=micro
export VISUAL=$EDITOR
export MICRO_TRUECOLOR=1

# --- Setting this config files location into variable ---
ZSH_FOLDER=${${(%):-%x}:A:h}

# --- Modules (order matters: keybinds before plugins) ---
source "$ZSH_FOLDER/aliases.zsh"
source "$ZSH_FOLDER/prompt.zsh"
source "$ZSH_FOLDER/keybinds.zsh"
source "$ZSH_FOLDER/plugins.zsh"

# --- Startup ---
(( $+commands[fastfetch] )) && fastfetch --config shorty
