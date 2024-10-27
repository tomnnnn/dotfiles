# dotfiles

## Setup
```sh
git init --bare $HOME/.dotfiles
alias mydotfiles='git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
mydotfiles remote add origin git@github.com:Siilwyn/dotfiles.git
```

## Replication
```sh
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/tomnnnn/dotfiles.git dotfiles-tmp
rsync --recursive --verbose --exclude '.git' dotfiles-tmp/ $HOME/
rm -r dotfiles-tmp
```

## Configuration
```sh
config config status.showUntrackedFiles no
config remote set-url origin git@github.com:Siilwyn/dotfiles.git
```

## Usage
```sh
config status
config add .gitconfig
config commit -m 'Add gitconfig'
config push
```
