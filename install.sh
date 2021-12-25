#!/bin/sh
DOTFILES="$HOME/.dotfiles"

echo "Setting up your Mac..."

# Check for ZSH and install if we dont have it


# Check for Oh My Zsh and install if we don't have it
if test ! $(which zplug); then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh | zsh

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -s $DOTFILES/terminal/.zshrc $HOME/.zshrc
rm -rf $HOME/.bashrc
ln -s $DOTFILES/terminal/.bashrc $HOME/.bashrc
touch $ZPLUG_LOADFILE

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
# brew bundle --file $DOTFILES/Brewfile
zplug install

# Install node modules
nvm install node
nvm install 14
nvm use node
npm install -g pnpm

# Symlink the Mackup config file to the home directory
ln -s $DOTFILES/.mackup.cfg $HOME/.mackup.cfg
mackup restore


# Set macOS preferences - we will run this last because this will reload the shell
#/bin/bash $DOTFILES/macos/dock.sh
#/bin/bash $DOTFILES/macos/system.sh
