########################################################################################################
#vim:ft=zsh
#
#   ZSH key bindings
#
#   NOTE: Be careful adding keybinds.  Remember that Alt+<key> sends the same
#   character as hitting Escape, then <key>.  When using vim mode, this causes
#   problems.  With <Alt-l>, for example, Did I mean to move the cursor to the
#   right, or list the contents of the directory?
#
#   NOTE: I use vi mode for command line editing.  It seems that these bindings
#   are only recognized in command mode, and not in normal mode.  I would like
#   to have commands that work regardless of mode (attempting to escape out to
#   normal mode does not work, as the command doesn't get invoked in the first
#   place).  I feel like there's a way to get there, if I think about it.
#   Haven't gotten there yet..
#
# TODO?: Add an easier way to paste from the system clipboard than shift-insert


# A string useful to initialize a to-be-inserted command from whatever state in
# which the command line may currently be.
#
# \e: go to normal mode
#  0: go to beginning of line
#  D: delete contents of line
#  i: go into insert mode
init='\e0Di'


# <Alt-p> goes to the [P]reviously visited directory
#bindkey -s '\ep' '^Ucd -^M'
bindkey -s '\ep' "${init}popd^M"

# <Alt-r> opens [R]anger, a really slick console-based vim-keyed file manager
bindkey -s '\er' "${init}ranger^M"

# <Alt-z> [re-]sources .[Z]shrc (and consequently all zshconfig component files)
# There are a couple different ways to approach this..

  # With this approach, erase whatever the current contents of the command
  # line are, and run our command
  #bindkey -s '\ez' "${init}source ~/.zshrc^M"

  # This approach just inserts our command at the current point in the command
  # line, and lets the user decide when and whether to run it. 
  bindkey -s '\ez' "\eisource ~/.zshrc\e"   

# Use <Alt-Enter> to insert a literal newline (It may be worth mentioning here
# that even without this, you can use the 'o' command in vi mode to insert
# newlines as well.)
bindkey '^[^M' self-insert-unmeta

# <Alt->> inserts the last argument of the previous command
bindkey '\e>' insert-last-word

##############################################################################

# Some other ideas:
#
#
# Alt-u goes [U]p a directory
#bindkey -s '\eu' '^Ucd ..^M'

# alt-h returns [H]ome
#bindkey -s '\eh' '^Ucd^M'

# alt-l [l]ists the contents of the current directory.
#bindkey -s '\el' '^Uls --color=auto --classify --human-readable^M'

# Alt-v opens [V]im, restoring the state in was in when last shutdown
#bindkey -s '\ev' '^Uvim -c "source ~/.vim/shutdown_session.vim"^M'

## Alt-d shows the [D]irectories in the current location
#bindkey -s '\ed' '^Uls -d */^M'

## Alt-t shows a [T]ree view of the current location
#bindkey -s '\et' '^Utree -L3^M'

## Alt-x e[X]its the terminal
#bindkey -s '\ex' '^Uexit^M'
