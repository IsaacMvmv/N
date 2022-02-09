#!/bin/sh

if [ -f /usr/bin/apt ];then
	sudo apt-get install unrar cmake libsdl2-dev libopenal-dev libavcodec-dev libavformat-dev libavutil-dev libswscale-dev
elif [ -f /usr/bin/pacman ];then
	sudo pacman -S  --needed sdl2 cmake openal ffmpeg unrar
fi

rm -rf ~/.tmp ~/.games/doom3BFG
mkdir ~/.tmp
cd ~/.tmp

git clone --recursive --depth=1 https://github.com/RobertBeckebans/RBDOOM-3-BFG
cd RBDOOM-3-BFG/neo
mkdir build
cd build

clear
echo "Do you want to use Vulkan (1) or OpenGL (2) for graphics api?"
echo "1 or 2"
read -rp "> " api


if [ $api = "1" ];then
	cmake .. -DCMAKE_BUILD_TYPE=Release -DSDL2=ON -DUSE_VULKAN=ON -DSPIRV_SHADERC=OFF
elif [ $api = "2" ]; then
	cmake .. -DCMAKE_BUILD_TYPE=Release -DONATIVE=ON -DSDL2=ON -DFFMPEG=OFF -DBINKDEC=ON
else
	echo "Invadid option. Rerun & choose 1 or 2"
	exit
fi


make -j$(nproc)


mkdir -pv ~/.games/doom3BFG
cp ~/.tmp/RBDOOM-3-BFG/neo/build/RBDoom3BFG ~/.games/doom3BFG
sudo rm /bin/doom3BFG
sudo ln ~/.games/doom3BFG/RBDoom3BFG /bin/doom3BFG

cd ~/.games/doom3BFG

wget https://raw.githubusercontent.com/IsaacMvmv/N/main/icons/doom3BFG.jpeg


echo "[Desktop Entry]
Type=Application
Version=1.0
Name=Doom 3 BFG
Comment=Doom3BFG Engine
Exec=/bin/doom3BFG
Icon=/home/$USER/.games/doom3BFG/doom3BFG.jpeg
Terminal=false
Categories=Game;" > ~/.local/share/applications/Doom3BFG.desktop
chmod +x ~/.local/share/applications/Doom3BFG.desktop

echo "You have to have base dir of original game placed in ~/.games/doom3BFG/base to play"
echo "Launch game by typing doom3BFG or clicking app shortcut"
