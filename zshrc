################################################################################
# ZSHRC - Z-shell Runtime Configuration
################################################################################
#
#   This ZSH config setup is different than most.  Here's what's going on:
#
#   Everything pertaining to ZSH configuration is in ~/.zsh/include
#
################################################################################
# ZSHRC COMPONENTS
# ----------------
#
#   This .zshrc file is split into individual component files for various things
#   such as options, aliases, etc.
#
#   To install a component, put it in the appropriate directory with an
#   extension of *.zsh
#
#   I haven't run into a situation yet where order matters, but such is
#   conceivable.  If so, try numbering them in the order in which they should
#   be sourced.
#
#   TODO:
#   ---------
#   * Checkout out 'zgen' (or antigen):
#          https://github.com/tarjoilija/zgen
#
################################################################################

# Any files in this directory that have an extension of '.zsh' will be sourced.
components_directory="$HOME/.zsh/include"

autoload colors && colors
print -n "$fg_bold[white]Sourcing components_directory.."
for component in $(ls $components_directory/*.zsh); do
    name=$(basename $component)
    print -n " $name"
    source $component
done
print
