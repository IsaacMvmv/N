#!/bin/sh

if [ -f /usr/bin/apt ];then
	apt-get install git cmake premake libsndfile1-dev libsndfile1 libopenal unzip libopenal-dev libglew-dev libglfw3 libglfw3-dev libsndfile1 libsndfile1-dev libmpg123 libmpg123-dev 

	mkdir .tmp
	cd .tmp
	wget https://github.com/premake/premake-core/releases/download/v5.0.0-beta1/premake-5.0.0-beta1-src.zip
	unzip premake-5.0.0-beta1-src.zip
	cd premake-5.0.0-beta1-src
	premake --os=linux gmake
	make -j$(nproc)

	sudo apt remove premake

	sudo cp bin/release/*.so /usr/lib
	sudo cp bin/release/premake5 /usr/bin
	cd ../..
	rm -rf .tmp

elif [ -f /usr/bin/pacman ];then
	sudo pacman -S --needed git premake cmake openal glew libsndfile mpg123 glfw-x11
fi


rm -rf ~/.tmp ~/.games/reVC
mkdir ~/.tmp
cd ~/.tmp

git clone --recursive --depth=1 https://github.com/erorcun/re3
cd re3

premake5  --with-librw  --os=linux gmake
cd build

Arch=$(uname -m)
if [ "$Arch" = x86_64 ];then
	make config=release_linux-amd64-librw_gl3_glfw-oal
elif [ "$Arch" = armv7l ];then
	make config=release_linux-arm-librw_gl3_glfw-oal
elif [ "$Arch" = aarch64 ];then
	make config=release_linux-arm64-librw_gl3_glfw-oal
else
	echo "Cannot detect architecture. Tell devs, this isnt soppused to happen."
	exit 1
fi

mkdir -pv ~/.games/re3
mv ../bin/linux-amd64-librw_gl3_glfw-oal/Release/re3 ~/.games/re3

cd ~/.games/re3
wget https://github.com/IsaacMvmv/N/releases/download/reVC/re3.zip
unzip re3.zip
rm re3.zip

cd

echo "#!/bin/sh
cd $HOME/.games/re3
./re3
cd \$OLDPWD" > re3
chmod +x re3
sudo mv re3 /bin

cd ~/.games/re3

wget https://raw.githubusercontent.com/IsaacMvmv/N/main/icons/reVC.jpeg


echo "[Desktop Entry]
Type=Application
Version=1.0
Name=Gta 3
Comment=re3
Exec=/bin/re3
Icon=/home/$USER/.games/re3/re3.jpeg
Terminal=false
Categories=Game;" > ~/.local/share/applications/re3.desktop
chmod +x ~/.local/share/applications/re3.desktop

echo "Launch game by typing re3 Or using desktop shortcut"
