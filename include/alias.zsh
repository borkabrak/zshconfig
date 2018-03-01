########################################################################################################
#vim:ft=zsh
#
#   ZSH aliases
#
#   This file was recovered on Sunday, 2015-07-19 at about 1:00pm.
#
#   Neat story:  I accidentally overwrote this file, while trying to add a new
#   alias, by using the wrong redirection operator (Damn you '>/>>'!) To get it
#   back, I first tried using an out-of-date file I found.  Not bad, but there
#   were still several aliases I had added since then that this technique
#   didn't recover.
#
#   I realized I could load a tmux session from a few days prior, and use the
#   `alias` command with no parameters to output all the aliases *it* had
#   loaded, from the original, lost, file.  A little jiggery-pokery with `diff`
#   and `sort -u`, and bingo!  53 total aliases recovered, and all I lost were
#   the comments!
#
#   Lesson learned: BACK UP MY DOTFILES.  I've got a git repo started for doing
#   that (borkabrak/dotfiles), but I need to finish it (alternatively, find
#   some backup script someone else has already written -- this can't be a
#   unique problem.)
#
########################################################################################################

######################################
# USEFUL TIP: Ignoring aliased command
######################################
# If an alias turns out to be in the way for any reason, there are a couple
# different ways to run the command using the unaliased, 'factory standard'
# version of it (i.e., ignoring any 'alias' commands that may have been
# executed):
#
#   Both of these methods will run the 'real' version of <command>, ignoring
#   any attempts that may have been tried to alias it to something else:
#
#   $ /usr/bin/<command>      # Access the command via the full path to it
#
#   $ env <command>           # Use `env` to run the command, bypassing any aliases.
#
#####################################################

#####################################################
# SET DEFAULT OPTIONS TO VARIOUS COMMANDS
##################################################### 
alias cp='cp -i' 
alias grep='grep --color' 
alias igrep='grep -i'
alias less='less -iR' 
alias a2r='sudo apache2ctl restart' 
alias bc='bc -l' 
alias ls='ls -h --color=auto'
alias mv='mv -i' 
alias rm='rm -I'
# Run tmux with 256-color and UTF-8 support
alias tmux='tmux -2 -u'
# Colorful tree view
alias tree='tree -C'

# Symlinks and such might be a better way to do this long-term, but I'm just
# trying out neovim as a replacement for vim for now.
#alias vim=nvim

# Running commands to xargs with nothing on STDIN:  not even once. :-D
alias xargs='xargs -r'

# curl options
#   As with all these aliases, to use the 'bare' form with no options, try:
#
#       $ env curl
#
##############
#
#   -L
#       If a url responds with a 3xx 'Moved' status, this options automatically
#       retries the download from the new location.
#
#   -O
#       Write output to a local file named similarly to the url.  (Instead of
#       the default writing to STDOUT.)

# alias curl='curl -L -O'

#####################################################
# FOR FUN
#####################################################
alias cowfortune='fortune -a | cowsay -n'
alias dammit,=sudo
alias please=sudo
alias xyzzy='echo Nothing happens'

#####################################################
# NEW COMMANDS - (i.e., the LHS didn't exist before alias is parsed)
#####################################################
alias datestamp='date +%F'
alias v=vim
alias gg='git status -sb'
alias g=git
alias hh=history
alias lisp='clisp -q'
alias ll='ls -l'
alias LL='ls -lL'
alias l=ls
alias L='ls -L'
alias lsdirs='ls -d */'
alias lsd=lsdirs
alias open=xdg-open
alias readme='vim README.mkd'
alias revim='vim -c ''source ~/.vim/shutdown_session.vim'''
alias regvim='gvim -c ''source ~/.vim/shutdown_session.vim'''
alias grevim=regvim
alias rot13='tr a-zA-Z n-za-mN-ZA-M'
alias rtfm=man
alias sassify='sass --watch --sourcemap=none --scss'
alias t=task
alias whatprovides='apt-file search -x'
alias which-command=whence

# Work around a common typo
alias cd..='cd ..'

# So far I've only run this accidentally just a few times.
alias x=exit

# Print command history with extra info: date, time, and time elapsed since
# prior command.  `fc` can actually do quite a lot with the history,
# apparently.  Search for ' fc ' in `man zshbuiltins` for more info.
alias historyfull='fc -liD'

# Show path, one per line
alias path='foreach p in $path; { print $p }'

# Resetting PATH makes newly added files known to zsh's auto-completion
alias repath='export PATH=$PATH'

# network stuff
alias pingle='ping 8.8.8.8'
alias p=pp
alias pp='ping 8.8.8.8'
alias speedtest='wget -O /dev/null http://speedtest.wdc01.softlayer.com/downloads/test100.zip'

# One-handed typing (for whatever reason). Read more about this at:
#   http://blog.xkcd.com/2007/08/14/mirrorboard-a-one-handed-keyboard-layout-for-the-lazy/
# Honestly, I don't know why I keep this -- I never use it.  But it preserves
# work done by somebody I like.
alias mirrorboard='xkbcomp ~/bin/mirrorboard.xkb $DISPLAY 2>/dev/null'

alias calc='autoload zcalc && zcalc'

# SUFFIX ALIASES

# From `man zshbuiltins`:
#
# If the -s flags is present, define a suffix alias: if the command word on a
# command line is in the form `text.name', where text is any non-empty string,
# it is  replaced  by the text `value text.name'.  Note that name is treated as
# a literal string, not a pattern.  A trailing space in value is not special in
# this case.  For example,
#
#       alias -s ps=gv
#
# will cause the command `*.ps' to be expanded to `gv *.ps'.
#
# typescript
alias -s ts=tsc
# javascript
alias -s js=nodejs

alias hn="www-browser 'http://news.ycombinator.com'"

# "Stealth mode" :)  - dim and quiet
alias cloak='echo "vol:$(vol 0)\nbrightness: $(dim 5)"'

# Loud (er) and bright
alias decloak='echo "vol:$(vol 50)\nbrightness: $(dim 100)"'

# At work - quiet and bright
alias work-mode='echo "vol:$(vol 0)\nbrightness: $(dim 100)"'

# Just report the volume/brightness settings
alias mode='echo "vol:$(vol)\nbrightness: $(dim)"'

#alias stealth=cloak
#alias stealth-mode=cloak
#alias quiet=cloak
#alias quiet-mode=cloak
#alias simmerdown=cloak

#alias unstealth=decloak
#alias destealth=decloak
#alias uncloak=decloak
#alias unquiet=decloak
#alias dequiet=decloak
#alias wakeup=decloak

#alias work=work-mode
#alias atwork=work-mode
#alias working=work-mode
#
#alias whatmode=mode
#alias what-mode=mode

# playing around with the session manager plugin for vim
alias vims=vim -c SessionList
alias gvims=gvim -c SessionList

# Abbreviations
alias f=file
alias qq=quietus

alias nvim-log="NVIM_PYTHON_LOG_FILE=~/.vim/nvim-python-log-file.txt nvim"

# ranger - a rather nice text-based file browser, among other things, apparently
alias rr=ranger
# rifle is a file opener originally made for ranger, but functional as a standalone
alias ff=rifle

# List monospaced fonts installed on the system
alias monofonts='fc-list :mono | cut -f 2 -d: | sort -u'

# Run the last command again, running output through less
#   NOTE:  The space before this command is INTENTIONAL, and elides adding the
#   command to the history.  This is handy when repeating 'lass'.  Without the
#   space, it reruns the last invocation of itself, which is generally not what
#   we want.
alias lass=' less =($(history -n -1))'

#############################################
#   console-based web search with Duckduckgo.
alias ddg=www-browser "https://duckduckgo.com/?q=$1"
