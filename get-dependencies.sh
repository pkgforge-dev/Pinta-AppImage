#!/bin/sh

set -eu

ARCH="$(uname -m)"
#echo "Installing package dependencies..."
# echo "---------------------------------------------------------------"
# pacman -Syu --noconfirm PACKAGESHERE

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

echo "Building pinta..."
echo "---------------------------------------------------------------"
make-aur-package pinta
