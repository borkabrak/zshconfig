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
#       '*.inactive'.  This is just a convenient way to "turn off" a whole
#       file.  If it doesn't end with *.zsh, it's ignored.
#
################################################################################

components_directory="$HOME/.zsh/include"

print -Pn "%F{green}⦗%f%F{magenta}$(tty)%f%F{green}⦘%f
%F{69}Loading ZSH config components from $components_directory%f..
"

# The '**/*' bit means that all *.zsh files will be read, even in arbitrarily
# deeply nested subdirectories.  So, if necessary, more config files can be further
# sub-categorized within their own directories, and everything still gets read.
for component in $(ls $components_directory/**/*.zsh); do

    # Strip the leading directories away to get just the base file name
    filename="%F{cyan}$(print $component | sed "s:$components_directory/::")%f"
    separator="%F{green}｜%f"

    source $component

    print -Pn "$filename$separator"

done
print

# Here's another, shorter and more computationally efficient, way of doing the
# same thing as that whole loop above. Although it doesn't let you register the
# processing of each file.. with fancy colored text.. yeah okay.
#
# source =(cat $components_directory/**/*.zsh)

