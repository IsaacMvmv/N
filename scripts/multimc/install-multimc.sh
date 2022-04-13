#!/bin/sh

name=multimc

if [ ! -z "$app" ];then
  install_packages openjdk-17-jdk qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools zlib1g-dev cmake git
elif [ -f /usr/bin/apt ];then
	sudo apt -y install openjdk-17-jdk qtbase5-dev qtchooser qt5-qmake qtbase5-dev-tools zlib1g-dev cmake git
elif [ -f /usr/bin/pacman ];then
	sudo pacman -S  --needed jdk-openjdk qt5-base zlib cmake git
fi

rm -rf ~/.tmp ~/.games/$name
mkdir ~/.tmp
cd ~/.tmp


git clone --recursive https://github.com/AfoninZ/MultiMC5-Cracked multimc
cd multimc
mkdir b
cd b
Arch=$(uname -m)
if [ "$Arch" = "x86_64" ];then
	cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=res ..
	make -j$(nproc) install
elif [ "$Arch" = "x86" ];then
	cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=res ..
	make -j$(nproc) install
else
	cmake -DLauncher_META_URL="https://minecraftmachina.github.io/meta-multimc-arm64/" -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=res ..
	make -j$(nproc) install
fi


mkdir ~/.games
cd
mv ~/.tmp/multimc/b/res ~/.games/$name 


sudo rm /bin/$name

echo "cd $HOME/.games/$name
./UltimMC" > $name
chmod +x $name
sudo mv $name /bin/$name

cd

rm -rf ~/.tmp


cd ~/.games/$name

wget https://github.com/IsaacMvmv/N/blob/main/icons/minecraft.png



mkdir -p ~/.local/share/applications


echo "[Desktop Entry]
Type=Application
Version=1.0
Name=$name
Comment=CUBES >:D
Exec=/bin/$name
Icon=/home/$USER/.games/$name/minecraft.png
Terminal=false
Categories=Game;" > ~/.local/share/applications/$name.desktop
chmod +x ~/.local/share/applications/$name.desktop


echo "Launch game by typing $name or clicking app shortcut"
