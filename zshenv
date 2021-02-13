########
# ZSHENV
###########################################################################
#
#   Environment variables (often called 'params' in the zsh documentation.)
#
###########################################################################

# Add a bin in my home dir, for my own scripts
PATH=$PATH:~/bin
PATH=$PATH:~/appimage

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

# Odd mystery around setting TERM here...
#
# When running gnome-terminal, the value of TERM is 'xterm-256color'.  And
# 'echoti colors' reports that the terminal does, indeed, support 256 colors.
#
# However, upon running tmux from within gnome-terminal, the value of TERM
# seems to revert to 'screen', which prevents us from supporting more than 8
# colors.  
#
# Testing color output with the escape-sequence style, '\e[38;5;number',
# demonstrates 256 color support, even within tmux, and echoti reporting 8 colors.
#
# But trying to use the simpler prompt-style color designators, a la '%F{number}',
# seems to require 'echoti colors' to report 256.  Setting TERM here makes that happen.
#
# So, while setting this here seems to fix the issue, it all feels a touch hacky.. 
TERM=xterm-256color

# HISTORY
#   Note that history tracking is NOT the default.  Some options/params must be set first.

# File to save history entries into.
HISTFILE=~/.zsh/history

# Number of history entries tracked internally, in memory.
HISTSIZE=1000

# Number of history entries saved to the history file when exiting the shell.
SAVEHIST=1000

# Sometimes I want to print a horizontal bar
hr="=============================================================================="

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
export PATH EDITOR PAGER HISTFILE HISTSIZE SAVEHIST TERM
