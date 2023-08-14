from itertools import count
import re

addressing_modes = (
    (0, re.compile(r"^([a-z]{3})$", flags=re.I).match),
    (1, re.compile(r"^([a-z]{3}) #\$[a-f0-9]{2}$", flags=re.I).match),
    (2, re.compile(r"^([a-z]{3}) \$[a-f0-9]{2}$", flags=re.I).match),
    (3, re.compile(r"^([a-z]{3}) \$[a-f0-9]{2},x$", flags=re.I).match),
    (4, re.compile(r"^([a-z]{3})\(\$[a-f0-9]{2}\),y$", flags=re.I).match),
    (5, re.compile(r"^([a-z]{3})\(\$[a-f0-9]{2},x\)$", flags=re.I).match),
    (6, re.compile(r"^([a-z]{3}) \$[a-f0-9]{2},y$", flags=re.I).match),
)

table = (
    ("0x69", "adc #$42"),
    ("0x65", "adc $42"),
    ("0x75", "adc $42,x"),
    ("0x71", "adc($42),y"),
    ("0x61", "adc($42,x)"),
    ("0x29", "and #$42"),
    ("0x25", "and $42"),
    ("0x35", "and $42,x"),
    ("0x31", "and($42),y"),
    ("0x21", "and($42,x)"),
    ("0x0a", "asl"),
    ("0x06", "asl $42"),
    ("0x16", "asl $42,x"),
    ("0x24", "bit $42"),
    ("0x18", "clc"),
    ("0xb8", "clv"),
    ("0xc9", "cmp #$42"),
    ("0xc5", "cmp $42"),
    ("0xd5", "cmp $42,x"),
    ("0xd1", "cmp($42),y"),
    ("0xc1", "cmp($42,x)"),
    ("0xe0", "cpx #$42"),
    ("0xe4", "cpx $42"),
    ("0xc0", "cpy #$42"),
    ("0xc4", "cpy $42"),
    ("0xc6", "dec $42"),
    ("0xd6", "dec $42,x"),
    ("0xca", "dex"),
    ("0x88", "dey"),
    ("0x49", "eor #$42"),
    ("0x45", "eor $42"),
    ("0x55", "eor $42,x"),
    ("0x51", "eor($42),y"),
    ("0x41", "eor($42,x)"),
    ("0xe6", "inc $42"),
    ("0xf6", "inc $42,x"),
    ("0xe8", "inx"),
    ("0xc8", "iny"),
    ("0xa9", "lda #$42"),
    ("0xa5", "lda $42"),
    ("0xb5", "lda $42,x"),
    ("0xb1", "lda($42),y"),
    ("0xa1", "lda($42,x)"),
    ("0xa2", "ldx #$42"),
    ("0xa6", "ldx $42"),
    ("0xb6", "ldx $42,y"),
    ("0xa0", "ldy #$42"),
    ("0xa4", "ldy $42"),
    ("0xb4", "ldy $42,x"),
    ("0x4a", "lsr"),
    ("0x46", "lsr $42"),
    ("0x56", "lsr $42,x"),
    ("0xea", "nop"),
    ("0x09", "ora #$42"),
    ("0x05", "ora $42"),
    ("0x15", "ora $42,x"),
    ("0x11", "ora($42),y"),
    ("0x01", "ora($42,x)"),
    ("0x2a", "rol"),
    ("0x26", "rol $42"),
    ("0x36", "rol $42,x"),
    ("0x6a", "ror"),
    ("0x66", "ror $42"),
    ("0x76", "ror $42,x"),
    ("0xe9", "sbc #$42"),
    ("0xe5", "sbc $42"),
    ("0xf5", "sbc $42,x"),
    ("0xf1", "sbc($42),y"),
    ("0xe1", "sbc($42,x)"),
    ("0x38", "sec"),
    ("0x85", "sta $42"),
    ("0x95", "sta $42,x"),
    ("0x91", "sta($42),y"),
    ("0x81", "sta($42,x)"),
    ("0x86", "stx $42"),
    ("0x96", "stx $42,y"),
    ("0x84", "sty $42"),
    ("0x94", "sty $42,x"),
    ("0xaa", "tax"),
    ("0xa8", "tay"),
    ("0xba", "tsx"),
    ("0x8a", "txa"),
    ("0x98", "tya"),
)

sorted_table = sorted(table, key=lambda x: x[1])

counter = iter(count())

spawn_indexes = []

expanded_table = []
groups = {}
last = None
sub_index = 0
for opcode, description in sorted_table:
    index = next(counter)
    for mode_index, pattern in addressing_modes:
        if result := pattern(description):
            instruction = result.group(1)
            break
    else:
        raise Exception(f"{opcode}, {description} does not fit into addressing pattern")
    if instruction != last:
        spawn_indexes.append((index, description))
        sub_index = 0
        last = instruction
    groups.setdefault(instruction, []).append(index)
    expanded_table.append(
        (index, mode_index, eval(opcode), instruction, sub_index, description)
    )
    sub_index += 1
    # print(f"{eval(opcode):<5}{str(description):<12}{str(mode):<5}{instruction}")


instruction_indexes = {instruction: index for index, instruction in enumerate(groups)}


# >>> {i: (index,description.split()[0],5) for i,(index,description) in enumerate(spawn_indexes)}

spawn_weights = {
    0: (0, "adc", 15),
    1: (5, "and", 10),
    2: (10, "asl", 5),
    3: (13, "bit", 2),
    4: (14, "clc", 10),
    5: (15, "clv", 1),
    6: (16, "cmp", 3),
    7: (21, "cpx", 3),
    8: (23, "cpy", 3),
    9: (25, "dec", 10),
    10: (27, "dex", 10),
    11: (28, "dey", 10),
    12: (29, "eor", 5),
    13: (34, "inc", 5),
    14: (36, "inx", 5),
    15: (37, "iny", 5),
    16: (38, "lda", 15),
    17: (43, "ldx", 15),
    18: (46, "ldy", 15),
    19: (49, "lsr", 5),
    20: (52, "nop", 1),
    21: (53, "ora", 5),
    22: (58, "rol", 5),
    23: (61, "ror", 5),
    24: (64, "sbc", 15),
    25: (69, "sec", 5),
    26: (70, "sta", 5),
    27: (74, "stx", 15),
    28: (76, "sty", 15),
    29: (78, "tax", 15),
    30: (79, "tay", 5),
    31: (80, "tsx", 3),
    32: (81, "txa", 5),
    33: (82, "tya", 5),
}

import sys
validation = sum(repeats for id,instruction,repeats in spawn_weights.values())
if validation != 256:
    sys.exit(f"Piece ID repeats must add up to 256.  This adds up to {validation}")

weight_list = [repeats for id,instruction,repeats in spawn_weights.values()]

table = []
current_total = 0
for weight in weight_list:
    current_total+=weight
    table.append(current_total)

table.pop()


from pprint import pp

groups_shifted_up = {k: [v[-1]] + v[:-1] for k, v in groups.items()}
groups_shifted_down = {k: v[1:] + [v[0]] for k, v in groups.items()}

pp(expanded_table)
pp(instruction_indexes)
pp(groups_shifted_up)
pp(groups_shifted_down)


def signed(num):
    if num >= 0 and num < 128:
        return num
    elif num >= -128:
        return 256 + num
    raise Exception(f"{num} out of range")


signed_table = {i: signed(i) for i in range(-8, 8)}

signed_table = {
    -8: 248,
    -7: 249,
    -6: 250,
    -5: 251,
    -4: 252,
    -3: 253,
    -2: 254,
    -1: 255,
    0: 0,
    1: 1,
    2: 2,
    3: 3,
    4: 4,
    5: 5,
    6: 6,
    7: 7,
}


compressed_rotation = []
for index, addressing, opcode, instruction, sub_index, description in expanded_table:
    previous = groups_shifted_up[instruction][sub_index]
    next_ = groups_shifted_down[instruction][sub_index]

    prev_diff = (index - previous) * -1
    next_diff = (index - next_) * -1

    prev_signed_shifted = (signed(prev_diff) << 4) & 0xF0
    next_signed_masked = signed(next_diff) & 0x0F

    compressed = prev_signed_shifted | next_signed_masked

    compressed_rotation.append(compressed)
    # print(f'{index:<4}{prev_diff:<4}{next_diff:<4}{compressed:08b}')


with open("./src/hacks/twotris_tables.asm", "w+") as file:
    print(f"twotrisOpcodeTable:", file=file)
    for (
        index,
        addressing,
        opcode,
        instruction,
        sub_index,
        description,
    ) in expanded_table:
        print(f"    .byte ${opcode:02x} ; {description}", file=file)
    print("\n", file=file)

    print("twotrisInstructionWeightTable:", file=file)
    for i in range(0,len(spawn_weights),8):
        print("    .byte  " + ",".join(f"${j:02x}" for j in table[i:i+8]), file=file)
    print("\n", file=file)



    print(f"twotrisAddressingTable:", file=file)
    for (
        index,
        addressing,
        opcode,
        instruction,
        sub_index,
        description,
    ) in expanded_table:
        print(f"    .byte ${addressing:02x} ; {description}", file=file)
    print("\n", file=file)

    print(f"twotrisInstructionGroups:", file=file)
    for (
        index,
        addressing,
        opcode,
        instruction,
        sub_index,
        description,
    ) in expanded_table:
        print(
            f"    .byte ${instruction_indexes[instruction]:02x} ; {description}",
            file=file,
        )
    print("\n", file=file)

    print(f"CompressedRotation:", file=file)
    for (
        index,
        addressing,
        opcode,
        instruction,
        sub_index,
        description,
    ) in expanded_table:
        print(f"    .byte ${compressed_rotation[index]:02x} ; {description}", file=file)
    print("\n", file=file)

    print(f"spawnInstructions:", file=file)
    for index, description in spawn_indexes:
        print(f"    .byte ${index:02x} ; {description}", file=file)
    print("\n", file=file)

    print(f"fourBitTo8Bit:", file=file)
    print(
        "    .byte   ",
        ",".join(f"${v:02x}" for v in sorted(signed_table.values())),
        file=file,
    )
    print("\n", file=file)

    print(f"twotrisInstructionStrings:", file=file)
    for instruction in groups:
        chars = ",".join(f'${ord(c)-55:02x}' for c in instruction.upper())
        print(f'    .byte {chars} ; {instruction}', file=file)
    print("\n", file=file)


    # This is how much room we have left
    print("padding:", file=file)
    for _ in range(784):
        print("    .byte $00", file=file)
    print("\n", file=file)

