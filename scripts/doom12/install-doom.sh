#!/bin/sh


if [ -f /usr/bin/apt ];then
	sudo apt install -y g++ make cmake libsdl2-dev libsdl-mixer1.2 libsdl-net1.2 libsdl-net1.2-dev libsdl-mixer1.2-dev git zlib1g-dev libbz2-dev libjpeg-dev libfluidsynth-dev libgme-dev libopenal-dev libmpg123-dev libsndfile1-dev libgtk-3-dev timidity nasm libgl1-mesa-dev tar libsdl1.2-dev libglew-dev
elif [ -f /usr/bin/pacman ];then
	sudo pacman -S --needed gcc make cmake sdl2 sdl_mixer sdl_net git zlib bzip2 libjpeg-turbo fluidsynth libgme openal mpg123 libsndfile gtk3 timidity++ nasm glu tar sdl glew
fi

rm -rf ~/.tmp ~/.games/doom1_2
mkdir ~/.tmp
cd ~/.tmp

git clone https://github.com/AXDOOMER/crispy-doom.git
cd crispy-doom
./autogen.sh
./configure --prefix=/home/$USER/.tmp/crispy-doom/res

echo '// Emacs style mode select   -*- C++ -*- 
//-----------------------------------------------------------------------------
//
// $Id: v_video.h,v 1.9 1998/05/06 11:12:54 jim Exp $
//
//  BOOM, a modified and improved DOOM engine
//  Copyright (C) 1999 by
//  id Software, Chi Hoang, Lee Killough, Jim Flynn, Rand Phares, Ty Halderman
//
//  This program is free software; you can redistribute it and/or
//  modify it under the terms of the GNU General Public License
//  as published by the Free Software Foundation; either version 2
//  of the License, or (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program; if not, write to the Free Software
//  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 
//  02111-1307, USA.
//
// DESCRIPTION:
//  Gamma correction LUT.
//  Color range translation support
//  Functions to draw patches (by post) directly to screen.
//  Functions to blit a block to the screen.
//
//-----------------------------------------------------------------------------

#ifndef __V_TRANS__
#define __V_TRANS__

#include "doomtype.h"

enum
{
    CR_NONE,
    CR_DARK,
    CR_GRAY,
    CR_GREEN,
    CR_GOLD,
    CR_RED,
    CR_BLUE,
    CR_RED2BLUE,
    CR_RED2GREEN,
    CRMAX
};

extern byte *cr[CRMAX];
extern char **crstr;

extern byte *tranmap;

void CrispyReplaceColor (char *str, const int cr, const char *col);

#endif // __V_TRANS__' > src/v_trans.h

make -j$(nproc)
make install


mkdir -pv ~/.games/doom1_2

mv ~/.tmp/crispy-doom/res/bin/crispy-doom ~/.games/doom1_2

cd ~/.games/doom1_2
wget https://github.com/IsaacMvmv/N/releases/download/doom/doom1.wad
wget https://github.com/IsaacMvmv/N/releases/download/doom/doom2.wad

echo '#!/bin/sh
cd /home/$USER/.games/doom1_2/
./crispy-doom -iwad doom1.wad
cd \$OLDPWD' > doom1

echo '#!/bin/sh
cd /home/$USER/.games/doom1_2/
./crispy-doom -iwad doom2.wad
cd \$OLDPWD' > doom2

chmod +x doom1 doom2
sudo rm /bin/doom1 /bin/doom2
sudo mv doom1 /bin/
sudo mv doom2 /bin/

rm -rf ~/.tmp

cd ~/.games/doom12

wget https://raw.githubusercontent.com/IsaacMvmv/N/main/icons/doom12.jpeg


echo "[Desktop Entry]
Type=Application
Version=1.0
Name=doom1
Comment=Doom1 and 2 Engine
Exec=/bin/doom1
Icon=/home/$USER/.games/doom1_2/doom12.jpeg
Terminal=false
Categories=Game;" > ~/.local/share/applications/Doom1.desktop
chmod +x ~/.local/share/applications/Doom1.desktop

echo "[Desktop Entry]
Type=Application
Version=1.0
Name=doom2
Comment=Doom1 and 2 Engine
Exec=/bin/doom2
Icon=/home/$USER/.games/doom1_2/doom12.jpeg
Terminal=false
Categories=Game;" > ~/.local/share/applications/Doom2.desktop
chmod +x ~/.local/share/applications/Doom2.desktop

echo Type "doom1, doom2 to run each game"
