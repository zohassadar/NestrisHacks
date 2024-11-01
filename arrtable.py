import pprint
import re

table = """
orientationTable:
        .byte   $00,$7B,$FF,$00,$7B,$00,$00,$7B
        .byte   $01,$FF,$7B,$00,$FF,$7B,$00,$00
        .byte   $7B,$00,$00,$7B,$01,$01,$7B,$00
        .byte   $00,$7B,$FF,$00,$7B,$00,$00,$7B
        .byte   $01,$01,$7B,$00,$FF,$7B,$00,$00
        .byte   $7B,$FF,$00,$7B,$00,$01,$7B,$00
        .byte   $FF,$7D,$00,$00,$7D,$00,$01,$7D
        .byte   $FF,$01,$7D,$00,$FF,$7D,$FF,$00
        .byte   $7D,$FF,$00,$7D,$00,$00,$7D,$01
        .byte   $FF,$7D,$00,$FF,$7D,$01,$00,$7D
        .byte   $00,$01,$7D,$00,$00,$7D,$FF,$00
        .byte   $7D,$00,$00,$7D,$01,$01,$7D,$01
        .byte   $00,$7C,$FF,$00,$7C,$00,$01,$7C
        .byte   $00,$01,$7C,$01,$FF,$7C,$01,$00
        .byte   $7C,$00,$00,$7C,$01,$01,$7C,$00
        .byte   $00,$7B,$FF,$00,$7B,$00,$01,$7B
        .byte   $FF,$01,$7B,$00,$00,$7D,$00,$00
        .byte   $7D,$01,$01,$7D,$FF,$01,$7D,$00
        .byte   $FF,$7D,$00,$00,$7D,$00,$00,$7D
        .byte   $01,$01,$7D,$01,$FF,$7C,$00,$00
        .byte   $7C,$00,$01,$7C,$00,$01,$7C,$01
        .byte   $00,$7C,$FF,$00,$7C,$00,$00,$7C
        .byte   $01,$01,$7C,$FF,$FF,$7C,$FF,$FF
        .byte   $7C,$00,$00,$7C,$00,$01,$7C,$00
        .byte   $FF,$7C,$01,$00,$7C,$FF,$00,$7C
        .byte   $00,$00,$7C,$01,$FE,$7B,$00,$FF
        .byte   $7B,$00,$00,$7B,$00,$01,$7B,$00
        .byte   $00,$7B,$FE,$00,$7B,$FF,$00,$7B
        .byte   $00,$00,$7B,$01,$00,$FF,$00,$00
        .byte   $FF,$00,$00,$FF,$00,$00,$FF,$00
        """

numbers = [
    -(256 - int(n, 16)) if int(n, 16) > 127 else int(n, 16)
    for n in re.findall(r"\$(..)", table)
]

coordinates = []

for i in range(0, len(numbers) - 12, 12):
    orientation = []
    for j in range(0, 12, 3):
        orientation.append((numbers[i + j], numbers[i + j + 2]))
    coordinates.append(orientation)

big_coords = []
sorted_by_y = [{} for _ in range(len(coordinates))]
for index, orientation in enumerate(coordinates):
    bigs = []
    for y1, x1 in orientation:
        for y2, x2 in coordinates[10]: # O piece
            y3 = y1*2 + y2
            x3 = x1*2 + x2
            bigs.append((y3,x3))
            sorted_by_y[index].setdefault(y3, []).append(x3)
    big_coords.append(bigs)

x_left = [[0 for _ in range(8)] for _ in range(len(coordinates))]
y_left = [[0 for _ in range(8)] for _ in range(len(coordinates))]
x_right = [[0 for _ in range(8)] for _ in range(len(coordinates))]
y_right = [[0 for _ in range(8)] for _ in range(len(coordinates))]

for index, orientation in enumerate(sorted_by_y):
    for idx8, y in enumerate(sorted(orientation.keys())):
        x_left[index][idx8] = min(orientation[y])
        y_left[index][idx8] = y
        x_right[index][idx8] = max(orientation[y])
        y_right[index][idx8] = y


print(f"zeroArrYLeft:")
for chunk in y_left:
    out = [f"{i:>2}" for i in chunk]
    print(f"    .byte {', '.join(out)}")

print(f"zeroArrXLeft:")
for chunk in x_left:
    out = [f"{i:>2}" for i in chunk]
    print(f"    .byte {', '.join(out)}")

print(f"zeroArrYRight:")
for chunk in y_right:
    out = [f"{i:>2}" for i in chunk]
    print(f"    .byte {', '.join(out)}")

print(f"zeroArrXRight:")
for chunk in x_right:
    out = [f"{i:>2}" for i in chunk]
    print(f"    .byte {', '.join(out)}")
