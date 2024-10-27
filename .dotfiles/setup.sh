#!/bin/bash

# Set variables
DOTFILES_REPO="https://github.com/tomnnnn/dotfiles.git"
DOTFILES_DIR="$HOME/.dotfiles"

# Clone the repository as a bare repo
git clone --bare "$DOTFILES_REPO" "$DOTFILES_DIR"

# Set up sparse checkout to exclude README.md
git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" config core.sparseCheckout true
echo '/*' > "$DOTFILES_DIR/info/sparse-checkout"
echo '!README.md' >> "$DOTFILES_DIR/info/sparse-checkout"

# Check out files, excluding README.md
git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" checkout

# Suppress untracked files in git status
git --git-dir="$DOTFILES_DIR" --work-tree="$HOME" config status.showUntrackedFiles no

echo "Dotfiles setup complete!"
