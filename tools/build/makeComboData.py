#!/usr/bin/python3
import os
import sys

if len(sys.argv) < 3:
    print('Usage: ' + sys.argv[0] + 'outputFile dataFiles')
    sys.exit(1)

outputFile  = sys.argv[1]
dataFiles   = sys.argv[2:]

fname_lower = os.path.basename(outputFile).split(".")[0].lower()
is_oamdata  = fname_lower.endswith("oamdata")

#git_dir         = "F:/My Files/Applications/My Repos/orcles-disasm/"
#outputFile      = git_dir + "/build_combo_h/interactionOamData.s"
#agesDataFile    = git_dir + "/data/ages/interactionOamData.s"
#seasonsDataFile = git_dir + "/data/seasons/interactionOamData.s"

def remove_duplicates(entries, entry_order):
    entries_by_data = {v: k for k, v in entries.items()}
    for i, name in reversed(list(enumerate(entry_order))):
        data = entries[name]
        dup_name = entries_by_data[data]
        if dup_name != name:
            entries[dup_name] = (f"{name}:", ) + entries[dup_name]
            entry_order.pop(i)

def read_and_combine_data(filepath):
    suffix = "ages" if "ages" in filepath.lower() else "seasons"
    with open(filepath) as f:
        palette_data = f.read()

    entries = {}
    entry_order = []
    name = None

    for line in palette_data.split("\n"):
        line = line.split(";")[0].strip()
        if line.endswith(":"):
            name = line.strip(":").strip() +  f"_{suffix}"
            entry_order.append(name)
            entries[name] = ()
        elif name:
            if "SubidData" in line and not line.startswith("m_"):
                line = line.replace(
                    "SubidData", f"SubidData_{suffix}"
                    )
            elif ("Animations:"          in line or
                  "OamData"              in line or
                  "oamData"              in line or
                  ".dw interaction"      in line or
                  ".dw enemy"            in line or
                  ".dw part"             in line or
                  "interactionAnimation" in line or
                  "enemyAnimation"       in line or
                  "partAnimation"        in line or
                  "specialObject"        in line or
                  "animationGroup"       in line or
                  "animationData"        in line or
                  "animationLoop"        in line):
                line = line.rstrip(":") + f"_{suffix}" + (
                    ":" if line.endswith(":") else ""
                    )

            entries[name] += (line, )

    return entries, entry_order

all_entries      = {}
all_entry_orders = []

for filename in dataFiles:
    entries, entry_orders = read_and_combine_data(filename)
    all_entries.update(entries)
    all_entry_orders.extend(entry_orders)

if is_oamdata:
    # remove duplicate oam data entries
    remove_duplicates(all_entries, all_entry_orders)

combo_data = ""
for name in all_entry_orders:
    combo_data += f"{name}:\n"
    for line in all_entries[name]:
        combo_data += "" if line.endswith(":") else "\t"
        combo_data += line + "\n"

with open(outputFile, "w") as f:
    f.write(combo_data)
