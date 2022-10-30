#!/bin/sh

if [ -f /usr/bin/apt ];then
	sudo apt install -y unzip wget git make gcc g++ libsdl2-2.0-0 libsdl2-dev libsdl2-mixer-dev libsdl2-image-dev 
elif [ -f /usr/bin/pacman ];then
	sudo pacman -S --needed unzip wget git make gcc sdl2 sdl2_mixer sdl2_image
fi


rm -rf ~/.tmp ~/.games/tesseract
mkdir ~/.tmp
cd ~/.tmp

git clone --depth=1 --recursive https://github.com/tesseract-ocr/tesseract
cd tesseract/src
make -j$(nproc) install
cd ..
rm -rf src

cd

mkdir -pv ~/.games/tesseract
mv ~/.tmp/* ~/.games/tesseract
echo '#!/bin/sh
cd /home/$USER/.games/tesseract
./bin_unix/native_client' > tesseract
chmod +x tesseract
sudo mv tesseract /bin/tesseract

rm -rf ~/.tmp

cd ~/.games/tesseract

wget https://raw.githubusercontent.com/IsaacMvmv/N/main/icons/tesseract.jpg

mkdir -p ~/.local/share/applications

echo "[Desktop Entry]
Type=Application
Version=1.0
Name=Tesseract shooter game
Comment=Based on Cube 2 engine
Exec=/bin/tesseract
Icon=/home/$USER/.games/tesseract/tesseract.jpg
Terminal=false
Categories=Game;" > ~/.local/share/applications/Tesseract.desktop
chmod +x ~/.local/share/applications/Tesseract.desktop

echo "Launch game by typing tesseract Or using desktop shortcut"
