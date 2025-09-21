#!/bin/bash

# Exit on error
set -e

# GitHub repository URL (replace with your actual repo URL)
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
if [ -d "$HOME/bin" ]; then
    TARGET_DIR="$HOME/bin"
else
    TARGET_DIR="/usr/local/bin"
fi

# Ensure the target directory exists and is in PATH
mkdir -p "$TARGET_DIR"
if [[ ":$PATH:" != *":$TARGET_DIR:"* ]]; then
    echo "Note: $TARGET_DIR is not in your PATH. Add it to your shell profile (e.g., ~/.bashrc or ~/.zshrc)."
fi

# Copy the script and make it executable
cp "$TEMP_DIR/bimagic" "$TARGET_DIR/"
chmod +x "$TARGET_DIR/bimagic"

# Clean up
rm -rf "$TEMP_DIR"

echo "Successfully installed bimagic to $TARGET_DIR!"
echo "Please ensure GITHUB_USER and GITHUB_TOKEN are set as environment variables."
