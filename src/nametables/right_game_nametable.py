import pathlib
import sys
import nametable_builder

from game_nametable import (
    table,
    attributes,
    characters,
    original_sha1sum,
)

file = pathlib.Path(__file__)
output = file.parent / file.name.replace(".py", ".bin")

starting_addresses = [(32, 96)]  # fmt: skip
lengths = [32]
table = """NEXT_____TOP_000000_LINES_000_A_"""
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
