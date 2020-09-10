########
# ZSHENV
###########################################################################
#
#   Environment variables (often called 'params' in the zsh documentation.)
#
###########################################################################

# Add a bin in my home dir, for my own scripts
PATH=$PATH:~/bin

# The EDITOR param can have non-obvious consequences.  From the KEYMAPS section
# of `man zshzle`, when discussing the default keymap:
#
#   In addition to these names, either `emacs' or `viins' is also linked to
#   the name `main'.  If one of the VISUAL or EDITOR  environment variables
#   contain the string `vi' when the shell starts up then it will be
#   `viins', otherwise it will be `emacs'.  bindkey's -e and -v options
#   provide a convenient way to override this default choice.
#
# In other words, if the EDITOR (or VISUAL) enviroment variables has 'vi' in
# it, the zsh command line will automatically be in vi mode.  Neat, but it's
# not great that it's unexpected.
EDITOR=vim

PAGER=less

# HISTORY
#   Note that history tracking is NOT the default.  Some options/params must be set first.

# File to save history entries into.
HISTFILE=~/.zsh/history

# Number of history entries tracked internally, in memory.
HISTSIZE=1000

# Number of history entries saved to the history file when exiting the shell.
SAVEHIST=1000

# A note on the export command:
#
#   From `man zshbuiltins`:
#
#     export [ name[=value] ... ]
#       The specified names are marked for automatic export to the environment of
#       subsequently executed  commands.  Equivalent  to  typeset -gx.  If a
#       parameter specified does not already exist, it is created in the global
#       scope.
#   
#   So you should export, not everything, but anything that a later command
#   might need in *it's* environment.  For example, EDITOR has consequences
#   affecting the default keymap for the command line editor.
#   
export PATH EDITOR PAGER HISTFILE HISTSIZE SAVEHIST 

# Sometimes I want to print a horizontal bar
hr="=============================================================================="
