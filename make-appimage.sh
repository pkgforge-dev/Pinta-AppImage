#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q pinta | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export DESKTOP=/usr/share/applications/pinta.desktop
export ICON=/usr/share/icons/hicolor/96x96/apps/pinta.png
export DEPLOY_OPENGL=1
export DEPLOY_DOTNET=1

# Deploy dependencies
quick-sharun \
	/usr/bin/pinta \
	/usr/lib/pinta \
	/usr/share/icons/hicolor/*/actions

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage
