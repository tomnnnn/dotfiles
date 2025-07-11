# Dotfiles

These are my personal dotfiles managed with [GNU Stow](https://www.gnu.org/software/stow/).

## Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/tomnnnn/dotfiles ~/dotfiles
   cd ~/dotfiles
   ```

2. **Install GNU Stow (if not already installed):**

   On Debian/Ubuntu:

   ```bash
   sudo apt install stow
   ```

   On macOS (using Homebrew):

   ```bash
   brew install stow
   ```

3. **Stow the desired package(s):**

   ```bash
   stow <package>
   ```

   For example, to install the `nvim` config:

   ```bash
   stow nvim
   ```

   This will symlink files from `~/dotfiles/nvim` into your home directory.

## Notes

- Each subdirectory (e.g., `zsh/`, `nvim/`, `tmux/`) is a stow package.
- You can safely remove a package with:

  ```bash
  stow -D <package>
  ```
