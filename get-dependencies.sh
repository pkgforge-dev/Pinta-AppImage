#!/bin/sh

set -eu

ARCH="$(uname -m)"
echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm pinta

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Building pinta..."
echo "---------------------------------------------------------------"
#make-aur-package PACKAGENAME

cc -shared -fPIC -O2 -o ./libappstream.so.5 -Wl,-soname,libappstream.so.5 libappstream-stub.c
mv -v ./libappstream.so.5 /usr/lib
