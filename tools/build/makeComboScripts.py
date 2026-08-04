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
    # common scripts must come first
    git_dir + "/scripts/common/bipinScripts.s",
    git_dir + "/scripts/common/blossomScripts.s",
    git_dir + "/scripts/common/childScripts.s",
    git_dir + "/scripts/common/commonScripts.s",
    git_dir + "/scripts/common/scriptHelper.s",
    git_dir + "/scripts/common/syrupScripts.s",

    git_dir + "/scripts/ages/scriptHelper.s",
    git_dir + "/scripts/seasons/scriptHelper.s",
    git_dir + "/scripts/ages/dungeonScripts.s",
    git_dir + "/scripts/seasons/dungeonScripts.s",
    git_dir + "/scripts/ages/scripts.s",
    git_dir + "/scripts/seasons/scripts.s",
    git_dir + "/scripts/seasons/scripts2.s",
    ]
# the weird naming is intentional to prevent it matching real conventions
suffixes = ("_SeAs", "_AgEs")

enemy_renames = {
    (name, suffixes[0]): f"{name}_SEASONS" for name in (
        "ENEMY_KING_MOBLIN",
        )
    }
interac_renames = {
    (name, suffixes[0]): f"{name}_SEASONS" for name in (
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
        jump_targets     = info_set["jump_targets"]
        asm_commands     = info_set["asm_commands"]
        script_commands  = info_set["script_commands"]
        enemy_commands   = info_set["enemy_commands"]
        interac_commands = info_set["interac_commands"]

        for renames, dct in ([enemy_renames,     enemy_commands],
                             [interac_renames, interac_commands]):
            for key in dct:
                name, suffix = key
                entry = entries.get(name+suffix, entries.get(name))

                if not entry:
                    continue

                entry = list(entry)
                dup_suffixes = ()
                for row_i in dct[key]:
                    line = entry[row_i]

                    cmd, rem = line.split(" ", 1)
                    args = [s for s in rem.replace(",", " ").split(" ") if s]
                    for col_i in dct[key][row_i]:
                        sym = args[col_i]

                        if suffix:
                            suffixes_to_check = [suffix]
                        else:
                            # commmon scripts file. might need to duplicate
                            # the script if the symbol is used in both games
                            suffixes_to_check = suffixes

                        for suffix in suffixes_to_check:
                            new_sym = renames.get((sym, suffix))
                            if new_sym:
                                print("Redirected symbol ref "
                                      f"'{sym}' to '{new_sym}'.")
                                args[col_i] = new_sym
                                dup_suffixes += (suffix,)

                    entry[row_i] = cmd + " " + ", ".join(args)

                orig_name = name
                for suffix in dup_suffixes:
                    name += suffix
                    print(f"Added symbol '{name}'.")
                    entry_names.add(name)
                    entry_order.insert(entry_order.index(orig_name)+1, name)
                    for info in (jump_targets, asm_commands, script_commands):
                        if key in info:
                            info[(name, suffix)] = info[key]

                entries[name] = tuple(entry)
            #input()

        for dct in (asm_commands, jump_targets, script_commands):
            for key in dct:
                name, suffix = key
                entry = entries.get(name+suffix, entries.get(name))

                if not entry:
                    continue

                entry = list(entry)
                need_dup = False
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

                        if not suffix:
                            # commmon scripts file. might need to duplicate
                            # the script if the symbol is used in both games
                            need_dup = (
                                sym + suffixes[0] in all_entry_names or
                                sym + suffixes[1] in all_entry_names
                                )
                            if need_dup:
                                suffix = suffixes[0]

                        if suffix and sym + suffix in all_entry_names:
                            # redirect the renamed symbol
                            sym = f"{prefix}{sym}"
                            print("Redirected symbol ref "
                                  f"'{sym}' to '{sym + suffix}'.")
                            args[col_i] = sym + suffix

                    entry[row_i] = cmd + " " + ", ".join(args)

                orig_name = name
                if need_dup:
                    name += suffix
                    print(f"Added symbol '{name}'.")
                    entry_names.add(name)
                    entry_order.insert(entry_order.index(orig_name)+1, name)

                entries[name] = tuple(entry)

    entries_by_data = {v: k for k, v in entries.items()
                       if v is not None}
    for i, name in reversed(list(enumerate(entry_order))):
        if name not in entries:
            entry_order.pop(i)
            continue

        data = entries[name]
        if name[0] in "@-+" or data is None:
            # don't bother trying to puzzle out local symbols
            continue
        elif i:
            checked = 0
            # the entry and the previous entry must both end with
            # either a scriptend or a jump of some form for this
            # to be considered a duplicate and be removable.
            for entry in [data, entries[entry_order[i-1]]]:
                if entry is None:
                    continue

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

            print(f"Redirected dup symbol '{remove}' to '{keep}'")
            new_data = (f"{name}:", ) + entries[keep]

            entries_by_data[new_data] = remove
            entries[remove] = new_data
            entry_order.pop(i)


def add_entry(name, entry, entries, entry_order, suffix):
    entry = tuple(entry)
    if name not in entries:
        pass
    elif entries[name] == entry:
        # only skip if it doesn't contain any directives
        can_skip = True
        for line in entry:
            cmd = line.split(" ")[0]
            if cmd[0] == "." and cmd[:2] != ".d":
                can_skip = False

        if can_skip:
            print(f"Skipped dup symbol '{name}'")
            return

    if entries.get(name, entry) != entry:
        new_name = name + suffix
        print(f"Renamed shared symbol '{name}' to '{new_name}'.")
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

        if ((line and not name) or
            (line.endswith(":") and not line.startswith("@"))):
            name and add_entry(name, entry, entries, entry_order, suffix)
            if not(line.endswith(":") or line.startswith("@")):
                # not a symbol, so make a None entry to indicate this.
                # i've kinda given up on making this first attempt being clean
                name = None
                entries[line] = None
                entry_order.append(line)
            else:
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
        if entries[name] is None:
            data += name + "\n"
            continue

        data += f"{name}:\n"
        line = None
        for line in entries[name]:
            data += ("" if line[-1:] == ":" else
                     "" if line[:1]  == "@" else
                     "\t")
            data += line + "\n"

        data += "" if line is None else "\n"

    with open(f"{outputDir}/{basename}.s", "w") as f:
        f.write(data)
