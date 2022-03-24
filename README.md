# dotfiles

My way to a clean and fresh MacOS setup, with all the tools I need.

## Supports:

- ZSH instead of bash
- p10k ZSH theme
- zplug for ZSH plugins
- ZSH yntax-highlighting, auto-completion etc.

- Homebrew 🍺 for package management
- Brew bundle - to install all packages
- Mackup - to save and restore app configurations
- MAS - to intall apple app store packages from brew

- Anaconda
- NVM & NPM


## First installation:
clone into `$HOME/.dotfiles`

### customize to your liking:

1.  edit install file:
    remove nvm and node and conda if you don't need it

2.  edit terminal/ .bashrc .zshrc
    remove conda, node and java configs if you don't need them

3.  edit Brewfile
    add your apps and remove the ones you don't need
    if you want to overwrite existing ones, in .install.sh change
    `brew bundle --file $DOTFILES/Brewfile`to `brew bundle --file $DOTFILES/Brewfile --force`

### install

`chmod +x install.sh`

if you run into zhs: permission not allowed, you have to remove apple quarantine from the file
`xattr -d com.apple.quarantine install.sh`
`xattr -l install.sh` should not show com.apple.quarantine
