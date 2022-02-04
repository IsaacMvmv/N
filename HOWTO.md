## The howto will be divided into 5 parts


## 1. Deps

You will have to include ALL the deps in the script, for apt, or for pacman. You can use https://pkgs.org/ to search for specific dependencies in other distros.
Currently only apt and pacman are supported.

## 2. Cloning and compiling

All scripts create a .temp directory, to avoid messing with the home directory, so when its created, clone the repo, and, usually open source games/engines will be prebuilt using cmake or configure.

If using cmake, you will have to add ```-DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=res``` to its options. They will reduce result size, performance and it will install the compilation in "res" folder. useful for "packaging" the app in a folder

If using configure, you will have to add ```--prefix=$PWD/res``` to its options. It will install the compilation in the "res" folder inside current dir. Useful for "packaging" later.

## 3. Packaging and preparing launch script

As gamefiles are installed in res directory, we have to move them to the definitive directory: /home/$USER/.games/%gamename%
Then, you have to make a launch script which cds to gamedir, launch desired executable and cd to $OLDPWD.

## 4. Move launch script to /bin/  and make app shortcut. Also remove tmp dir
Give it execution perms and... move it. After that make app shortcut. finally, remove tmp dir

## 5. Say "Ready, launch it by typing "X" command or clicking in the app menu!





This can be better understood while looking to doom3 install script, because its the cleanest script here, and the less modified:




Doom3's step 1
```
if [ -f /bin/apt ];then
	sudo apt -y install sdl2-image sdl2-mixer sdl2-ttf libfontconfig-dev qt5-default automake mercurial libtool libfreeimage-dev libopenal-dev libpango1.0-dev libsndfile-dev libudev-dev libtiff5-dev libwebp-dev libasound2-dev libaudio-dev libxrandr-dev libxcursor-dev libxi-dev libxinerama-dev libxss-dev libesd0-dev freeglut3-dev libmodplug-dev libsmpeg-dev libjpeg-dev libogg-dev libvorbis-dev libvorbisfile3 libcurl4 cmake aria2
elif [ -f /bin/pacman ];then
	sudo pacman -S  --needed sdl2_image sdl2_ttf sdl2_mixer fontconfig qt5-base automake mercurial libtool freeimage openal pango libsndfile libtiff xorg-xrandr libxinerama libxss freeglut libjpeg-turbo libogg libvorbis cmake 
fi
```

Doom3's step 2
```
rm -rf ~/.tmp ~/.games/doom3 rm -rf ~/.local/share/dhewm3/
mkdir ~/.tmp
cd ~/.tmp

git clone https://github.com/dhewm/dhewm3
cd dhewm3/neo
mkdir build
cd build
cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=res
make -j$(nproc) install
```
Doom3's step 3
```
mkdir -pv ~/.games/doom3
cp res/bin/dhewm3 ~/.games/doom3
cp res/lib/dhewm3/* ~/.games/doom3

sudo rm /bin/doom3

echo "cd $HOME/.games/doom3
./dhewm3
cd $OLDPWD" > doom3
```
Doom3's step 4
```
chmod +x doom3
sudo mv doom3 /bin/doom3

cd
rm -rf ~/.tmp


cd ~/.games/doom3

wget https://raw.githubusercontent.com/IsaacMvmv/N/main/icons/doom3.jpeg

mkdir -p ~/.local/share/applications


echo "[Desktop Entry]
Type=Application
Version=1.0
Name=Doom 3
Comment=Doom 3 engine
Exec=/bin/doom3
Icon=/home/$USER/.games/doom3/doom3.jpeg
Terminal=false
Categories=Games;" > ~/.local/share/applications/Doom3.desktop
chmod +x ~/.local/share/applications/Doom3.desktop
```
Doom3's step 5 
```
echo "Lunch game by typing doom3 or use app shortcut ;D"
```
