# vim:ft=zsh
#
# ==============================================================================
# SETTING THE ZSH PROMPT
# ==============================================================================
# • Prompt sequences have some special expansion rules that allow for things
# like colored text and pre-set variables.  You can read all about the details
# by searching for EXPANSION OF PROMPT SEQUENCES in `man zshmisc`.  You can get
# the `print` command to use these special rules as well by giving it the -P
# option.  (get colors without autoload!)  `echo` won't do that, if you're
# looking for differences.
#
# • Dynamic information in the prompt (stuff that may change in between
# displays of the prompt.  i.e., time.) can be done with the special hook
# function 'precmd()'.  ZSH also provides an array, 'psvar', that can be used
# to set the prompt dynamically.  
##############################################################################
# 
#-------------------------------------------------------------------------------------
# SPECIAL EFFECTS POSSIBLE WITH PROMPT EXPANSION:
#-------------------------------------------------------------------------------------
# %F{color}     Foreground color
# %K{color}     Background color
# %B            Bold
# %U            Underline
# %S            Standout (reverse fore- and background colors)
#-------------------------------------------------------------------------------------
# Here's a handy function to show what color is produced by each number:
#
# function showcolors {
#   for i in {0..255}; {
#     print -P "%F{$i}This is color $i."
#   } | less -R
# }

# I've broken different parts down into pieces to try to make futzing around
# with it easier:
#-------------------------------------------------------------------------------------
               user="%F{ 10}%n%f"
                 at="%F{ 87}@%f"
               host="%F{141}%m%f"
                sep="%F{ 87}:%f"
  current_directory="%F{ 12}%~%f"
              arrow="%F{ 13}➤%f"
#-------------------------------------------------------------------------------------
PROMPT="${user}${at}${host}${sep}${current_directory}${arrow} "


# Print a symbol to represent the state of power to the system
function power_state_symbol() {
  if [[ $(acpi -a) =~ "on-line" ]] { 
    print "%F{10}🔌%f"  # Power adapter is plugged in
    } else { 
    print "%F{11}🗲%f"   # Otherwise, it must be discharging
  }
}


# precmd(): A special function that ZSH runs automatically before each display
# of the prompt.
function precmd() {

  time="%S%F{141}$(date +'%l:%M%p')%s%f"
  battery="%F{10}$(battery-percent)%%%f$(power_state_symbol)"
      tty="%F{ 87}tty$(tty | env grep -o '[0-9]')%f"

  # ZSH lets you have a 'right prompt', which sits on the far right side of the
  # command line.  
  RPROMPT="${battery} ${tty} ${time}"
}
