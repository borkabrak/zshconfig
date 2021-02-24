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
# looking for differences. :)
#
# • Dynamic information in the prompt (anything that may change in between
# displays of the prompt, such as the current time) can be handled with the
# special hook function 'precmd()'. precmd() is run just before every time the
# prompt is displayed, giving you a chance to make sure it's up-to-date.
#
# ZSH also provides an array, 'psvar', that can be used to set the prompt
# dynamically.
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


# Print a symbol to represent the state of power to the system
function get_power_state_symbol() {
  if [[ $(acpi -a) =~ "on-line" ]] { 
    print "%F{10}🔌 %f"  # Power adapter is plugged in
    } else { 
    print "%F{11}🗲 %f"   # Otherwise, it must be discharging
  }
}

function battery_capacity() {
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
  if [[ currentcharge -gt 66 ]] {
    # green: near-full
    color=10
  } elif [[ currentcharge -gt 33 ]] {
    # yellow: in between
    color=11
  } else {
    # red: low
    color=1
  }

  retval="%F{$color}$currentcharge%% $symbol %f"

  if [[ currentcharge -lt 10 ]] {
    # If charge < 10%, try to make it more attention-getting
    retval="%S%F{1}‼$currentcharge%%%f%s"
  }

  print $retval
}

# precmd(): A special function that ZSH runs automatically before each display
# of the prompt.
function precmd() {

                           user="%F{ 10}%n%f"
                             at="%F{ 87}@%f"
                           host="%F{141}%m%f"
                            sep="%F{ 87}:%f"
              current_directory="%F{ 12}%~%f"
                          arrow="%F{ 13}➤%f"
  current_directory_entry_count="🗁 %F{141}$(printf '%3s' $(ls | wc -l))%f"    # ⎹⎸

                           time="%S%F{141}$(date +'%l:%M%p %S"')%s%f"
                        battery="$(get_power_state_symbol)$(battery_capacity $(battery-percent))"
                            tty="%F{87}$(tty)%f"

  ###############################################################################################
  # Main prompt
  #-------------
  PROMPT="${user}${at}${host}${sep}${current_directory}${arrow} "
  ###############################################################################################
  
  ###################################
  # 'Right' prompt
  #----------------
  RPROMPT="${battery} ${current_directory_entry_count} ${tty} ${time}"
  ###################################
}
