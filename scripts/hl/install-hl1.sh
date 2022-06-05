#!/bin/sh

set -e

rm -rf ~/.tmp
mkdir ~/.tmp
cd ~/.tmp


if [ -f /usr/bin/apt ];then
	sudo apt install -y python libsdl2-2.0-0 libsdl2-dev gcc g++ libfreetype6-dev pkg-config git upzip fontconfig libfontconfig1-dev
elif [ -f /usr/bin/pacman ];then
	sudo pacman -S --needed sdl2 gcc fontconfig python freetype2 git unzip pkgconf
fi

if [ $(uname -m) == "x86_64" ]; then
  ARGS="--64bits"
fi





git clone --recursive --depth=1 https://github.com/FWGS/hlsdk-xash3d hl

cd hl

./waf configure --enable-lto --enable-poly-opt --build-type=release $ARGS
./waf build
mkdir res
./waf install --strip --destdir=res
mv res ../hlsdk

cd ..

git clone --recursive --depth=1 --branch bshift https://github.com/FWGS/hlsdk-xash3d bshift

cd bshift

./waf configure --enable-lto --enable-poly-opt --build-type=release $ARGS
./waf build
mkdir res
./waf install --strip --destdir=res
mv res ../bshiftsdk

cd ..


git clone --recursive --depth=1 --branch opfor https://github.com/FWGS/hlsdk-xash3d opfor

cd opfor

./waf configure --enable-lto --enable-poly-opt --build-type=release $ARGS
./waf build
mkdir res
./waf install --strip --destdir=res
mv res ../opforsdk

cd ..


git clone --recursive --depth=1 https://github.com/FWGS/xash3d-fwgs
cd xash3d-fwgs

./waf configure --build-type=release --enable-lto --enable-poly-opt $ARGS
./waf build
./waf install --strip --destdir=res

mv res ../engine

cd ..

rm -rf hl bshift opfor xash3d-fwgs ~/.xash3d

mkdir -p ~/.xash3d ~/.games
mv * ~/.xash3d
mv ~/.xash3d/hlsdk/valve ~/.xash3d/valve
mv ~/.xash3d/bshiftsdk/bshift ~/.xash3d/bshift
mv ~/.xash3d/opforsdk/gearbox ~/.xash3d/gearbox
rm -rf ~/.xash3d/hlsdk
mv ~/.xash3d/engine ~/.games/hl

cd
rm -rf ~/.tmp



echo '#!/bin/sh
export LD_LIBRARY_PATH=/home/$USER/.games/hl:$LD_LIBRARY_PATH
export XASH3D_BASEDIR="$HOME/.xash3d"
/home/$USER/.games/hl/xash3d "$@"' > hl

chmod +x hl
sudo mv hl /bin/hl


echo '#!/bin/sh
export LD_LIBRARY_PATH=/home/$USER/.games/hl:$LD_LIBRARY_PATH
export XASH3D_BASEDIR="$HOME/.xash3d"
/home/$USER/.games/hl/xash3d -game bshift "$@"' > bshift

chmod +x bshift
sudo mv bshift /bin/bshift


echo '#!/bin/sh
export LD_LIBRARY_PATH=/home/$USER/.games/hl:$LD_LIBRARY_PATH
export XASH3D_BASEDIR="$HOME/.xash3d"
/home/$USER/.games/hl/xash3d -game gearbox "$@"' > opfor

chmod +x opfor
sudo mv opfor /bin/opfor


cd ~/.games/hl

wget https://raw.githubusercontent.com/IsaacMvmv/N/main/icons/hl.png
wget https://raw.githubusercontent.com/IsaacMvmv/N/main/icons/bshift.png
wget https://raw.githubusercontent.com/IsaacMvmv/N/main/icons/opfor.png

cd ~/.xash3d

Lang=$(echo $LANG | grep es)

if [ $Lang = "" ];then
	wget https://github.com/N0tN/N0tN/releases/download/webpage/V1.zip
	unzip V1.zip
	rm V1.zip
else
	wget https://github.com/N0tN/N0tN/releases/download/webpage/V2.zip
	unzip V2.zip
	rm V2.zip
fi

wget https://github.com/N0tN/N0tN/releases/download/webpage/V3.zip
unzip V3.zip
rm V3.zip

wget https://github.com/N0tN/N0tN/releases/download/webpage/V4.zip
unzip V4.zip
rm V4.zip

mkdir -pv ~/.local/share/applications/

echo "[Desktop Entry]
Type=Application
Version=1.0
Name=Half life
Comment=Xash3d engine and hlsdk .so files
Exec=/bin/hl
Icon=/home/$USER/.games/hl/hl.png
Terminal=false
Categories=Game;" > ~/.local/share/applications/HalfLife.desktop
chmod +x ~/.local/share/applications/HalfLife.desktop

echo "[Desktop Entry]
Type=Application
Version=1.0
Name=Half life
Comment=Xash3d engine and hlsdk .so files
Exec=/bin/bshift
Icon=/home/$USER/.games/hl/bshift.png
Terminal=false
Categories=Game;" > ~/.local/share/applications/Bshift.desktop
chmod +x ~/.local/share/applications/Bshift.desktop

echo "[Desktop Entry]
Type=Application
Version=1.0
Name=Opposing_force
Comment=Xash3d engine and hlsdk .so files
Exec=/bin/opfor
Icon=/home/$USER/.games/hl/opfor.png
Terminal=false
Categories=Game;" > ~/.local/share/applications/Opposing_force.desktop
chmod +x ~/.local/share/applications/Opposing_force.desktop


echo "Launch game by typing hl or use app icon"
