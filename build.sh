#!/bin/bash
set -e

compile_flags=()

omit_ud1 () {
    # Add flag if it hasn't been added already
    if ! [[ ${compile_flags[*]} == *"-D OMIT_UD1"* ]]; then
        compile_flags+=("-D OMIT_UD1")
    fi
    }

hacks=(
    "anydas"
    "penguin"
    "sps"
    "wallhack2"
    )

help () {
    echo "Usage: $0 [-v] [-H <hackname>] [-B] [-M <1|3>] [-h]"
    echo "-v  verbose"
    echo "-H  <hackname>"
    echo "-M  <mapper> (1: MMC1 or 3: CNROM)"
    echo "-L  Skippable legalscreen"
    echo "-B  B-Type debug"
    echo "-h  you are here"
    echo ""
    echo "Valid hacks:"
    for hack in "${hacks[@]}"; do
        echo "  $hack"
    done
}

while getopts "vH:M:LBh" flag; do
  case "${flag}" in
    v) 
        set -x 
        verbose=1
        ;;
    H)
        case "${OPTARG}" in 
        "anydas")
            echo "Anydas enabled"
            omit_ud1
            compile_flags+=("-D ANYDAS")
            ;;
        "penguin")
            echo "Penguin Line Clear enabled"
            compile_flags+=("-D PENGUIN")
            ;;
        "sps")
            echo "Same Piece Sets enabled"
            omit_ud1
            compile_flags+=("-D SPS")
            ;;
        "wallhack2")
            echo "Wallhack2 enabled"
            omit_ud1
            compile_flags+=("-D WALLHACK2")
            ;;
        *)
            echo "${OPTARG} is an invalid hack"
            exit 1
            ;;
        esac
        ;;
    M)
        case "${OPTARG}" in 
        1)
            echo "Default MMC1 selected"
            ;;
        3)
            echo "CNROM (Mapper 3) enabled"
            compile_flags+=("-D CNROM")
            ;;
        *)
            echo "Invalid flag ${OPTARG} selected"
            exit 1
            ;;
        esac
        ;;
    L)
        compile_flags+=("-D SKIPPABLE_LEGAL")
        echo "Skippable Legal Screen enabled"  ;;
    B)
        compile_flags+=("-D B_TYPE_DEBUG")
        echo "B-Type debug enabled"  ;;
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

# Rebuild all nametables that are dependent on buildflags
grep -l "in buildflags:" src/nametables/*.py | while read nametable; do
    touch $nametable
done

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
        python $nametable ${compile_flags[*]}
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


# Validate if making clean version
if [ ${#compile_flags[@]} -eq 0 ]; then
    echo "Validating sha1sum"
    if command -v sha1sum &>/dev/null; then
        sha1sum -c tetris.sha1
        # sha1sum tetris.nes
    elif command -v shasum &>/dev/null; then
        # mac support
        shasum -c tetris.sha1
    else
        echo "sha1sum or shasum not found.  Unable to get SHA-1 hash of tetris.nes."
    fi
else
    echo "Hacked version has been compiled.  sha1sum will not match.  Validating label placement instead"
    # Validate label placement
    expected=$(cat labels.txt)
    current=$(bash tools/select_labels.sh)

    if [[ $expected = $current ]]; then
        echo "Labels line up"
    else
        echo "Labels do not line up!"
        diff -y labels.txt <(bash tools/select_labels.sh)
    fi
fi



# show some stats
sed -n '23,27p' < tetris.map
if [[ -f tetris.bps ]]; then
    # mac support
    if [[ $(uname) == "Darwin" ]]; then
        stat -f %z tetris.bps
    else
        stat -c %s tetris.bps
    fi
fi
