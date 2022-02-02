#!/bin/sh

if [ -f /bin/apt ];then
	sudo apt install -y gcc g++ make git libsdl1.2debian-dev libsdl-image1.2-dev zlib1g-dev libogg0-dev libvorbis0a-dev libopenal1-dev libcurl4-dev libsdl1.2debian libsdl-image1.2 zlib1g libogg0 libvorbis0a libopenal1 libcurl4 
elif [ -f /bin/pacman ];then
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
bash client.sh
cd $OLDPWD' > acr
chmod +x acr
sudo mv acr /bin/acr

rm -rf ~/.tmp

cd ~/.games/doom3BFG

wget https://raw.githubusercontent.com/IsaacMvmv/N/main/icons/acr.jpeg

mkdir -p ~/.local/share/applications

echo "[Desktop Entry]
Type=Application
Version=1.0
Name=Assault Cube Reloaded
Comment=Shooter game
Exec=/bin/acr
Icon=/home/$USER/.games/acr/acr.jpeg
Terminal=false
Categories=Games;" > ~/.local/share/applications/AssaultCubeReloaded.desktop
chmod +x ~/.local/share/applications/AssaultCubeReloaded.desktop

echo "Launch game by typing acr Or using desktop shortcut"

echo launch game by typing "acr"
