################################################################################
# ZSHRC - Z-shell Runtime Configuration
#
#     # ZSH config files are symlinks into this git repository.
#
#         This ZSH config setup is different than most.  Here's what's going on:
#         
#         Everything pertaining to ZSH configuration is in a git repository.  
#         
#         The repository also includes a script to 'install' the files, which works
#         by creating symlinks in the user's home directory (or $ZSHDOTDIR, if set).
#         These links point to the files in the repository, so updating the repo
#         automatically provides new shells with the new configuration.
#
#
#     # This zshrc sources all the actual configuration commands from `include/*.zsh`
#
#         This .zshrc file is split into individual component files for various things
#         such as options, aliases, etc.
#      
#         TODO:
#         ---------
#         * Checkout out 'zgen' instead of antigen:
#             It looks to have some very real advantages.
#      
#                https://github.com/tarjoilija/zgen
#
#
################################################################################
#
#--------------------------------------------------------------------------------
#
# ZSHRC COMPONENTS
# ----------------
#

# To add a new file, just put it in the components directory and give it a
# *.zsh extension.  No editing of anything else is required.
#
# This file just loads all the other files in the components directory that
# have an extension of '*.zsh'.
components_directory="$HOME/.zsh/include"

autoload colors && colors
print -n "$fg_bold[white]Sourcing ZSH config components from $components_directory..\n\t$fg[cyan]"
for component in $(ls $components_directory/*.zsh); do
    name=$(basename $component)
    print -n " $name"
    source $component
done
print
