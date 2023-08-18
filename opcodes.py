import logging
import pprint
import re
import sys

logger = logging.getLogger(__name__)
logging.basicConfig(level=logging.INFO)


# implied index, pattern
modes = (
    re.compile(r"^([a-z]{3})$", flags=re.I),
    re.compile(r"^([a-z]{3}) #\$[a-f0-9]{2}$", flags=re.I),
    re.compile(r"^([a-z]{3}) \$[a-f0-9]{2}$", flags=re.I),
    re.compile(r"^([a-z]{3}) \$[a-f0-9]{2},x$", flags=re.I),
    re.compile(r"^([a-z]{3})\(\$[a-f0-9]{2}\),y$", flags=re.I),
    re.compile(r"^([a-z]{3})\(\$[a-f0-9]{2},x\)$", flags=re.I),
    re.compile(r"^([a-z]{3}) \$[a-f0-9]{2},y$", flags=re.I),
)
indexed_modes = [(i, pattern) for i, pattern in enumerate(modes)]


instructions = (
    (15, re.compile(r"^adc$")),
    (15, re.compile(r"^and$")),
    (15, re.compile(r"^(?:as|ro)l$")),
    (2, re.compile(r"^bit$")),
    (4, re.compile(r"^(cl[cv]|sec)$")),
    (4, re.compile(r"^cp[xy]$")),
    (4, re.compile(r"^cmp$")),
    (25, re.compile(r"^de[cxy]$")),
    (15, re.compile(r"^eor$")),
    (25, re.compile(r"^in[cxy]$")),
    (15, re.compile(r"^lda$")),
    (15, re.compile(r"^ld[xy]$")),
    (15, re.compile(r"^(?:ls|ro)r$")),
    (2, re.compile(r"^nop$")),
    (15, re.compile(r"^ora$")),
    (15, re.compile(r"^sbc$")),
    (15, re.compile(r"^sta$")),
    (15, re.compile(r"^st[xy]$")),
    (25, re.compile(r"^t[saxy][axy]$")),
)


indexed_instructions = [
    (i, weight, pattern) for i, (weight, pattern) in enumerate(instructions)
]


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

table_with_groups = []

for opcode, syntax in table:
    logger.debug(f"evaluating {opcode=} {syntax=}")
    for mode_index, pattern in indexed_modes:
        if result := pattern.match(syntax):
            instruction = result.group(1)
            break
    else:
        raise Exception(
            f"{opcode}, {syntax} does not match any addressing mode pattern"
        )

    group_found = False
    for group_index, weight, pattern in indexed_instructions:
        logger.debug(
            f"testing {instruction!r} against {pattern!r}.  {pattern.match(instruction)=}"
        )
        if result := pattern.match(instruction):
            logger.debug(f"{result=}")
            group_found = True
            logger.debug(f"{group_found=}")
            break
    if not group_found:
        raise Exception(f"{opcode}, {instruction} does not match any grouping pattern")

    table_with_groups.append(
        (
            opcode,
            syntax,
            mode_index,
            instruction,
            group_index,
        )
    )


# sort by group_index
sorted_table = sorted(table_with_groups, key=lambda x: x[4])
logger.debug(pprint.pformat(sorted_table))


# create a set with instructions, sort, add index
instruction_groups = {
    instruction: i
    for i, instruction in enumerate(sorted({t[3] for t in table_with_groups}))
}
logger.debug(pprint.pformat(instruction_groups))


spawn_indexes = []
expanded_table = []

rotation_groups = {}

last = None
sub_index = 0
for index,(
    opcode,
    syntax,
    mode_index,
    instruction,
    group_index,
) in enumerate(sorted_table):
    opcode = eval(opcode)
    instruction_group = instruction_groups[instruction]
    if group_index != last:
        spawn_indexes.append((index, instruction))
        sub_index = 0
        last = group_index
    rotation_groups.setdefault(group_index, []).append(index)
    expanded_table.append(
        (
            index,
            opcode,
            syntax,
            mode_index,
            instruction,
            group_index,
            instruction_group,
            sub_index,
        )
    )
    sub_index += 1
    # logger.debug(f"{opcode:<5}{str(syntax):<12}{mode_index:<5}{syntax}")


GROUP_LIMIT = 7
for rotation_group in rotation_groups.values():
    if (rot_group_len := len(rotation_group)) > GROUP_LIMIT:
        sys.exit (f"{rot_group_len} exceeds limit of {GROUP_LIMIT}")


validation = sum(weight for group_index, weight, pattern in indexed_instructions)
if validation != 256:
    sys.exit(f"Piece ID repeats must add up to 256.  This adds up to {validation}")

weight_list = [weight for group_index, weight, pattern in indexed_instructions]

weight_table = []
current_total = 0
for weight in weight_list:
    current_total += weight
    weight_table.append(current_total)

weight_table.pop()

groups_shifted_up = {k: [v[-1]] + v[:-1] for k, v in rotation_groups.items()}
groups_shifted_down = {k: v[1:] + [v[0]] for k, v in rotation_groups.items()}

# pprint.pprint(expanded_table)
# pprint.pprint(groups_shifted_up)
# pprint.pprint(groups_shifted_down)


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


extra_tables = """
        ; $80 - instruction
        ; $81 - value
        ; $82 - null
renderChars:
        .byte $80,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$82,$82  ; INS
        .byte $80,$FF,$FA,$F9,$81,$FF,$FF,$82,$82,$82  ; INS #$00
        .byte $80,$FF,$F9,$81,$FF,$FF,$FF,$82,$82,$82  ; INS $00
        .byte $80,$FF,$F9,$81,$25,$21,$FF,$82,$82,$82  ; INS $00,x
        .byte $80,$F7,$F9,$81,$F8,$25,$22,$82,$82,$82  ; INS($00),y
        .byte $80,$F7,$F9,$81,$25,$21,$F8,$82,$82,$82  ; INS($00,x)
        .byte $80,$FF,$F9,$81,$25,$22,$FF,$82,$82,$82  ; INS $00,y
        .byte $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF  ; blank


boardInitializeData:
        .byte   $21,$86,$03,$0A,$00,$00;A in T spot
        .byte   $21,$C6,$03,$21,$00,$00;X in J spot
        .byte   $22,$06,$03,$22,$00,$00;Y in Z spot
        .byte   $22,$46,$03,$17,$FF,$00;N in O spot
        .byte   $22,$86,$03,$1F,$FF,$00;V in S spot
        .byte   $22,$C6,$03,$23,$FF,$00;Z in L spot
        .byte   $23,$06,$03,$0C,$FF,$00;C in I spot
        .byte   $FE             ; end

        
"""


compressed_rotation = []
for (
    index,
    opcode,
    syntax,
    mode_index,
    instruction,
    group_index,
    instruction_group,
    sub_index,
) in expanded_table:
    previous = groups_shifted_up[group_index][sub_index]
    next_ = groups_shifted_down[group_index][sub_index]

    prev_diff = (index - previous) * -1
    next_diff = (index - next_) * -1
    logger.debug(f'{prev_diff=} {next_diff=}')

    prev_signed_shifted = (signed(prev_diff) << 4) & 0xF0
    next_signed_masked = signed(next_diff) & 0x0F

    compressed = prev_signed_shifted | next_signed_masked

    compressed_rotation.append(compressed)
    # print(f'{index:<4}{prev_diff:<4}{next_diff:<4}{compressed:08b}')


with open("./src/hacks/twotris_tables.asm", "w+") as file:

    print(f"SPAWN_LENGTH := ${len(spawn_indexes)-2:02x}\n\n\n", file=file)

    print(f"twotrisOpcodeTable:", file=file)
    for (
        index,
        opcode,
        syntax,
        mode_index,
        instruction,
        group_index,
        instruction_group,
        sub_index,
    ) in expanded_table:
        print(f"    .byte ${opcode:02x} ; {syntax}", file=file)
    print("\n", file=file)

    print("twotrisInstructionWeightTable:", file=file)
    for i in range(0, len(weight_table), 8):
        print(
            "    .byte  " + ",".join(f"${j:02x}" for j in weight_table[i : i + 8]), file=file
        )
    print("\n", file=file)

    print(f"twotrisAddressingTable:", file=file)
    for (
        index,
        opcode,
        syntax,
        mode_index,
        instruction,
        group_index,
        instruction_group,
        sub_index,
    ) in expanded_table:
        print(f"    .byte ${mode_index:02x} ; {syntax}", file=file)
    print("\n", file=file)

    print(f"twotrisInstructionGroups:", file=file)
    for (
        index,
        opcode,
        syntax,
        mode_index,
        instruction,
        group_index,
        instruction_group,
        sub_index,
    ) in expanded_table:
        print(
            f"    .byte ${instruction_group:02x} ; {syntax}",
            file=file,
        )
    print("\n", file=file)

    print(f"CompressedRotation:", file=file)
    for (
        index,
        opcode,
        syntax,
        mode_index,
        instruction,
        group_index,
        instruction_group,
        sub_index,
    ) in expanded_table:
        print(f"    .byte ${compressed_rotation[index]:02x} ; {syntax}", file=file)
    print("\n", file=file)

    print(f"spawnInstructions:", file=file)
    for index, syntax in spawn_indexes:
        print(f"    .byte ${index:02x} ; {syntax}", file=file)
    print("\n", file=file)

    print(f"fourBitTo8Bit:", file=file)
    print(
        "    .byte   ",
        ",".join(f"${v:02x}" for v in sorted(signed_table.values())),
        file=file,
    )
    print("\n", file=file)

    print(f"twotrisInstructionStrings:", file=file)
    for instruction in instruction_groups:
        chars = ",".join(f"${ord(c)-55:02x}" for c in instruction.upper())
        print(f"    .byte {chars} ; {instruction}", file=file)
    print("\n", file=file)

    print(extra_tables, file=file)
    print("\n", file=file)

    # This is how much room we have left
    # print("padding:", file=file)
    # for _ in range(784):
    #     print("    .byte $00", file=file)
    # print("\n", file=file)
