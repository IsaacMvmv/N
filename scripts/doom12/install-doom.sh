#!/bin/sh


if [ -f /usr/bin/apt ];then
	sudo apt install -y g++ make cmake libsdl1.2-dev, libsdl-mixer1.2-dev and libsdl-net1.2-dev git gcc
elif [ -f /usr/bin/pacman ];then
	sudo pacman -S --needed libpng sdl_mixer sdl_net cmake git gcc make
fi

rm -rf ~/.tmp ~/.games/doom1_2
mkdir ~/.tmp
cd ~/.tmp

git clone --depth=1 https://github.com/coelckers/prboom-plus
cd prboom-plus/prboom2
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=res
make -j$(nproc) install

mkdir -pv ~/.games/doom1_2

mv ~/.tmp/prboom-plus/prboom2/build/res/bin/prboom-plus ~/.games/doom1_2
mv ~/.tmp/prboom-plus/prboom2/build/prboom-plus.wad ~/.games/doom1_2


cd

echo '#!/bin/sh
cd /home/$USER/.games/doom1_2/
./prboom-plus -iwad doom1.wad' > doom1

echo '#!/bin/sh
cd /home/$USER/.games/doom1_2/
./prboom-plus -iwad doom2.wad' > doom2

chmod +x doom1 doom2
sudo rm /bin/doom1 /bin/doom2
sudo mv doom1 /bin/
sudo mv doom2 /bin/

rm -rf ~/.tmp

cd ~/.games/doom1_2

wget https://github.com/N0tN/N0tN/releases/download/webpage/A1.wad
mv A1.wad doom1.wad
wget https://github.com/N0tN/N0tN/releases/download/webpage/A2.wad
mv A2.wad doom2.wad
wget https://raw.githubusercontent.com/IsaacMvmv/N/main/icons/doom1.png
wget https://raw.githubusercontent.com/IsaacMvmv/N/main/icons/doom2.png

echo "[Desktop Entry]
Type=Application
Version=1.0
Name=doom1
Comment=Doom1 and 2 Engine
Exec=/bin/doom1
Icon=/home/$USER/.games/doom1_2/doom1.png
Terminal=false
Categories=Game;" > ~/.local/share/applications/Doom1.desktop
chmod +x ~/.local/share/applications/Doom1.desktop

echo "[Desktop Entry]
Type=Application
Version=1.0
Name=doom2
Comment=Doom1 and 2 Engine
Exec=/bin/doom2
Icon=/home/$USER/.games/doom1_2/doom2.png
Terminal=false
Categories=Game;" > ~/.local/share/applications/Doom2.desktop
chmod +x ~/.local/share/applications/Doom2.

echo "Open game by typing doom1, doom2 or clicking app shortcut"
