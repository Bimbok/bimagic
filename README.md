# Bimagic - Git Wizard
<img width="2361" height="1472" alt="Image" src="https://github.com/user-attachments/assets/d74de26d-949b-4aa9-9b2e-c25de5b25b42" />

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

### Neovim Integration

You can use Bimagic directly inside Neovim! This integration wraps the CLI tool in a floating terminal window using `toggleterm.nvim` for a seamless workflow.

#### LazyVim / Toggleterm Setup

Create a new plugin file (e.g., `~/.config/nvim/lua/plugins/bimagic.lua`) with the following configuration. This sets up a `<leader>gm` keybinding to launch the wizard in a floating popup.

```lua
return {
  {
    "akinsho/toggleterm.nvim",
    opts = function(_, opts)
      opts.size = 20
      opts.open_mapping = [[<c-\>]]
    end,
    keys = {
      {
        "<leader>gm",
        function()
          local Terminal = require("toggleterm.terminal").Terminal
          local bimagic = Terminal:new({
            cmd = "bimagic", -- This assumes 'bimagic' is in your global PATH
            hidden = true,
            direction = "float",
            float_opts = {
              border = "curved", -- 'single', 'double', 'shadow', 'curved'
              width = 100,
              height = 25,
              title = "  Bimagic Git Wizard ",
            },
            close_on_exit = true,

            on_open = function(term)
              vim.cmd("startinsert!")
              vim.api.nvim_buf_set_keymap(term.bufnr, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
            end,
          })
          bimagic:toggle()
        end,
        desc = "Bimagic (Git Wizard)",
      },
    },
  },
}
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

- gum (required for modern UI and interactive selection)
  - See installation instructions below or use the automated script.
  - If not installed, the tool will not work.

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
2. **Add files** - Stage files (interactive multi-select; includes [ALL])
3. **Commit changes** - Commit staged changes with a message
4. **Push to remote** - Push changes (handles multiple remotes and auto-configuration)
5. **Pull latest changes** - Fetch and merge changes from remote
6. **Create/switch branch** - Create a new branch or switch to an existing one
7. **Set remote** - Configure remotes (supports HTTPS with token or SSH)
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

The `Remove files/folders (rm)` option lets you select files and folders interactively, with full git integration:

#### Features:

- **Interactive Multi-select**: Select one or many files to remove
- **Git Integration**: Tracked files are removed via `git rm -rf`; untracked via `rm -rf`
- **Safety Confirmation**: Explicit confirmation before deletion
- **Smart Detection**: Works whether or not a file is tracked in git

#### How it works:

1. A list of tracked and untracked files is displayed
2. Use the interactive filter to multi-select entries (TAB to select, ENTER to confirm)
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

#### Safety Features:

- **Double confirmation** for `*` (everything) - requires typing "yes"
- **Preview** of what will be deleted before proceeding
- **Existence check** - only proceeds if files actually exist
- **Git-aware** - uses `git rm` for tracked files, regular `rm` for untracked files
  Revert one or more commits selected via interactive filter from `git log --oneline`. Each selected commit is reverted in sequence; on conflicts, the process stops and you are instructed to resolve and continue.

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

   ```bash
   mkdir -p ~/bin
   ```

2. Ensuring it's in your PATH (add to ~/.bashrc or ~/.zshrc):

   ```bash
   export PATH="$HOME/bin:$PATH"
   ```

3. Running the installation again

## Security Considerations

1. **Token Security**:
   - Your GitHub token is stored in your shell configuration file
   - Protect this file with proper permissions (chmod 600)
   - Never share your token or commit it to version control

2. **Script Integrity**:
   - Review the installation script before running it
   - The script only copies files and sets permissions

3. **Network Security**:
   - The script uses HTTPS to communicate with GitHub
   - Ensure you're on a secure network when using the tool

## Troubleshooting

### Common Issues

1. **"Command not found" after installation**
   - Your bin directory may not be in PATH
   - Add `export PATH="$HOME/bin:$PATH"` to your shell config file
   - Run `source ~/.bashrc` or `source ~/.zshrc`

2. **Permission denied errors**
   - The script might not be executable
   - Run `chmod +x ~/bin/bimagic` or `sudo chmod +x /usr/local/bin/bimagic`

3. **GitHub authentication errors**
   - Verify your GITHUB_USER and GITHUB_TOKEN environment variables are set correctly
   - Ensure your token has the necessary permissions

4. **Remote operation failures**
   - Check your internet connection
   - Verify the repository name is correct

### Getting Help

If you encounter issues:

1. Check that Git is installed: `git --version`
2. Verify your environment variables are set: `echo $GITHUB_USER`
3. Ensure you have a GitHub personal access token with repo permissions

## Uninstallation

If you ever need to remove Bimagic from your system, you have two options:

### Option 1: Curl Directly (Recommended)

Run the uninstall script directly from GitHub:

```bash
curl -sSL https://raw.githubusercontent.com/Bimbok/bimagic/main/uninstall.sh | bash
```

### Option 2: Manual Uninstallation

1. Remove the Bimagic script:

   ```bash
   # Remove from user directory (if installed there)
   rm -f ~/bin/bimagic

   # Remove from system directory (if installed there - requires sudo)
   sudo rm -f /usr/local/bin/bimagic
   ```

2. Optional: Remove GitHub credentials from your shell configuration:

   ````bash
   # Edit your shell config file (e.g., ~/.bashrc, ~/.zshrc)
   # Remove lines containing GITHUB_USER and GITHUB_TOKEN
   nano ~/.bashrc  # or ~/.zshrc
   ```### What the Uninstall Script Does

   ````

3. **Finds Installations**: Checks common installation directories (~/bin and /usr/local/bin)
4. **Confirmation**: Asks for confirmation before proceeding
5. **Removes Bimagic**: Deletes the script from all found locations
6. **Optional Cleanup**: Offers to remove GitHub environment variables from shell configuration files
7. **Creates Backups**: Creates timestamped backups of modified shell configuration files

### Safety Features

- Asks for confirmation before removing anything
- Creates backups of modified configuration files
- Uses sudo only when necessary (for system directories)
- Provides clear feedback about what's happening
- Includes timestamped backups to prevent data loss

### Notes

- The uninstall script will only remove the Bimagic script file
- Your Git repositories and other files will not be affected
- GitHub credentials are only removed if you explicitly choose to do so
- Backups are created before modifying any configuration files

Remember to update your repository with both the `uninstall.sh` script and the updated README section.

## Contributing

Contributions to Bimagic are welcome! Please feel free to submit pull requests or open issues for bugs and feature requests.

## License

This project is open source and available under the MIT License.

## Disclaimer

This tool is provided as-is without any warranties. Use it at your own risk. Always ensure you have backups of important repositories before performing operations with this tool.

---

**Enjoy the magical Git experience!** ✨
