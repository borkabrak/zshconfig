# My own personal ZSH functions

# Autoload other functions from the ZSH standard library
# (/usr/share/zsh/functions)

# mv, cp, ln on multiple files at once
autoload zmv zcp zln

function ghub() { 
# Clone a github repository by name alone (in the form 'user/repository')
  git clone https://github.com/$1.git 
}

function makedir() {
# Create a new directory and automatically cd into it.
# (cf. `mkdir -p`)
    if [[ ! -e $1 ]]; then
        mkdir -p $1
    fi
    cd $1
}

alias makdir=makedir

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

function queryproc() {
# Show all processes matching a string, and a summary count at the end.
# Seems awfully specific, but I keep finding myself doing it, so..
#	Example:
#		$ queryproc steam			# show all steam processes, with a count of how many there are.

	pgrep -fa $1
	print "$hr\n'$1' procs: $(pgrep -fa $1 | wc -l)"
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
