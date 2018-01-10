################################################################################
# ZSHRC - Z-shell Runtime Configuration
################################################################################
#
#   This ZSH config setup is different than most.  Here's what's going on:
#
#   Everything pertaining to ZSH configuration is in a git repository.  
#
#   The repository also includes a script to 'install' the files, which works
#   by creating symlinks in the user's home directory (or $ZSHDOTDIR, if set).
#   These links point to the files in the repository, so updating the repo
#   automatically provides new shells with the new configuration.
#
################################################################################
# ZSHRC COMPONENTS
# ----------------
#
#   This .zshrc file is split into individual component files for various things
#   such as options, aliases, etc.
#
#   TODO:
#   ---------
#   * Checkout out 'zgen' instead of antigen:
#       It looks to have some very real advantages.
#
#          https://github.com/tarjoilija/zgen
#
################################################################################

# What about having a directory containing everything I want to source?  That
# would allow installation to be as easy as just putting the file in that
# directory, instead of editing this file.
#components=(
#    alias
#    options
#    functions
#    named-directories
#    prompt
#    tmp
#    zle
#    #antigen
#    zgen
#)

# Any files in this directory that have an extension of '.zsh' will be sourced.
components_directory="$HOME/.zsh/include"

autoload colors && colors
print -n "$fg_bold[white]Sourcing components_directory..$fg_bold[grey]"
for component in $(ls $components_directory/*.zsh); do
    name=$(basename $component)
    print -n " $name"
    source $component
done
print


alias nmap="/cygdrive/c/Program Files (x86)/Nmap/nmap"
