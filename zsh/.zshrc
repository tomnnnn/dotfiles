ZSH_CUSTOM="$HOME/.zsh"
# Plugins directory
PLUGINS_DIR="$HOME/.zsh/plugins"

# List of plugins
plugins=(
   "zsh-users/zsh-syntax-highlighting"
   "zsh-users/zsh-autosuggestions"
)
# Report missing plugins missing_plugins=()
for plugin in "${plugins[@]}"; do
  # change $plugin to the plugin name without the username
  plugin_name=$(echo $plugin | cut -d'/' -f2)

  if [[ ! -d "$PLUGINS_DIR/$plugin_name" ]]; then
    missing_plugins+=("$plugin")
    echo "Warning: plugin $plugin_name not found."
  fi
done

if [[ ${#missing_plugins[@]} -gt 0 ]]; then
  echo "Run 'zsh-install' to install missing plugins."
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# enable powerlevel10k
source ~/.zsh/powerlevel10k/powerlevel10k.zsh-theme
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


source_if_exists() {
  if [[ -f $1 ]]; then
    source "$1"
    return 0
  fi
  return 1
}

# Source all plugins from the .zsh folder
for plugin in "${plugins[@]}"; do
  # Extract the plugin name without the username
  plugin=$(echo "$plugin" | cut -d'/' -f2)

  # Check if the plugin file exists and source it
  if source_if_exists "$PLUGINS_DIR/$plugin/$plugin.plugin.zsh"; then
    continue
  else
    source_if_exists "$PLUGINS_DIR/$plugin/$plugin.zsh"
  fi
done

# colorful ls
alias ls='gls --color -h --group-directories-first'

# keybindings
bindkey '^e' autosuggest-accept

# install missing plugins command
zsh-install() {
  for plugin in "${missing_plugins[@]}"; do
    # change to the plugin name without the username
    plugin_name=$(echo $plugin | cut -d'/' -f2)

    if [[ ! -d "$PLUGINS_DIR/$plugin" ]]; then
      repo="https://github.com/${plugin}.git"
      git clone --depth 1 $repo "$PLUGINS_DIR/$plugin_name"
    fi
  done

  # reload zsh
  echo "Reloading zsh..."
  exec zsh
}

export EDITOR="nvim"

if [[ $(uname) == "Darwin" ]]; then
  # Mac specific
  # alias rm='trash'

  export CPATH=/opt/homebrew/include
  export LIBRARY_PATH=/opt/homebrew/lib
fi

alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

export PATH=/Users/tomn/.nimble/bin:$PATH

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/Caskroom/mambaforge/base/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/Caskroom/mambaforge/base/bin:$PATH"
    fi
fi
unset __conda_setup

if [ -f "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/mamba.sh" ]; then
    . "/opt/homebrew/Caskroom/mambaforge/base/etc/profile.d/mamba.sh"
fi
# <<< conda initialize <<<

# yazi
function y() {
	local tmp="$(mktemp -t "yazi-cwd.XXXXXX")" cwd
	yazi "$@" --cwd-file="$tmp"
	if cwd="$(command cat -- "$tmp")" && [ -n "$cwd" ] && [ "$cwd" != "$PWD" ]; then
		builtin cd -- "$cwd"
	fi
	rm -f -- "$tmp"
}

# zoxide
eval "$(zoxide init --cmd j zsh)"
