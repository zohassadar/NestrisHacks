
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

original_sha1sum = "081ed83e792c4c38c0ae0cc8854d135ac942363f"

characters = (
    #0123456789ABCDEF
    "0123456789SCOREL" #0
    "VHIGTA-UQPNMKJFB" #1
    "WXYZ◥,'>!♡abcdef" #2
    "ghijklmnopqrstuv" #3
    "wxyz#$%&◤()*+/:;" #4
    "<=?@[]^_`{|}~¹º»" #5
    "¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊË" #6
    "ÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛ" #7
    "ÜÝÞßàáâãäåæçèéêë" #8
    "ìíîïðñòóôõö÷øùúû" #9
    "üýþÿЉЊЋЌЍЎЏАБВГД" #A
    "ЕЖЗИЙКЛМНОПРСТУФ" #B
    "ХЦЧШЩЪЫЬЭЮЯабвгд" #C
    "εζηθικλμνξοπρςστ" #D
    "υφχψωϊϋόύώϏϐϑϒϓϔ" #E
    "ϕϖϗϘϙϚϛϜϝϞϟϠϡͰͱ." #F
)  # fmt: skip

table = """
ÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓ
ÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓ
ÒÓ............................ÒÓ
ÒÓ............................ÒÓ
ÒÓ.....SCORE..000000..........ÒÓ
ÒÓ............................ÒÓ
ÒÓ............................ÒÓ
ÒÓ............................ÒÓ
ÒÓ............................ÒÓ
ÒÓ............................ÒÓ
ÒÓ............................ÒÓ
ÒÓ............................ÒÓ
ÒÓ............................ÒÓ
ÒÓ............................ÒÓ
ÒÓ..............¼½¾...........ÒÓ
ÒÓ..............ÌÍÎ...........ÒÓ
ÒÓ............................ÒÓ
ÒÓ............................ÒÓ
ÒÓ..ÜÞ..................o.....ÒÓ
ÒÓ...................p.rs.u...ÒÓ
ÒÓ..................◤()*+/:;..ÒÓ
ÒÓ.....ГГ...........`{|}~¹º»..ÒÓ
ÒÓ....дσУϔ..ДД......ÄÅÆÇÈÉÊË..ÒÓ
ÒÓвввввУг...ττ......ÔÕÖ×ØÙÚÛ..ÒÓ
ÒÓ.ςбввгσ...ττ......äåæçèéêë..ÒÓ
ÒÓввρςϑϒϒϒϒϒϒϒϓ.....ôõö÷øùúû..ÒÓ
ÒÓâãâãâãâãâãâãâãâãâãâãâãâãâãâãÒÓ
ÒÓòóòóòóòóòóòóòóòóòóòóòóòóòóòóÒÓ
ÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓ
ÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓÒÓ

"""

attributes = """
2222222222222222
2211111111112222
2211111111110002
2211111111110002
2011101111110002
2011101111110002
2010002220000002
2010000011000002
2000000000000002
2012200000003002
2222222200333002
2222212200333302
2222222200000002
2000000000000002
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

