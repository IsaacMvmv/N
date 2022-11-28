#!/bin/sh

set -e

if [ $(uname -m) == "x86_64" ]; then
  ARGS="-DXASH_64BIT=1"
  ARCH="amd64"
  Clname="client64.so"
elif [ $(uname -m) == "aarch64" ]; then
	ARCH="arm64"
	Clname="client_arm64.so"
elif [ $(uname -m) == "armv7h" ]; then
	ARCH="armhf"
	Clname="client_armv7h.so"
fi


if [ -f /usr/bin/apt ];then
	sudo apt install -y libsdl2-2.0-0 libsdl2-dev gcc g++ cmake make libfreetype6-dev pkg-config git unzip fontconfig libfontconfig1-dev 
elif [ -f /usr/bin/pacman ];then
	sudo pacman -S --needed sdl2 gcc fontconfig cmake make freetype2 git unzip pkgconf
fi


rm -rf ~/.tmp ~/.games/cstrike
mkdir ~/.tmp
cd ~/.tmp


git clone --recursive --depth=1 https://github.com/FWGS/xash3d xash3d

cd xash3d

mkdir build
cd build

mkdir res

cmake .. -DCMAKE_INSTALL_PREFIX=res $ARGS

make -j$(nproc) install

mv res ../../engine

cd ../..

rm -rf xash3d

mkdir -p $HOME/.games/cstrike
mv engine/bin/xash3d $HOME/.games/cstrike
mv engine/lib/xash3d/* $HOME/.games/cstrike

cd $HOME/.games/cstrike

wget https://raw.githubusercontent.com/IsaacMvmv/N/main/icons/cstrike.png

wget https://github.com/N0tN/N0tN/releases/download/webpage/C1.zip
unzip C1.zip
rm C1.zip
mv libxashmenu* cstrike/cl_dlls

wget https://github.com/IsaacMvmv/cstrike_linux/releases/download/Libs/cslibs_${ARCH}.zip
unzip cslibs_${ARCH}.zip
rm cslibs_${ARCH}.zip
mv client*.so cstrike/cl_dlls/${Clname}
mv cs*.so cstrike/dlls/cs.so

rm -rf ~/.tmp

echo "#!/bin/sh
export LD_LIBRARY_PATH=/home/$USER/.games/cstrike:$LD_LIBRARY_PATH
cd /home/$USER/.games/cstrike
/home/$USER/.games/cstrike/xash3d -game cstrike '$@'" > cstrikescript

chmod +x cstrikescript
sudo mv cstrikescript /bin/cstrike

mkdir -pv ~/.local/share/applications/

echo "[Desktop Entry]
Type=Application
Version=1.0
Name=Counter Strike
Exec=/bin/cstrike
Icon=/home/$USER/.games/hl/hl.png
Terminal=false
Categories=Game;" > ~/.local/share/applications/Cstrike.desktop
chmod +x ~/.local/share/applications/Cstrike.desktop

echo "Launch game by typing cstrike or use app icon"
