#!/bin/sh

set -eu

ARCH="$(uname -m)"
VERSION="$(cat ~/version)"
SHARUN="https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/quick-sharun.sh"

export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export OUTNAME=Pinta-"$VERSION"-anylinux-"$ARCH".AppImage
export DESKTOP=/usr/share/applications/pinta.desktop
export ICON=/usr/share/icons/hicolor/96x96/apps/pinta.png
export DEPLOY_OPENGL=1
export DEPLOY_DOTNET=1

# ADD LIBRARIES
wget --retry-connrefused --tries=30 "$SHARUN" -O ./quick-sharun
chmod +x ./quick-sharun
./quick-sharun /usr/bin/pinta /usr/lib/pinta
sed -i \
	-e 's|#!/usr/bin/env sh|#!/bin/sh|g'  \
	-e 's|prefix=/usr|prefix=${APPDIR}|g' \
	./AppDir/bin/pinta

for d in ./AppDir/share/icons/hicolor/*; do
	mkdir -p "$d"/actions
	cp -r /usr/share/icons/hicolor/"${d##*/}"/actions "$d"/actions || :
done

./quick-sharun --make-appimage

mkdir -p ./dist
mv -v ./*.AppImage*  ./dist
mv -v ~/version      ./dist

echo "All Done!"
