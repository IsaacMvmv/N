#!/bin/sh


if [ -f /usr/bin/apt ];then
	sudo apt install -y g++ make cmake libsdl2-dev git zlib1g-dev libbz2-dev libjpeg-dev libfluidsynth-dev libgme-dev libopenal-dev libmpg123-dev libsndfile1-dev libgtk-3-dev timidity nasm libgl1-mesa-dev tar libsdl1.2-dev libglew-dev
elif [ -f /usr/bin/pacman ];then
	sudo pacman -S --needed gcc make cmake sdl2 git zlib bzip2 libjpeg-turbo fluidsynth libgme openal mpg123 libsndfile gtk3 timidity++ nasm mesa glu tar sdl glew
fi


sudo rm -rf ~/.tmp /bin/doom ~/.games/doom ~/.config/gzdoom
mkdir ~/.tmp
cd ~/.tmp


git clone https://github.com/coelckers/ZMusic.git zmusic
cd zmusic
mkdir build
cd build
cmake .. -DCMAKE_INSTALL_PREFIX=res -DCMAKE_BUILD_TYPE=Release
make -j$(nproc) install

cd ~/.tmp

git clone https://github.com/coelckers/gzdoom.git
cd gzdoom
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DZMUSIC_INCLUDE_DIR=/home/$USER/.tmp/zmusic/build/res/include/ -DZMUSIC_LIBRARIES=/home/$USER/.tmp/zmusic/build/res/lib/libzmusic.so.1.1.8 -DCMAKE_BUILD_TYPE=Release
make -j$(nproc)

mkdir -pv ~/.games/doom

mv ~/.tmp/gzdoom/build/gzdoom ~/.games/doom
mv ~/.tmp/gzdoom/build/*.pk3 ~/.games/doom
mv ~/.tmp/gzdoom/build/soundfonts ~/.games/doom
mv ~/.tmp/zmusic/build/res/lib/lib* ~/.games/doom

cd

echo '#!/bin/sh
cd /home/$USER/.games/doom
LD_LIBRARY_PATH=.:LD_LIBRARY_PATH ./gzdoom $@' > doom

chmod +x doom
sudo rm /bin/doom
sudo mv doom /bin


rm -rf ~/.tmp

cd ~/.games/doom


wget https://raw.githubusercontent.com/N0tN/N/main/icons/doom1.png

mkdir -p ~/.config/gzdoom

echo "[Desktop Entry]
Type=Application
Version=1.0
Name=doom
Comment=Doom1, 2 and more engine
Exec=/bin/doom1
Icon=/home/$USER/.games/doom/doom1.png
Terminal=false
Categories=Game;" > ~/.local/share/applications/Doom.desktop
chmod +x ~/.local/share/applications/Doom.desktop


echo "Open game by typing doom or clicking app shortcut.
Place all wads, pk3, etc... to $HOME/.config/gzdoom
TO PLAY MULTIPLAYER, a host have to do: \"doom -HOST playernumber\", and the client have to do: \"doom -JOIN hostip\""
