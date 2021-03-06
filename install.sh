#!/bin/sh
DOTFILES="$HOME/.dotfiles"

echo "Setting up your Mac..."

# Check for ZSH and install if we dont have it


# Install oh my zsh
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"

# install zplug
/bin/sh -c "$(curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh)"

# install homebrew
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
brew bundle --file $DOTFILES/Brewfile
zplug install

# Install node modules
nvm install node
nvm install 14
nvm use node
npm instal -g npm
npm install -g pnpm
npm install -g cypress

# Install anaconda envs and python packages
conda update -n base -c defaults conda
# create basic datascience environment
conda env create -f environment-datascience.yml python=3.8
conda env create -f environment-machinelearning.yml python=3.6

# Symlink the Mackup config file to the home directory
ln -s $DOTFILES/.mackup.cfg $HOME/.mackup.cfg
mackup restore


# Set macOS preferences - we will run this last because this will reload the shell
#/bin/bash $DOTFILES/macos/dock.sh
#/bin/bash $DOTFILES/macos/system.sh
