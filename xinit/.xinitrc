#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.config/.Xmodmap
sysresources=/etc/X11/xinit/.Xresources
sysmodmap=/etc/X11/xinit/.Xmodmap

eval $(ssh-agent)
ssh-add ~/.ssh/id_ghidorah_rsa

# merge in defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs
if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

#xrandr --size 1920x1200 --output HDMI-A-0 --mode 2560x1440 --left-of eDP &
if [[ "$(xrandr | grep 'HDMI-A-0 connected')" != "" ]]; then
  xrandr --output eDP --mode 1920x1200 --output HDMI-A-0 --mode 2560x1440 --left-of eDP &
else
  xrandr --output eDP --mode 1920x1200 &
fi

xmodmap -e 'clear lock' &
xwallpaper --stretch ~/Pictures/Wallpapers/$(ls ~/Pictures/Wallpapers| shuf -n 1)
picom -b &
brillo -S 10 &
#goblocks &!
dwmblocks &!
xset r rate 200 25&

while true; do
    # Log stderror to a file
    dwm 2> ~/.cache/.dwm.log
done
