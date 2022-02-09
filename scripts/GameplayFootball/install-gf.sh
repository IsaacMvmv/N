#!/bin/sh


if [ -f /usr/bin/apt ];then
	sudo apt-get install git cmake build-essential libgl1-mesa-dev libsdl2-dev libsdl2-image-dev libsdl2-ttf-dev libsdl2-gfx-dev libopenal-dev libboost-all-dev libdirectfb-dev libst-dev mesa-utils xvfb x11vnc libsqlite3-dev
elif [ -f /usr/bin/pacman ];then
	sudo pacman -S --needed git cmake gcc sdl2 sdl2_image sdl2_ttf sdl2_gfx openal boost
fi


rm -rf ~/.tmp ~/.games/gf
mkdir ~/.tmp
cd ~/.tmp

git clone https://github.com/vi3itor/GameplayFootball.git
cd GameplayFootball

cp -R data/. build

cd build

cmake ..
make -j$(nproc)

mkdir res
mv gameplayfootball res
cp -r ../data/* res


mkdir -pv ~/.games/
mv res ~/.games/gf

echo '#!/bin/sh
cd /home/$USER/.games/gf
./gameplayfootball
cd $OLDPWD' > gf
chmod +x gf
sudo mv gf /bin/

cd
rm -rf ~/.tmp


cd ~/.games/gf

wget https://raw.githubusercontent.com/IsaacMvmv/N/main/icons/gf.png


echo "[Desktop Entry]
Type=Application
Version=1.0
Name=GameplayFootball
Comment=Football open source game
Exec=/bin/gf
Icon=/home/$USER/.games/gf/gf.png
Terminal=false
Categories=Game;" > ~/.local/share/applications/GameplayFootball.desktop
chmod +x ~/.local/share/applications/GameplayFootball.desktop


echo Launch game by typing gf
