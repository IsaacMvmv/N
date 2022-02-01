#!/bin/sh

if [ -f /bin/apt ];then
	apt install -y git ninja gcc g++ meson python3 libxnvctrl-dev libdbus-1-dev libx11-dev libdrm-dev mesa-common-dev
	python3 -m pip install mako

elif [ -f /bin/pacman ];then
	sudo pacman -S --needed git ninja gcc meson python-mako libxnvctrl dbus libdrm
fi



rm -rf ~/.tmp
mkdir ~/.tmp
cd ~/.tmp


git clone --recurse-submodules https://github.com/flightlessmango/MangoHud.git
cd MangoHud

meson build --prefix=$PWD/res
ninja -C build install

sudo rm -rf /bin/mangohud /lib/libMangoHud.so /lib/libMangoHud_dlsym.so

sudo cp bin/mangohud /bin
sudo cp lib/mangohud/* /lib

rm -rf ~/.tmp




echo For vulkan games use \"mangohud\ \%game\%\" and for opengl games use \"mangohud --dlsym \%game\%\"
