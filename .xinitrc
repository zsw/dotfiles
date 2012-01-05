# vim: nospell tw=0 ft=sh

setxkbmap -option terminate:ctrl_alt_bksp
setxkbmap -option caps:escape
xset b off
xset +fp /usr/share/fonts/local
xset fp rehash
xmodmap $HOME/.xmodmap
urxvtd -q -f -o &
xsetroot -cursor_name left_ptr -solid '#121212' &
unclutter -root -noevents &
autocutsel -fork &
autocutsel -selection PRIMARY -fork &
ssh-add < /dev/null     ## should prompt for passwd with x11-ssh-askpass
firefox &
_ssh_auth_save

numlockx &
#xrandr --dpi 94
export USERNAME=steve

while sinac -w 300; do slock; done &    ## screen lock

urxvtc -title dtsteve -e sh -c "$HOME/bin/go dtsteve"
urxvtc -title donkey -e sh -c "$HOME/bin/go donkey"
urxvtc -title mail -e sh -c "$HOME/bin/go mail"
urxvtc -title im -e sh -c "$HOME/bin/go im"
urxvtc -title torrent -e sh -c "$HOME/bin/go torrent"

/etc/rc.d/incrond restart &
$HOME/bin/dwmbar.sh -l &

while sleep 60; do
    date '+%a %d%^b %R' --date="30 seconds" > /srv/http/nginx/D.html
done &

while true; do
    xsetroot -name "$(cat $HOME/.config/dwm_fifo)"
done &

echo "$LANG" > /root/foo

while true; do
    LANG=en_CA.UTF-8 dwm &>> /var/log/dwm.log
done
