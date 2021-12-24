#!/bin/sh
DOTFILES = $HOME/.dotfiles

echo "Setting up your Mac..."

# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

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

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle --file $DOTFILES/Brewfile


# Symlink the Mackup config file to the home directory
ln -s $DOTFILES/.mackup.cfg $HOME/.mackup.cfg
mackup restore
# read -p "Is Google Drive Sync ready & 4.3 Backup/Config/Mackup there (y/n)? " answer
# case ${answer:0:1} in
#     y|Y )
#         if [[-d "$HOME/Google Drive/4.3 Backup/Config/Mackup"
#           mackup restore
#         else
#           read -p "Please enter Google Drive Path" google_path
#           if [[-d "$HOME/Google Drive/4.3 Backup/Config/Mackup"
#             mackup restore
#     ;;
#     * )
#         echo Please get Google Drive Sync Ready
#     ;;



# Set macOS preferences - we will run this last because this will reload the shell
/bin/bash $DOTFILES/macos/dock.sh
/bin/bash $DOTFILES/macos/system.sh
