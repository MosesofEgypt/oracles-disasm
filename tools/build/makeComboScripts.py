#!/usr/bin/python3
import os
import sys

from pprint import pprint
'''
if len(sys.argv) < 3:
    print('Usage: ' + sys.argv[0] + 'outputFile dataFiles')
    sys.exit(1)

outputFile  = sys.argv[1]
dataFiles   = sys.argv[2:]
'''

git_dir             = "F:/My Files/Applications/My Repos/orcles-disasm/"
outputDir          = git_dir + "/build_combo_h/"
dataFiles = [
    git_dir + "/scripts/ages/scriptHelper.s",
    git_dir + "/scripts/seasons/scriptHelper.s",
    git_dir + "/scripts/ages/dungeonScripts.s",
    git_dir + "/scripts/seasons/dungeonScripts.s",
    git_dir + "/scripts/ages/scripts.s",
    git_dir + "/scripts/seasons/scripts.s",

    git_dir + "/scripts/common/bipinScripts.s",
    git_dir + "/scripts/common/blossomScripts.s",
    git_dir + "/scripts/common/childScripts.s",
    git_dir + "/scripts/common/commonScripts.s",
    git_dir + "/scripts/common/scriptHelper.s",
    git_dir + "/scripts/common/syrupScripts.s",
    ]

seasons_enemy_renames = {
    name: f"{name}_SEASONS" for name in (
        "ENEMY_KING_MOBLIN",
        )
    }
seasons_interaction_renames = {
    name: f"{name}_SEASONS" for name in (
        "INTERAC_BIRD",
        "INTERAC_SUBROSIAN",
        "INTERAC_ROSA",
        "INTERAC_GORON",
        "INTERAC_SYRUP",
        "INTERAC_ZELDA",
        "INTERAC_SYRUP_CUCCO",
        "INTERAC_COMPANION_SPAWNER",
        "INTERAC_MASTER_DIVER",
        "INTERAC_MAKU_SEED",
        "INTERAC_OLD_MAN_WITH_RUPEES",
        "INTERAC_DIN",
        "INTERAC_TWINROVA_FLAME",
        "INTERAC_AMBI",
        "INTERAC_MAKU_SEED_AND_ESSENCES",
        "INTERAC_VIRE",
        )
    }

def remove_duplicates(entries, entry_order):
    for name in entries:
        while entries[name]:
            if entries[name][-1]:
                entries[name] += (""), 
                break
            entries[name] = entries[name][:-1]

    entries_by_data = {v: k for k, v in entries.items()}
    for i, name in reversed(list(enumerate(entry_order))):
        data = entries[name]
        if name[0] in "@-+":
            # don't bother trying to puzzle out local symbols
            continue
        elif i:
            checked = 0
            # the entry and the previous entry must both end with
            # either a scriptend or a jump of some form for this
            # to be considered a duplicate and be removable.
            for entry in [data, entries[entry_order[i-1]]]:
                for line in entry[::-1]:
                    cmd = line.replace("\t", " ").split(" ")[0].lower()
                    if cmd == ".dw":
                        # ignore jump tables
                        continue
                        
                    checked += cmd in (
                        "scriptend", "scriptjump",
                        "retscript", "jumprandom",
                        )
                    break

            if checked == 2:
                continue

        dup_name = entries_by_data.get(data)
        if dup_name != name:
            print(f"Removing duplicate symbol data '{name}'")
            new_data = (f"{name}:", ) + entries[dup_name]

            entries_by_data[new_data] = dup_name
            entries[dup_name] = new_data
            entry_order.pop(i)


def read_and_combine_data(filepath, all_entry_names):
    suffix = "ages" if "ages" in filepath.lower() else "seasons"
    with open(filepath) as f:
        palette_data = f.read()

    entries = {}
    entry_order = []
    name = None
    jumptable = False
    i = 0
    asm_commands         = {}
    script_commands      = {}
    enemy_commands       = {}
    interaction_commands = {}
    jump_targets         = {}

    for line in palette_data.split("\n"):
        line = line.split(";")[0].strip()
        if line.endswith(":"):
            name = line.strip(":").strip()
            if name in all_entry_names and not name.startswith("@"):
                new_name = name + f"_{suffix}"
                print(f"Renamed {name} to {new_name}.")
                name = new_name

            entry_order.append(name)
            all_entry_names.add(name)
            entries[name] = ()
            i = 0
            jumptable = False
            continue
        elif name and line:
            cmd_parts = line.replace("\t", " ").split(" ")
            if cmd_parts[0] in (
                    "scriptjump", "loadscript", "callscript",
                    "jumpiftextoptioneq", "jumprandom",
                    "jumpifmemoryset", "jumpiftradeitemeq",
                    "jumpifnoenemies", "jumpiflinkvariableneq",
                    "jumpifmemoryeq", "jumpifobjectbyteeq"
                    ):
                script_commands.setdefault(name, []).append(i)
            elif cmd_parts[0] in (
                    "spawninteraction",
                    ):
                interaction_commands.setdefault(name, []).append(i)
            elif cmd_parts[0] in (
                    "spawnenemy", "spawnenemyhere",
                    ):
                enemy_commands.setdefault(name, []).append(i)
            elif cmd_parts[0] in (
                    "asm15",
                    ):
                asm_commands.setdefault(name, []).append(i)
            elif cmd_parts[0] in (
                    "jumptable_memoryaddress",
                    "jumptable_objectbyte",
                    ):
                jumptable = True
            elif jumptable and cmd_parts[0] == ".dw":
                jump_targets.setdefault(name, []).append(i)
                entries[name] += (line, )
                i += 1
                continue

        elif not name:
            continue

        jumptable = False
        entries[name] += (line, )
        i += 1

    #pprint(asm_commands)
    #pprint(script_commands)
    #pprint(enemy_commands)
    #pprint(interaction_commands)
    #pprint(jump_targets)

    return entries, entry_order

all_entries      = []
all_entry_orders = []
all_filenames    = []
all_entry_names  = set()

for filename in dataFiles:
    entries, entry_orders = read_and_combine_data(filename, all_entry_names)
    all_entries.append(entries)
    all_entry_orders.append(entry_orders)
    all_entry_names.update(entry_orders)
    basename = os.path.basename(filename).rsplit(".")[0]
    basename += ("_ages.s"    if "ages"    in filename.lower() else
                 "_seasons.s" if "seasons" in filename.lower() else
                 ".s")
    all_filenames.append(os.path.join(outputDir, basename))

# remove duplicate entries
for filepath, entries, names in zip(
        all_filenames, all_entries, all_entry_orders
        ):
    remove_duplicates(entries, names)

    data = ""
    for name in names:
        data += f"{name}:\n"
        for line in entries[name]:
            data += "" if line.endswith(":") else "\t"
            data += line + "\n"

    with open(filepath, "w") as f:
        f.write(data)
