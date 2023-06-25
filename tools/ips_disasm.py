import sys
import os
import pathlib

DISASM_DIR = "ips"
pathlib.Path(DISASM_DIR).mkdir(exist_ok=True)

INFO_FILE = "temp_ips.info"
RAW_FILE = "temp_ips.output"

INFO_FILE_PATH = pathlib.Path(DISASM_DIR) / INFO_FILE
RAW_FILE_PATH = pathlib.Path(DISASM_DIR) / RAW_FILE

infofile_template = """
GLOBAL {{ 
  COMMENTS $4;   
  STARTADDR ${};   
  LABELBREAK $1;
  }};

"""

try:
    file = sys.argv[1]
except IndexError:
    sys.exit("Specify file")

if not file.endswith(".ips"):
    sys.exit(f"{file} is not .ips")

output = pathlib.Path(DISASM_DIR) / f"{file.replace('.ips', '')}.asm"
if output.exists():
    output.unlink()

patch = open(file, "rb").read()
header, patch = patch[:5], patch[5:]
if header != b"PATCH":
    sys.exit(f"{file} doesn't look like a patch")

results = []

while True:
    if patch == b"EOF" or not patch:
        break
    offsetb, sizeb, patch = patch[:3], patch[3:5], patch[5:]
    offset = int.from_bytes(offsetb, byteorder="big") - 16 + 0x8000
    size = int.from_bytes(sizeb, byteorder="big")
    if not size:
        length, value, patch = patch[:2], patch[2:3], patch[3:]
        length = int.from_bytes(length, byteorder="big")
        data = value * length
    else:
        data, patch = patch[:size], patch[size:]
    
    with open(INFO_FILE_PATH, "w+") as file:
        file.write(infofile_template.format(f"{offset:04x}"))
        
    os.system(f'tail +28 tetris.info | grep -Ev "TYPE (ADDRTABLE|BYTETABLE|DBYTETABLE|WORDTABLE)" >> {INFO_FILE_PATH}')

    with open(RAW_FILE_PATH, "wb") as file:
        file.write(data)

    os.system(f'da65 --info {INFO_FILE_PATH} {RAW_FILE_PATH} | tail +7 | grep -v ":= \$...." >> {output}')
    os.system(f'echo "" >> {output}')
    os.system(f'echo "" >> {output}')


if INFO_FILE_PATH.exists():
    INFO_FILE_PATH.unlink()

if RAW_FILE_PATH.exists():
    RAW_FILE_PATH.unlink()