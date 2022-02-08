#!/bin/sh

if [ -f /usr/bin/apt ];then
	sudo apt -y git build-essential pkg-config libusb-1.0-0-dev libsdl2-dev libxinerama-dev libxss-dev libesd0-dev freeglut3-dev libmodplug-dev libsmpeg-dev libjpeg-dev libogg-dev libvorbis-dev libvorbisfile3 libcurl4 cmake aria2
elif [ -f /usr/bin/pacman ];then
	sudo pacman -S  --needed base-devel python sdl2 glew
fi


rm -rf ~/.tmp ~/.games/sm64
mkdir ~/.tmp
cd ~/.tmp

git clone https://github.com/MorsGames/sm64plus
cd sm64plus
wget https://ia903207.us.archive.org/20/items/super-mario-64-usa/Super%20Mario%2064%20%28U%29%20%5B%21%5D.z64
mv Super* baserom.us.z64
SM64PLUS_BASEROM_us="$PWD/baserom.us.z64" make -j "$(nproc)"


mkdir -pv ~/.games/

mv build/us_pc ~/.games/sm64
mv ~/.games/sm64/sm64.us* ~/.games/sm64/sm64

sudo rm /bin/sm64


echo "cd $HOME/.games/sm64
./sm64" > sm64
chmod +x sm64
sudo mv sm64 /bin/sm64

rm -rf ~/.tmp


cd ~/.games/sm64

wget https://raw.githubusercontent.com/IsaacMvmv/N/main/icons/sm64.png

mkdir -p ~/.local/share/applications


echo "[Desktop Entry]
Type=Application
Version=1.0
Name=Super Mario 64
Comment=Unofficial port
Exec=/bin/sm64
Icon=/home/$USER/.games/sm64/sm64.png
Terminal=false
Categories=Game;" > ~/.local/share/applications/Sm64.desktop
chmod +x ~/.local/share/applications/Sm64.desktop


echo "Lunch game by typing Sm64 Or clicking menu icon ;D"
