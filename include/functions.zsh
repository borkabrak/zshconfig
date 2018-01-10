# My own personal ZSH functions

# Autoload other functions from the ZSH standard library
# (/usr/share/zsh/functions)

# mv, cp, ln on multiple files at once
autoload zmv zcp zln

# Clone a github repository by name alone (in the form 'user/repository')
function ghub() { git clone https://github.com/$1.git }

# Automatically switch to a newly created directory
# (cf. `mkdir -p`)
function makedir() {
    if [[ ! -e $1 ]]; then
        mkdir -p $1
    fi
    cd $1
}

alias makdir=makedir

# Wait <n> seconds and sound an alert noise.  Regularly report time left.
function timer(){

  if [[ $@ = 0 ]]; then echo "$ timer <minutes>"; return 1; fi
  for i in $(seq 1 $1 ); {
    remaining=$(( $1 - $(( $i - 1 )) ))
    echo "$remaining minutes remaining.";
    sleep $seconds_in_a_minute;
  }
  sfx warble;
}

# For debugging.  Practice parsing options
function parseopts() {
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

# Show each step in a chain of symbolic links
function tracelink() {

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
        popd -q

    fi

}

# Show info about commands
function wh() {

    if (( $# < 1 )); then
        cat <<-USAGE
        $0 - Show info about commands

            $ $0 [<options>] <command>

        By default, show info about all commands that begin with <command>.
        This function accepts additional options to whence. (man zshbuiltins)
            -jdc, 2015-12

USAGE
        return 1
    fi

    whence -sam "$@"

}

# Carry out the shell-level operations common to setting up most websites.
function newsite() {

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

###################################################
# c - for "see" - Automatically do what I want.
#
# Provide summary/descriptive information on things.  Try hard to be as
# informative as possible with minimal instruction.
#
# TODO: 
#   * Detect textfiles and cat them.  'file' on default.
#   * Allow globs. (e.g. '*.jpg')
#
# -jdc 2014-12-04
function c() {

    # target is first argument (or current directory if no arg given)
    target=${@[1]-.}

    # Choose behavior based on what the given target *is*
    #   Possible types:
    #      * Directory - ls
    #      * Filename - head
    #      * symlink - tracelink
    
    # If target is a directory, show its contents
    if [[ -d $target ]]; then
        ls -l --human-readable --color --size  $target
       
        # Show the first few lines of any readme files
        #   Match anything containing 'readme', with an optional single
        #   character between the words.
        setopt EXTENDED_GLOB
        head -5 -v (#i)$target/*read?#me* 2>/dev/null

    # If it's a symlink, show the link chain
    elif [[ -L $target ]]; then
        tracelink $target;

    # It's a regular file - 'file' it and show the first few lines
    elif [[ -f $target ]]; then
        file $target
        print '================'
        head $target

    else
        # Anything else - use 'file' to see what it is.
        file $target

    fi

}

# Return arg, stripped of anything that makes it not an integer
function parseInt() {
    arg=($1 or read)
    grep -o '[0-9]\+' =(echo $1) | head -1
}
############################################
# Trying something with pushd/popd, from:
#   http://unix.stackexchange.com/questions/4290/aliasing-cd-to-pushd-is-it-a-good-idea
############################################
# pushd() {
#   if [ $# -eq 0 ]; then
#     DIR="${HOME}"
#   else
#     DIR="$1"
#   fi
#
#   builtin pushd "${DIR}" > /dev/null
#   echo -n "DIRSTACK: "
#   dirs
# }
#
# pushd_builtin() {
#   builtin pushd > /dev/null
#   echo -n "DIRSTACK: "
#   dirs
# }
#
# popd() {
#   builtin popd > /dev/null
#   echo -n "DIRSTACK: "
#   dirs
# }
#
# alias cd='pushd'
# alias back='popd'
# alias flip='pushd_builtin'

# vim: ft=zsh

