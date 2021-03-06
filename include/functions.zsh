# My own personal ZSH functions
#
# This is a list of functions written to extend normal zsh behavior


# Autoload other functions from the ZSH standard library
# (/usr/share/zsh/functions)
# mv, cp, ln on multiple files at once
autoload zmv zcp zln


function ghub() {
# Clone a github repository by name alone (in the form 'user/repository')
  git clone https://github.com/$1.git
}


alias makdir=makedir
function makedir() {
# Create a new directory and automatically cd into it.
# (cf. `mkdir -p`)
    if [[ ! -e $1 ]]; then
        mkdir -p $1
    fi
    cd $1
}


function timer(){
# Wait <n> seconds and sound an alert noise.  Regularly report time left.

  if [[ $@ = 0 ]]; then echo "$ timer <minutes>"; return 1; fi
  for i in $(seq 1 $1 ); {
    remaining=$(( $1 - $(( $i - 1 )) ))
    echo "$remaining minutes remaining.";
    sleep $seconds_in_a_minute;
  }
  sfx warble;
}


function countdown() {

  # Reset to expected value, in case it's been used elsewhere
  OPTIND=1

  # Set command default
  command=(/home/jon/bin/sfx warble)

  function usage() {
      print """
          USAGE
              $1 [ -h ] [ -m ] [ -c COMMAND ] duration

          DESCRIPTION
              Count down a given amount of time, then execute a command.

          OPTIONS

              -h Print usage and exit.

              -m Interpret duration as minutes instead of seconds.

              -c command
                Command to execute.  Defaults to \`$command\`
        """
  }

  # Parse options
  while getopts "hmc:d" OPT; do

    case $OPT in

      h)
        usage $0 && return
        ;;

      m)
        use_minutes=true
        ;;

      c)
        command=(${=OPTARG})
        ;;

      d)
        debug=true
        ;;

    esac

  done

  # Validate input
  duration=$@[$#]
  if ! [[ $duration =~ '^[0-9]+$' ]]; then
    print "'$duration' is not an integer. The countdown duration must be the last argument given"
    usage $0
    return
  fi

  if [[ $use_minutes ]]; then
    # Duration is in minutes, so convert it to seconds
    duration=$(( 60 * duration ))
  fi

  # Execute
  sleep $duration && "$command[@]"

}


function parseopts() {
# For debugging.  Practice parsing options
# For more examples, check out countdown()

    print "==[ $(date) ]=="
    typeset -a opts;
    zparseopts -a opts h v;
    print "Parameters:"
    for p in $*; do
        print "\t$p"
    done

    print "opts:$opts"
    for o in $opts; do
        print "\t$o"
    done
    print "===================================="
    return $opts
}


function tracelink() {
# Show each step in a chain of symbolic links
#
# Actually.. sorry, self, but 'whence' has options that do this, probably better..

    # With no args, just show usage
    if [[ ! $# > 0 ]]; then
        cat <<-END
$0():
    Show each step in a chain of symbolic links

    USAGE:
        $0 <linkname> [command...]

    linkname
        The link to start with.

    command
        Optional.
        Command to run on every link instead of 'ls'.
        The link/file name is appended to this.

END
        return 0
    fi

    # First argument is the link name
    target=$1 && shift

    # Default command is "ls"
    command=(ls --color)
    # All other arguments are a single command to run
    if [[ $# > 0 ]]; then
        command=($@)
    fi

    # 1.) Run the command on the current target
    $command $target

    # 2.) Recurse on symbolic links
    if [[ -L $target ]]; then

        # Since links can be relative, we need to switch to the target's
        # directory to follow the next one.
        pushd -q $(dirname $target)

        # Recurse on the file to which the current target links.
        tracelink $(readlink $target) $command

        # Pop back out to this target's directory, so that we end up where we
        # began.
        # popd -q

    fi

}


function newsite() {
# Carry out the shell-level operations common to setting up most websites.

    # !!! NOT YET TESTED !!!
    echo "NOT YET TESTED" && return 1

    # Name of this one
    sitename=$1

    # Directory to start them in
    sitedir=~/public_html/$sitename

    # Create the folder
    mkdir -p $sitedir/$sitename
    # Make it browseable
    chmod +x $sitedir

    # Might want to consider default content for these
    for filename in (index.html $sitename.scss $sitename.js); do
        touch $sitedir/$filename
    done

    # Maybe..
    # * open up an appropriately-built vim session?
    # * Start a libnotify watch to build the CSS?
    # * Initialize a git repo?
    #       - Suitable default .gitignore
    #
    # At any rate, test this - it's enough to be a help already, anyway.

}


function c() {
#########################################################################
# c - for "see" - Show any summary info possible for arbitrary expression
#########################################################################
#
# Provide summary/descriptive information on things.  Try hard to be as
# informative as possible with minimal instruction.
#
# TODO:
#   * Allow globs. (e.g. '*.jpg')
#
# -jdc 2014-12-04

    # target is the first argument given.  Default to current directory.
    target=${@[1]-.}

    # Choose behavior based on what the given target *is*
    #   Possible types:
    #      * Directory - ls
    #      * Filename - ls; file; head
    #      * symlink - tracelink

    # directory:
    if [[ -d $target ]]; then
        ls --indicator-style=classify --group-directories-first --human-readable --color --size  $target

        print
        # Show the first few lines of any readme files that happen to be in the
        # directory.
        setopt EXTENDED_GLOB
        head -5 -v (#i)$target/*read?#me* 2>/dev/null

    # symlink:
    elif [[ -L $target ]]; then
        # show the link chain
        tracelink $target;

    # regular file:
    elif [[ -f $target ]]; then
        (ls -hl $target; file $target) | grep --color=always $target
        print
        head $target | pygmentize

    else
        # Anything else:
        ls -l $target
        file $target

    fi

}


function parseInt() {
# Return arg, stripped of anything that makes it not an integer

    arg=($1 or read)
    grep -o '[0-9]\+' =(echo $1) | head -1
}


function process-query() {

  if [[ $# -lt 1 ]] {
    print "
    USAGE
      $0 <pattern>

    DESCRIPTION
      Print all currently running processes matching <pattern> and a summary
      count of how many there are.

      Accepts multiple patterns at a time.
    "
    return 1
  }

  for param in $@; {

    print -P "[ %F{13}$(pgrep -fc $param)%f ] currently running processes match '%F{10}$param%f':"
    pgrep -fa $param
    print

  }

}


function rand() {
# Print a random number between 0 and a given param (non-inclusive;  that is,
# 'rand 2' prints either 0 or 1 - never 2)
# If no param is given, then just print $RANDOM

  #cf: `man zshparam /RANDOM`, `man zshexpn /PARAMETER EXPANSION`
  retval=$RANDOM
  if [[ $1 ]]; then retval=$(( $RANDOM % $1 )) fi
  print $retval
}


function hotrod() {
# Output brief info on the process currently using the most CPU

  top -bn 1 -o -'%CPU' | tail -1 | awk '{ print $NF,$1,$9 }'
}


# Print a compact table of which numbers produce which colors.
# This is helpful for using prompt-style color output a la:
#     %F{color/number}colored text%f
function colortable() {

  separator=" "   # │ | :


  # ${1-16} means use the value of $1 or, if $1 is not set, use the literal
  # value '16'.  In other words, set this to the param passed to this function
  # or default to 16.
  entries_per_line=${1-16}
  # NOTE: Using 36 entries per line (with a small enough font to get a whole
  # row on the screen) shows an effect I don't quite understand.  Like
  # particular hues lining up.  Must have something to do with how the list was
  # originally determined.  But what, exactly?

  # Use this to adjust the width of the column automatically to the width of
  # the screen.
  #
  # entries_per_line=$(( $COLUMNS / 4 ))

  for n in {0..255}; {

    # output - Add leading zeros so everything lines up
    print -Pn "${separator}%F{$n}$(printf %0.3i $n)%f"

    # add a new line every so many entries
    if [[ $(( ( n + 1 ) % $entries_per_line )) -eq 0 ]] {
      print -n "${separator}\n"
    }

  }

}


# Print a sizeable bit of text showing number/color correspondence
function colorlist() {
  for i in {0..255}; {
    print -P "%F{$i}This is color $i."
  } | less -R
}


# Suspend system in a manner independent of desktop environment
function suspend-to-memory() {

  # Default
  subcmd="suspend"

  case $1 in

    hard|hibernate)
      subcmd="hibernate"
      ;;

  esac

  print systemctl $subcmd
  systemctl $subcmd

}


function duf() {
  df -h .

  print -Pn "Total size of %F{6}$(pwd)%f.. "
  print -P  "%F{10}%B$(du -hs . 2>/dev/null | awk '{print $1}')%b%f"
}


###############################################################################
# A couple of functions to more easily access directories on my phone, wherever
# it gets auto-mounted.  These are functions because named directories and
# shell params don't seem to handle wildcards (*) very well.
#
# One benefit to using the wildcards is that, even if the phone is disconnected
# and reconnected, these functions still work without even needing to re-source
# this file.
#------------------------------------------------------------
function cd-phone() {
  cd /run/user/$UID/gvfs/mtp*/
}


function cd-phone-comics() {
  cd /run/user/$UID/gvfs/mtp*/Internal*/Comics
}


function cd-phone-sdcard() {
  cd /run/user/$UID/gvfs/mtp*/SD*/
}


# Print something to the screen and run it through a speech synthesizer
function say() {

  # `speak stop` stops all running espeak processes
  if [[ $argv[1] == "stop" ]] {
    pkill espeak
    return
  }

  if [[ -f $argv[1] && $#argv -lt 2 ]] {

    cat $argv[1]

    # throw it in the background so we don't get hung up waiting on a
    # potentially long speech
    espeak -f $argv[1] &

  } else {

    print $argv
    espeak "$argv" &

  }

}


############################################################
# A couple of functions to help with reading markdown files.
#
# ----------------------------------------------------------
# markdownconvert - converts a markdown file into
#   $1 - name of file containing markdown source
# ----------------------------------------------------------
function markdownconvert() {

  if [[ $#argv -lt 1 ]] {
    print "
USAGE

  $0 <markdown file>


DESCRIPTION

  Converts a markdown file into HTML.  Returns (prints) the name of the file
  containing the HTML-ized markdown content.

      "
    return 1
  }

  # The filename can be anything that persists long enough (the '=(<command>)'
  # shell construct doesn't, for some reason)
  filename="/tmp/markdownfile.html"
  markdown $1 > $filename
  print $filename
}


# Display a markdown file in a browser
function markdown-read() {
  # Use a browser to display the file
  x-www-browser $(markdownfile $1)
}


# ----------------------------------------------------------
# Display a markdown file in a browser
#   $1 - name of file containing markdown source
# ----------------------------------------------------------
function markdown-read() {
  x-www-browser $(markdownconvert $1)
}


# Output the integer percentage of battery charge.
function battery-percent() {
  acpi -b | head -1 | perl -pe 's/.*?(\d+)%.*/\1/i'
}


# Save obscure characters along with a little information about them
function unicode-junk-drawer() {

  savefile="unicode-characters.txt"

  # If no params given, print help and quit
  if [[ $# -lt 1 ]] {
    print "
    USAGE: $0 <chars>
      chars - unicode characters to save

    DESCRIPTION:
      Save some info about obscure unicode characters, in case I want to reuse them.
      "
      return 1
  }

  chars=$*  # TODO: Split this into individual characters

  # Write character information to the file, then sort the file, removing
  # duplicate characters
  unicode -s --max 0 --brief $chars | tee -a $savefile
  content=$(cat $savefile)
  print $content | sort -u > $savefile

  print -P "%F{6}Any new characters appended to: $savefile%f"
}


# Get just the inode number for a directory entry
function inode() {
  if [[ $#argv -lt 1 ]] {
    print "
      DESCRIPTION:
        Fetch inode numbers for directory entries

      USAGE:
        $0 <entry name> [<entry name>] ...
    "
    return 1
  }

  for entryname in $argv; {

    ls -i $entryname | cut -f1 -d' '

  }

}


######################################################
# Show all uncommented lines in the input
######################################################
# For now, a commented line is one in which the first non-whitespace character
# is something other than a hash (#) or a double slash (//).  Blank lines are
# also omitted from output.
function uncommented-lines() {
  env grep -P -v '^\s*(#|//|$)' $argv
}


######################################################
# Wrapper for tmux, with my own shortcut substitutions
######################################################
function tm() {

  #TODO: 'help|usage' subcommand

  # Use a clean array for the new argument list
  newargs=()

  # Check for shortcut abbreviations
  case $argv[1] in

    # 'ls' -> 'list-session'
    # ls)
    #   newargs[1]='list-sessions'
    #   ;;

    # 'key*' -> 'list-keys'
    key*)
      newargs[1]='list-keys'
      ;;


    # 'nw' -> 'new-window'
    nw)
      newargs[1]='new-window'
      ;;


    # 'a*' -> 'attach-session'
    # (Anything starting with 'a' means 'attach-session')
    #
    #     $ tm a <sessionname>    # attach to the session named <sessionname>
    #
    #     NOTE:  This may seem like an aggresive abbreviation, but tmux itself
    #     provides no subcommands that begin with 'a' other than
    #     'attach-session'.
    a*)

      # If we have a session name, use it with '-t', the way tmux expects
      if [[ $#argv -gt 1 ]] {

        newargs=('attach-session' '-t' $argv[2])

      } else {

        # If no session name is given, this will attach to a single existing session
        newargs+=('attach-session')

      }
      ;;


    # 'cw' -> 'choose-window'
    # Requires tmux version >2.1, <=3.3
    cw)
      newargs[1]='choose-window'
      ;;

    # 'ns' -> 'new-session'
    # Requires tmux version >2.1, <=3.3
    ns)
      newargs[1]='new-session'

      # If there's another arg, use it as the name of the new session
      if [[ $#argv -gt 1 ]]
      then
        newargs+=('-s' $argv[2]);
      fi
      ;;


    # 'cd' -> change the starting directory for new windows
    cd)
      defaultinput=$(pwd)

      # Anything following 'cd' is presumably the directory to use..
      if [[ $#argv -gt 1 ]]
      then

          # ..but make sure the directory exists
          if [[ -d $argv[2] ]]
          then
              defaultinput=$argv[2]
          else
              print "$argv[2] does not seem to be an existing directory."
          fi
      fi

      # Any args following the directory name get wiped out, but I can't think what we'd want them for
      newargs=("command-prompt" -I $defaultinput -p "Change tmux's working directory to:" "attach -c %1")
      ;;

    # 'log' -> toggle logging.
    #
    #   Log file is at ~/tmux-server-$PID.log
    #   Default is off - tmux normally does not log events.  Probably because..
    #
    #   NOTE: ..tmux logging is QUITE verbose.  When active, tmux seems to add
    #   something on the order of 1000 lines per second.
    lg|log)
      # Logging in a running tmux server is toggled by sending the USR2 signal to the tmux process.
      kill -usr2 $(pgrep tmux)
      return 0  # This doesn't need a 'tmux' command, so we exit early
      ;;


    # Default case - nothing matched, so go ahead with arguments as given
    *)
      newargs=($argv)


  esac


  # Show final command as it will be run
  print -P "%F{69}⮞%f %F{29}tmux $newargs%f\n"

  # Finally, run tmux with the new argument list
  tmux $newargs
}

# in-progress: monitor battery charging status for when you have a flaky power
# plug that needs repair
function battery-monitor() {
  while true;
  do

    acpi
    sleep 1;
    clear;

  done
}

# Print just the first [n] sections of the man page about <topic>.
function manshort() {

  if [[ $#argv == 0 ]] {
    print -P "
    %F{69}$0%f

      Print the first few sections of a man page.

    %F{69}USAGE%f

      %F{69}\$ %F{29}$0 <manpage> <sectioncount>%f

      manpage - The man page to display.

      sectioncount - Number of sections to display.  Default 2.

    %F{69}EXAMPLE%f

      %F{69}\$ %F{29}$0 ls 3%f

      Print the first 3 sections of the man page for the 'ls' command.

    "

    return 1

  }

  topic=$argv[1]

  sectioncount=2
  if [[ $#argv -gt 1 ]] {
    sectioncount=$argv[2]
  }

  man $(basename $topic) 2>/dev/null |
    awk "

      # How many sections do we print?
      BEGIN {
        sectioncount=$sectioncount
      }

      # Count sections by watching for the section header (non-whitespace in first column).
      /^[^[:space:]]/ {
        currentsection++
      };

      # Quit processing the file when a particular section count is reached
      currentsection > (sectioncount + 1) {
        exit
      };

      { print }

    ";
}

function manopts() {

  if [[ $#argv == 0 ]] {

    print -P "
    $0: List the options for a command.

    USAGE: $0 <manpage>

    NOTE:  This is a brainless little function that really just shows all the
    lines from the command's man page that start with a dash (As well as the
    line following).  It's ad-hoc, slapdash, and is always sick at sea.  It
    would be laughably naive to bet anything important on it being either
    accurate or complete.
    "
    return 1

  }

  man $argv[1] | grep -P "^\s*-" -A 2 | less

}

# usage() is a utility function intended to streamline the delivery of friendly,
# attractive messages to help the user invoke these functions correctly.
# usage() is intended as an aid for writing other functions, rather than a
# standalone end-user tool.
#
# USAGE: usage $usagetext $errormessage
#
#   $usagetext - a block of text describing the general usage of the function
#
#   $errormessage - an optional message indicating the specific error condition that prompted this invocation of usage()
#
# For an example, take a look at every()
function usage() {

    if [[ $#argv -gt 1 ]] { print -P "\n%F{220}$funcstack[2]():$argv[2]%f" }

    print -P "$argv[1]"

    return 1
}

# Run a command every <x> seconds
function every() {

    usagetext="
    %F{69}NAME%f

      %F{29}$0()%f

      Run a command every <x> seconds

    %F{69}USAGE%f

      %F{69}\$ %F{29}$0 <duration> <command>%f

      duration  - The number of seconds to wait between invocations of the
                  command.

      command   - The command to run.  Whitespace should be escaped or the
                  command surrounded in quotes.

    %F{69}EXAMPLE%f

      %F{69}\$ %F{29}$0 3 \"date -R\"%f

      Every 3 seconds, output the date in RFC2822 format.

    "
# Audit parameters..
  if [[ $#argv -eq 0 ]] {
    usage $usagetext
    return 1
  }

  if [[ $#argv -ne 2 ]] {
    usage $usagetext "There should be exactly 2 params"
    return 1
  }

  delay=$argv[1]
  if [[ ! $delay == [0-9]* ]] {
    usage $usagetext "'$delay' does not seem to be an integer"
    return 1
  }

  command=$argv[2]

  while true; do

    eval $command

    sleep $delay

  done
}

# Print just the names of all loaded functions (the zsh builtin command
# 'functions' prints the entire function body as well)
function functionnames() {
  functions | grep '^[^} 	]' | awk '{print $1}'
}

# Show directories in the current location sorted by size *of their contents*
# (`ls -S` seems to just show the size of the directory inode itself -- 4K for
# every one.)
function sizes() {
  du -hd0 */ | sort -hr
}
