#!/bin/sh

if [ -f /bin/apt ];then
	apt-get install git cmake premake libopenal unzip libopenal-dev libglew-dev libglfw3 libglfw3-dev libsndfile1 libsndfile1-dev libmpg123 libmpg123-dev 

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

elif [ -f /bin/pacman ];then
	sudo pacman -S --needed git premake cmake openal glew libsndfile mpg123 glfw-x11
fi


rm -rf ~/.tmp ~/.games/reVC
mkdir ~/.tmp
cd ~/.tmp

git clone --recursive -b miami --depth=1 https://github.com/erorcun/re3
cd re3

premake5  --with-librw  --os=linux gmake
cd build

Arch=$(uname -m)
if [ "$Arch" = "x86_64" ];then
	make -j$(nproc) config=release_linux-amd64-librw_gl3_glfw-oal
	mkdir -pv ~/.games/reVC
	mv ../bin/linux-amd64-librw_gl3_glfw-oal/Release/reVC ~/.games/reVC
elif [ "$Arch" = "armv7l" ];then
	make -j$(nproc) config=release_linux-arm-librw_gl3_glfw-oal
	mkdir -pv ~/.games/reVC
	mv ../bin/linux-arm-librw_gl3_glfw-oal/Release/reVC ~/.games/reVC
elif [ "$Arch" = "aarch64" ];then
	make -j$(nproc) config=release_linux-arm64-librw_gl3_glfw-oal
	mkdir -pv ~/.games/reVC
	mv ../bin/linux-arm64-librw_gl3_glfw-oal/Release/reVC ~/.games/reVC
else
	echo "Cannot detect architecture. Tell devs, this isnt soppused to happen."
	exit 1
fi



cd ~/.games/reVC
wget https://github.com/IsaacMvmv/N/releases/download/reVC/reVC.zip
unzip reVC.zip
rm reVC.zip

cd

echo "#!/bin/sh
cd $HOME/.games/reVC
./reVC
cd \$OLDPWD" > reVC
chmod +x reVC
sudo mv reVC /bin


rm -rf ~/.tmp

cd ~/.games/reVC

wget https://raw.githubusercontent.com/IsaacMvmv/N/main/icons/reVC.jpeg


echo "[Desktop Entry]
Type=Application
Version=1.0
Name=Gta Vice City
Comment=reVC
Exec=/bin/reVC
Icon=/home/$USER/.games/reVC/reVC.jpeg
Terminal=false
Categories=Game;" > ~/.local/share/applications/reVC.desktop
chmod +x ~/.local/share/applications/reVC.desktop

echo "Launch game by typing reVC Or using desktop shortcut"
