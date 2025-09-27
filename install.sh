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
    echo "🔍 Detecting operating system..."
    
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
            echo ""
            echo "Please install fzf manually using one of these methods:"
            echo ""
            echo "Ubuntu/Debian: sudo apt update && sudo apt install fzf"
            echo "CentOS/RHEL/Fedora: sudo dnf install fzf"
            echo "Arch Linux: sudo pacman -S fzf"
            echo "macOS: brew install fzf"
            echo "From source: git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install"
            echo ""
            read -p "Do you want to continue with the installation anyway? (y/N): " -r continue_install
            if [[ ! $continue_install =~ ^[Yy]$ ]]; then
                echo "Installation cancelled. Please install fzf first."
                exit 1
            else
                echo "Continuing installation... (Note: Bimagic will not work properly without fzf)"
            fi
        fi
    else
        echo "Skipping fzf installation."
        read -p "Do you want to continue with the installation anyway? (y/N): " -r continue_install
        if [[ ! $continue_install =~ ^[Yy]$ ]]; then
            echo "Installation cancelled. Please install fzf first."
            exit 1
        else
            echo "Continuing installation... (Note: Bimagic will not work properly without fzf)"
        fi
    fi
else
    echo "✅ fzf is installed and ready"
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
if [[ ":$PATH:" != *":$TARGET_DIR:"* ]]; then
    echo "Note: $TARGET_DIR is not in your PATH. Add it to your shell profile:"
    echo "  echo 'export PATH=\"\$PATH:$TARGET_DIR\"' >> ~/.bashrc"
    echo "  source ~/.bashrc"
fi
