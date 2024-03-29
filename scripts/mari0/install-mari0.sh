#!/bin/sh



if [ -f /usr/bin/apt ];then
	sudo apt install -y gcc g++ make git libmodplug-dev libmodplug1 libtheora-dev libtheora0 libluajit-5.1-2 libluajit-5.1-dev libsdl2-2.0-0 libopenal1 libopenal-dev libsdl2-dev libfreetype6 libfreetype6-dev libmpg123-0 libvorbis-dev libmpg123-dev
elif [ -f /usr/bin/pacman ];then
	sudo pacman -S --needed gcc make git luajit sdl2 openal freetype2 mpg123 libvorbis libmodplug libtheora
fi




rm -rf ~/.tmp
mkdir ~/.tmp
cd ~/.tmp

wget https://github.com/IsaacMvmv/N/releases/download/mari0/love-11.1-linux-src.tar.gz
tar xf love-11.1-linux-src.tar.gz
rm love-11.1-linux-src.tar.gz
cd love-11.1

./configure --prefix=$PWD/res
make -j$(nproc) install


rm -rf ~/.games/mari0
mkdir -pv ~/.games/mari0

cp res/bin/love ~/.games/mari0
cp res/lib/* ~/.games/mari0

echo "#!/bin/sh
cd $HOME/.games/mari0
LD_LIBRARY_PATH=.:$LD_LIBRARY_PATH ./love Mari0_Community_Edition_v1.6.love
cd" > mari0

chmod +x mari0

sudo rm /bin/mari0
sudo mv mari0 /bin/mari0

cd $HOME/.games/mari0
wget https://raw.githubusercontent.com/IsaacMvmv/N/main/icons/mari0.jpg
wget https://github.com/IsaacMvmv/N/releases/download/mari0/Mari0_Community_Edition_v1.6.love

cd $OLDPWD
rm -rf ~/.tmp


mkdir -p ~/.local/share/applications


echo "[Desktop Entry]
Type=Application
Version=1.0
Name=Mari0
Comment=Awesome portals game :D
Exec=/bin/mari0
Icon=/home/$USER/.games/mari0/mari0.jpg
Terminal=false
Categories=Game;" > ~/.local/share/applications/Mari0.desktop
chmod +x ~/.local/share/applications/Mari0.desktop


echo "Launch game by typing mari0 Or using desktop shortcut"
