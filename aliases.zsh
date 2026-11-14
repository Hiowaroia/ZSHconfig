# ==============================================================================
# Editor selection & wrappers
# ==============================================================================

# Pick an editor for this session (Enter keeps the current one).
choose-editor() {
  local choice
  read "choice?Editor: [n]ano / n[v]im / [k]ate / [m]icro (current: $EDITOR): "

  case "${choice:l}" in
    n|nano)     export EDITOR=nano ;;
    v|nvim|vim) export EDITOR=nvim ;;
    k|kate)     export EDITOR=kate ;;
    m|micro)    export EDITOR=micro ;;
    "")         ;;
    *)          echo "Unknown choice, keeping $EDITOR" ;;
  esac

  export VISUAL=$EDITOR
}

# Edit as current user. ${=EDITOR} splits flags stored in $EDITOR.
edit() {
  choose-editor
  ${=EDITOR} "$@"
}

# Edit as root. GUI editors (Kate) run directly and ask for auth themselves.
edit-sudo() {
  choose-editor
  case "$EDITOR" in
    kate*) ${=EDITOR} "$@" ;;
    *)     sudo ${=EDITOR} "$@" ;;
  esac
}

# ==============================================================================
# Display & terminal
# ==============================================================================

alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Fastfetch, wait for a key, then reset the terminal.
alias cff='clear && fastfetch && read -k 1 -s -r && reset'

alias matrix='cmatrix -as'

# ==============================================================================
# System maintenance
# ==============================================================================

# Update everything make a log file in ~/Documents/update-logs.
upd() {
  local log=~/Documents/update-logs/$(date +%F_%H-%M-%S).log
  mkdir -p ${log:h}
  {
    sudo sh -c 'pacman -Syu --noconfirm; flatpak update -y'
    flatpak update --user -y
  } 2>&1 | tee $log
  return 0
}

alias shut='systemctl poweroff'

# Reboot into Windows once
windows() {
  local num
  num=$(efibootmgr | awk '/Windows Boot Manager/ {gsub(/Boot|\*/,"",$1); print $1; exit}')
  [[ -n $num ]] || { print -u2 "No Windows Boot Manager entry in NVRAM"; return 1 }
  sudo efibootmgr --bootnext "$num" && systemctl reboot
}

alias uefi='systemctl reboot --firmware-setup'
alias soft-reboot='systemctl soft-reboot'

# ==============================================================================
# Config editing (root)
# ==============================================================================

alias limine-config='edit-sudo /boot/limine.conf'
alias nano-config-global='edit-sudo /etc/nanorc'
alias pacman-config='edit-sudo /etc/pacman.conf'

# ==============================================================================
# Config editing (user)
# ==============================================================================

alias fastfetch-config='edit ~/.config/fastfetch/config.jsonc'
alias kitty-config='edit ~/.config/kitty/kitty.conf'
alias micro-config-settings='edit ~/.config/micro/settings.json'
alias micro-config-bindings='edit ~/.config/micro/bindings.json'

# ==============================================================================
# Zsh config
# ==============================================================================

: ${ZSH_FILE:=aliases}

# Pick and edit a modular Zsh config file (Enter keeps the last chosen one).
zsh-config() {
  [[ -d $ZSH_FOLDER ]] || { print -u2 "ZSH_FOLDER missing or not a directory: '$ZSH_FOLDER'"; return 1 }

  local choice
  read "choice?File:   [m]ain / [a]liases / [k]eybinds / p[l]ugins / p[r]ompt (default: $ZSH_FILE): "

  case "${choice:l}" in
    m|main)         ZSH_FILE="main"      ;;
    a|aliases)      ZSH_FILE="aliases"   ;;
    k|keybinds)     ZSH_FILE="keybinds"  ;;
    l|plugins)      ZSH_FILE="plugins"   ;;
    r|prompt)       ZSH_FILE="prompt"    ;;
    "")             ;;
    *)              echo "Unknown choice, editing $ZSH_FILE" ;;
  esac

  edit "$ZSH_FOLDER/$ZSH_FILE.zsh"
}

# Restart zsh to apply config changes.
alias zsh-reload='exec zsh'
