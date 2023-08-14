from itertools import count
import re

addressing_modes = (
    (0, re.compile(r"^([a-z]{3})$", flags=re.IGNORECASE).match),
    (1, re.compile(r"^([a-z]{3}) #\$[a-f0-9]{2}$", flags=re.IGNORECASE).match),
    (2, re.compile(r"^([a-z]{3}) \$[a-f0-9]{2}$", flags=re.IGNORECASE).match),
    (3, re.compile(r"^([a-z]{3}) \$[a-f0-9]{2},x$", flags=re.IGNORECASE).match),
    (4, re.compile(r"^([a-z]{3})\(\$[a-f0-9]{2}\),y$", flags=re.IGNORECASE).match),
    (5, re.compile(r"^([a-z]{3})\(\$[a-f0-9]{2},x\)$", flags=re.IGNORECASE).match),
    (6, re.compile(r"^([a-z]{3}) \$[a-f0-9]{2},y$", flags=re.IGNORECASE).match),
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
for (opcode, description) in sorted_table:
    index = next(counter)
    for mode_index, pattern in addressing_modes:
        if result := pattern(description):
            instruction=result.group(1)
            break
    else:
        raise Exception(f'{opcode}, {description} does not fit into addressing pattern')
    if instruction != last:
        spawn_indexes.append((index, description))
        sub_index = 0
        last = instruction
    groups.setdefault(instruction, []).append(index)
    expanded_table.append((index, mode_index, eval(opcode), instruction, sub_index, description))
    sub_index+=1
    # print(f"{eval(opcode):<5}{str(description):<12}{str(mode):<5}{instruction}")


instruction_indexes = {instruction: index for index, instruction in enumerate(groups)}


from pprint import pp

groups_shifted_up = {k: [v[-1]] + v[:-1] for k,v in groups.items()}
groups_shifted_down = {k: v[1:] + [v[0]] for k,v in groups.items()}

pp(expanded_table)
pp(instruction_indexes)
# pp(groups_shifted_up)
# pp(groups_shifted_down)



with open("./src/hacks/twotris_tables.asm", "w+") as file:
    print(f"twotrisOpcodeTable:", file=file)
    for index, addressing, opcode, instruction, sub_index, description in expanded_table:
        print(f"    .byte ${opcode:02x} ; {description}", file=file)
    print("\n", file=file)

    print(f"twotrisAddressingTable:", file=file)
    for index, addressing, opcode, instruction, sub_index, description in expanded_table:
        print(f"    .byte ${addressing:02x} ; {description}", file=file)
    print("\n", file=file)

    print(f"twotrisInstructionGroups:", file=file)
    for index, addressing, opcode, instruction, sub_index, description in expanded_table:
        print(f"    .byte ${instruction_indexes[instruction]:02x} ; {description}", file=file)
    print("\n", file=file)

    print(f"twotrisRotationPrevious:", file=file)
    for index, addressing, opcode, instruction, sub_index, description in expanded_table:
        print(f"    .byte ${groups_shifted_up[instruction][sub_index]:02x} ; {description}", file=file)
    print("\n", file=file)

    print(f"twotrisRotationNext:", file=file)
    for index, addressing, opcode, instruction, sub_index, description in expanded_table:
        print(f"    .byte ${groups_shifted_down[instruction][sub_index]:02x} ; {description}", file=file)
    print("\n", file=file)


    print(f"twotrisInstructionStrings:", file=file)
    for instruction in groups:
        print(f"    .byte \"{instruction}\"", file=file)
    print("\n", file=file)





