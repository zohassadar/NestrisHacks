#!/bin/bash
set -e

compile_flags=()

help () {
    echo "Usage: $0 [-v] [-f <1|3|4>] [-F] [-h]"
    echo "-v  verbose"
    echo "-f  OPTION_FLAG"
    echo "-F  PLAIN_FLAG"
    echo "-h  you are here"
}

while getopts "vf:Fh" flag; do
  case "${flag}" in
    v) set -x ;;
    f)
        if ! [[ "${OPTARG}" =~ ^[134]$ ]]; then
            echo "Valid optionsare 1, 3 or 4"
            exit 1
        fi
        compile_flags+=("-D OPTION_FLAG=${OPTARG}")
        echo "OPTION_FLAG set to ${OPTARG}"  ;;
    F)
        compile_flags+=("-D PLAIN_FLAG")
        echo "PLAIN_FLAG enabled"  ;;
    h)
        help; exit ;;
    *)
        help; exit 1 ;;
  esac
done

if [[ $(uname) == "Darwin" ]]; then
    # mac support
    scriptTime=$(stat -f "%m" "$0")
else
    scriptTime=$(stat -c "%X" "$0")
fi


nametableCount=$(ls src/nametables/*nametable.bin 2>/dev/null | wc -l | xargs)

if ! [ "$(ls src/nametables/*nametable.py 2>/dev/null | wc -l | xargs)" = $nametableCount ]; then
    echo "Building all nametables"
    touch src/nametables/*nametable.py
fi

ls src/nametables/*nametable.py | while read nametable; do
    if [[ $(uname) == "Darwin" ]]; then
        # mac support
        nametableTime=$(stat -f "%m" $nametable)
    else
        nametableTime=$(stat -c "%Y" $nametable)
    fi
    if [ "$nametableTime" -gt "$scriptTime" ]; then
        printf "Building %s\n" $nametable
        python $nametable
    fi
done


chrCount=$(ls src/gfx/*.chr 2>/dev/null | wc -l | xargs)

if ! [ "$(ls src/gfx/*.png 2>/dev/null | wc -l | xargs)" = $chrCount ]; then
    echo "Converting all PNG to CHR"
    touch src/gfx/*png
fi

ls src/gfx/*.png | while read png; do
    if [[ $(uname) == "Darwin" ]]; then
        # mac support
        pngTime=$(stat -f "%m" $png)
    else
        pngTime=$(stat -c "%Y" $png)
    fi
    if [ "$pngTime" -gt "$scriptTime" ]; then
        printf "Converting %s\n" $png
        python tools/nes-util/nes_chr_encode.py $png ${png%.png}.chr
    fi
done


# touch this file to store the last modified / checked date

touch src/gfx/*.png
touch src/nametables/*nametable.py
touch "$0"

# build object files
ca65 ${compile_flags[*]} -g src/tetris.asm -o header.o
ca65 ${compile_flags[*]} -l tetris.lst -g src/main.asm -o main.o

# link object files

ld65 -m tetris.map -Ln tetris.lbl --dbgfile tetris.dbg -o tetris.nes -C src/tetris.nes.cfg main.o header.o

# create patch
if [[ -f clean.nes ]] && [[ $(uname) == "Darwin" ]]; then
    echo "Unable to create patch on mac"
elif [[ -f clean.nes ]]; then
    ./tools/flips-linux --create clean.nes tetris.nes tetris.bps
else
    echo "clean.nes not found.  Skipping patch creation."
fi

# show some stats
if command -v sha1sum &>/dev/null; then
    sha1sum -c tetris.sha1
    # sha1sum tetris.nes
elif command -v shasum &>/dev/null; then
    # mac support
    shasum tetris.nes
else
    echo "sha1sum or shasum not found.  Unable to get SHA-1 hash of tetris.nes."
fi

sed -n '23,27p' < tetris.map

if [[ -f tetris.bps ]]; then
    # mac support
    if [[ $(uname) == "Darwin" ]]; then
        stat -f %z tetris.bps
    else
        stat -c %s tetris.bps
    fi
fi