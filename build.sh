#!/bin/bash
set -e
echo "Instantiated as $0 $@"

output_path="build/"
basename="Tetris"
build_flags=()
output_name=($basename)

hacks=(
    "anydas"
    "penguin"
    "sps"
    "wallhack2"
    )

variations=(
    "-m 3"
    "-l -H penguin"
    "-l -H penguin -H wallhack2"
    "-l -H penguin -H anydas"
    "-l -H penguin -H sps"
    "-l -H penguin -H anydas -H sps"
    "-l -H penguin -H anydas -H wallhack2"
    # "-l -H penguin -H sps -H wallhack2"
    # "-l -H penguin -H anydas -H sps -H wallhack2"
    # "-l -H wallhack2"
    # "-l -H wallhack2 -H anydas"
    # "-l -H wallhack2 -H sps"
    # "-l -H wallhack2 -H anydas -H sps"
    )

variation_list () {
    for variation in "${variations[@]}"; do
        echo "  $variation"
    done
    }

subcommands=(
    "list:\n show variation list\n"
    "all:\n build variation list\n"
    "clean <debug|nes|all>:\n remove build files\n"
    "set-labels:\n update labels.txt\n"
    "bps2ips:\n Apply bps and create ips\n"
    )

get_labels () {
    # labels to spot check
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
    grep -E "${labels[*]}" "$1" | sort
    unset IFS
}

help () {
    echo "Usage: $0 [-h] [-v] [-a] [-b] [-f] [-H <hackname>] [-l] [-m <1|3>] [-s]"
    echo "-a  faster aeppoz + press select to end game"
    echo "-b  debug b-type"
    echo "-f  floating piece for debugging"
    echo "-h  you are here"
    echo "-H  <hack>"
    echo "-l  skip legal"
    echo "-m  <mapper>"
    echo "-s  set sha1file"
    echo "-v  verbose"
    echo ""
    echo "Valid hacks:"
    for hack in "${hacks[@]}"; do
        echo "  $hack"
    done
    echo ""
    echo "Alternative subcommands:"
    echo ""
    for sc in "${subcommands[@]}"; do
        printf "$sc\n"
    done
}

get_flag_opts (){
    while getopts "abhH:lm:sv" flag; do
        case "${flag}" in
            a)
                build_flags+=("-D AEPPOZ")
                echo "AEPPOZ debug enabled (not actually implemented yet)"
                output_name+=("Aep")
                ;;
            b)
                build_flags+=("-D B_TYPE_DEBUG")
                echo "B-Type debug enabled"
                output_name+=("Bdb")
                ;;
            f)
                build_flags+=("-D FLOATING_PIECE")
                echo "Floating piece debug enabled (not actually implemented yet)"
                output_name+=("Flt")
                ;;
            h)
                help
                exit
                ;;
            H)
                case "${OPTARG}" in 
                "anydas")
                    echo "Anydas enabled"
                    omit_ud1
                    build_flags+=("-D ANYDAS")
                    output_name+=("Any")
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
            l)
                build_flags+=("-D SKIPPABLE_LEGAL")
                echo "Skippable Legal Screen enabled"
                output_name+=("S")
                ;;
            m)
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
            s)
                setsha1=1
                ;;
            v) 
                set -x 
                verbose=1
                ;;
            *)
                help
                exit 1 
                ;;
        esac
    done
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

create_patch () {
    echo "Creating ${1%.nes}.bps using $1"
    flips --create "${output_path}${basename}.nes" "$1" "${1%.nes}.bps"
    }

set_labels () {
    echo "Setting labels.txt using ${output_path}${basename}.lbl"
    get_labels "${output_path}${basename}.lbl" > labels.txt
    }

bps2ips () {
    echo "Converting $1 to ${1%.bps}.ips"
    flips --apply "$1" "${output_path}${basename}.nes" "${1%bps}.nes"
    flips --create --ips "${output_path}${basename}.nes" "${1%bps}.nes" "${1%.bps}.ips"
    }

omit_ud1 () {
    # Add flag if it hasn't been added already
    if ! [[ ${build_flags[*]} == *"-D OMIT_UD1"* ]]; then
        build_flags+=("-D OMIT_UD1")
    fi
    # When specified, unreferenced_data1.bin not included
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

    bps2sps)
        bps2ips $@
        exit
    ;;
    set-labels)
        set_labels
        exit
    ;;
    all)
        for variation in "${variations[@]}"; do
            echo "Building $variation"
            "./$0" ${@:2} $variation
            if [[ $? -eq 0 ]]; then
                echo "Successfully built $variation"
            else
                echo "Failed to build $variation"
                exit 1
            fi
        done
        exit
    ;;
    list)
        variation_list
        exit
    ;;
    *)
        get_flag_opts $@
    ;;

esac

if [[ $(uname) == "Darwin" ]]; then
    # mac support
    get_stat () {
        stat -f "%m" "$1"
        }
    get_size () {
        stat -f %z "$1"
        }
    sha1check () {
        echo "Checking sha1sum for $1"
        shasum -c "$1"
        }
    sha1set () {
        sha=$(shasum "$1")
        printf "Setting sha1sum for $1 to $2: $sha"
        echo "$sha" > "$2"
        }
    scriptTime=$(get_stat "$0")
else
    function get_stat () {
        stat -c "%Y" "$1"
        }
    get_size () {
        stat -c %s "$1"
        }
    sha1check () {
        echo "Checking sha1sum for $1"
        sha1sum -c "$1"
        }
    sha1set () {
        sha=$(sha1sum "$1")
        printf "Setting sha1sum for $1 to $2: $sha\n"
        echo "$sha" > "$2"
        }

    scriptTime=$(get_stat "$0")
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
    nametableTime=$(get_stat $nametable)
    if [[ "$nametableTime" -gt "$scriptTime" ]]; then
        set -e
        echo "Building $nametable"
        verbose=$verbose python $nametable ${build_flags[*]}
    fi
done
chrCount=$(ls src/gfx/*.chr 2>/dev/null | wc -l | xargs)

if ! [ "$(ls src/gfx/*.png 2>/dev/null | wc -l | xargs)" = $chrCount ]; then
    echo "Converting all PNG to CHR"
    touch src/gfx/*png
fi

ls src/gfx/*.png | while read png; do
    pngTime=$(get_stat $png)
    if [ "$pngTime" -gt "$scriptTime" ]; then
        echo "Converting $png"
        python tools/nes-util/nes_chr_encode.py $png ${png%.png}.chr
    fi
done

# touch this file to store the last modified / checked date
touch src/gfx/*.png
touch src/nametables/*nametable.py
touch "$0"

output_file=$(IFS=""; printf "${output_name[*]}"; unset IFS)
mkdir -p "$output_path"
output="${output_path}${output_file}"


# build object files
ca65 ${build_flags[*]} -g src/header.asm -o build/header.o
ca65 ${build_flags[*]} -l ${output}.lst -g src/main.asm -o build/main.o

# link object files

ld65 -m ${output}.map \
    -Ln ${output}.lbl \
    --dbgfile ${output}.dbg \
    -o ${output}.nes \
    -C src/tetris.nes.cfg build/main.o build/header.o

# Validate labels
expected=$(cat labels.txt)
current=$(get_labels "${output}.lbl")
if [[ "$expected" = "$current" ]]; then
    echo "Labels line up"
else
    echo "Labels do not line up!"
    diff -y labels.txt <(get_labels "${output}.lbl")
    exit 1
fi

# Validate against sha1sum
if [[ -n $setsha1 ]]; then
    sha1set "${output}.nes" "sha1files/${output_file}.sha1"
else
    if [[ -f "sha1files/${output_file}.sha1" ]]; then
        sha1check "sha1files/${output_file}.sha1"
    else
        echo "sha1files/${output_file}.sha1 not created"
        exit 1
    fi
fi

# show some stats
sed -n '23,27p' < "${output}.map"

# create patch
if [[ $output == "${output_path}${basename}" ]]; then
    exit 1
elif sha1check "sha1files/${basename}.sha1" 2>/dev/null; then
    create_patch "${output}.nes"
else
    echo "Base file not yet built or is invalid"
    exit 1
fi

# show patch size
if [[ -f "${output}.bps" ]]; then
    echo Patch size: $(get_size "${output}.bps")
fi
