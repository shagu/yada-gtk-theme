#!/bin/bash -e

function replace() {
  printf "  %-30s %s\n" "$3:" "$1 -> $2"
  find . -type f -exec sed -i "s/$1/$2/gI" {} \; # bg
}

function step() {
  echo -e "\e[1;34m::\e[0;1m $@\e[0m"
}

step "Cleanup"
rm -rf arc-theme

step "Fetching Upstream (Arc)"
git submodule init
git submodule update
git submodule update --recursive --remote
cd arc-theme

ACCENT="#8AB4F8"

step "Replacing Colors"
replace "#383C4A" "#1a1a1a" "Background (Main)"
replace "#404552" "#212121" "Background (Widgets)"

replace "#444A58" "#212121" "Button"
replace "#3E4350" "#000000" "Button (Inactive)"
replace "#505666" "$ACCENT" "Button (Highlight)"

replace "#767B87" "$ACCENT" "Scrollbar (Slider)"
replace "#3E434F" "#1a1a1a" "Scrollbar (Background)"

replace "#2F343F" "#1a1a1a" "Headerbar"
replace "#5294e2" "$ACCENT" "Selection"
replace "#D3DAE3" "#eeeeee" "Font Color"

step "Replacing Name"
replace "Arc-Dark" "yada-gtk" "Main Theme"
replace "Arc" "yada-gtk" "Leftovers"

step "Running Meson Build"
meson setup --prefix=$(dirname $(pwd)) -Dvariants=dark build/
meson install -C build/
cd -

step "Build Theme Release Package"
mkdir -p release
cd share/themes
tar cfJ ../../release/yada-gtk.tar.xz yada-gtk
cd -

step "Update Repository"
cp -rf share/themes/yada-gtk/* .
