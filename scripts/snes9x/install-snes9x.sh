#!/bin/bash

sudo apt update &&
sudo apt install pkg-config libgtk2.0-dev libxml2-dev libxv-dev libsdl-dev libsdl-dev -y &&
wget http://launchpad.net/intltool/trunk/0.50.2/+download/intltool-0.50.2.tar.gz &&
tar -xzf intltool-0.50.2.tar.gz &&
sudo chmod -R 777 intltool-0.50.2 &&
cd intltool-0.50.2 &&
./configure &&
make &&
sudo make install &&
cd .. &&
rm -r intltool-0.50.2 &&
rm intltool-0.50.2.tar.gz &&
wget http://files.ipherswipsite.com/snes9x/snes9x-1.53-src.tar.bz2 &&
tar -xjf snes9x-1.53-src.tar.bz2 &&
sudo chmod -R 777 snes9x-1.53-src &&
cd snes9x-1.53-src/gtk &&
./configure &&
make &&
sudo make install &&
cd ../.. &&
rm -r snes9x-1.53-src &&
rm snes9x-1.53-src.tar.bz2
