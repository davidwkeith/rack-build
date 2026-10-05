#!/bin/sh
# Build outputs from the OpenSCAD sources.
# Usage: ./build.sh            re-render the README preview images (committed)
#        ./build.sh release    export every printable STL into stl/ (release builds only;
#                              stl/ is not committed -- CI attaches it to the GitHub release)
set -eu
cd "$(dirname "$0")"

render() {  # render <source> <part> <output>
  echo "stl/$3.stl"
  openscad -q -o "stl/$3.stl" --export-format asciistl -D "part=\"$2\"" "scad/$1.scad"
}

preview() {  # preview <source> <camera> <size> [-D overrides...] -- assembled view, as racked
  src=$1 cam=$2 size=$3; shift 3
  for scheme in "Tomorrow" "Tomorrow Night"; do   # light, then dark for prefers-color-scheme
    [ "$scheme" = "Tomorrow" ] && out="images/$src.png" || out="images/$src-dark.png"
    echo "$out"
    openscad -q -o "$out" --render=true --projection=o --colorscheme="$scheme" \
      --imgsize="$size" --camera="$cam" "$@" "scad/$src.scad"
  done
}

case "${1:-preview}" in
  release)
    mkdir -p stl
    for p in left right sled pin rod; do render rack-1u-hue-pi         "$p" "rack-1u-$p";  done
    for p in 1 2 2-stack 3;           do render rack-2u-audio-stacks   "$p" "audio-$p";    done
    for p in left right;              do render rack-1u-keystone-panel "$p" "keystone-$p"; done
    ;;
  preview)
    mkdir -p images
    preview rack-1u-hue-pi         241,58,15,60,0,20,640 1600,620 -D 'part="assembly"'
    preview rack-2u-audio-stacks   241,65,40,60,0,20,800 1600,760 -D 'part="all"'  -D gap=0 -D print_orient=false
    preview rack-1u-keystone-panel 241,5,22,60,0,20,450  1600,420 -D 'part="both"' -D gap=0 -D print_orient=false
    ;;
  *)
    echo "usage: $0 [release]" >&2
    exit 2
    ;;
esac
