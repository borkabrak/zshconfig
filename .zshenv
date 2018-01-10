########
# ZSHENV
########
#
#   Environment variables (often called 'params' in the zsh documentation.)
#
########

# Set variables only on the first level of nested shells
#   ( I'm not sure why, though, and I need $EDITOR within `screen` on Cygwin, so I'm disabling it until I find out.)
# if [[ $SHLVL == 1 ]]; then

# Add a bin in my home dir, for my own scripts
PATH=$PATH:~/bin

PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

EDITOR=vim

GOPATH=/home/jon/src/gocode

PAGER=less

# HISTORY
#   Note that history tracking is NOT the default.  Some options/params must be set first.

# File to save history entries into.
HISTFILE=~/.zsh/history

# Number of history entries tracked internally, in memory.
HISTSIZE=1000

# Number of history entries saved to the history file
SAVEHIST=5000

# Not sure this is necessary..
export PATH EDITOR GOPATH PAGER HISTFILE HISTSIZE SAVEHIST

# fi
