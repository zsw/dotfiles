## Set up your environment (PATH, LANG, EDITOR, ...) in ~/.bash_profile

PATH="$HOME/bin:${PATH}"

## exports
export BROWSER=firefox
export DISPLAY=:0
export EDITOR=vim
export GREP_COLOR='1;32'
export GREP_OPTIONS='--color=auto'
export HISTCONTROL=ignoredups       ## ignore duplicates in bash history
export HISTFILESIZE=99999           ## bash history will save N commands
export HISTIGNORE="&:[bf]g:exit"    ## commands to ignore in bash history
export HISTSIZE=99999               ## bash will remember N commands
export IGNOREEOF=3                  ## ctrl-d shouldn't log out
export LC_COLLATE=C
export LESSHISTFILE="-"
export MAILCAP_PATH=/etc/mailcap
export MAILCHECK=0                  ## do not check for internal mail
export MANPAGER=vimpager
export MANWIDTH=80
export OOO_FORCE_DESKTOP=gnome
export PAGER=vimpager
export MOZ_DISABLE_PANGO=1
export PYTHONPATH=$HOME/bin
export SCREEN_LOCK_WAIT_TIME=300
export SSH_AUTH_SOCK=$HOME/.tmux/ssh-auth-sock
export USERNAME=steve
export VISUAL=vim
export XDG_CONFIG_HOME=$HOME/.config

## define bash colours -- https://wiki.archlinux.org/index.php/Color_Bash_Prompt#List_of_colors_for_prompt_and_Bash
export BLACK='\e[0;30m'         ## Black
export DARKGREY='\e[1;30m'      ## Dark Grey
export RED='[0;31m'           ## Red
export LIGHTRED='\e[1;31m'      ## Light Red
export GREEN='\e[0;32m'         ## Green
export LIGHTGREEN='\e[1;32m'    ## Green
export YELLOW='\e[0;33m'        ## Yellow
export LIGHTYELLOW='\e[1;33m'   ## Yellow
export BLUE='\e[0;34m'          ## Blue
export LIGHTBLUE='\e[1;34m'     ## Blue
export MAGENTA='\e[0;35m'       ## Purple
export LIGHTMAGENTA='\e[1;35m'  ## Purple
export CYAN='\e[0;36m'          ## Cyan
export LIGHTCYAN='\e[1;36m'     ## Cyan
export LIGHTGREY='\e[0;37m'     ## White
export WHITE='\e[1;37m'         ## White
export BLACKUN='\e[4;30m'       ## Black - Underline
export REDUN='\e[4;31m'         ## Red
export GREENUN='\e[4;32m'       ## Green
export YELLOWUN='\e[4;33m'      ## Yellow
export BLUEUN='\e[4;34m'        ## Blue
export PURPLEUN='\e[4;35m'      ## Purple
export CYANUN='\e[4;36m'        ## Cyan
export WHITEUN='\e[4;37m'       ## White

export BLACKBG='\e[40m'         ## Black - Background
export REDBG='\e[41m'           ## Red
export GREENBG='\e[42m'         ## Green
export BROWNBG='\e[43m'         ## Yellow
export BLUEBG='\e[44m'          ## Blue
export PURPLEBG='\e[45m'        ## Purple
export CYANBG='\e[46m'          ## Cyan
export LIGHTGREYBG='\e[47m'     ## White

export COLOUROFF='\e[0m'        ## Text Reset
export BOLD='\e[1m'
export REVERSE='\e[7m'          ## Reverse Colours

## colour for less
export GROFF_NO_SGR=1
export LESS_TERMCAP_mb=$'\E[01;31m'     ## begin blinking
export LESS_TERMCAP_md=$'\E[01;31m'     ## begin bold
export LESS_TERMCAP_me=$'\E[0m'         ## end mode
export LESS_TERMCAP_se=$'\E[0m'         ## end standout-mode
export LESS_TERMCAP_so=$'\E[01;44;33m'  ## begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'         ## end underline
export LESS_TERMCAP_us=$'\E[01;32m'     ## begin underline

. $HOME/.bashrc
stty -ixon
stty -ctlecho

