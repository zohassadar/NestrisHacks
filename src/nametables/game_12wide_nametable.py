
import argparse
import pathlib
import sys

import nametable_builder

"""
This script has been generated by nametable_builder.py.  It's intended to rebuild the nametable
into a .bin

Unless modified, it will reproduce the original.
"""

file = pathlib.Path(__file__)
output = file.parent / file.name.replace(".py", ".bin")

parser = argparse.ArgumentParser()
parser.add_argument('-D', '--buildflag', action='append', dest='buildflags', help='Build Flag')
args = parser.parse_args()
buildflags = args.buildflags if args.buildflags else []


original_sha1sum = "36fa36fcab592f7b1b9373809ccbcdcbfd949e2b"

characters = (
    #0123456789ABCDEF
    "0123456789ABCDEF" #0
    "GHIJKLMNOPQRSTUV" #1
    "WXYZ-,'╥┌━┐┇╏└╍┘" #2
    "ghijklmn╔╧╗╣╠╚╤╝" #3
    "wxyz╭▭╮╢╟╰▱╯├╪┤/" #4
    "┉=!@[]^Ë`{|}~¹()" #5
    "¼½¾¿ÀÁÂÃÄÅÆÇÈÉ‟." #6
    "ÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛ" #7
    "ÜÝÞßàáâãäåæçèéêë" #8
    "ìíîïðñòóôõö÷øùúû" #9
    "üýþÿЉЊЋЌЍЎЏАБВГД" #A
    "ЕЖЗИЙКЛМНОПРСТУФ" #B
    "ХЦЧШЩЪЫЬЭЮЯабвгд" #C
    "εζηθικλμνξοπρςστ" #D
    "υφχψωϊϋόύώϏϐϑϒϓϔ" #E
    "ϕϖϗϘϙ©ϛ┬ϝϞϟϠϡͰͱ_" #F
)  # fmt: skip

table = """
ÖÃÓÓÎÕÖÔÑÖÃÓÔßÔßÓãÃÔÏãÌÍÃãÔÑÖÎÖÃ
ÎßãÓãÃÔÏãÎßãÔÕÕÖãÔàÖÞÖÜÝÞÕÖãÔßÔá
ãÎÖãÔàÖÞÖ╔╧╧╧╧╧╧╧╧╧╧╧╧╗╔╧╧╧╧╧╧╗ã
╔╧╧╧╧╧╧╗Ó╣__LINES-____╠╣______╠Ã
╣_-TYPE╠Ó╚╤╤╤╤╤╤╤╤╤╤╤╤╝╣TOP___╠Ó
╚╤╤╤╤╤╤╝ãghhhhhhhhhhhhi╣000000╠Ó
ÔÕÕÖÃÌÍÃÔj____________k╣______╠ã
ÕÖÔÕßÜÝÞÕj____________k╣SCORE_╠Ã
╧╧╧╧╧╧╧╧╗j____________k╣000000╠Þ
ÅÆÇÈÉ‟.)╠j____________k╣______╠Ã
________╠j____________k╚╤╤╤╤╤╤╝Ó
_wxy____╠j____________kÔÕÕÖÔÕÏÔß
_┉=!000_╠j____________kghhhhiãÃÔ
_╰▱╯____╠j____________kjNEXTkÎßÔ
_{|}000_╠j____________kj____kãÎÖ
_╮╢_____╠j____________kj____kÔßÌ
_^Ë`000_╠j____________kj____kÎÖÜ
_¼½_____╠j____________kj____kÓÔÏ
_¾¿_000_╠j____________klmmmmnãÃÓ
_z╭▭____╠j____________k╔╧╧╧╧╧╗Óã
_@[]000_╠j____________k╣LEVEL╠ÓÔ
_├╪┤____╠j____________k╣_____╠ãÃ
_~¹(000_╠j____________k╚╤╤╤╤╤╝Ôá
________╠j____________kÃÔÑÖÃÎÕÖã
_ÀÁÂ000_╠j____________kÐÖãÔáãÃÔÕ
________╠j____________kãÔÕÏãÎßÎÖ
╤╤╤╤╤╤╤╤╝lmmmmmmmmmmmmnÃÌÍãÃãÔßÃ
ÃÃÔÑÖÎÕÖÃÔÏÔÏÃÎÖÎÕÖÔÕÕÖÓÜÝÔáÃÔÕß
ÓÞÏãÃãÃÎßÃÞÖÓÓÓÃãÃÌÍÎÖÃÜÖÔÏãÓÔÕÕ
ÜÖãÔàÖÓãÔàÖÃãÓãÓÎßÜÝÓÃÞÕÖÃÓÔßÎÖÃ

"""

attributes = """
3333333333333333
3333333333333333
3333333333333333
3333322222233333
3333322222233333
2200322222233333
2200322222233333
2200322222233333
2200322222233333
2200322222233333
2200322222233333
2200322222233333
2200322222233333
3333333333333333
3333333333333333
0000000000000000"""

lengths = [32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32,
 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32, 32]  # fmt: skip

starting_addresses = [(32, 0), (32, 32), (32, 64), (32, 96), (32, 128), (32, 160), (32, 192),
 (32, 224), (33, 0), (33, 32), (33, 64), (33, 96), (33, 128), (33, 160),
 (33, 192), (33, 224), (34, 0), (34, 32), (34, 64), (34, 96), (34, 128),
 (34, 160), (34, 192), (34, 224), (35, 0), (35, 32), (35, 64), (35, 96),
 (35, 128), (35, 160), (35, 192), (35, 224)]  # fmt: skip


if __name__ == "__main__":
    try:
        nametable_builder.build_nametable(
            output,
            table,
            attributes,
            characters,
            original_sha1sum,
            lengths,
            starting_addresses,
        )
    except Exception as exc:
        print(
            f"Unable to build nametable: {type(exc).__name__}: {exc!s}", file=sys.stderr
        )
        sys.exit(1)
