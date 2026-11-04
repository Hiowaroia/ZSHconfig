# ==============================================================================
# Interactive Text Editor Selection & Wrapper Functions
# ==============================================================================

# Prompts the user to select an editor and exports it to $EDITOR
choose_editor() {
  local choice
  # Prompt for user input
  read "choice?Editor [n]ano / n[v]im / [k]ate / [m]icro (default: $EDITOR): "

  case "${choice:l}" in
    v|nvim|nvim)        export EDITOR=nvim ;;     # Set Neovim for 'v', 'nvim' or 'vim'
    m|micro)            export EDITOR=micro ;;    # Set Micro for 'm' or 'micro'
    k|kate)             export EDITOR=kate ;;     # Set Kate GUI editor for 'k' or 'kate'
    n|nano)             export EDITOR=nano ;;     # Default to Nano for 'n', 'nano', or empty Return
    "")                 ;;                        # If left empty, does nothing, and so keeps $EDITOR as it was
    *)                  echo "Unknown choice, using $EDITOR"; ;; # PRetty much the same as above
  esac
}

# Opens target file(s) with chosen $EDITOR as current user
edit() {
  choose_editor
  ${=EDITOR} "$@"  # ${=EDITOR} enables word-splitting in ZSH to handle flags inside $EDITOR
}

# Opens target file(s) with root privileges (bypassing sudo for GUI editors like Kate)
edit_sudo() {
  choose_editor
  case "$EDITOR" in
    kate*) ${=EDITOR} "$@" ;;       # Run GUI editors directly (avoiding sudo GUI issues)
    *)     sudo ${=EDITOR} "$@" ;;  # Run CLI editors (nano/nvim) with elevated privileges
  esac
}

# ==============================================================================
# Display & Terminal Utilities
# ==============================================================================

# Enable automatic color output for file listings and pattern searches
alias ls='ls --color=auto'
alias grep='grep --color=auto'

# Display Fastfetch output, wait for any single keypress, then clear terminal state
alias cff='clear && fastfetch && read -k 1 -s -r && reset'

# Launch cmatrix in asynchronous scrolling mode with bold characters
alias matrix='cmatrix -as'

# ==============================================================================
# System Maintenance & Management
# ==============================================================================

# Synchronize and upgrade Flatpak applications and Pacman system packages
alias upd='sudo flatpak update -y && sudo pacman -Syu --noconfirm'

# Shut down the system immediately via systemd
alias shut='systemctl poweroff'

# Reboot directly into the Windows boot entry via systemd-boot's systemctl (currently not working, stil no idea why)
alias windows='systemctl reboot --boot-loader-entry=windows'

# Reboot into motherboard UEFI/BIOS firmware interface
alias uefi='systemctl reboot --firmware-setup'

# Perform a quick userspace soft-reboot without restarting hardware/kernel
alias soft-reboot='systemctl soft-reboot'

# ==============================================================================
# System Configuration Editing (Requires Root Privileges)
# ==============================================================================

# Edit Limine bootloader main configuration
alias limine-config='edit_sudo /boot/limine.conf'

# Edit global Nano text editor configuration
alias nano-config-global='edit_sudo /etc/nanorc'

# Edit Pacman package manager configuration
alias pacman-config='edit_sudo /etc/pacman.conf'

# ==============================================================================
# User Configuration Editing (No Root Required)
# ==============================================================================

# Edit Fastfetch configuration JSON file
alias fastfetch-config='edit ~/.config/fastfetch/config.jsonc'

# Edit local user-level Micro configuration
alias micro-config-settings='edit ~/.config/micro/settings.json'
alias micro-config-bindings='edit ~/.config/micro/bindings.json'

# ==============================================================================
# ZSH Shell Modular Configurations (Edit & Auto-Reload)
# ==============================================================================

# Edit primary ZSH configuration file and reload current shell environment
alias zsh-config='edit ~/.zshrc'

# Edit ZSH aliases module and reload shell environment
alias zsh-config-aliases='edit ~/.zsh/aliases.zsh'

# Edit ZSH prompt theme module and reload shell environment
alias zsh-config-prompt='edit ~/.zsh/prompt.zsh'

# Edit ZSH plugins module and reload shell environment
alias zsh-config-plugins='edit ~/.zsh/plugins.zsh'

# Edit ZSH keybindings module and reload shell environment
alias zsh-config-keybinds='edit ~/.zsh/keybinds.zsh'

# Reloads ZSH configuration after it was edited
alias zsh-reload='source ~/.zshrc'
