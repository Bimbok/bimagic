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

# Function to detect OS and install fzf
install_fzf() {
    echo "🔍 Detecting operating system for fzf..."
    
    # Detect OS
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        # Linux
        if command -v apt &> /dev/null; then
            echo "📦 Detected Ubuntu/Debian - Installing fzf via apt..."
            sudo apt update && sudo apt install -y fzf
        elif command -v dnf &> /dev/null; then
            echo "📦 Detected Fedora/CentOS/RHEL - Installing fzf via dnf..."
            sudo dnf install -y fzf
        elif command -v yum &> /dev/null; then
            echo "📦 Detected CentOS/RHEL (older) - Installing fzf via yum..."
            sudo yum install -y fzf
        elif command -v pacman &> /dev/null; then
            echo "📦 Detected Arch Linux - Installing fzf via pacman..."
            sudo pacman -S --noconfirm fzf
        elif command -v zypper &> /dev/null; then
            echo "📦 Detected openSUSE - Installing fzf via zypper..."
            sudo zypper install -y fzf
        else
            echo "⚠️  Could not detect package manager. Installing fzf from source..."
            install_fzf_from_source
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if command -v brew &> /dev/null; then
            echo "📦 Detected macOS with Homebrew - Installing fzf via brew..."
            brew install fzf
        else
            echo "⚠️  Homebrew not found. Installing fzf from source..."
            install_fzf_from_source
        fi
    else
        echo "⚠️  Unsupported OS: $OSTYPE. Installing fzf from source..."
        install_fzf_from_source
    fi
}

# Function to install fzf from source
install_fzf_from_source() {
    echo "📦 Installing fzf from source..."
    if command -v git &> /dev/null; then
        git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
        ~/.fzf/install --key-bindings --completion --no-update-rc
        echo "✓ fzf installed from source"
    else
        echo "❌ Git not available. Cannot install fzf from source."
        return 1
    fi
}

# Function to install gum
install_gum() {
    echo "🔍 Checking for supported package managers to install gum..."

    if command -v brew &> /dev/null; then
        echo "📦 Installing gum via Homebrew..."
        brew install gum
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
        echo "Note: Ubuntu/Debian users may need to add the Charm repository."
        return 1
    fi
}

# Check for fzf dependency
if ! command -v fzf &> /dev/null; then
    echo "⚠️  fzf is not installed. Bimagic requires fzf for its interactive menu."
    echo ""
    read -p "Do you want to automatically install fzf? (Y/n): " -r auto_install
    auto_install=${auto_install:-Y}  # Default to Y if empty
    
    if [[ $auto_install =~ ^[Yy]$ ]]; then
        echo "🚀 Attempting to automatically install fzf..."
        if install_fzf; then
            echo "✅ fzf installed successfully!"
        else
            echo "❌ Failed to install fzf automatically."
            echo "Please install fzf manually."
            exit 1
        fi
    else
        echo "Skipping fzf installation. Bimagic may not work properly."
    fi
else
    echo "✅ fzf is installed and ready"
fi

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

# Clone the repository
echo "Cloning bimagic repository..."
TEMP_DIR=$(mktemp -d)
git clone "$REPO_URL" "$TEMP_DIR"

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
    sudo cp "$TEMP_DIR/bimagic" "$TARGET_DIR/"
    sudo chmod +x "$TARGET_DIR/bimagic"
else
    cp "$TEMP_DIR/bimagic" "$TARGET_DIR/"
    chmod +x "$TARGET_DIR/bimagic"
fi

# Clean up
rm -rf "$TEMP_DIR"

echo "Successfully installed bimagic to $TARGET_DIR!"
echo "Please ensure GITHUB_USER and GITHUB_TOKEN are set as environment variables."

# Check if target directory is in PATH
if [[ ":$PATH:" != ":$TARGET_DIR:"* ]]; then
    echo "Note: $TARGET_DIR is not in your PATH. Add it to your shell profile:"
    echo "  echo 'export PATH=\"$PATH:$TARGET_DIR\"' >> ~/.bashrc"
    echo "  source ~/.bashrc"
fi