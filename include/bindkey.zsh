########################################################################################################
#vim:ft=zsh
#
#   ZSH key bindings
#
# TODO: Add an easier way to paste from the system clipboard than shift-insert

# Use Alt-Enter to insert a literal newline (It may be worth mentioning here
# that even without this, you can use the 'o' command in vi mode to insert
# newlines as well.)
bindkey '^[^M' self-insert-unmeta

# The following big list of key bindings is problematic, and so I'm disabling them.
#   * They're a nice idea, but it turns out that Alt+<key> sends the same
#   character as hitting Escape, then <key>.  When using vim mode, this causes
#   problems.  Did I mean to move the cursor to the right, or list the contents
#   of the directory?
#
#   * Something else to remember:  Using ^U to begin these bindings, in order
#   to clear the command line before inserting the bound command, is also a
#   nice idea.  Until you find that ^U only erases the characters inserted
#   since the last time you entered insert mode.  Which is not necessarily
#   everything on the line, creating frankenstein command lines whose results
#   are.. let's just call it 'undefined'.
#     - As a substitute, let's try '\e0Di'  ('esc' to enter command mode, '0'
#     to go to beginning of line, 'D' to delete everything to the end of the
#     line, 'i' to enter insert mode.)
#
#   * In summations, sure, use bindings all you want, but come back to it in a
#   bit with a little more polish.  In the meantime, most of these have ended
#   up just causing problems.  Live and learn.

# Alt-u goes [U]p a directory
#bindkey -s '\eu' '^Ucd ..^M'

# alt-h returns [H]ome
#bindkey -s '\eh' '^Ucd^M'

# alt-l [l]ists the contents of the current directory.
#bindkey -s '\el' '^Uls --color=auto --classify --human-readable^M'

# Alt-p goes to the [P]reviously visited directory
#bindkey -s '\ep' '^Ucd -^M'

# Alt-v opens [V]im, restoring the state in was in when last shutdown
#bindkey -s '\ev' '^Uvim -c "source ~/.vim/shutdown_session.vim"^M'
#
## Alt-d shows the [D]irectories in the current location
#bindkey -s '\ed' '^Uls -d */^M'
#
## Alt-t shows a [T]ree view of the current location
#bindkey -s '\et' '^Utree -L3^M'
#
## Alt-x e[X]its the terminal
#bindkey -s '\ex' '^Uexit^M'

# Alt-r opens [R]anger, a really slick console-based vim-keyed file manager
bindkey -s '\er' '\e0Diranger^M'

# Alt-z sources .[Z]shrc
bindkey -s '\ez' '\e0Disource ~/.zshrc^M'

# Alt-> inserts the last argument of the previous command
bindkey '\e>' insert-last-word

