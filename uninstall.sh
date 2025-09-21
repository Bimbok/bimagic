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
read -p "Are you sure you want to uninstall Bimagic? (y/N): " -r confirm
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
read -p "Do you want to remove GITHUB_USER and GITHUB_TOKEN from your shell config? (y/N): " -r remove_vars
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

echo ""
echo "Bimagic has been successfully uninstalled."
echo "Thank you for using Bimagic! ✨"