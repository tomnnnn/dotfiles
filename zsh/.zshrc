# zsh configuration file, tested on MacOS
# Author: Hai Phong Nguyen

#### =========================================================
####  Instant prompt (must be near the top)
#### =========================================================

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

#### =========================================================
####  Globals & paths
#### =========================================================

ZSH_CUSTOM="$HOME/.zsh"
PLUGINS_DIR="$ZSH_CUSTOM/plugins"

export EDITOR="nvim"

# Exports Management System
# Taken from: https://github.com/pgaijin66/dotfiles/blob/main/zsh/zshrc
export EXPORTS_DIR="$HOME/.config/exports"

# Create exports directory if it doesn't exist
[ ! -d "$EXPORTS_DIR" ] && mkdir -p "$EXPORTS_DIR"

load_exports() {
    if [ -d "$EXPORTS_DIR" ]; then
        # Only source files that exist and are readable
        for export_file in "$EXPORTS_DIR"/*; do
            if [ -f "$export_file" ] && [ -r "$export_file" ]; then
                source "$export_file"
            fi
        done
    fi
}

edit_exports() {
    local file=${1:-main}
    local filepath="$EXPORTS_DIR/$file"
    
    # Create the file if it doesn't exist
    [ ! -f "$filepath" ] && touch "$filepath"
    
    ${EDITOR:-vim} "$filepath"
}

reload_exports() {
    load_exports
    echo "Exports reloaded from $EXPORTS_DIR"
}

# Load exports on startup (only if directory exists and has files)
if [ -d "$EXPORTS_DIR" ] && [ "$(ls -A "$EXPORTS_DIR" 2>/dev/null)" ]; then
    load_exports
fi


#### =========================================================
####  Helpers
#### =========================================================

# Source file if it exists
source_if_exists() {
  [[ -f $1 ]] && source "$1"
}

# Extract repo name (user/repo → repo)
plugin_name() {
  print -r -- "${1##*/}"
}


#### =========================================================
####  Prompt (Powerlevel10k)
#### =========================================================

source "$ZSH_CUSTOM/powerlevel10k/powerlevel10k.zsh-theme"
[[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh


#### =========================================================
####  Plugins
#### =========================================================

typeset -a plugins missing_plugins

# Add plugins here if needed
plugins=(
  zsh-users/zsh-syntax-highlighting
  zsh-users/zsh-autosuggestions
)

for plugin in "${plugins[@]}"; do
  name="$(plugin_name "$plugin")"
  dir="$PLUGINS_DIR/$name"

  if [[ ! -d $dir ]]; then
    missing_plugins+=("$plugin")
    print "Warning: plugin $name not found."
    continue
  fi

  source_if_exists "$dir/$name.plugin.zsh" \
    || source_if_exists "$dir/$name.zsh"
done

(( ${#missing_plugins[@]} )) && \
  print "Run 'zsh-install' to install missing plugins."

# Powerlevel10k installer
p10k-install() {
  local repo dir
  repo="https://github.com/romkatv/powerlevel10k.git"
  dir="$ZSH_CUSTOM/powerlevel10k"

  if [[ -d $dir ]]; then
    print "Powerlevel10k already installed."
    return 0
  fi

  git clone --depth 1 "$repo" "$dir"
  print "Reloading zsh..."
  exec zsh
}


#### =========================================================
####  Plugin installer
#### =========================================================

zsh-install() {
  local plugin name repo

  for plugin in "${missing_plugins[@]}"; do
    name="$(plugin_name "$plugin")"
    repo="https://github.com/$plugin.git"

    if [[ ! -d "$PLUGINS_DIR/$name" ]]; then
      git clone --depth 1 "$repo" "$PLUGINS_DIR/$name"
    fi
  done

  exec zsh
}


#### =========================================================
####  Aliases & keybindings
#### =========================================================

# Colored ls
alias ls='ls --color=auto'

# zsh-autosuggestions
bindkey '^e' autosuggest-accept

#### =========================================================
####  Tools
#### =========================================================

# yazi
y() {
  local tmp cwd
  tmp="$(mktemp -t "yazi-cwd.XXXXXX")"
  yazi "$@" --cwd-file="$tmp"
  if cwd="$(<"$tmp")" && [[ -n $cwd && $cwd != $PWD ]]; then
    builtin cd -- "$cwd"
  fi
  rm -f -- "$tmp"
}

# zoxide
command -v zoxide >/dev/null && eval "$(zoxide init --cmd z zsh)"

# fzf
command -v fzf >/dev/null && source <(fzf --zsh)


#### =========================================================
####  Conda
#### =========================================================

__conda_setup="$('/opt/homebrew/Caskroom/miniforge/base/bin/conda' shell.zsh hook 2>/dev/null)"
if [[ $? -eq 0 ]]; then
  eval "$__conda_setup"
elif [[ -f /opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh ]]; then
  source /opt/homebrew/Caskroom/miniforge/base/etc/profile.d/conda.sh
else
  export PATH="/opt/homebrew/Caskroom/miniforge/base/bin:$PATH"
fi
unset __conda_setup


#### =========================================================
####  Mamba
#### =========================================================

export MAMBA_EXE='/opt/homebrew/Caskroom/miniforge/base/bin/mamba'
export MAMBA_ROOT_PREFIX="$HOME/.local/share/mamba"

__mamba_setup="$("$MAMBA_EXE" shell hook --shell zsh --root-prefix "$MAMBA_ROOT_PREFIX" 2>/dev/null)"
if [[ $? -eq 0 ]]; then
  eval "$__mamba_setup"
else
  alias mamba="$MAMBA_EXE"
fi
unset __mamba_setup


#### =========================================================
####  OS-specific
#### =========================================================

case "$(uname)" in
  Darwin)
    export CPATH=/opt/homebrew/include
    export LIBRARY_PATH=/opt/homebrew/lib
    ;;
esac

[ -f "/Users/tomn/.ghcup/env" ] && . "/Users/tomn/.ghcup/env" # ghcup-env
