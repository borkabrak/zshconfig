print "Greetings, sir.  It's wonderful to have you back."

# Some things I might want to be reminded about..
task list
print "=============================================================================="
#jot

# # Swap keys <CapsLock> and <Escape>
#setxkbmap -option caps:swapescape

# Here's something a bit more elaborate:

setxkbmap -option # Start by clearing any extant setxkbmap options
setxkbmap -option caps:ctrl_modifier
setxkbmap -option caps:escape
setxkbmap -option shift:both_capslock

# At least for now, remind me of this setup
setxkbmap -query
print "
  CapsLock functions as both Ctrl and Escape. To actually lock caps, use both shift keys.
"
