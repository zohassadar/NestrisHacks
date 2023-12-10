#!/usr/bin/env bash
set -e

output_path="build/"
basename="Tetris"
buildflags=()
name_modifiers=()


help () {
    echo "Usage: $0 [-h] [-v] [-a] [-b] [-f] [-H <hackname>] [-l] [-m <1|3>] [-s]"
    echo "-a  aeppoz + hold select to top out"
    echo "-b  debug b-type"
    echo "-f  floating piece for debugging"
    echo "-h  you are here"
    echo "-v  verbose"
    echo ""
}
 get_flag_opts (){
    while getopts "abhH:lm:psv" flag; do
        case "${flag}" in
            a)
                buildflags+=("-D AEPPOZ")
                echo "AEPPOZ debug enabled"
                name_modifiers+=("Aep")
                ;;
            b)
                buildflags+=("-D B_TYPE_DEBUG")
                echo "B-Type debug enabled"
                name_modifiers+=("Bdb")
                ;;
            f)
                buildflags+=("-D FLOATING_PIECE")
                echo "Floating piece debug enabled (not actually implemented yet)"
                name_modifiers+=("Flt")
                ;;
            h)
                help
                exit
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


create_patch () {
    echo "Creating ${1%.nes}.bps using $1"
    flips --create "${output_path}${basename}.nes" "$1" "${1%.nes}.bps"
    }


omit_ud1 () {
    # Add flag if it hasn't been added already
    if ! [[ ${buildflags[*]} == *"-D OMIT_UD1"* ]]; then
        buildflags+=("-D OMIT_UD1")
    fi
    # When specified, unreferenced_data1.bin not included
    }

omit_ud1
buildflags+=("-D TOURNAMENT")
buildflags+=("-D ANYDAS")
buildflags+=("-D WALLHACK2")
buildflags+=("-D CNROM")
name_modifiers+=("Any")
name_modifiers+=("Trn")
name_modifiers+=("Why2")


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

build_gfx () {
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
        if [[ "$nametableTime" -ge "$scriptTime" ]]; then
            set -e
            echo "Building $nametable"
            verbose=$verbose python $nametable ${buildflags[*]}
        fi
    done
    chrCount=$(ls src/gfx/*.chr 2>/dev/null | wc -l | xargs)

    if ! [ "$(ls src/gfx/*.png 2>/dev/null | wc -l | xargs)" = $chrCount ]; then
        echo "Converting all PNG to CHR"
        touch src/gfx/*png
    fi

    ls src/gfx/*.png | while read png; do
        pngTime=$(get_stat $png)
        if [ "$pngTime" -ge "$scriptTime" ]; then
            echo "Converting $png"
            python tools/nes-util/nes_chr_encode.py $png ${png%.png}.chr
        fi
    done

    }
# touch this file to store the last modified / checked date
touch "$0"

sorted_modifiers=($(echo ${name_modifiers[@]} | tr " " "\n" | sort))
output_file=$(IFS=""; printf "${basename}${sorted_modifiers[*]}"; unset IFS)
mkdir -p "$output_path"
output="${output_path}${output_file}"


# build object files
ca65 ${buildflags[*]} -g src/header.asm -o build/header.o
ca65 ${buildflags[*]} -l ${output}.lst -g src/main.asm -o build/main.o

# link object files

ld65 -m ${output}.map \
    -Ln ${output}.lbl \
    --dbgfile ${output}.dbg \
    -o ${output}.nes \
    -C src/tetris.nes.cfg build/main.o build/header.o

# show some stats
sed -n '23,27p' < "${output}.map"

echo ${output}.nes