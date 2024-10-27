# Plugins directory
PLUGINS_DIR="$HOME/.zsh/plugins"

# List of plugins
plugins=(
  # git clone --depth 1 git@github.com:zsh-users/zsh-syntax-highlighting.git $PLUGINS_DIR/zsh-syntax-highlighting
  "zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  # git clone --depth 1 git@github.com:marlonrichert/zsh-autocomplete.git $PLUGINS_DIR/zsh-autocomplete
  "zsh-autocomplete/zsh-autocomplete.plugin.zsh"
  # git clone --depth 1 git@github.com:zsh-users/zsh-autosuggestions.git $PLUGINS_DIR/zsh-autosuggestions
  "zsh-autosuggestions/zsh-autosuggestions.plugin.zsh"
)

# Report missing plugins
for plugin in "${plugins[@]}"; do
  if [[ ! -f $PLUGINS_DIR/$plugin ]]; then
    echo "Warning: plugin $plugin not found."
  fi
done

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
  source_if_exists "$PLUGINS_DIR/$plugin"
done

# colorful ls
alias ls='ls --color=auto'

# keybindings
bindkey '^e' autosuggest-accept
bindkey              '^I'         menu-complete
bindkey "$terminfo[kcbt]" reverse-menu-complete


alias config='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
