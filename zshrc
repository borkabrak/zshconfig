################################################################################
# ZSHRC - Z-shell Runtime Configuration
#
#       ZSH has a ton of different configuration commands possible.  Once your
#       config gets big enough, it makes sense to split all those commands into
#       different COMPONENT FILES, depending on their type (shell functions,
#       options, named directories, etc.), and named accordingly.
#
#       All the different component files are kept in a components DIRECTORY.
#
#       This version of zshrc does nothing but read those components.
#       Specifically, it sources everything in the components directory that
#       has an extension of "*.zsh"
#
#       To add a new file, just create it and put it in the components
#       directory.  Make sure it has a *.zsh extension, and you're done.
#
#       You might see files in the components directory with extensions like
#       '*.inactive'.  This is just a convenient way to turn a whole swath of
#       config on and off.  If they don't end with *.zsh, they're ignored.
#
################################################################################

components_directory="$HOME/.zsh/include"

autoload colors && colors
print -n "$fg_bold[white]Sourcing ZSH config components from $components_directory..\n\t$fg[cyan]"
for component in $(ls $components_directory/*.zsh); do
    name=$(basename $component)
    print -n " $name"
    source $component
done
print

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
#         TODO:
#         ---------
#         * Checkout out 'zgen' instead of antigen:
#             It looks to have some very real advantages.
#      
#                https://github.com/tarjoilija/zgen
#
