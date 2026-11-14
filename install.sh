#!/bin/zsh
setopt ERR_EXIT

SRC_DIR=${0:A:h}
TARGET_FOLDER_LOCATION="$HOME/.config/zsh"
TARGET_ZSHRC_LOCATION="$HOME"

echo "This is a script for copying zsh config files into a designated place"

# Config folder (a typed leading ~ is expanded)
read "choice?Choose where to export the files (default: $TARGET_FOLDER_LOCATION): "
choice=${choice/#\~/$HOME}
TARGET_FOLDER_LOCATION=${choice:-$TARGET_FOLDER_LOCATION}

# .zshrc location
read "choice?Where do you want to place the .zshrc file? (default: $TARGET_ZSHRC_LOCATION): "
choice=${choice/#\~/$HOME}
TARGET_ZSHRC_LOCATION=${choice:-$TARGET_ZSHRC_LOCATION}

# Absolute paths, so the symlink can't dangle
TARGET_FOLDER_LOCATION=${TARGET_FOLDER_LOCATION:A}
TARGET_ZSHRC_LOCATION=${TARGET_ZSHRC_LOCATION:A}

# Copy first, link last
mkdir -p "$TARGET_FOLDER_LOCATION" "$TARGET_ZSHRC_LOCATION"
cp "$SRC_DIR"/{aliases,keybinds,main,plugins,prompt}.zsh "$TARGET_FOLDER_LOCATION"
ln -sf "$TARGET_FOLDER_LOCATION/main.zsh" "$TARGET_ZSHRC_LOCATION/.zshrc"

echo "Done. Restart zsh with: exec zsh"
