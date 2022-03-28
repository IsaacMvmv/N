#!/bin/sh

name=scpsl

rm -rf ~/.games/$name
mkdir -pv ~/.games/$name

sudo rm /bin/$name

echo "cd $HOME/.games/$name
./SCPSL" > $name
chmod +x $name
sudo mv $name /bin/$name


cd ~/.games/$name

wget https://github.com/IsaacMvmv/Stuff/releases/download/SCPSL_BETA/SCPSL_BETA.zip
unzip SCPSL_BETA.zip
chmod +x SCPSL SCPSL.x86_64

wget https://github.com/IsaacMvmv/N/blob/main/icons/scp.jpg


mkdir -p ~/.local/share/applications


echo "[Desktop Entry]
Type=Application
Version=1.0
Name=$name
Comment=SCP GAME
Exec=/bin/$name
Icon=/home/$USER/.games/$name/scp.jpg
Terminal=false
Categories=Game;" > ~/.local/share/applications/$name.desktop
chmod +x ~/.local/share/applications/$name.desktop


echo "Launch game by typing $name or clicking app shortcut"
