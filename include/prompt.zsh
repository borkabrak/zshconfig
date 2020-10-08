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
function get_power_state_symbol() {
  if [[ $(acpi -a) =~ "on-line" ]] { 
    print "%F{10}🔌 %f"  # Power adapter is plugged in
    } else { 
    print "%F{11}🗲 %f"   # Otherwise, it must be discharging
  }
}

function get_battery_graphic() {
  # Given the battery charge percentage ($1), print a graphical representation, possibly including the charge

  currentcharge=$1
  color=015 #default color is regular old white
  max=100   # max percentage is, of course, 100
  symbols=({▁..█})  # List of symbols is U+2581..U+2588 (▁ ▂ ▃ ▄ ▅ ▆ ▇ █)  
  symbol=$symbols[$#symbols]

  # Approximately map the current battery charge (1..100) to the corresponding
  # symbol from the array.  This should be tolerant of arbitrary changes to the
  # symbol list.
  subscript=$(( ( $currentcharge / ($max / $#symbols) ) + 1 ))
  if [[ subscript -gt $#symbols ]] { subscript=$#symbols }
  symbol=$symbols[$subscript]

  # Set color
  #   green:      near-full
  #   yellow:     in between
  #   red:        low
  if [[ currentcharge -gt 66 ]] {
    color=10
  } elif [[ currentcharge -gt 33 ]] {
    color=11
  } else {
    color=1
  }

  retval="%F{$color}$symbol$currentcharge%%%f"

  if [[ currentcharge -lt 10 ]] {
    # If charge < 10%, try to make it more attention-getting
    retval="%S%F{1}‼$currentcharge%%%f%s"
  }

  print $retval
}

# precmd(): A special function that ZSH runs automatically before each display
# of the prompt.
function precmd() {

  batterypercent=$(battery-percent)

  time="%S%F{141}$(date +'%l:%M%p')%s%f"
  battery="$(get_power_state_symbol)$(get_battery_graphic $batterypercent)"
      tty="%F{87}tty$(tty | env grep -o '[0-9]\+')%f"


  
  # ZSH lets you have a 'right prompt', which sits on the far right side of the
  # command line.  
  RPROMPT="${battery} ${tty} ${time}"
}
