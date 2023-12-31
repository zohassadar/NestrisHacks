
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


original_sha1sum = "c7285a27cf683130dc1aeef2e2594daac5b79fd4"

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
¾ìÏÜxß¾ÎÜ½ÜíÜzÏ¾ÜÝÝßìÝß¾¾ÜÝ½Ü½ìÏ
ÎÎ¾¼½ìýÞ¾Î¾üßÞÜxß¾Ü½ÞÜÝýÎ¼½Þ¾ÎÎ¾
ÎÞÎÌÍÞÜÝýÞüÝßÜÝÝßüíÎÜzÏÜýÌÍìýÞÞÎ
Þ¾Îghhhhhhhhhhhhi¾ÞÞ¾Þ¼½¾¼½ÞÜíÜý
ÜyÞj_GAME__TYPE_küÝßüíÌÍÎÌÍìÏüß¾
¾Þ¾lmmmmmmmmmmmmnìÏÜíÞ¾Üý¼½Î¼½Üy
wÏüÝßÜzÏÜÝÝßÜÝÝßÜýìÏüßüÝßÌÍÞÌÍ¾Þ
ÞìÏìÏ¾Þ╔╧╧╧╧╧╧╧╧╗¾Î╔╧╧╧╧╧╧╧╧╗ìý¾
ÜýÜýÜxß╣_A-TYPE_╠ÎÞ╣_B-TYPE_╠ÞÜy
ìÏ¾ÜÝ½¾╚╤╤╤╤╤╤╤╤╝üÏ╚╤╤╤╤╤╤╤╤╝ìÏÞ
ÎÜxß¾Þüí¼½¼½¾ÜÝ½¼½ÜÝÝß¾Ü½ìÝßÜýÜ½
ÞìÝßüÝßÞÌÍÌÍüÝßÞÌÍ¾ÜÝ½üíÎÞ¾ÜÝÝßÎ
¾Þ¾ghhhhhhhhhhhhiÜxß¾Þ¾ÞÞÜyìÏÜíÞ
ÎÜyj_MUSIC_TYPE_kÜzÏüíÎÜÝ½ÞÎìÏüß
üÏÞlmmmmmmmmmmmmn¾ÞÜíÞÎ¼½Þ¾ÞÎÜÝ½
¼½¾ÜÝ½ÜzÏÜÝÝßÜÝÝßüÝßüßÞÌÍÜxßÞÜíÞ
ÌÍüÝßÞ¾ÞÜÝ½¾┌━━━━━━━━━━┐ÜÝÝß¼½üß
Ýß¼½¾¾üÝß¾ÞÎ┇__________╏ÜÝÝßÌÍÜÝ
½¾ÌÍÎwÏìÏwÏÎ┇_MUSIC@[1_╏¾Ü½¼½ìÝß
Þüí¾ÎÞ¾Î¾Þ¾Þ┇__________╏üíÎÌÍÞ¾¾
Ï¾ÞÎÞìýÞwÏüí┇_MUSIC@[2_╏¾ÞÞ¾¼½Îü
ßwÏüÏÞ¼½Þ¼½Þ┇__________╏wÏÜyÌÍüÏ
½ÞÜÝÝßÌÍ¾ÌÍ¾┇_MUSIC@[3_╏ÞìÏÞ¾ÜÝ½
ÍìÝßÜÝ½ÜyÜÝý┇__________╏ÜýÜÝýìÏÞ
½ÞÜzÏ¾Þ¾ÞÜÝ½┇___OFF____╏ÜÝÝßÜý¼½
Þ¼½ÞìýÜxß¾¾Þ┇__________╏¼½¾¾Ü½ÌÍ
¾ÌÍ¾ÞìÝß¾ÎwÏ└╍╍╍╍╍╍╍╍╍╍┘ÌÍÎwÏÎÜÝ
Î¾ÜxßÞ¼½ÎÎÞ¾ÜÝÝß¾Ü½ìÝßìÏ¼½ÎÞ¾Þ¾¾
ÎüÝß¾¾ÌÍÎÞìý¾¼½ÜxßÎÞ¾Üý¾ÌÍÞÜyìýÎ
ÞÜÝ½ÎÎìÏÞ¾Þ¾ÎÌÍÜzÏÞÜxßÜxßÜÝ½ÞÞÜý

"""

attributes = """
2222222222222222
2000000002222222
2000000002222222
2221111112222222
2221111112222222
2111111110000002
2000000002222222
2000000002222222
2222220000002222
2222220000002222
2222220000002222
2222220000002222
2222220000002222
2222220000002222
2222222222222222
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

