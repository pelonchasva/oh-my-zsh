#!/usr/bin/env bash
# Oh My Zsh + Powerlevel10k setup script
# Author: Andres Valencia
# --------------------------------------------------

set -e

# === CONFIGURATION ===
ZSHRC_URL="https://raw.githubusercontent.com/pelonchasva/oh-my-zsh/main/.zshrc"
# Optional: use raw URLs for any custom additions
# CUSTOM_ALIASES_URL="https://raw.githubusercontent.com/pelonchasva/oh-my-zsh/main/aliases.zsh"

# === DEPENDENCIES ===
if command -v apt >/dev/null 2>&1; then
    echo "Installing dependencies (apt)..."
    sudo apt update && sudo apt install -y zsh git curl fonts-powerline
elif command -v apk >/dev/null 2>&1; then
    echo "Installing dependencies (apk)..."
    sudo apk add zsh git curl
elif command -v dnf >/dev/null 2>&1; then
    echo "Installing dependencies (dnf)..."
    sudo dnf install -y zsh git curl
else
    echo "❌ Unsupported package manager. Install zsh, git, and curl manually."
    exit 1
fi

# === OH MY ZSH ===
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing Oh My Zsh..."
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes \
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh already installed."
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

# === PLUGINS ===
echo "Installing plugins..."
# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions"
else
    echo "zsh-autosuggestions already installed."
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting"
else
    echo "zsh-syntax-highlighting already installed."
fi

# === POWERLEVEL10K ===
echo "Installing Powerlevel10k..."
if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git "$ZSH_CUSTOM/themes/powerlevel10k"
else
    echo "Powerlevel10k already installed."
fi

# === CONFIG ===
echo "Downloading your .zshrc..."
curl -fsSL "$ZSHRC_URL" -o "$HOME/.zshrc"

# (Optional) include extra configs, e.g. aliases
# if [ -n "$CUSTOM_ALIASES_URL" ]; then
#     curl -fsSL "$CUSTOM_ALIASES_URL" -o "$HOME/.aliases.zsh"
# fi

# === FONTS ===
echo "Installing MesloLGS NF fonts (for Powerlevel10k)..."
FONT_DIR="$HOME/.local/share/fonts"
mkdir -p "$FONT_DIR"
for font in Regular Bold Italic 'Bold Italic'; do
    curl -fsSL "https://github.com/romkatv/powerlevel10k-media/raw/master/MesloLGS%20NF%20${font}.ttf" \
        -o "$FONT_DIR/MesloLGS NF ${font}.ttf"
done
fc-cache -fv >/dev/null 2>&1 || true

# === SHELL ===
if [ "$SHELL" != "$(command -v zsh)" ]; then
    echo "Changing default shell to Zsh..."
    chsh -s "$(command -v zsh)" "$USER" || echo "Could not change shell automatically."
fi

echo
echo "✅ All done!"
echo "Please ensure your terminal font is set to: MesloLGS NF"
echo "Then restart your shell with: zsh"
echo
echo "If Powerlevel10k doesn't configure automatically, run: p10k configure"
