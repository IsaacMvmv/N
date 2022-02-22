#!/bin/sh

name=libremines

if [ ! -z "$app" ];then
  install_packages build-essential qt5-default cmake libqt5svg5-dev qtmultimedia5-dev git
elif [ -f /usr/bin/apt ];then
	sudo apt -y install build-essential qt5-default cmake libqt5svg5-dev qtmultimedia5-dev git
elif [ -f /usr/bin/pacman ];then
	sudo pacman -S  --needed base-devel qt5-base qt5-svg qt5-multimedia cmake
fi

rm -rf ~/.tmp ~/.games/$name
mkdir ~/.tmp
cd ~/.tmp

git clone https://github.com/Bollos00/LibreMines
cd LibreMines
mkdir b
cd b
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=res
make -j$(nproc) install

sudo mv res/bin/libremines /bin/libremines

cd

rm -rf ~/.tmp

mkdir ~/.games/$name
cd ~/.games/$name

wget https://github.com/IsaacMvmv/N/blob/main/icons/$name.png



mkdir -p ~/.local/share/applications


echo "[Desktop Entry]
Type=Application
Version=1.0
Name=$name
Comment=MINES
Exec=/bin/$name
Icon=/home/$USER/.games/$name/$name.png
Terminal=false
Categories=Game;" > ~/.local/share/applications/$name.desktop
chmod +x ~/.local/share/applications/$name.desktop


echo "Launch game by typing $name or clicking app shortcut"
