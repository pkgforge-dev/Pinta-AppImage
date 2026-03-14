#!/bin/sh

set -eu

ARCH=$(uname -m)
VERSION=$(pacman -Q pinta | awk '{print $2; exit}') # example command to get version of application here
export ARCH VERSION
export OUTPATH=./dist
export ADD_HOOKS="self-updater.bg.hook"
export UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY%/*}|${GITHUB_REPOSITORY#*/}|latest|*$ARCH.AppImage.zsync"
export DESKTOP=/usr/share/applications/com.github.PintaProject.Pinta.desktop
export ICON=/usr/share/icons/hicolor/96x96/apps/com.github.PintaProject.Pinta.png
export GTK_CLASS_FIX=1
export DEPLOY_OPENGL=1
export DEPLOY_DOTNET=1

# Deploy dependencies
quick-sharun /usr/bin/pinta /usr/lib/pinta

# Additional changes can be done in between here

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --simple-test ./dist/*.AppImage
