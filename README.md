# Bimagic - Git Wizard 🧙‍♂️

By Bimbok and adityapaul26

A powerful Bash-based Git automation tool that simplifies your GitHub workflow with an interactive menu system.

## Overview

Bimagic is an interactive command-line tool that streamlines common Git operations, making version control more accessible through a user-friendly menu interface. It handles repository initialization, committing, branching, and remote operations with GitHub integration using personal access tokens.

## Sample
https://github.com/user-attachments/assets/36d09f38-fe48-4476-8b08-f592222224a9

## Features

- 🔮 Interactive menu-driven interface
- 🔐 Secure GitHub authentication via personal access tokens
- 📦 Easy repository initialization and setup
- 🔄 Simplified push/pull operations
- 🌿 Branch management made easy
- 📊 Status dashboard (ahead/behind, branch, clean/uncommitted/conflicts)
- 🛡️ Automatic master-to-main branch renaming
- 🗑️ Safe file/folder removal with git integration
- 📈 Contributor statistics with time range selection
- 🌐 Git graph (pretty git log) viewer
- 🔀 Merge branches with conflict detection
- ⏪ Revert commit(s) with multi-select

## Installation

### Automated Installation (Recommended)

Run this one-line command to install Bimagic:

```bash
curl -sSL https://raw.githubusercontent.com/Bimbok/bimagic/main/install.sh | bash
```

### Manual Installation

1. Clone the repository:
```bash
git clone https://github.com/Bimbok/bimagic.git
```

2. Make the script executable:
```bash
chmod +x bimagic/bimagic
```

3. Move it to your bin directory:
```bash
# Option 1: For user-local installation (no sudo required)
mkdir -p ~/bin
mv bimagic/bimagic ~/bin/

# Option 2: For system-wide installation (requires sudo)
sudo mv bimagic/bimagic /usr/local/bin/
```

4. Ensure the bin directory is in your PATH (add to ~/.bashrc or ~/.zshrc if needed):
```bash
export PATH="$HOME/bin:$PATH"  # For user-local installation
```

## Dependencies

- fzf (required for interactive selection)
  - Linux (apt): `sudo apt install fzf`
  - macOS (Homebrew): `brew install fzf`
  - If not installed, the menu selections will not work.

## Configuration

### Setting Up GitHub Credentials

Bimagic requires your GitHub username and a personal access token. Add these to your shell configuration file:

1. Open your shell configuration file:
```bash
# For bash users
nano ~/.bashrc

# For zsh users
nano ~/.zshrc
```

2. Add these lines at the end of the file:
```bash
# GitHub credentials for bimagic
export GITHUB_USER="your_github_username"
export GITHUB_TOKEN="your_github_personal_access_token"
```

3. Reload your shell configuration:
```bash
source ~/.bashrc  # or source ~/.zshrc
```

### Creating a GitHub Personal Access Token

1. Go to GitHub → Settings → Developer settings → Personal access tokens
2. Click "Generate new token"
3. Give your token a descriptive name (e.g., "bimagic-cli")
4. Select the "repo" scope (this provides full control of private repositories)
5. Click "Generate token"
6. Copy the token immediately (you won't be able to see it again!)

## Usage

Simply run the `bimagic` command in your terminal:

```bash
bimagic
```

You'll be presented with an interactive menu where you can choose from various Git operations.

### Status Dashboard

At the top of the interface, a status box summarizes:
- Current `GITHUB_USER` and branch
- Ahead/behind counts relative to upstream (if set)
- Working tree state: clean, uncommitted, or conflicts

### Menu Options

1. **Init new repo** - Initialize a new Git repository (auto-renames master → main)
2. **Add files** - Stage files (fzf multi-select; includes [ALL])
3. **Commit changes** - Commit staged changes with a message
4. **Push to remote** - Push changes (auto-sets remote with token if missing)
5. **Pull latest changes** - Fetch and merge changes from remote
6. **Create/switch branch** - Create a new branch or switch to an existing one
7. **Set remote (via token)** - Set the remote URL using `GITHUB_USER`/`GITHUB_TOKEN`
8. **Show status** - Display repo status dashboard (ahead/behind, branch, cleanliness)
9. **Contributor Statistics** - View per-author activity with time range selection
10. **Git graph** - Pretty git log with graph and decorations
11. **Remove files/folders (rm)** - Safely remove files/folders with git integration
12. **Merge branches** - Merge a selected branch into the current one
13. **Uninitialize repo** – Remove Git tracking from a project
14. **Revert commit(s)** - Revert one or more commits (multi-select)
15. **Exit** - Quit the wizard

### Contributor Statistics (Option 9)

Analyze contributions over a chosen time range (Last 7/30/90 days, Last year, All time). The tool parses `git log --numstat` to compute per-author lines changed and commit counts, and surfaces highlights like most active/productive contributors.

#### What you get:
- Per-author bar visualization and percentages
- Lines changed and commit counts
- Highlights: most active and most productive

### Git graph (Option 10)

Displays a pretty, colorized `git log --graph` with abbrev commit, decorations, author, date, and subject. Press `q` to exit the view.

### File Removal (Option 11)

The `Remove files/folders (rm)` option lets you select files and folders interactively using fzf, with full git integration:

#### Features:
- **fzf Multi-select**: Select one or many files to remove
- **Git Integration**: Tracked files are removed via `git rm -rf`; untracked via `rm -rf`
- **Safety Confirmation**: Explicit confirmation before deletion
- **Smart Detection**: Works whether or not a file is tracked in git

#### How it works:
1. A list of tracked and untracked files is displayed
2. Use fzf to multi-select entries (TAB to select, ENTER to confirm)
3. The selection is previewed and you are asked to confirm (y/N)
4. Each selected item is removed appropriately (git-tracked or filesystem)
5. A success message lists removed paths

### Merge branches (Option 12)

Merge another branch into your current branch using an interactive selector. If conflicts occur, you will be notified to resolve them manually.

#### Flow:
1. Current branch is shown
2. Select a branch (other than current) to merge into the current one
3. If merge succeeds, you get a success message; otherwise, conflicts are reported

### Revert commit(s) (Option 14)

Revert one or more commits selected via fzf from `git log --oneline`. Each selected commit is reverted in sequence; on conflicts, the process stops and you are instructed to resolve and continue.

#### Flow:
1. Select commit(s) to revert (multi-select)
2. Confirm the action (y/N)
3. Reverts run with `git revert --no-edit`
4. On conflict, resolve then run `git revert --continue`

## Why Sudo Might Be Required

### Understanding the Need for Elevated Privileges

The installation script may request sudo privileges for these reasons:

1. **System-wide installation**: 
   - The script tries to install to `/usr/local/bin/` by default
   - This directory is typically owned by root for security reasons
   - Writing to system directories requires administrative privileges

2. **Directory permissions**:
   - If you don't have a `~/bin` directory or it's not writable
   - The script falls back to system installation

### Avoiding Sudo Requirements

You can avoid needing sudo by:

1. Creating a local bin directory:
   ```