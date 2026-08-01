#!/usr/bin/python3
import sys

if len(sys.argv) < 4:
    print('Usage: ' + sys.argv[0] + 'outputFile agesPalettes seasonsPalettes')
    sys.exit(1)

outputFile      = sys.argv[1]
agesPalettes    = sys.argv[2]
seasonsPalettes = sys.argv[3]

def read_and_combine_data(filepath, suffix):
    with open(filepath) as f:
        palette_data = f.read()

    entries = {}
    entry_order = []
    name = None

    for line in palette_data.split("\n"):
        line = line.split(";")[0].strip()
        if line.endswith(":"):
            name = line.strip(":").strip()
            entry_order.append(name)
            entries[name] = ()
        elif name:
            entries[name] += (line, )

    data = ""
    for name in entry_order:
        data += f"{name}_{suffix}:\n"
        for line in entries[name]:
            data += ("\t%s\n" % line) if line else "\n"

    return data


combo_data = (
    "paletteDataStart:\n" +
    read_and_combine_data(agesPalettes, "ages") +
    read_and_combine_data(seasonsPalettes, "seasons")
    )

with open(outputFile, "w") as f:
    f.write(combo_data)
