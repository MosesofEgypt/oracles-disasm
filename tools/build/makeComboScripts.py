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

suffixes = ("_seasons", "_ages")

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

def remove_duplicates(entries, entry_order, symbol_info, entry_names):
    for info_set in symbol_info:
        asm_commands     = info_set["asm_commands"]
        script_commands  = info_set["script_commands"]
        enemy_commands   = info_set["enemy_commands"]
        interac_commands = info_set["interac_commands"]
        jump_targets     = info_set["jump_targets"]
        for dct in (asm_commands, jump_targets, script_commands):
            for key in dct:
                name, suffix = key
                entry = entries.get(name+suffix, entries.get(name))

                if not entry:
                    continue

                entry = list(entry)
                for row_i in dct[key]:
                    line = entry[row_i]

                    cmd, rem = line.split(" ", 1)
                    args = [s for s in rem.replace(",", " ").split(" ") if s]
                    for col_i in dct[key][row_i]:
                        sym = args[col_i]
                        prefix  = (sym.split(".")[0]+".") if "." in sym else ""
                        sym     = sym.split(".", 1)[1] if prefix else sym
                        if sym[0] in "@-+":
                            continue

                        if "bipin_showText_subid1To9" in rem:
                            print(row_i, col_i, name, sym, suffix)
                            print(entry)

                        if suffix and sym + suffix in all_entry_names:
                            # redirect the renamed symbol
                            print("Redirected symbol reference "
                                  f"'{sym}' to '{sym + suffix}'.")
                            args[col_i] = prefix + sym + suffix

                    entry[row_i] = cmd + " " + ", ".join(args)

                entries[name] = tuple(entry)

    entries_by_data = {v: k for k, v in entries.items()}
    for i, name in reversed(list(enumerate(entry_order))):
        if name not in entries:
            entry_order.pop(i)
            continue

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
                checked += not entry
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

            if checked < 2:
                continue

        dup_name = entries_by_data.get(data)
        if dup_name != name and dup_name[0]:
            keep   = name
            remove = dup_name
            if keep in (remove+s for s in suffixes):
                keep, remove = remove, keep

            print(f"Redirected duplicate symbol '{remove}' to '{keep}'")
            new_data = (f"{name}:", ) + entries[keep]

            entries_by_data[new_data] = remove
            entries[remove] = new_data
            entry_order.pop(i)


def add_entry(name, entry, entries, entry_order, suffix):
    entry = tuple(entry)
    if name not in entries:
        pass
    elif entries[name] == entry:
        print(f"Removed duplicate symbol '{name}'")
        return
    elif entries[name] != entry:
        new_name = name + suffix
        print(f"Renamed '{name}' to '{new_name}'.")
        name = new_name

    entries[name] = entry
    entry_order.append(name)

def read_and_combine_data(filepath, entries, entry_order):
    suffix = (suffixes[0] if "seasons" in filepath.lower() else
              suffixes[1] if "ages"    in filepath.lower() else
              "")
    with open(filepath) as f:
        palette_data = f.read()

    entry, name = [], None
    jumptable   = False
    asm_commands     = {}
    script_commands  = {}
    enemy_commands   = {}
    interac_commands = {}
    jump_targets     = {}

    for line in palette_data.split("\n"):
        line = line.split(";")[0].strip()
        if not line:
            continue

        i = len(entry)

        if line.endswith(":") and not line.startswith("@"):
            name and add_entry(name, entry, entries, entry_order, suffix)
            name  = line.strip(":").strip()
            entry = []
        elif name:
            line_parts = line.replace("\t", " ").split(" ")
            cmd = line_parts[0]
            key = (name, suffix)
            if cmd in (
                    "scriptjump", "loadscript", "callscript",
                    "jumpifnoenemies", 
                    ):
                script_commands.setdefault(key, {})[i] = [0]
            elif cmd in (
                    "jumpifmemoryset", "jumpiflinkvariableneq",
                    "jumpifmemoryeq",  "jumpifobjectbyteeq",
                    ):
                script_commands.setdefault(key, {})[i] = [2]
            elif cmd in ("jumpiftextoptioneq", "jumpiftradeitemeq"):
                script_commands.setdefault(key, {})[i] = [1]
            elif cmd in ("spawnenemy", "spawnenemyhere"):
                enemy_commands.setdefault(key, {})[i] = [0]
            elif cmd == "jumprandom":
                script_commands.setdefault(key, {})[i] = [0, 1]
            elif cmd == "spawninteraction":
                interac_commands.setdefault(key, {})[i] = [0]
            elif cmd == "asm15":
                asm_commands.setdefault(key, {})[i] = [0]
            elif jumptable or cmd in (
                    "jumptable_memoryaddress",
                    "jumptable_objectbyte",
                    ):
                if cmd == ".dw":
                    jump_targets.setdefault(key, {})[i] = [0]

                jumptable = True
                entry.append(line)
                continue

            entry.append(line)

        jumptable = False

    name and add_entry(name, entry, entries, entry_order, suffix)

    return dict(
        asm_commands     = asm_commands,
        script_commands  = script_commands,
        enemy_commands   = enemy_commands,
        interac_commands = interac_commands,
        jump_targets     = jump_targets,
        )

all_entries      = {}
all_entry_orders = {}
all_symbol_infos = {}
all_entry_names = set()

for filename in dataFiles:
    basename    = os.path.basename(filename).rsplit(".")[0]
    entries     = all_entries.setdefault(basename, {})
    entry_order = all_entry_orders.setdefault(basename, [])

    symbol_info = read_and_combine_data(
        filename, entries, entry_order
        )
    all_entry_names.update(entry_order)

    all_symbol_infos.setdefault(basename, []).append(symbol_info)

# remove duplicate entries
for basename in all_entries:
    entries     = all_entries[basename]
    names       = all_entry_orders[basename]
    symbol_info = all_symbol_infos[basename]
    remove_duplicates(entries, names, symbol_info, all_entry_names)

    data = ""
    for name in names:
        data += f"{name}:\n"
        line = None
        for line in entries[name]:
            data += "" if line.endswith(":") else "\t"
            data += line + "\n"

        data += "" if line is None else "\n"

    with open(f"{outputDir}/{basename}.s", "w") as f:
        f.write(data)
