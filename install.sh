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
