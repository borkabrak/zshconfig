################################################################################
# OPTIONS
################################################################################
#
# It's worth remembering that, with options names, case doesn't matter and
# underscores are ignored.
#
# Options, as opposed to params, are environment variables that are either on
# or off.  If it holds a value (such as a filename, or a number), it's properly
# a 'param', and is probably set in zshenv.
################################################################################

## History
    
    # Lines are added to the history file upon execution, until file size is
    # 20% greater than $HISTSIZE
    #setopt INC_APPEND_HISTORY
    # setopt SHARE_HISTORY

    #Save each command's beginning timestamp (in seconds since the epoch) and
    #the duration (in seconds) to the history file.
    setopt EXTENDED_HISTORY

    # Don't append consecutive duplicates to the command history.
    setopt HIST_IGNORE_DUPS

    # Don't append the history command itself (fc -l) to the history.
    setopt HIST_NO_STORE

    # When referring to a command in the history, don't immediately execute it --
    # just load it in the command line, ready to go.
    setopt HIST_VERIFY


## MISC

    # allow comments even in interactive shells
    setopt INTERACTIVE_COMMENTS

    # Using a directory name as a command switches to that directory 
    setopt AUTOCD

    # `cd` does an automatic `pushd` for you
    setopt AUTOPUSHD
        # Don't push duplicates onto the directory stack.
        setopt PUSHD_IGNORE_DUPS

    # If an arg to `cd` isn't a directory name, try prepending tilde (~), allowing
    # named directories, e.g.
    setopt CDABLE_VARS

    # In globs, also use the special characters: '#~^'
    setopt EXTENDED_GLOB

    # Don't exit on ^D (unless, actually, ten consecutive such EOF chars are
    # received).
    setopt IGNORE_EOF

    # When displaying completion lists, try to save space by allowing variables
    # column widths.
    # setopt list_packed

    # Completion lists sort horizontally -- across, then down (default is down, then across)
    setopt LIST_ROWS_FIRST

    # Disable 'nomatch'.  The effect is that errors are NOT printed if a pattern
    # for filename generation has no match.
    setopt NONOMATCH

    # In a single-quoted string, allow a quote to escape itself: I.E:
    #   'This here''s one valid string' 
    setopt RC_QUOTES

################################################################################
# Options Active on original (before .zshrc was lost)
################################################################################
# setopt noappendhistory
# setopt autocd
# setopt autopushd
# setopt nobeep
# setopt cdablevars
# setopt extendedglob
# setopt globdots
# setopt histignoredups
# setopt histnostore
# setopt histverify
# setopt ignoreeof
# setopt listpacked
# setopt listrowsfirst
# setopt login
# setopt longlistjobs
# setopt monitor
# setopt nonomatch
# setopt pushdignoredups
# setopt rcquotes
################################################################################

