#!/bin/bash
set -e


build_flags=()
output_name=("Tetris")
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
    echo "-S  Set SHA-1"
    echo "-h  you are here"
    echo ""
    echo "Valid hacks:"
    for hack in "${hacks[@]}"; do
        echo "  $hack"
    done
}

get_labels (){
labels=(
    "@playStateNotDisplayLineClearingAnimation"
    "shift_tetrimino"
    "rotate_tetrimino"
    "drop_tetrimino"
    "isPositionValid"
    "game_palette"
    "gameModeState_initGameBackground"
    "playState_playerControlsActiveTetrimino"
    "render_mode_legal_and_title_screens"
    "render_mode_menu_screens"
    "render_mode_congratulations_screen"
    "pollControllerButtons"
    "nmi"
    "memset_page"
    "soundEffectSlot1_rotateTetrimino_ret"
    "unreferenced_data4"
    )
    IFS="|"
    grep -E "${labels[*]}" $1 | sort
    unset IFS
}



clean_nes () {
    echo "Cleaning nes files"
    set +e
    rm build/*.nes 2>/dev/null
    set -e
    }

clean_debug () {
    echo "Cleaning debug files"
    set +e
    rm build/*.lbl 2>/dev/null
    rm build/*.map 2>/dev/null
    rm build/*.lst 2>/dev/null
    rm build/*.dbg 2>/dev/null
    rm build/*.o 2>/dev/null
    set -e
    }

clean_all () {
    echo "Cleaning all"
    clean_debug
    clean_nes
    set +e
    rm build/*.bps 2>/dev/null
    set -e
    }


omit_ud1 () {
    # Add flag if it hasn't been added already
    if ! [[ ${build_flags[*]} == *"-D OMIT_UD1"* ]]; then
        build_flags+=("-D OMIT_UD1")
    fi
    }

get_flag_opts (){
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
                build_flags+=("-D ANYDAS")
                output_name+=("Ad")
                ;;
            "penguin")
                echo "Penguin Line Clear enabled"
                build_flags+=("-D PENGUIN")
                output_name+=("Plc")
                ;;
            "sps")
                echo "Same Piece Sets enabled"
                omit_ud1
                build_flags+=("-D SPS")
                output_name+=("Sps")
                ;;
            "wallhack2")
                echo "Wallhack2 enabled"
                omit_ud1
                build_flags+=("-D WALLHACK2")
                output_name+=("Wh2")
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
                build_flags+=("-D CNROM")
                output_name+=("Cnrom")
                ;;
            *)
                echo "Invalid flag ${OPTARG} selected"
                exit 1
                ;;
            esac
            ;;
        L)
            build_flags+=("-D SKIPPABLE_LEGAL")
            echo "Skippable Legal Screen enabled"
            output_name+=("Cnrom")
            ;;
        B)
            build_flags+=("-D B_TYPE_DEBUG")
            echo "B-Type debug enabled"
            output_name+=("Bdebug")
            ;;
        B)
            echo "Setting SHA-1 sum"
            setsha1=1
            ;;
        h)
            help; exit ;;
        *)
            help; exit 1 ;;
    esac
    done
}

case $1 in
    clean)
        case $2 in
        debug)
            clean_debug
            exit
        ;;
        nes)
            clean_nes
            exit
        ;;
        all)
            clean_all
            exit
        ;;
        "")
            echo "Please choose:  debug, nes or all"
            exit 1
        ;;
        *)
            echo "Invalid clean option $2"
            echo "Please choose:  debug, nes or all"
            exit 1
        ;;
        esac
    ;;
    *)
        get_flag_opts
    ;;

esac



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
        python $nametable ${build_flags[*]}
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

mkdir -p build
output=$(IFS=""; printf "build/${output_name[*]}"; unset IFS)

# build object files
ca65 ${build_flags[*]} -g src/tetris.asm -o build/header.o
ca65 ${build_flags[*]} -l ${output}.lst -g src/main.asm -o build/main.o

# link object files

ld65 -m ${output}.map \
    -Ln ${output}.lbl \
    --dbgfile ${output}.dbg \
    -o ${output}.nes \
    -C src/tetris.nes.cfg build/main.o build/header.o

# create patch
if [[ -f clean.nes ]] && [[ $(uname) == "Darwin" ]]; then
    echo "Unable to create patch on mac"
elif [[ -f clean.nes ]]; then
    ./tools/flips-linux --create clean.nes tetris.nes tetris.bps
else
    echo "clean.nes not found.  Skipping patch creation."
fi



# Validate if making clean version
if [[ -n $setsha1 ]]; then
    echo "Setting sha1sum"
    if command -v sha1sum &>/dev/null; then
        sha1sum ${output}.nes > sha1files/${output}.sha1 
        # sha1sum tetris.nes
    elif command -v shasum &>/dev/null; then
        # mac support
        shasum -c  ${output}.nes > sha1files/${output}.sha1
    else
        echo "sha1sum or shasum not found.  Unable to get SHA-1 hash of tetris.nes."
    fi
elif [ ${#build_flags[@]} -eq 0 ]; then
    echo "Validating sha1sum"
    if command -v sha1sum &>/dev/null; then
        sha1sum -c sha1files/${output}.sha1 
        # sha1sum tetris.nes
    elif command -v shasum &>/dev/null; then
        # mac support
        shasum -c  sha1files/${output}.sha1
    else
        echo "sha1sum or shasum not found.  Unable to get SHA-1 hash of tetris.nes."
    fi
else
    echo "Hacked version has been compiled.  sha1sum will not match.  Validating label placement instead"
    # Validate label placement
    expected=$(cat labels.txt)
    current=$(get_labels ${output}.lbl)

    if [[ $expected = $current ]]; then
        echo "Labels line up"
    else
        echo "Labels do not line up!"
        diff -y labels.txt <(get_labels ${output}.lbl)
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
