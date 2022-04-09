#!/bin/sh
if [ -f /usr/bin/apt ];then
	sudo apt -y install cmake git libsdl2-dev gcc g++ extra-cmake-modules qttools5-dev qttools5-dev-tools libxi-dev libxtst-dev libx11-dev itstool gettext libqt5x11extras5-dev
elif [ -f /usr/bin/pacman ];then
	sudo pacman -S  --needed git cmake qt5-tools itstool extra-cmake-modules libxtst hicolor-icon-theme sdl2 qt5-x11extras gcc
fi

rm -rf ~/.tmp
mkdir ~/.tmp
cd ~/.tmp

git clone --depth=1 https://github.com/AntiMicroX/antimicroX
cd antimicroX
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=res
make -j$(nproc) install

sudo cp res/bin/antimicrox /bin/antimicrox

sudo cp res/share/applications/io.github.antimicrox.antimicrox.desktop /usr/share/applications/io.github.antimicrox.antimicrox.desktop
sudo cp res/share/icons/breeze/48x48/apps/antimicrox_trayicon.png /usr/share/icons/breeze/48x48/apps/antimicrox_trayicon.png
sudo cp -r res/share/icons/hicolor/* /usr/share/icons/hicolor/.
sudo cp other/60-antimicrox-uinput.rules /usr/lib/udev/rules.d/60-antimicrox-uinput.rules

cd
rm -rf ~/.tmp


echo "Installed, enjoy :D"