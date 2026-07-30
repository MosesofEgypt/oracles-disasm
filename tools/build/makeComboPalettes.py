#!/usr/bin/python3
import sys

if len(sys.argv) < 4:
    print('Usage: ' + sys.argv[0] + 'outputFile agesPalettes seasonsPalettes')
    sys.exit(1)

outputFile      = sys.argv[1]
agesPalettes    = sys.argv[2]
seasonsPalettes = sys.argv[3]

with open(agesPalettes) as f:
    ages_palette_data = f.read()

with open(seasonsPalettes) as f:
    seasons_palette_data = f.read()

ages_palettes = {}
ages_palette_order = []
ages_palettes_by_data = {}
name = None

for line in ages_palette_data.split("\n"):
    line = line.split(";")[0].strip()
    if line.endswith(":"):
        name = line.strip(":").strip()
        ages_palette_order.append(name)
        ages_palettes[name] = ()
    elif name:
        ages_palettes[name] += (line, )

seasons_palettes = {}
seasons_palette_order = []
seasons_palettes_by_data = {}
name = None

for line in seasons_palette_data.split("\n"):
    line = line.split(";")[0].strip()
    if line.endswith(":"):
        name = line.strip(":").strip()
        seasons_palette_order.append(name)
        seasons_palettes[name] = ()
    elif name:
        seasons_palettes[name] += (line, )


combo_palette_data = ""
for name in ages_palette_order:
    combo_palette_data += "%s_ages:\n" % name
    for line in ages_palettes[name]:
        combo_palette_data += ("\t%s\n" % line) if line else "\n"

for name in seasons_palette_order:
    combo_palette_data += "%s_seasons:\n" % name
    for line in seasons_palettes[name]:
        combo_palette_data += ("\t%s\n" % line) if line else "\n"

with open(outputFile, "w") as f:
    f.write(combo_palette_data)
