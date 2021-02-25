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
    "
    return 1
  }
	pgrep -fa $1
	print -P "===\n%F{13}$(pgrep -fc $1)%f processes matching '%F{10}$1%f'"
}


function rand() {
# Print a random number between 0 and a given param (minus one)
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
function colortable {

  separator=" "   # │ | :


  # ${1-16} means return $1 or, if $1 is not set, return 16.  In other words,
  # set this to the param passed to this function or default to 16.
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
function colorlist {
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


###############################################################################

# Show the largest $1 directories in the current location
function showlargest() {

  # first argument: how many to show.  Default to 10.
  count=${1-10}

  # 1048576 = 1024 * 1024 (Converts bytes to GB)
  du * | sort -rn | head -$count | awk '{print ($1 / 1048576 ) "GB", $0}'
}


# Print something to the screen and run it through a speech synthesizer
function speak {
  print $argv
  espeak "$argv" & # throw it in the background so we don't wait on a potentially long speech
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
function battery-percent {
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

  # Use a clean array for the new argument list
  newargs=()

  # Check for shortcut abbreviations
  case $argv[1] in

    # 'ls' -> 'list-session'
    ls)
      newargs[1]='list-sessions'
      ;;


    keys)
      newargs[1]='list-keys'
      ;;


    # Anything starting with 'a' means 'attach-session'
    #
    #     $ tm a <sessionname>    # attach to a specific session
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


    # 'cd' -> change directory for new windows.
    cd)
      defaultinput=$(pwd)

      # if we have more arguments beyond 'cd'..
      if [[ $#argv -gt 1 ]]
      then

          # ..make sure the directory exists and is a directory
          if [[ -d $argv[2] ]]
          then
              defaultinput=$argv[2]
          else
              print "$argv[2] does not seem to be an existing directory."
          fi
      fi

      # This wipes out any further args passed in, but I'm not sure how those could mean anything, anyway.
      newargs=("command-prompt" -I $defaultinput -p "Change tmux's working directory to:" "attach -c %1")
      ;;


    # Default case - nothing matched, so go ahead with argument as given
    *)
      newargs=$argv


  esac

  # Show final command as it will be run
  print -P "%F{69}⮞%f %F{29}tmux $newargs%f\n"

  # Finally, run tmux with new argument list
  tmux $newargs
}
