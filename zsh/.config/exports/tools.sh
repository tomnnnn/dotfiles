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
