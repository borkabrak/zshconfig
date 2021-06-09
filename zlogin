print "Greetings, sir.  It's wonderful to have you back."

# Some things I might want to be reminded about..
# task list
print "=============================================================================="
#jot

# # Swap keys <CapsLock> and <Escape>
#setxkbmap -option caps:swapescape

# Here's something a bit more elaborate:
#
#   NOTE:  Here's something odd.. this worked fine for a while, with the
#   CapsLock key sending Escape on keyup, and acting as a Ctrl key when held
#   down while typing another key.  Then, at some point, and for no apparent
#   reason, it stopped being an escape key.  WTF???
#
#   For now, I guess I'll give up the Ctrl functionality.
#
#   Something might be possible using the 'xcape' program..

setxkbmap -option # Start by clearing any extant setxkbmap options
# setxkbmap -option caps:ctrl_modifier
setxkbmap -option caps:escape
setxkbmap -option shift:both_capslock
# setxkbmap -query

print "
  CapsLock = Escape
  Escape   = Escape
  To lock caps, use both shift keys.
"
