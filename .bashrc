[[ ! $PS1 ]] && return             ## If non-interactive, exit

eval "$(dircolors -b $HOME/.config/dircolours)"     ## colourize ls

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
export RED='\e[0;31m'           ## Red
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

export PROMPT_COMMAND='(( $? == 0 )) && echo -en $LIGHTGREY || echo -en $RED'
PS1="\h:\w/\[\e[0m\] "
(( $(id -u) > 0 )) && PS1="\u@\h:\w/\[\e[0m\] "

## colour for less
export GROFF_NO_SGR=1
export LESS_TERMCAP_mb=$'\E[01;31m'     ## begin blinking
export LESS_TERMCAP_md=$'\E[01;31m'     ## begin bold
export LESS_TERMCAP_me=$'\E[0m'         ## end mode
export LESS_TERMCAP_se=$'\E[0m'         ## end standout-mode
export LESS_TERMCAP_so=$'\E[01;44;33m'  ## begin standout-mode - info box
export LESS_TERMCAP_ue=$'\E[0m'         ## end underline
export LESS_TERMCAP_us=$'\E[01;32m'     ## begin underline

[[ -f /etc/bash_completion ]] && source /etc/bash_completion
[[ -f $HOME/.bash_dm ]] && source $HOME/.bash_dm

complete -cf sudo               ## bash (sudo) completion

## shell options
shopt -s cdspell        ## autocorrects cd misspellings
shopt -s checkjobs      ## check for bg or suspended jobs before exiting
shopt -s checkwinsize   ## update the value of LINES and COLUMNS after each command if altered
shopt -s cmdhist        ## Append bash history instead of overwriting it
shopt -s dotglob        ## include dotfiles in pathname expansion
shopt -s expand_aliases ## expand aliases
shopt -s extglob        ## enable extended pattern-matching features
shopt -s globstar       ## ** match files and dirs recursively, **/ match dirs recursively
shopt -s histappend     ## append to (not overwrite) the history file
shopt -u hostcomplete   ## disable tab completion for /etc/hosts
shopt -s no_empty_cmd_completion    ## do run completion on an empty line
shopt -s nocaseglob     ## pathname expansion will be treated as case-insensitive


:h() { vi -c ":silent help $@" -c "only"; }
apache() { apachectl configtest && /etc/rc.d/httpd stop && sleep 1 && /etc/rc.d/httpd start; }
aurget() { command aurget --asroot "$@"; }
bin() { git --git-dir=$HOME/.config/bin.git/ --work-tree=$HOME/bin "$@"; }
burn() { wodim -v dev=/dev/cdrom "$@"; }
cal() { command cal -3; }
calc() { awk "BEGIN { printf \"%.3f\n\", $* }"; }
cp() { command cp -prv "$@"; }
debug() { local script="$1"; shift; bash -vx $(command -v "$script") "$@"; }   ## run a bash script in debug mode
df() { command df -Th "$@"; }
dotfiles() { git --git-dir=$HOME/.config/dotfiles.git/ --work-tree=$HOME "$@"; }
du() { command du -ch --exclude=mnt "$@"; }
du0() { du -ch --exclude=mnt --max-depth=0 "$@"; }
du1() { du -ch --exclude=mnt --max-depth=1 "$@"; }
ducks() { du -chs --exclude=mnt * | sort -rh | head -11; }  ## disk hog
fm() { /usr/bin/fdm fetch && $HOME/dm/bin/process_emails.sh; }
gcron() { crontab -l | grep "$@"; }
gh() { history | grep "$@"; }
gkb() { ssh dtsteve "grep $* $HOME/dm/archive/30197/notes" | grep "$@"; }
gn() { ssh -t dtsteve 'vim + $HOME/dm/archive/30320/notes' 2>/dev/null; }
gps() { pgrep -lf "$@"; }                                       ## search process list
grep() { command grep -Iis -d skip "$@"; }
info() { command info --vi-keys "$@"; }                                 ## j/k scrolling in info
l() { ls --color=auto -CF --group-directories-first "$@"; }     ## short list
ll() { ls --color=auto -lAh --group-directories-first "$@"; }   ## long list, hidden files
lptxt () { lp -o page-bottom=72 -o page-top=72 -o page-left=72 -o page-right=72 "$1"; }
logcheck() { find /var/log/* -type f -regex '[^0-9]+$' -exec grep -Eni '.*(missing|error|fail|(not|no .+) found|(no |not |in)valid|fatal|conflict|problem|critical|corrupt|warning|wrong|illegal|segfault|fault|caused|unable|\(EE\)|\(WW\))' {} \+; }
#less() { command less -iFX "$@"; }
less() { vimpager "$@"; }
makepkg() { command makepkg --asroot "$@"; }
mkdir() { command mkdir -p "$@"; }
mlb() { refresh.sh "$HOME/bin/mlb.sh -o h TOR"; }
mond() { mon dvi && mon lvds && mon dvi; }
monl() { mon lvds && mon dvi && mon lvds; }
monv() { mon vga && mon lvds && mon vga; }
mp() { mplayer -vf eq -cache 8192 -lavdopts fast:skiploopfilter=all no-correct-pts -framedrop -quiet yes -really-quiet yes "$@"; }
mpdvd() { mplayer dvdnav:// /dev/sr0 "$@"; }
mpiso() { mplayer dvd://1 -dvd-device "$@"; }
mprar() { unrar p -inul $1 | mplayer -; }
mpsc() { mplayer -cache 8192 http://localhost:8908 -prefer-ipv4; }
mr() { mairix -f $HOME/.mairix/mairixrc && mairix -f $HOME/.mairix/mairixrc "$@"; }
mv() { command mv -v "$@"; }
myip() { curl -Ls http://tnx.nl/ip; }       ## lookup internet IP
ng() { nagcon -a -i 5 -f /var/nagios/status.dat; }
pacf() { find /boot /etc -name '*.pac*' 2>/dev/null; }
pacs() { pacsearch "$@"; }
pactest() { pacman -Sql testing | xargs pacman -Q 2>/dev/null; }
pacu() { pacsearch -S && pacsearch "$@"; }
pb() { socksify pianobar; }
pg() { ping -c 3 google.com; }
gpw() { gpg -d $HOME/doc/file.asc | grep "$@"; }
rm() { command rm -r "$@"; }
s() { pacman-color -Ss "$1" ; aurget --asroot -Ss "$1"; }
sanitize() { for i in "$@" ; do j=$(tr '[[:upper:]]' '[[:lower:]]' <<< "$i" | tr ' ' _) && mv "$i" "$j" ; done; }
sc() { sp-sc-auth "$@" 3908 8908; }
send() { echo "Attached." | mutt -s "See Attached File" -a "$1" "$2"; }
service() { /etc/rc.d/$1 $2; }      ## alias 'service' to /etc/rc.d
si() { pacman -S "$@" || aurget -Syu "$@"; }
spell() { aspell -a <<< "$@"; }
sprunge() { curl -sF 'sprunge=<-' http://sprunge.us | tr -d '\n' | xclip; }
startx() { shopt -u checkjobs; nohup ssh-agent startx &>> /var/log/X.log & exit; }
switch() { mv $1 ${1}.tmp && mv $2 $1 && mv ${1}.tmp $2; }
tord() { torrent_search.py -orz -g blue -k yellow -l $HOME/mnt/donkey/tmp/torrents/ "$@"; }
utb() { w3m -dump http://cb.vu/unixtoolbox.xhtml |less; }
vcron() { crontab -e; }
vepps() { ssh -t dtsteve 'vim + $HOME/dm/archive/30201/notes'; }
vi() { _vi "$@"; }
vkb() { ssh -t dtsteve 'vim + $HOME/dm/archive/30197/notes' 2>/dev/null; }
vpw() { vim $HOME/doc/file.asc; }
which() { (alias; declare -f) | /usr/bin/which --tty-only --read-alias --read-functions --show-tilde --show-dot $@; }
xp() { echo 'WM_CLASS(STRING) = "NAME", "CLASS"'; xprop | grep "WM_WINDOW_ROLE\|WM_CLASS"; }  ## xprop CLASS and NAME


## functions
_vi() {
    s=3
    (( $(id -u) > 0 )) && s=4
    if [[ $TMUX ]]; then
        tmux select-window -t "$s"
        for i in "$@"; do
            [[ $i == - ]] && /usr/bin/vim - && break
            i=$(readlink -fn "$i")
            tmux send-keys Escape ":tabedit $i" C-m
        done
    else
        vim "$@"
    fi
}

## uncompress archive based on filename
ax() {
    if [[ -f $1 ]]; then
        case "$1" in
            *.7z)       7z x "$1"       ;;
            *.bz2)      bunzip2 "$1"    ;;
            *.rar)      unrar x "$1"    ;;
            *.tar)      tar xf "$1"     ;;
            *.tar.bz)   tar xjf "$1"    ;;
            *.tar.bz2)  tar xjf "$1"    ;;
            *.tar.gz)   tar xzf "$1"    ;;
            *.tbz)      tar xjf "$1"    ;;
            *.tbz2)     tar xjf "$1"    ;;
            *.tgz)      tar xzf "$1"    ;;
            *.Z)        uncompress "$1" ;;
            *.zip)      unzip "$1"      ;;
            *.gz)       gunzip "$1"     ;;
            *)          echo "$1 cannot be extracted via ax()" ;;
        esac
    else
        echo "$1 is not a valid file"
    fi
}

## create archive based on filename
ac() {
    (( $# < 1 )) && { echo "usage: archivec foo.tar.gz ./bar ./baz" ; exit 1 ;}

    case "$1" in
        *.rar)      var="$1" && shift && rar "$var" "$@"      ;;
        *.tar.bz2)  var="$1" && shift && tar cvjf "$var" "$@" ;;
        *.tar.gz)   var="$1" && shift && tar cvzf "$var" "$@" ;;
        *.tgz)      var="$1" && shift && tar cvzf "$var" "$@" ;;
        *.zip)      var="$1" && shift && zip "$var" "$@"      ;;
        *)          echo "$1 cannot create archive via ac()"  ;;
    esac
}

## uncompress one file from a tar.gz archive
archivef() {
    (( $# != 2 )) &&
    { echo "usage: archivef [file] [archive.{tar.gz,tgz}]"
      echo "example: archivef "mnt/raid/archive/syncbackup/donkey-2010-01-03/root/.rtorrent.rc" donkey-2010-01-03.tgz"
      exit 1 ;}

    case $2 in
        *.tar.gz|*.tgz) gunzip < $2 | bsdtar -qxf - $1 ;;
        *)              echo "$2: not a valid archive" ;;
    esac
}

def() { word=$(tr ' ' _ <<< "$*")
        w3m -dump "http://www.google.ca/search?q=define%20$word" | awk '/^     1./,/^        More info >>/'
        mplayer "http://ssl.gstatic.com/dictionary/static/sounds/de/0/$word.mp3" &>/dev/null
}
