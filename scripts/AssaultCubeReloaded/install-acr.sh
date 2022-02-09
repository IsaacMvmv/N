#!/bin/sh

if [ -f /usr/bin/apt ];then
	sudo apt install -y gcc g++ make git libsdl1.2debian-dev libsdl-image1.2-dev zlib1g-dev libogg0-dev libvorbis0a-dev libopenal1-dev libcurl4-dev libsdl1.2debian libsdl-image1.2 zlib1g libogg0 libvorbis0a libopenal1 libcurl4 
elif [ -f /usr/bin/pacman ];then
	sudo pacman -S --needed gcc make sdl openal git libvorbis libogg zlib sdl_image sdl libx11
fi


rm -rf ~/.tmp ~/.games/acr
mkdir ~/.tmp
cd ~/.tmp


git clone https://github.com/acreloaded/acr
cd acr/source/src
make -j$(nproc) install

cd

mkdir -pv ~/.games
mv ~/.tmp/acr ~/.games/acr
echo '#!/bin/sh
cd /home/$USER/.games/acr
bash client.sh' > acr
chmod +x acr
sudo mv acr /bin/acr

rm -rf ~/.tmp

cd ~/.games/acr

wget https://raw.githubusercontent.com/N0tN/N/main/icons/acr.png

mkdir -p ~/.local/share/applications

echo "[Desktop Entry]
Type=Application
Version=1.0
Name=Assault Cube Reloaded
Comment=Shooter game
Exec=/bin/acr
Icon=/home/$USER/.games/acr/acr.png
Terminal=false
Categories=Game;" > ~/.local/share/applications/AssaultCubeReloaded.desktop
chmod +x ~/.local/share/applications/AssaultCubeReloaded.desktop

echo "Launch game by typing acr Or using desktop shortcut"
