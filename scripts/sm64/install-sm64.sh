#!/bin/sh

git clone --recursive https://github.com/MorsGames/sm64plus
cd sm64plus
wget https://ia903207.us.archive.org/20/items/super-mario-64-usa/Super%20Mario%2064%20%28U%29%20%5B%21%5D.z64
mv Super* baserom.us.z64
SM64PLUS_BASEROM_us="$PWD/baserom.us.z64" make -j "$(nproc)"
