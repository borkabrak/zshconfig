########################################################################################################
#
#   ZSH ALIASES
#
########################################################################################################

# First, remove all existing aliases. Necessary to get a clean slate when, say,
# changing something in this file and re-sourcing zshrc from an existing shell.
unalias -a  # remove normal aliases
unalias -as # remove suffix aliases

########################################################################################################
# SETTING DEFAULT OPTIONS TO VARIOUS COMMANDS
########################################################################################################
#
#   This section is for aliases that copy a normal command, adding options that
#   you almost always want to use. For example:  
#
#     $ alias cp='cp -i'
#
#   will make it so that `cp` always ask before it overwrites a file at the
#   destination.
#
#   Q: ALMOST always, you say?
#
#   A: Right.  Sometimes you really do want to use the soi-disant 'factory
#   standard' version of a command, without whatever nonsense you've done here
#   to mess it up. :)  There are at least a couple ways to do that:
#
#   Both of the following methods will run the 'real' (unaliased, as-installed)
#   version of <command>, ignoring any attempts that may have been tried to
#   alias it to something else:
#
#   1.) You could refer explicitly to the executable (assuming it has one):
#
#     $ /usr/bin/<command>
#
#
#   2.) ..but it's often easier to use the 'env' command:
#
#     $ env <command>
#
#     For convenience and ease of use, the command 'e' can be aliased to 'env',
#     as has been done here.
#
#
########################################################################################################

alias bc='bc -l' 
alias cp='cp -i' 
alias grep='grep --color' 
alias igrep='grep -i'
alias less='less -iR' 
alias ls='ls -h --color=auto'
alias mv='mv -i' 
#alias print='print -P'  # Leaving this here so I don't try it again.  You'll end up typing over the prompt. ???
alias rm='rm -I'
alias tmux='tmux -2 -u' # Run tmux with 256-color and UTF-8 support
alias tree='tree -C' # Colorful tree view
alias w3m='w3m -B' #   -B: If no argument is given, open w3m on a list of bookmarks
alias xargs='xargs -r' # Running commands to xargs with nothing on STDIN:  not even once. :-D
########################################################################################################

# When using whence to learn about a command,
#   c - csh-style output (seems more complete)
#   v - more verbose output
#   a - show all occurences
#   f - if it's a function, show its source code
#   S - if it's a symlink, show all the links until its final resolution
#   m - take arguments to be regex patterns and output all matching commands
#       (usually doesn't do anything unless wildcards are used.)
#   x4 - when printing functions, use a 4-space tabstop
alias wh='whence -cvafSmx4'


##############################################################################
# NEW COMMANDS - (i.e., the LHS didn't exist before alias is parsed)
##############################################################################
alias a2r='sudo apache2ctl restart' 
alias datestamp='date +%F'
alias g=git
alias gg='git status -sb'
alias grevim=regvim
alias hh='fc -li 0' #full history, with extra info.  `fc` is worth reading about in `man zshbuiltins`
alias L='ls -L'
alias l=ls
alias la='ls -a'
alias lisp='clisp -q'
alias ll='ls -l'
alias LL='ls -lL'
alias lsd=lsdirs
alias lsdirs='ls -d */' # List only directories
alias named_directories='hash -d'  #List named directories
alias open=xdg-open
alias readme='vim README.mkd'
alias regvim='gvim -c "source ~/.vim/shutdown_session.vim"'
alias revim='vim -c "source ~/.vim/shutdown_session.vim"'
alias rot13='tr a-zA-Z n-za-mN-ZA-M'
alias rtfm=man
alias sassify='sass --watch --sourcemap=none --scss'
alias t=task
alias tt=task
alias v=vim
alias vv='revim'

# `unicode` - no limit on answers returned, one line each, assume pattern. 
alias ucode='unicode --max 0 --brief -r'  

alias whatprovides='apt-file search -x'

# The w3m package, along with the fairly kick-ass web browser/pager basic
# program, also provides a command to a configuration suitable for manpages.
alias wman=w3mman

alias x=exit  # So far I've only run this accidentally just a few times.

# Work around a common typo
alias cd..='cd ..'

# Show elements in $PATH, one per line
alias path='print ${(F)path}'

# Resetting PATH makes newly added files known to zsh's auto-completion
alias repath='export PATH=$PATH'

# network stuff
alias pingle='ping 8.8.8.8'
alias pp='ping 8.8.8.8'
alias speedtest='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test100.zip'

# One-handed typing (for whatever reason). Read more about this at:
#   http://blog.xkcd.com/2007/08/14/mirrorboard-a-one-handed-keyboard-layout-for-the-lazy/
# Honestly, I don't know why I keep this -- I never use it.  But it preserves
# work I like done by somebody I like.
alias mirrorboard='xkbcomp ~/mirrorboard.xkb $DISPLAY 2>/dev/null'

alias calc='autoload zcalc && zcalc'

###############################################################################
# SUFFIX ALIASES
###############################################################################
#
# Associate file extensions with programs used to open/run them.  
#
# For example:
#
#   alias -s ext=prog
#
# ..means that the command 'anything.ext' is replaced with 'prog anything.ext'.
# More at `man zshbuiltins`.

alias -s txt=bat
alias -s cfg=less
alias -s conf=less
alias -s log=less
alias -s mkd=less

alias -s ts=tsc
alias -s js=nodejs
alias -s pdf=xreader

alias -s html=www-browser
###############################################################################


# hacker news
alias hn="www-browser 'http://news.ycombinator.com'"

# "Stealth mode" :)  - dim and quiet
alias cloak='echo "vol:$(vol 0)\nbrightness: $(dim 5)"'

# Loud (er) and bright
alias decloak='echo "vol:$(vol 50)\nbrightness: $(dim 100)"'

# At work - quiet and bright
alias work-mode='echo "vol:$(vol 0)\nbrightness: $(dim 100)"'

# Just report the volume/brightness settings
alias mode='echo "vol:$(vol)\nbrightness: $(dim)"'


# VOLUME
########

# NOTE: amixer does provide a 'mute/unmute' operation pair, but they don't seem
# to exactly counter each other.  I think it's likely that they operate on
# something more specific than 'Master'.  However, I think setting 'Master'
# explicitly to 0/100% is a better choice for a portable way to express the
# intent, and more likely to work for more environments.  (Though this does
# mean that 'unmute' sets the volume to max -- not necessarily what it was
# before.  C'est la guerre.
alias mute='amixer set Master 0' alias unmute='amixer set Master 100%'

alias hush='amixer set Master 0'
alias shutup='amixer set Master 0'
alias quiet='amixer set Master 0'
alias silence='amixer set Master 0'
alias loud='amixer set Master 100%'

# playing around with the session manager plugin for vim
alias vims=vim -c SessionList
alias gvims=gvim -c SessionList

# Abbreviations
alias qq=quietus

alias nvim-log="NVIM_PYTHON_LOG_FILE=~/.vim/nvim-python-log-file.txt nvim"

# ranger - a rather nice text-based file browser, among other things, apparently
alias rr=ranger
# rifle is a file opener originally made for ranger, but functional as a standalone
alias ff=rifle

#alias man=w3mman

# List the various sections of the manual, as currently presented in the man
# page for man itself.
#
# NOTE: This is *very* ad-hoc and really just prints all lines starting with
#       numbers from the first 100 lines of man's man page.  Use gently.
alias mansections='man man | head -100 | grep -P "^ *\d"'

# List monospaced fonts installed on the system
alias monofonts='fc-list :mono family'

# Re-run the last command, this time putting output into `less`
#
#   NOTE:  The command has a space a the first character. This causes zsh to
#   elide adding the command to the history.  This is handy when running 'lass'
#   multiple times.  Without the space, it reruns the prior invocation of
#   'lass' itself, which is generally not what we want.
alias lass=' less =($(history -n -1))'

#############################################
#   console-based web search with Duckduckgo.
alias ddg='www-browser "https://duckduckgo.com/?q=$1"'

# Display a random article from wikipedia in a console-based browser
alias random-wikipedia-article='www-browser ''https://en.wikipedia.org/wiki/Special:Random'' '

# Just so I don't have to look up the particular characters for this one.
#   (It seems as though there should be some sort of digraph-like functionality to do this in vim.)
alias shrug="print '¯\_(ツ)_/¯'"

# System Shock was downloaded via Steam, but apparently it must be run directly
# from this directory, or it throws a weird error and crashes..
alias shock="cd ~/.local/share/Steam/steamapps/common/SS2/support/systemshock2/drive_c/Program\ Files/SystemShock2/ && wine Shock2.exe"

# Maybe there's a better way, but for now..
# alias lua="lua5.3"

# suspend to memory 
alias stm=suspend-to-memory
alias shh=suspend-to-memory
alias sleepytime=suspend-to-memory
alias goodnight=suspend-to-memory

alias say='print'
alias p='print'

# shortcut to a script I wrote to show count and names of processes that match
# a given string
alias pquery='process-query'
alias pq='process-query'
alias qp='process-query'

# jot is a little script I wrote for very simple note taking
alias j=jot

# bat is supposed to be a better substitute for cat
alias cat=bat
alias b=bat
#####################################################
# FOR FUN
#
# Dumb little things here just because I like them.
#####################################################
alias cowfortune='fortune -a | cowsay -n'
alias dammit,=sudo
alias please=sudo
alias xyzzy='echo Nothing happens.'

## uncategorized ##########

alias e=env

alias tml='tmux list-sessions'
