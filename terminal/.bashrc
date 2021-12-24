# If not running interactively, don't do anything

[ -z "$PS1" ] && return

# Resolve DOTFILES_DIR (assuming ~/.dotfiles on distros without readlink and/or $BASH_SOURCE/$0)
CURRENT_SCRIPT=$BASH_SOURCE

if [[ -n $CURRENT_SCRIPT && -x readlink ]]; then
  SCRIPT_PATH=$(readlink -n $CURRENT_SCRIPT)
  DOTFILES_DIR="${PWD}/$(dirname $(dirname $SCRIPT_PATH))"
elif [ -d "$HOME/.dotfiles" ]; then
  DOTFILES_DIR="$HOME/.dotfiles"
else
  echo "Unable to find dotfiles, exiting."
  return
fi

# Make utilities available

PATH="$DOTFILES_DIR/bin:$PATH"

# Source the dotfiles (order matters)

for DOTFILE in "$DOTFILES_DIR"/system/.{function,function_*,path,env,alias,fnm,grep,prompt,completion,fix,custom}; do
  [ -f "$DOTFILE" ] && . "$DOTFILE"
done

if is-macos; then
  for DOTFILE in "$DOTFILES_DIR"/system/.{env,alias,function,path}.macos; do
    [ -f "$DOTFILE" ] && . "$DOTFILE"
  done
fi

# Set LSCOLORS

eval "$(dircolors -b "$DOTFILES_DIR"/system/.dir_colors)"

# Hook for extra/custom stuff

DOTFILES_EXTRA_DIR="$HOME/.extra"

if [ -d "$DOTFILES_EXTRA_DIR" ]; then
  for EXTRAFILE in "$DOTFILES_EXTRA_DIR"/runcom/*.sh; do
    [ -f "$EXTRAFILE" ] && . "$EXTRAFILE"
  done
fi

# Clean up

unset CURRENT_SCRIPT SCRIPT_PATH DOTFILE EXTRAFILE

# Export

export DOTFILES_DIR DOTFILES_EXTRA_DIR

#Anaconda Integration
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('${HOME}/.miniforge3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
   \eval "$__conda_setup"
else
   if [ -f "${HOME}/.miniforge3/etc/profile.d/conda.sh" ]; then
        . "${HOME}/.miniforge3/etc/profile.d/conda.sh"  # commented out by conda initialize
        CONDA_CHANGEPS1=false conda activate base
   else
        \export PATH="${HOME}/.miniforge3/bin:$PATH"
   fi
fi
unset __conda_setup
#>>> conda initialize >>>

[[ -r "/usr/local/etc/profile.d/bash_completion.sh" ]] && . "/usr/local/etc/profile.d/bash_completion.sh"
