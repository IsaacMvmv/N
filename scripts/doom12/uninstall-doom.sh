#!/bin/sh

sudo rm -rf /bin/doom1 /bin/doom2 ~/.games/doom1_2 ~/.local/share/applications/Doom2.desktop ~/.local/share/applications/Doom1.desktop ~/.local/share/prboom-plus 


if [ -f /usr/bin/pacman ];then
  sudo pacman -Rs freepats-legacy
  sudo rm -rf /etc/timidity++/freepats.cfg
fi
