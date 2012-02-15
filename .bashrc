[[ ! $PS1 ]] && return             ## If non-interactive, exit
#export PROMPT_COMMAND='(( $? == 0 )) && echo -en $LIGHTGREY || echo -en $RED'
#PS1="\h:\w/\[\e[0m\] "
(( $(id -u) > 0 )) && PS1="\u@\h:\w/\[\e[0m\] "

eval "$(dircolors -b $HOME/.config/dircolours)"     ## colourize ls

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
bin() { git --git-dir=/var/git/bin/ --work-tree=$HOME/bin "$@"; }
burn() { wodim -v dev=/dev/cdrom "$@"; }
cal() { command cal -3; }
calc() { awk "BEGIN { printf \"%.3f\n\", $* }"; }
cp() { command cp -prv "$@"; }
debug() { local script="$1"; shift; bash -vx $(command -v "$script") "$@"; }   ## run a bash script in debug mode
df() { command df -Th "$@"; }
dotfiles() { git --git-dir=/var/git/dotfiles/ --work-tree=$HOME "$@"; }
du() { command du -ch --exclude=mnt "$@"; }
du0() { du -ch --exclude=mnt --max-depth=0 "$@"; }
du1() { du -ch --exclude=mnt --max-depth=1 "$@"; }
ducks() { du -chs --exclude=mnt * | sort -rh | head -11; }  ## disk hog
#fm() { /usr/bin/fdm fetch && $HOME/dm/bin/process_emails.sh; }
fm() { /usr/bin/fdm fetch; }
g() { read a b c < $HOME/.config/git/current; eval git --git-dir=$a --work-tree=$b "$@"; }
gcron() { crontab -l | grep "$@"; }
gh() { history | grep "$@"; }
gkb() { ssh dtsteve "grep -i $* $HOME/dm/archive/30197/notes" | grep "$@"; }
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
tvshow() { ssh -t dtsteve 'vim + $HOME/dm/archive/30069/notes' 2>/dev/null; }
utb() { w3m -dump http://cb.vu/unixtoolbox.xhtml |less; }
vcron() { crontab -e; }
vepps() { ssh -t dtsteve 'vim + $HOME/dm/archive/30201/notes'; }
vi() { _vi "$@"; }
vkb() { [[ $HOSTNAME == dtsteve ]] && vim + $HOME/dm/archive/30197/notes ||
        ssh -t dtsteve 'vim + $HOME/dm/archive/30197/notes' 2>/dev/null; }
vpw() { vim $HOME/doc/file.asc; }
which() { (alias; declare -f) | /usr/bin/which --tty-only --read-alias --read-functions --show-tilde --show-dot $@; }
wp() { term=$(echo "$@" | tr ' ' _); curl -Ls "http://en.wikipedia.org/w/api.php?action=query&titles=$term&prop=extlinks&format=json" | awk -F':"|"}' -v RS=, '/http/ {gsub(/\\/, "", $2); print $2}'; }   ## print reference urls from wikipedia
xp() { echo 'WM_CLASS(STRING) = "NAME", "CLASS"'; xprop | grep "WM_WINDOW_ROLE\|WM_CLASS"; }  ## xprop CLASS and NAME


## FUNCTIONS
_vi() {
    s=3
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

## dictionary
def() { word=$(tr ' ' _ <<< "$*")
        lynx -dump "http://www.thefreedictionary.com/p/$word" | awk -v w="$word" '$0 ~ w,/   __________/'
        mplayer "http://ssl.gstatic.com/dictionary/static/sounds/de/0/$word.mp3" &>/dev/null
}

_git_prompt() {
    unset state branch remote repo
    g rev-parse --git-dir &> /dev/null
    git_status=$(g status 2> /dev/null)

    branch_pattern="^# On branch ([^${IFS}]*)"
    [[ $git_status =~ $branch_pattern ]] && branch=${BASH_REMATCH[1]}

    diverge_pattern="# Your branch and (.*) have diverged"
    [[ $git_status =~ $diverge_pattern ]] && remote=${YELLOW}↕

    remote_pattern="# Your branch is (.*) of"
    ## add an elif or two here if you want to get more specific
    if [[ $git_status =~ $remote_pattern ]]; then
        if [[ ${BASH_REMATCH[1]} == "ahead" ]]; then
            remote=${LIGHTYELLOW}↑
        else
            remote=${LIGHTYELLOW}↓
        fi
    fi

    [[ $git_status =~ "working directory clean" ]] || state=${LIGHTRED}⚡

    repo=$(read a _ < $HOME/.config/git/current; echo "${a##*/}")
    echo "$state$remote\[$CYAN\]$repo\[$LIGHTGREY\]|\[$CYAN\]$branch\[$COLOUROFF\]"
}

_prompt() {
    e=$?
    prompt=$(_git_prompt)
    if (( $e == 0 )); then
        PS1="$prompt\n\[$LIGHTGREY\]\h:\w/\[\e[0m\] \[$COLOUROFF\]"
    else
        PS1="$prompt\n\[$RED\]\h:\w/\[\e[0m\] \[$COLOUROFF\]"
    fi
}

PROMPT_COMMAND=_prompt
