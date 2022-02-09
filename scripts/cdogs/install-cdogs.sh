#!/bin/sh

if [ -f /usr/bin/apt ];then
    sudo apt -y install cmake libsdl2-dev libsdl2-image-dev libsdl2-mixer-dev libgtk-3-dev build-essential python3 git
elif [ -f /usr/bin/pacman ];then
    sudo pacman -S --needed cmake sdl2 sdl2_image sdl2_mixer gtk3 make python git
fi


rm -rf ~/.tmp ~/.games/cdogs-sdl
mkdir ~/.tmp
cd ~/.tmp

git clone --recursive https://github.com/cxong/cdogs-sdl.git
cd cdogs-sdl
cmake . -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=res
make
make install

rm -rf ~/.games/cdogs-sdl
mkdir ~/.games/cdogs-sdl
cd ~/.games/cdogs-sdl

wget https://raw.githubusercontent.com/N0tN/N/main/icons/cdogs-sdl.png

mv ~/.tmp/cdogs-sdl/res/* .

cd

rm -rf ~/.tmp


echo "#!/bin/sh
cd $HOME/.games/cdogs-sdl/bin
./cdogs-sdl" > cdogs-sdl
chmod +x cdogs-sdl
sudo mv cdogs-sdl /bin/cdogs-sdl


mkdir -p ~/.local/share/applications


echo "[Desktop Entry]
Type=Application
Version=1.0
Name=CDogs
Comment=CDogs Game
Exec=/bin/cdogs-sdl
Icon=/home/$USER/.games/cdogs-sdl/cdogs-sdl.png
Terminal=false
Categories=Game;" > ~/.local/share/applications/CDogs.desktop
chmod +x ~/.local/share/applications/CDogs.desktop
