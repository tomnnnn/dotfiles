ZSH_CUSTOM="$HOME/.zsh"
# Plugins directory
PLUGINS_DIR="$HOME/.zsh/plugins"

# List of plugins
plugins=(
  "zsh-users/zsh-syntax-highlighting"
  "marlonrichert/zsh-autocomplete"
  "zsh-users/zsh-autosuggestions"
)

# Report missing plugins
missing_plugins=()
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
  fi
}

# Source all plugins from the .zsh folder
for plugin in "${plugins[@]}"; do
  # change to the plugin name without the username
  plugin=$(echo $plugin | cut -d'/' -f2)
  source_if_exists "$PLUGINS_DIR/$plugin/$plugin.plugin.zsh"
done

# colorful ls
alias ls='ls --color=auto'

# keybindings
bindkey '^e' autosuggest-accept
bindkey              '^I'         menu-complete
bindkey "$terminfo[kcbt]" reverse-menu-complete

# install missing plugins command
zsh-install() {
  for plugin in "${missing_plugins[@]}"; do
    # change to the plugin name without the username
    plugin_name=$(echo $plugin | cut -d'/' -f2)

    if [[ ! -d "$PLUGINS_DIR/$plugin" ]]; then
      repo="git@github.com:${plugin}.git"
      git clone --depth 1 $repo "$PLUGINS_DIR/$plugin_name"
    fi
  done

  # reload zsh
  echo "Reloading zsh..."
  exec zsh
}

alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
