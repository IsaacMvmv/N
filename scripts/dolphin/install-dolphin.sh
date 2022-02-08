#!/bin/sh

if [ -f /usr/bin/apt ];then
	sudo apt install --no-install-recommends ca-certificates qtbase5-dev qtbase5-private-dev git cmake make gcc g++ pkg-config libavcodec-dev libavformat-dev libavutil-dev libswscale-dev libxi-dev libxrandr-dev libudev-dev libevdev-dev libsfml-dev libminiupnpc-dev libmbedtls-dev libcurl4-openssl-dev libhidapi-dev libsystemd-dev libbluetooth-dev libasound2-dev libpulse-dev libpugixml-dev libbz2-dev libzstd-dev liblzo2-dev libpng-dev libusb-1.0-0-dev gettext
elif [ -f /usr/bin/pacman ];then
	sudo pacman -S --needed cmake git python alsa-lib bluez-libs enet hidapi libevdev libgl libpng libpulse libx11 libxi libxrandr lzo mbedtls pugixml qt5-base sfml zlib libavcodec.so libavformat.so libavutil.so libcurl.so libminiupnpc.so libswscale.so libudev.so libusb-1.0.so
fi

rm -rf ~/.tmp
mkdir ~/.tmp
cd ~/.tmp

git clone --recursive --depth=1 https://github.com/dolphin-emu/dolphin
export CXXFLAGS+=" -fpermissive"
mkdir dolphin/build
cd dolphin/build
cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=/usr -DUSE_SHARED_ENET=ON ..
make -j$(nproc)
sudo make install
