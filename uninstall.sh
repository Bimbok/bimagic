#!/bin/bash

# Bimagic Uninstall Script
echo "Bimagic Uninstaller"
echo "==================="

# Determine installation locations
TARGET_DIRS=("$HOME/bin" "/usr/local/bin")
FOUND_INSTALLS=()

# Check where bimagic is installed
for dir in "${TARGET_DIRS[@]}"; do
    if [[ -f "$dir/bimagic" ]]; then
        FOUND_INSTALLS+=("$dir")
        echo "Found Bimagic installation in: $dir"
    fi
done

if [[ ${#FOUND_INSTALLS[@]} -eq 0 ]]; then
    echo "Bimagic is not installed on this system."
    exit 0
fi

# Confirm uninstallation
read -p "Are you sure you want to uninstall Bimagic? (y/N): " -r confirm < /dev/tty
if [[ ! $confirm =~ ^[Yy]$ ]]; then
    echo "Uninstallation cancelled."
    exit 0
fi

# Remove bimagic from all found locations
for dir in "${FOUND_INSTALLS[@]}"; do
    echo "Removing Bimagic from $dir..."
    
    if [[ "$dir" == "/usr/local/bin" ]]; then
        # Need sudo for system directory
        if sudo rm -f "$dir/bimagic"; then
            echo "✓ Successfully removed from $dir"
        else
            echo "✗ Failed to remove from $dir (permission issue?)"
        fi
    else
        # User directory, no sudo needed
        if rm -f "$dir/bimagic"; then
            echo "✓ Successfully removed from $dir"
        else
            echo "✗ Failed to remove from $dir"
        fi
    fi
done

# Optional: Remove environment variables from shell config
read -p "Do you want to remove GITHUB_USER and GITHUB_TOKEN from your shell config? (y/N): " -r remove_vars < /dev/tty
if [[ $remove_vars =~ ^[Yy]$ ]]; then
    SHELL_FILES=("$HOME/.bashrc" "$HOME/.zshrc")
    
    for file in "${SHELL_FILES[@]}"; do
        if [[ -f "$file" ]]; then
            # Remove lines containing GITHUB_USER or GITHUB_TOKEN
            if grep -q "GITHUB_USER\|GITHUB_TOKEN" "$file"; then
                # Create a backup
                cp "$file" "${file}.backup-$(date +%Y%m%d)"
                
                # Remove the lines
                sed -i '/GITHUB_USER\|GITHUB_TOKEN/d' "$file"
                echo "✓ Removed GitHub variables from $file"
                echo "  A backup was created at ${file}.backup-$(date +%Y%m%d)"
            else
                echo "✓ No GitHub variables found in $file"
            fi
        fi
    done
fi

# Optional: Remove fzf if it was installed for Bimagic
if command -v fzf &> /dev/null; then
    echo ""
    echo "fzf is currently installed on your system."
    read -p "Do you want to remove fzf as well? (y/N): " -r remove_fzf < /dev/tty
    if [[ $remove_fzf =~ ^[Yy]$ ]]; then
        echo "Attempting to remove fzf..."
        
        # Try different package managers
        if command -v apt &> /dev/null; then
            echo "Detected apt package manager"
            if sudo apt remove -y fzf 2>/dev/null; then
                echo "✓ Successfully removed fzf via apt"
            else
                echo "✗ Failed to remove fzf via apt (may not be installed via package manager)"
            fi
        elif command -v dnf &> /dev/null; then
            echo "Detected dnf package manager"
            if sudo dnf remove -y fzf 2>/dev/null; then
                echo "✓ Successfully removed fzf via dnf"
            else
                echo "✗ Failed to remove fzf via dnf (may not be installed via package manager)"
            fi
        elif command -v yum &> /dev/null; then
            echo "Detected yum package manager"
            if sudo yum remove -y fzf 2>/dev/null; then
                echo "✓ Successfully removed fzf via yum"
            else
                echo "✗ Failed to remove fzf via yum (may not be installed via package manager)"
            fi
        elif command -v brew &> /dev/null; then
            echo "Detected Homebrew package manager"
            if brew uninstall fzf 2>/dev/null; then
                echo "✓ Successfully removed fzf via Homebrew"
            else
                echo "✗ Failed to remove fzf via Homebrew (may not be installed via Homebrew)"
            fi
        elif command -v pacman &> /dev/null; then
            echo "Detected pacman package manager"
            if sudo pacman -R fzf 2>/dev/null; then
                echo "✓ Successfully removed fzf via pacman"
            else
                echo "✗ Failed to remove fzf via pacman (may not be installed via package manager)"
            fi
        else
            echo "⚠️  Could not detect package manager. fzf may have been installed manually."
            echo "If you installed fzf from source, you can remove it manually:"
            echo "  rm -rf ~/.fzf"
            echo "  Remove fzf-related lines from your shell config files"
        fi
    else
        echo "✓ Keeping fzf installed"
    fi
else
    echo "✓ fzf is not installed, nothing to remove"
fi

echo ""
echo "Bimagic has been successfully uninstalled."
echo "Thank you for using Bimagic! ✨"