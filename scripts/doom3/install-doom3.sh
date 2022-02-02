#!/bin/sh

if [ -f /bin/apt ];then
	sudo apt -y install sdl2-image sdl2-mixer sdl2-ttf libfontconfig-dev qt5-default automake mercurial libtool libfreeimage-dev libopenal-dev libpango1.0-dev libsndfile-dev libudev-dev libtiff5-dev libwebp-dev libasound2-dev libaudio-dev libxrandr-dev libxcursor-dev libxi-dev libxinerama-dev libxss-dev libesd0-dev freeglut3-dev libmodplug-dev libsmpeg-dev libjpeg-dev libogg-dev libvorbis-dev libvorbisfile3 libcurl4 cmake aria2
elif [ -f /bin/pacman ];then
	sudo pacman -S  --needed sdl2_image sdl2_ttf sdl2_mixer fontconfig qt5-base automake mercurial libtool freeimage openal pango libsndfile libtiff xorg-xrandr libxinerama libxss freeglut libjpeg-turbo libogg libvorbis cmake 
fi

rm -rf ~/.tmp ~/.games/doom3 rm -rf ~/.local/share/dhewm3/
mkdir ~/.tmp
cd ~/.tmp

git clone https://github.com/dhewm/dhewm3
cd dhewm3/neo
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=res
make -j$(nproc) install

mkdir -pv ~/.games/doom3
cp res/bin/dhewm3 ~/.games/doom3
cp res/lib/dhewm3/* ~/.games/doom3

sudo rm /bin/doom3

echo "cd $HOME/.games/doom3
./dhewm3
cd $OLDPWD" > doom3
chmod +x doom3
sudo mv doom3 /bin/doom3

cd ~/.games/doom3
mkdir base
cd base
wget https://github.com/IsaacMvmv/N/releases/download/doom/doom3.zip
unzip doom3.zip
rm doom3.zip

rm -rf ~/.tmp


cd ~/.games/doom3

wget https://raw.githubusercontent.com/IsaacMvmv/N/main/icons/doom3.jpeg

mkdir -p ~/.local/share/applications


echo "[Desktop Entry]
Type=Application
Version=1.0
Name=Doom 3
Comment=Doom 3 engine
Exec=/bin/doom3
Icon=/home/$USER/.games/doom3/doom3.jpeg
Terminal=false
Categories=Games;" > ~/.local/share/applications/Doom3.desktop
chmod +x ~/.local/share/applications/Doom3.desktop


echo "Lunch game by typing doom3 ;D"
