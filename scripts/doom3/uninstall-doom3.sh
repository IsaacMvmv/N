#!/bin/sh

set -e

if [ ! -z "$app" ];then
  purge_packages
fi

sudo rm -rf /bin/doom3 ~/.games/doom3 ~/.local/share/dhewm3/ ~/.config/dhewm3 ~/.local/share/applications/Doom3.desktop
