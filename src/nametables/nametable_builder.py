import argparse
import hashlib
import logging
import os
import pprint
import re
import sys
from collections import Counter

logger = logging.getLogger(__name__)
verbose=os.getenv("verbose")
logging.basicConfig(level=logging.DEBUG if verbose else logging.INFO)


BUILD_HEADER = '''
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

'''

BUILD_FOOTER = """
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
"""

FINDALL_NON_NEWLINES = re.compile(r"[^\n]").findall


class Args(argparse.Namespace):
    action: str
    output: str
    nametable: str
    characters: str
    skip_attrs: bool

def konami_compression(buffer: bytearray):
    """
    https://github.com/kirjavascript/TetrisGYM/blob/master/src/nametables/rle.js
    """
    buffer = bytearray(buffer)
    i = 0
    compressed = bytearray()
    while True:
        if i >= len(buffer):
            break
        num = buffer[i]
        for peek in range(1,min(0x81, (len(buffer) - i) + 1)):
            if (len(buffer) - (i + peek)) > 0 and num != buffer[i+peek]:
                break
        if peek - 1:
            compressed.extend([peek, num])
            i+=peek
            continue
        for peek in range(min(0x80, (len(buffer) - i) + 1)):
            if (len(buffer) - (i + peek)) > 0 and buffer[i+peek] == buffer[i+peek+1]:
                break
        compressed.extend([0x80+peek])
        compressed.extend(buffer[i:i+peek])
        i+=peek
    compressed.append(0xff)
    return compressed


def extract_bytes_from_nametable(
    nametable_filename: str,
) -> tuple[list[tuple[int, int]], list[int], list[int], str]:
    """
    Read nametable and return a list of starting addresses as tuples, a list of lengths, and another list of the raw data
    """
    start_addresses = []
    lengths = []
    data = []
    nametable = open(nametable_filename, "rb").read()
    logger.debug(f"Original file length is {len(nametable)}")
    original_sha1sum = hashlib.sha1(nametable).hexdigest()
    logger.debug(f"Original sha1sum is {original_sha1sum}")

    with open(nametable_filename, "rb") as file:
        while True:
            chunk = file.read(3)
            if not chunk or chunk == b"\xff":
                break
            logging.debug(f"chunk: {chunk!r}")
            start_address = tuple(chunk[0:2])
            start_addresses.append(start_address)
            length = chunk[2]
            lengths.append(length)
            data.extend(list(file.read(length)))
    logger.debug(f"Read {len(start_addresses)} starting addresses")
    logger.debug(f"Read {len(lengths)} lengths")
    logger.debug(f"Read {len(data)} data")
    return (
        start_addresses,
        lengths,
        data,
        original_sha1sum,
    )


def validate_attribute_length(attributes: list[int]):
    attribute_len = len(attributes)
    if attribute_len != 64:
        print(
            f"Expected length of attribute table is 64 bytes.  Received {attribute_len}",
            file=sys.stderr,
        )
        sys.exit(1)


def break_out_attribute_table(attributes: list[int]) -> list[str]:
    validate_attribute_length(attributes)
    results = []
    for row_index in range(0, 57, 8):
        line1 = ""
        line2 = ""
        for byte in attributes[row_index : row_index + 8]:
            top_left = byte & 0b00000011
            top_right = (byte & 0b00001100) >> 2
            bottom_left = (byte & 0b00110000) >> 4
            bottom_right = (byte & 0b11000000) >> 6
            line1 += f"{top_left}{top_right}"
            line2 += f"{bottom_left}{bottom_right}"
        results.append(line1)
        results.append(line2)
    return results


def restore_attribute_table(attr_table):
    attributes = re.findall("[0123]", attr_table)
    if not attributes:
        return []

    attrs = []
    for row in range(0, len(attributes), 32):
        data = attributes[row : row + 32]
        line1 = data[:16]
        line2 = data[16:]
        for i in range(0, 16, 2):
            tl = int(line1[i])
            tr = int(line1[i + 1]) << 2
            bl = int(line2[i]) << 4
            br = int(line2[i + 1]) << 6
            byte = br | bl | tr | tl
            attrs.append(byte)
    validate_attribute_length(attrs)
    return attrs


def format_characters(characters_raw: str):
    output = []
    output.append("characters = (")
    output.append("    #0123456789ABCDEF")
    for i, line in enumerate(characters_raw.splitlines()):
        index = f"#{i:x}".upper()
        output.append(f'    "{line}" {index}')
    output.append(")  # fmt: skip")
    return "\n".join(output)


def break_nametable(args: Args):
    characters_raw = open(args.characters).read()

    logger.debug(f"Opening characters file {args.characters}")
    logger.debug(f"characters is {len(characters_raw)} characters long")
    characters = FINDALL_NON_NEWLINES(characters_raw)
    validate_characters(characters)
    logger.debug(f"characters length is {len(characters)}")

    starting_addresses, lengths, data, original_sha1sum = extract_bytes_from_nametable(
        args.nametable
    )

    attributes_output = []
    if not args.skip_attrs:
        attributes_raw = data[-64:]
        attributes_output = break_out_attribute_table(attributes_raw)
        data = data[:-64]

    nametable_output = []
    for length in lengths:
        row = data[:length]
        data = data[length:]
        text_row = "".join(characters[byte] for byte in row)
        nametable_output.append(text_row)

    with open(args.output or args.nametable.replace(".bin", ".py"), "w+") as file:
        print(BUILD_HEADER, file=file)

        print(f'original_sha1sum = "{original_sha1sum}"\n', file=file)

        print(format_characters(characters_raw), end="\n\n", file=file)

        print(f'table = """', file=file)
        print("\n".join(nametable_output), end='"""\n\n', file=file)

        print(f'attributes = """', file=file)
        print("\n".join(attributes_output), end='"""\n\n', file=file)

        print(
            f"lengths = {pprint.pformat(lengths, compact=True)}  # fmt: skip\n",
            file=file,
        )

        print(
            f"starting_addresses = {pprint.pformat(starting_addresses, compact=True)}  # fmt: skip\n",
            file=file,
        )

        print(BUILD_FOOTER, file=file)


def get_reverse_index(
    characters: str,
) -> dict[str, int]:
    index = FINDALL_NON_NEWLINES(characters)
    return {c: i for i, c in enumerate(index)}


def validate_characters(characters: list[str]):
    characters_len = len(characters)
    if characters_len != 256:
        print(
            f"Characters text needs 256 characters.  Received {characters_len}",
            file=sys.stderr,
        )
        sys.exit(1)
    unique_characters_len = len(set(characters))
    if unique_characters_len != 256:
        count = Counter(characters)
        duplicates = [k for k, v in count.items() if v > 1]
        print(
            f"Characters text needs 256 unique character.  Duplicates: {duplicates!r}",
            file=sys.stderr,
        )
        sys.exit(1)


def build_nametable(
    output: str,
    table: str,
    attributes: str,
    characters: str,
    original_sha1sum: str,
    lengths: list[int],
    starting_addresses: list[tuple[int, int]],
    compress: bool = True,
) -> None:
    validate_characters(characters)
    logger.debug(f"Read {len(lengths)} lengths")
    logger.debug(f"Read {len(starting_addresses)} starting addresses")

    attribute_bytes = restore_attribute_table(attributes)
    logger.debug(f"Read {len(attribute_bytes)} bytes from attributes")

    table_chars = re.findall(r"[^\n]", table)
    reverse_index = get_reverse_index(characters)
    table_bytes = [reverse_index[t] for t in table_chars]
    logger.debug(f"Read {len(table_bytes)} bytes from table")

    table_bytes.extend(attribute_bytes)
    logger.debug(f"Read {len(table_bytes)} bytes total")

    output_bytes = []
    for length, starting_address in zip(lengths, starting_addresses):
        if not compress:
            output_bytes.extend(starting_address)
            output_bytes.append(length)
        output_bytes.extend(table_bytes[:length])
        table_bytes = table_bytes[length:]
    if not compress:
        output_bytes.append(255)
    else:
        output_bytes = konami_compression(output_bytes)

    output_data = bytes(output_bytes)
    sha1sum = hashlib.sha1(output_data).hexdigest()
    if sha1sum != original_sha1sum:
        logger.warning(f"Warning! {sha1sum} does not match original {original_sha1sum}")
    else:
        logger.debug(f"Original nametable being rebuilt")
    with open(output, "wb") as file:
        file.write(output_data)


def get_args():
    parser = argparse.ArgumentParser()
    subparsers = parser.add_subparsers(required=True, dest="action")

    break_parser = subparsers.add_parser(
        "break",
        help="Break a nametable into a .py file",
    )

    break_parser.add_argument(
        "nametable",
        help="Filename of nametable",
    )

    break_parser.add_argument(
        "characters",
        type=str,
        help="Text file that contains 256 unique characters (newlines ignored)",
    )

    break_parser.add_argument(
        "--output",
        type=str,
        help="Output .py file.  Will be the same as input but with extension changed if not specified",
    )

    break_parser.add_argument(
        "--skip-attrs",
        action="store_true",
        help="Do not break out the last 64 bytes as attr table",
    )

    namespace = Args()
    return parser.parse_args(namespace=namespace)


def main():
    actions = {
        "break": break_nametable,
    }
    args = get_args()
    actions[args.action](args)


if __name__ == "__main__":
    main()
