#!/usr/bin/python3
import sys

if len(sys.argv) < 4:
    print('Usage: ' + sys.argv[0] + 'outputFile agesPalettes seasonsPalettes')
    sys.exit(1)

outputFile      = sys.argv[1]
agesPalettes    = sys.argv[2]
seasonsPalettes = sys.argv[3]
debug = True

with open(agesPalettes) as f:
    ages_data = f.read()

with open(seasonsPalettes) as f:
    seasons_data = f.read()

ages_headers = {}
ages_header_order = []
seasons_headers = {}
seasons_header_order = []

def parse_palette_data(data, headers, header_order):
    name = None
    in_header = False
    for line in data.split("\n"):
        line = line.split(";")[0].strip()
        if line.startswith("m_PaletteHeaderStart"):
            new_name = line.split(" ")[-1].split(",")[-1]
            if in_header:
                debug and print(f"Fell through {name} to {new_name}")

            name = new_name
            header_order.append(name)
            headers[name] = ()
            in_header = True
            continue

        elif line.startswith("m_PaletteHeaderEnd"):
            in_header = False

        if name:
            headers[name] += (line, )

def make_header_names_unique(
        headers, header_names, other_header_names, defines, ages=False
        ):
    suffix = "AGES" if ages else "SEASONS" 
    new_headers = {}
    new_header_order = []
    for i, name in enumerate(header_names):
        new_name = name
        header_data = headers[name]
        new_header_data = ()
        if name in other_header_names:
            new_name += f"_{suffix}"
            if other_header_names.index(name) == i:
                # they're the same index, so we can use the
                # original define to refer to both of them
                defines[name] = new_name

            debug and print(f"Renamed {name} to {new_name}")

        for line in header_data:
            
            if (line.startswith("m_PaletteHeaderBg") or
                line.startswith("m_PaletteHeaderSpr")):
                line_parts = [s for s in line.replace(","," ").split(" ") if s]
                data_name = line_parts[3]
                if (data_name.startswith("paletteData") or
                    data_name == "standardSpritePaletteData"):
                    # rename palette data being referenced
                    modifier = ""
                    if "+" in data_name:
                        data_name, modifier = data_name.split("+")
                        modifier = "+".join(["", *modifier])
                        
                    data_name += f"_{suffix}".lower()
                    line_parts[3] = data_name + modifier
                    line = line.split(" ", 1)[0] + " " + (", ".join(line_parts[1:]))
                else:
                    debug and print(f"Skipping renaming palette {line_parts[3]}")

            new_header_data += (line, )

        new_headers[new_name] = new_header_data
        new_header_order.append(new_name)

    return new_headers, new_header_order
            

parse_palette_data(ages_data, ages_headers, ages_header_order)
parse_palette_data(seasons_data, seasons_headers, seasons_header_order)

defines = {}
new_ages_headers, new_ages_header_order = make_header_names_unique(
    ages_headers, ages_header_order, seasons_header_order, defines, True
    )
new_seasons_headers, new_seasons_header_order = make_header_names_unique(
    seasons_headers, seasons_header_order, ages_header_order, defines
    )

combo_headers_data = "\n".join([
    "paletteHeaderTable_ages:",
    f".repeat {len(new_ages_header_order)} index COUNT",
    "\t.dw paletteHeader{%.2x{COUNT}}_ages",
    ".endr",
    "",
    "paletteHeaderTable_seasons:",
    f".repeat {len(new_seasons_header_order)} index COUNT",
    "\t.dw paletteHeader{%.2x{COUNT}}_seasons",
    ".endr",
    "",
    "",
])

for headers, names, is_ages in ([
        [new_ages_headers,    new_ages_header_order,    True],
        [new_seasons_headers, new_seasons_header_order, False],
        ]):
    macro_suffix = "_ages" if is_ages else "_seasons"

    for i, name in enumerate(names):
        header_data = [s for s in headers[name] if s]

        combo_headers_data += "\n\t".join([
            f"m_PaletteHeaderStart{macro_suffix} {i}, {name}",
            *header_data,
            ]) + ("\n\n" if header_data else "\n")


combo_headers_data += "".join(
    f".define {k}\t{defines[k]}\n" for k in sorted(defines)
    )

with open(outputFile, "w") as f:
    f.write(combo_headers_data)
