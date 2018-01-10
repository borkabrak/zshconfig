# vim:ft=zsh
# Zsh prompt definition
#Alright, there's a lot going on with prompt colors in zsh.  Quick and dirty course:
#
#	-Color sequences are enabled in a string by quoting the whole thing in the dollar-quote ($'') construct.
#
#	-A color is 'turned on' with the sequence:
#
#		\e[x;yym
#
#	 	where 'x' is a modifier (1 means 'bright' or 'bold', while '0' means normal)
#	 	and 'yy' is a color code (31 is red, 32 is green, and 34 is blue, for example)
#		and the 'm' is a literal character 'm'.
#		(The above is not _exactly_ how it works, but is accurate enough for here)
#
#	-Be warned: The shell seems to consider the color escape characters when calculating the length
  #		of the prompt.
#		This will make the cursor do some crazy things in some situations, especially upon completion
  #		attempts.
#		To avoid this, surround the entire color escape sequence above (from the slash to the m) with
#		curly braces.
#		BUT, to make sure those curly braces are not printed literally by the shell, preface
#		each one with zsh's escape character, '%'
#
#		Like this:
#			%{<color escape>%}
#
#Also, while an argument can be made that as an environment variable, PROMPT belongs in .zshenv,
# I can't think of a case in which a non-interactive shell would need a prompt.
  # (More info on ANSI escape sequences: http://en.wikipedia.org/wiki/ANSI_escape_code )

#This uncolored prompt looks like:
#	'[user@host]~> '
#PROMPT=$'[%n@%m]%~> '

#This prompt looks like:
#
#	'[user@host]~> '
#
#	but with some groovy colors setting elements apart
#
#PROMPT=$'%{\e[0;32m%}[%n@%{\e[1;31m%}%m%{\e[0;32m%}]%{\e[1;34m%}%~%{\e[1;32m%}>%{\e[0m%}'

#Super psycho sexy prompt developed by a shadowy clan of NASA-trained space monkeys:
#PROMPT=$'%{\e[0;32m%}[%{\e[1;32m%}%n@%{\e[1;31m%}%m%{\e[1;32m%}:zsh(%?)%{\e[1;32m%}]%{\e[0;34m%}%~%{\e[1;32m%}> %{\e[0m%}'
#PROMPT=$'%{\e[1;32m%}[%{\e[1;32m%}%n@%{\e[1;34m%}%m%{\e[1;32m%}:zsh(%?)%{\e[1;32m%}]%{\e[1;34m%}%~%{\e[1;32m%}> %{\e[0m%}'

#==============================================================================
autoload -U colors && colors
#PROMPT=$'%{\e[1;32m%}%n@%{\e[38;5;129m%}%m%{\e[m%}:%{\e[1;34m%}%~%{\e[m%}%{\e[1;35m%}»%{\e[0m%} '
#PROMPT=$'%{\e[1;32m%}%n@%{\e[38;5;129m%}%m%{\e[m%}:%{\e[1;34m%}%~%{\e[m%}%{\e[1;35m%}≫ %{\e[0m%} '
#PROMPT=$'%{\e[1;32m%}%n@%{\e[38;5;129m%}%m%{\e[m%}:%{\e[1;34m%}%~%{\e[m%}%{\e[1;35m%}›%{\e[0m%} '
#PROMPT=$'%{\e[1;32m%}%n@%{\e[38;5;21m%}%m%{\e[m%}:%{\e[1;34m%}%~%{\e[m%}%{\e[1;35m%}⇒%{\e[0m%} '
PROMPT=$'%{\e[1;32m%}%n@%{\e[38;5;21m%}%m%{\e[m%}:%{\e[1;34m%}%~%{\e[m%}%{\e[1;35m%}➤%{\e[0m%} '

# This one uses nicer color specifications, but seems to mess up spacing somehow (try 'ls <tab>')
# Apparently you should wrap the colors in %{ [...] %}, according to:
#
#   https://wiki.archlinux.org/index.php/Zsh#Colors
#
#PROMPT="$fg_bold[cyan]%n$fg[green]@$fg[red]%m$reset_color:$fg_bold[green]%~$fg[magenta]$reset_color> "
#❱
export PROMPT
