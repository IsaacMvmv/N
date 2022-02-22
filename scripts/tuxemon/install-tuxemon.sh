#!/bin/sh

# Vars

name=tuxemon


if [ ! -z "$app" ];then
  install_packages python python-pygame python-pip python-imaging git
elif [ -f /usr/bin/apt ];then
	sudo apt -y install python python-pygame python-pip python-imaging git
elif [ -f /usr/bin/pacman ];then
	sudo pacman -S  --needed python python-pygame python-pip python-imaging git
fi

rm -rf ~/.tmp ~/.games/$name
mkdir ~/.tmp
cd ~/.tmp

git clone https://github.com/Tuxemon/Tuxemon.git
cd Tuxemon
sudo pip install -U -r requirements.txt


mkdir -pv ~/.games/$name


sudo rm /bin/$name

echo "cd $HOME/.games/$name
python run_tuxemon.py" > $name
chmod +x $name
sudo mv $name /bin/$name

cd

rm -rf ~/.tmp


cd ~/.games/$name

wget https://raw.githubusercontent.com/IsaacMvmv/N/main/icons/$name.png



mkdir -p ~/.local/share/applications


echo "[Desktop Entry]
Type=Application
Version=1.0
Name=$name
Comment= Pokemon-like game!
Exec=/bin/$name
Icon=/home/$USER/.games/$name/$name.png
Terminal=false
Categories=Game;" > ~/.local/share/applications/$name.desktop
chmod +x ~/.local/share/applications/$name.desktop


echo "Launch game by typing $name or clicking app shortcut"
