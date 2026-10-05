#!/bin/sh
# Re-export every printable STL from the OpenSCAD sources. Usage: ./build.sh
set -eu
cd "$(dirname "$0")"

render() {  # render <source> <part> <output>
  echo "stl/$3.stl"
  openscad -q -o "stl/$3.stl" --export-format asciistl -D "part=\"$2\"" "scad/$1.scad"
}

for p in left right sled pin rod; do render rack-1u-airport-hue-pi "$p" "rack-1u-$p"; done
for p in 1 2 3;                   do render rack-2u-audio-stacks   "$p" "audio-$p";   done
for p in left right;              do render rack-1u-keystone-panel "$p" "keystone-$p"; done
