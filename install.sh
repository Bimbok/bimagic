#!/bin/bash

# Exit on error
set -e

# GitHub repository URL
REPO_URL="https://github.com/Bimbok/bimagic.git"

# Check for required tools
if ! command -v git &> /dev/null; then
    echo "Error: git is not installed. Please install git first."
    exit 1
fi

# Function to install gum
install_gum() {
    echo "🔍 Checking for supported package managers to install gum..."

    if command -v brew &> /dev/null; then
        echo "📦 Installing gum via Homebrew..."
        brew install gum
    elif command -v apt &> /dev/null; then
        echo "📦 Detected Ubuntu/Debian - Installing gum via Charm repository..."
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
        echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list
        sudo apt update && sudo apt install -y gum
    elif command -v pacman &> /dev/null; then
        echo "📦 Installing gum via pacman (Arch Linux)..."
        sudo pacman -S --noconfirm gum
    elif command -v nix-env &> /dev/null; then
        echo "📦 Installing gum via Nix..."
        nix-env -iA nixpkgs.gum
    elif command -v flox &> /dev/null; then
        echo "📦 Installing gum via Flox..."
        flox install gum
    elif command -v winget &> /dev/null; then
        echo "📦 Installing gum via WinGet..."
        winget install charmbracelet.gum
    elif command -v scoop &> /dev/null; then
        echo "📦 Installing gum via Scoop..."
        scoop install charm-gum
    else
        echo "❌ Could not find a supported package manager for automated gum installation."
        echo "Please install gum manually using instructions from: https://github.com/charmbracelet/gum"
        return 1
    fi
}

# Check for gum dependency
if ! command -v gum &> /dev/null; then
    echo "⚠️  gum is not installed. Bimagic requires gum for its modern UI."
    echo ""
    read -p "Do you want to automatically install gum? (Y/n): " -r auto_install_gum
    auto_install_gum=${auto_install_gum:-Y}  # Default to Y if empty
    
    if [[ $auto_install_gum =~ ^[Yy]$ ]]; then
        echo "🚀 Attempting to automatically install gum..."
        if install_gum; then
            echo "✅ gum installed successfully!"
        else
            echo "❌ Failed to install gum automatically."
            echo "Please install gum manually: https://github.com/charmbracelet/gum"
            exit 1
        fi
    else
        echo "Skipping gum installation. Bimagic will not work without it."
        exit 1
    fi
else
    echo "✅ gum is installed and ready"
fi

# Locate the bimagic script
if [ -f "./bimagic" ]; then
    echo "📦 Using local bimagic script..."
    SOURCE_PATH="./bimagic"
    IS_LOCAL=true
else
    echo "🌐 Cloning bimagic repository..."
    TEMP_DIR=$(mktemp -d)
    git clone "$REPO_URL" "$TEMP_DIR"
    SOURCE_PATH="$TEMP_DIR/bimagic"
    IS_LOCAL=false
fi

# Determine the target directory (prioritize ~/bin if it exists, else /usr/local/bin)
if [ -d "$HOME/bin" ] && [ -w "$HOME/bin" ]; then
    TARGET_DIR="$HOME/bin"
    USE_SUDO=false
else
    TARGET_DIR="/usr/local/bin"
    USE_SUDO=true
fi

# Ensure the target directory exists
if [ "$USE_SUDO" = true ]; then
    sudo mkdir -p "$TARGET_DIR"
else
    mkdir -p "$TARGET_DIR"
fi

# Copy the script and make it executable
if [ "$USE_SUDO" = true ]; then
    sudo cp "$SOURCE_PATH" "$TARGET_DIR/bimagic"
    sudo chmod +x "$TARGET_DIR/bimagic"
else
    cp "$SOURCE_PATH" "$TARGET_DIR/bimagic"
    chmod +x "$TARGET_DIR/bimagic"
fi

# Clean up if we cloned
if [ "$IS_LOCAL" = false ]; then
    rm -rf "$TEMP_DIR"
fi

echo "Successfully installed bimagic to $TARGET_DIR!"
echo "Please ensure GITHUB_USER and GITHUB_TOKEN are set as environment variables."

# Check if target directory is in PATH
if [[ ":$PATH:" != ":$TARGET_DIR:"* ]]; then
    echo "Note: $TARGET_DIR is not in your PATH. Add it to your shell profile:"
    echo "  echo 'export PATH=\"$PATH:$TARGET_DIR\"' >> ~/.bashrc"
    echo "  source ~/.bashrc"
fi