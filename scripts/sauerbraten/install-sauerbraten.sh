#!/bin/sh

if [ -f /usr/bin/apt ];then
	sudo apt install -y 
elif [ -f /usr/bin/pacman ];then
	sudo pacman -S --needed 
fi


rm -rf ~/.tmp ~/.games/sauerbraten
mkdir ~/.tmp
cd ~/.tmp


git clone --depth=1 https://github.com/embeddedc/sauerbraten
cd sauerbraten/src
make -j$(nproc) install
cd ..
rm -rf src

cd

mkdir -pv ~/.games
mv ~/.tmp/sauerbraten ~/.games/sauerbraten
echo '#!/bin/sh
cd /home/$USER/.games/sauerbraten
./bin_unix/native_client' > sauerbraten
chmod +x sauerbraten
sudo mv sauerbraten /bin/sauerbraten

rm -rf ~/.tmp

cd ~/.games/sauerbraten

wget https://raw.githubusercontent.com/IsaacMvmv/N/main/icons/sauerbraten.png

mkdir -p ~/.local/share/applications

echo "[Desktop Entry]
Type=Application
Version=1.0
Name=sauerbraten shooter game
Comment=Based on Cube 2 engine
Exec=/bin/sauerbraten
Icon=/home/$USER/.games/sauerbraten/sauerbraten.png
Terminal=false
Categories=Game;" > ~/.local/share/applications/Sauerbraten.desktop
chmod +x ~/.local/share/applications/Sauerbraten.desktop

echo "Launch game by typing sauerbraten Or using desktop shortcut"
