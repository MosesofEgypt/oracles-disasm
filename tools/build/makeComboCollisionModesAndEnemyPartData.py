#!/usr/bin/python3
import sys

if len(sys.argv) < 4:
    print('Usage: ' + sys.argv[0] + 'outputDir agesDataDir seasonsDataDir')
    sys.exit(1)

outputDir      = sys.argv[1]
agesDataDir    = sys.argv[2]
seasonsDataDir = sys.argv[3]

debug = True

# defining these instead of trying to read them in and parse the defines
ages_types_old = [
    "ENEMYCOLLISION_00",
    "ENEMYCOLLISION_ITEM",
    "ENEMYCOLLISION_DORMANT",
    "ENEMYCOLLISION_SWITCH",
    "ENEMYCOLLISION_PODOBOO",
    "ENEMYCOLLISION_IRON_MASK_DETACHED",
    "ENEMYCOLLISION_PROJECTILE",
    "ENEMYCOLLISION_PROJECTILE_WITH_RING_MOD",
    "ENEMYCOLLISION_MERGED_TWINROVA",
    "ENEMYCOLLISION_VERAN_TURTLE_FORM_VULNERABLE",
    "ENEMYCOLLISION_TWINROVA",
    "ENEMYCOLLISION_GANON",
    "ENEMYCOLLISION_RAMROCK_ARMS",
    "ENEMYCOLLISION_VERAN_FAIRY",
    "ENEMYCOLLISION_RAMROCK",
    "ENEMYCOLLISION_MOTIONLESS_ENEMY",
    "ENEMYCOLLISION_STANDARD_ENEMY",
    "ENEMYCOLLISION_BURNABLE_ENEMY",
    "ENEMYCOLLISION_LYNEL",
    "ENEMYCOLLISION_BLADE_TRAP",
    "ENEMYCOLLISION_SWITCHHOOK_DAMAGE_ENEMY",
    "ENEMYCOLLISION_EYESOAR_CHILD",
    "ENEMYCOLLISION_GIBDO",
    "ENEMYCOLLISION_SPARK",
    "ENEMYCOLLISION_SPIKED_BEETLE",
    "ENEMYCOLLISION_BUBBLE",
    "ENEMYCOLLISION_GHINI",
    "ENEMYCOLLISION_BUZZBLOB",
    "ENEMYCOLLISION_WHISP",
    "ENEMYCOLLISION_IRON_MASK",
    "ENEMYCOLLISION_ACTIVE_RED_ARMOS",
    "ENEMYCOLLISION_KEESE",
    "ENEMYCOLLISION_DARKNUT",
    "ENEMYCOLLISION_POLS_VOICE",
    "ENEMYCOLLISION_LIKE_LIKE",
    "ENEMYCOLLISION_GOPONGA_FLOWER",
    "ENEMYCOLLISION_ANGLER_FISH_BUBBLE",
    "ENEMYCOLLISION_WALLMASTER",
    "ENEMYCOLLISION_GIANT_BLADE_TRAP",
    "ENEMYCOLLISION_THWIMP",
    "ENEMYCOLLISION_THWOMP",
    "ENEMYCOLLISION_ZOL",
    "ENEMYCOLLISION_CUCCO",
    "ENEMYCOLLISION_FIRE_KEESE",
    "ENEMYCOLLISION_GIANT_CUCCO",
    "ENEMYCOLLISION_BARI",
    "ENEMYCOLLISION_PEAHAT_VULNERABLE",
    "ENEMYCOLLISION_GIANT_GHINI_CHILD",
    "ENEMYCOLLISION_WIZZROBE",
    "ENEMYCOLLISION_CROW",
    "ENEMYCOLLISION_SHADOW_HAG_BUG",
    "ENEMYCOLLISION_GEL",
    "ENEMYCOLLISION_PINCER",
    "ENEMYCOLLISION_GOHMA_GEL",
    "ENEMYCOLLISION_SWORD_MASKED_MOBLIN",
    "ENEMYCOLLISION_BALL_AND_CHAIN_SOLDIER",
    "ENEMYCOLLISION_HARDHAT_BEETLE",
    "ENEMYCOLLISION_ARM_MIMIC",
    "ENEMYCOLLISION_MOLDORM",
    "ENEMYCOLLISION_BEETLE",
    "ENEMYCOLLISION_FLYING_TILE",
    "ENEMYCOLLISION_AMBI_GUARD_CHASING_LINK",
    "ENEMYCOLLISION_CANDLE",
    "ENEMYCOLLISION_3f",
    "ENEMYCOLLISION_BUSH",
    "ENEMYCOLLISION_TWINROVA_BAT",
    "ENEMYCOLLISION_HARMLESS_HARDHAT_BEETLE",
    "ENEMYCOLLISION_VERAN_POSSESSION_BOSS",
    "ENEMYCOLLISION_STANDARD_MINIBOSS",
    "ENEMYCOLLISION_SMASHER",
    "ENEMYCOLLISION_VIRE",
    "ENEMYCOLLISION_ANGLER_FISH_ANTENNA",
    "ENEMYCOLLISION_BLUE_STALFOS",
    "ENEMYCOLLISION_PUMPKIN_HEAD_BODY",
    "ENEMYCOLLISION_HEAD_THWOMP",
    "ENEMYCOLLISION_SHADOW_HAG",
    "ENEMYCOLLISION_EYESOAR_VULNERABLE",
    "ENEMYCOLLISION_SMOG",
    "ENEMYCOLLISION_OCTOGON",
    "ENEMYCOLLISION_PLASMARINE",
    "ENEMYCOLLISION_KING_MOBLIN",
    "ENEMYCOLLISION_SPIKED_BEETLE_FLIPPED",
    "ENEMYCOLLISION_ROCK",
    "ENEMYCOLLISION_UNMASKED_IRON_MASK",
    "ENEMYCOLLISION_ACTIVE_BLUE_ARMOS",
    "ENEMYCOLLISION_STALFOS_BLOCKED_WITH_SWORD",
    "ENEMYCOLLISION_DARKNUT_BLOCKED_WITH_SWORD",
    "ENEMYCOLLISION_BIG_GOPONGA_FLOWER",
    "ENEMYCOLLISION_PEAHAT",
    "ENEMYCOLLISION_BARI_ELECTRIC_SHOCK",
    "ENEMYCOLLISION_AMBI_GUARD",
    "ENEMYCOLLISION_VERAN_GHOST",
    "ENEMYCOLLISION_VERAN_HUMAN",
    "ENEMYCOLLISION_PUMPKIN_HEAD_HEAD",
    "ENEMYCOLLISION_PUMPKIN_HEAD_GHOST",
    "ENEMYCOLLISION_SUBTERROR_DRILLING",
    "ENEMYCOLLISION_ARMOS_WARRIOR_PROTECTED",
    "ENEMYCOLLISION_ARMOS_WARRIOR_SHIELD",
    "ENEMYCOLLISION_ARMOS_WARRIOR_SWORD",
    "ENEMYCOLLISION_SMASHER_BALL",
    "ENEMYCOLLISION_ANGLER_FISH",
    "ENEMYCOLLISION_BLUE_STALFOS_BAT",
    "ENEMYCOLLISION_BLUE_STALFOS_SICKLE",
    "ENEMYCOLLISION_OCTOGON_SHELL",
    "ENEMYCOLLISION_PLASMARINE_SHOCK",
    "ENEMYCOLLISION_SUBTERROR_UNDERGROUND",
    "ENEMYCOLLISION_VERAN_TURTLE_FORM",
    "ENEMYCOLLISION_VERAN_SPIDER_FORM_VULNERABLE",
    "ENEMYCOLLISION_VERAN_SPIDER_FORM",
    "ENEMYCOLLISION_EYESOAR",
    "ENEMYCOLLISION_COLOR_CHANGING_GEL",
    "ENEMYCOLLISION_LYNEL_BEAM",
    "ENEMYCOLLISION_ENEMY_SWORD",
    "ENEMYCOLLISION_FIRE",
    "ENEMYCOLLISION_FALLING_FIRE",
    "ENEMYCOLLISION_WALL_FLAME",
    "ENEMYCOLLISION_SPIKED_BALL",
    "ENEMYCOLLISION_ROTATABLE_SEED_THING",
    "ENEMYCOLLISION_VIRE_PROJECTILE",
    "ENEMYCOLLISION_BABY_BALL",
    "ENEMYCOLLISION_KING_MOBLIN_BOMB",
    "ENEMYCOLLISION_SEED_EYE_STATUE",
    "ENEMYCOLLISION_TWINROVA_PROJECTILE",
    "ENEMYCOLLISION_GANON_TRIDENT",
    "ENEMYCOLLISION_VERAN_SPIDERWEB",
    "ENEMYCOLLISION_UNDEAD",
    "ENEMYCOLLISION_BURNABLE_UNDEAD",
    "ENEMYCOLLISION_GIANT_GHINI"
    ]
seasons_types_old = [
    "ENEMYCOLLISION_00",
    "ENEMYCOLLISION_ITEM",
    "ENEMYCOLLISION_DORMANT",
    "ENEMYCOLLISION_SWITCH",
    "ENEMYCOLLISION_PODOBOO",
    "ENEMYCOLLISION_IRON_MASK_DETACHED",
    "ENEMYCOLLISION_PROJECTILE",
    "ENEMYCOLLISION_PROJECTILE_WITH_RING_MOD",
    "ENEMYCOLLISION_MERGED_TWINROVA",
    "ENEMYCOLLISION_ONOX",
    "ENEMYCOLLISION_TWINROVA",
    "ENEMYCOLLISION_GANON",
    "ENEMYCOLLISION_DRAGON_ONOX",
    "ENEMYCOLLISION_GLEEOK",
    "ENEMYCOLLISION_KING_MOBLIN",
    "ENEMYCOLLISION_MOTIONLESS_ENEMY",
    "ENEMYCOLLISION_STANDARD_ENEMY",
    "ENEMYCOLLISION_BURNABLE_ENEMY",
    "ENEMYCOLLISION_LYNEL",
    "ENEMYCOLLISION_BLADE_TRAP",
    "ENEMYCOLLISION_POKEY",
    "ENEMYCOLLISION_GIBDO",
    "ENEMYCOLLISION_SPARK",
    "ENEMYCOLLISION_SPIKED_BEETLE",
    "ENEMYCOLLISION_BUBBLE",
    "ENEMYCOLLISION_GHINI",
    "ENEMYCOLLISION_BUZZBLOB",
    "ENEMYCOLLISION_WHISP",
    "ENEMYCOLLISION_IRON_MASK",
    "ENEMYCOLLISION_ACTIVE_RED_ARMOS",
    "ENEMYCOLLISION_MAGUNESU",
    "ENEMYCOLLISION_DARKNUT",
    "ENEMYCOLLISION_BURNABLE_UNDEAD",
    "ENEMYCOLLISION_POLS_VOICE",
    "ENEMYCOLLISION_LIKE_LIKE",
    "ENEMYCOLLISION_GOPONGA_FLOWER",
    "ENEMYCOLLISION_WALLMASTER",
    "ENEMYCOLLISION_GIANT_BLADE_TRAP",
    "ENEMYCOLLISION_THWIMP",
    "ENEMYCOLLISION_THWOMP",
    "ENEMYCOLLISION_UNDEAD",
    "ENEMYCOLLISION_KEESE",
    "ENEMYCOLLISION_ZOL",
    "ENEMYCOLLISION_CUCCO",
    "ENEMYCOLLISION_FIRE_KEESE",
    "ENEMYCOLLISION_GIANT_CUCCO",
    "ENEMYCOLLISION_PEAHAT_VULNERABLE",
    "ENEMYCOLLISION_WIZZROBE",
    "ENEMYCOLLISION_CROW",
    "ENEMYCOLLISION_GEL",
    "ENEMYCOLLISION_PINCER",
    "ENEMYCOLLISION_GOHMA_GEL",
    "ENEMYCOLLISION_SWORD_MASKED_MOBLIN",
    "ENEMYCOLLISION_BALL_AND_CHAIN_SOLDIER",
    "ENEMYCOLLISION_HARDHAT_BEETLE",
    "ENEMYCOLLISION_ARM_MIMIC",
    "ENEMYCOLLISION_MOLDORM",
    "ENEMYCOLLISION_BEETLE",
    "ENEMYCOLLISION_FLYING_TILE",
    "ENEMYCOLLISION_BLAINO_VULNERABLE",
    "ENEMYCOLLISION_DIGDOGGER_CHILD",
    "ENEMYCOLLISION_3f",
    "ENEMYCOLLISION_BUSH",
    "ENEMYCOLLISION_TWINROVA_BAT",
    "ENEMYCOLLISION_BLAINO_GLOVE",
    "ENEMYCOLLISION_GORIYA_BROS",
    "ENEMYCOLLISION_OMUAI_VULNERABLE",
    "ENEMYCOLLISION_AGUNIMA_VULNERABLE",
    "ENEMYCOLLISION_SYGER_TAIL",
    "ENEMYCOLLISION_VIRE",
    "ENEMYCOLLISION_POE_SISTER_MINIBOSS",
    "ENEMYCOLLISION_FRYPOLAR",
    "ENEMYCOLLISION_AQUAMENTUS_HORN",
    "ENEMYCOLLISION_DODONGO",
    "ENEMYCOLLISION_MOTHULA",
    "ENEMYCOLLISION_GOHMA_EYE",
    "ENEMYCOLLISION_MANHANDLA_BODY_VULNERABLE",
    "ENEMYCOLLISION_MEDUSA_HEAD",
    "ENEMYCOLLISION_SPIKED_BEETLE_FLIPPED",
    "ENEMYCOLLISION_ROCK",
    "ENEMYCOLLISION_UNMASKED_IRON_MASK",
    "ENEMYCOLLISION_ACTIVE_BLUE_ARMOS",
    "ENEMYCOLLISION_STALFOS_BLOCKED_WITH_SWORD",
    "ENEMYCOLLISION_DARKNUT_BLOCKED_WITH_SWORD",
    "ENEMYCOLLISION_BIG_GOPONGA_FLOWER",
    "ENEMYCOLLISION_PEAHAT",
    "ENEMYCOLLISION_BLAINO_INVULNERABLE",
    "ENEMYCOLLISION_BLAINO_GLOVE_SOFT_PUNCH",
    "ENEMYCOLLISION_BLAINO_GLOVE_HARD_PUNCH",
    "ENEMYCOLLISION_OMUAI_GRABBABLE",
    "ENEMYCOLLISION_AGUNIMA_INVULNERABLE",
    "ENEMYCOLLISION_SYGER_BODY",
    "ENEMYCOLLISION_POE_SISTER_FIRSTFIGHT",
    "ENEMYCOLLISION_AQUAMENTUS_BODY",
    "ENEMYCOLLISION_GOHMA_BODY",
    "ENEMYCOLLISION_GOHMA_CLAW",
    "ENEMYCOLLISION_GOHMA_CLAW_LUNGING",
    "ENEMYCOLLISION_MANHANDLA_BODY_INVULNERABLE",
    "ENEMYCOLLISION_MANHANDLA_HEAD_VULNERABLE",
    "ENEMYCOLLISION_MANHANDLA_CORE",
    "SE_ENEMYCOLLISION_64",
    "ENEMYCOLLISION_DRAGON_ONOX_CLAW",
    "ENEMYCOLLISION_LYNEL_BEAM",
    "ENEMYCOLLISION_ENEMY_SWORD",
    "ENEMYCOLLISION_FIRE",
    "ENEMYCOLLISION_FALLING_FIRE",
    "ENEMYCOLLISION_WALL_FLAME",
    "ENEMYCOLLISION_SPIKED_BALL",
    "ENEMYCOLLISION_POE_SISTER_FLAME",
    "ENEMYCOLLISION_KING_MOBLIN_BOMB",
    "ENEMYCOLLISION_TWINROVA_PROJECTILE",
    "ENEMYCOLLISION_DIN_CRYSTAL",
    "ENEMYCOLLISION_GANON_TRIDENT",
    "ENEMYCOLLISION_VIRE_PROJECTILE",
    "ENEMYCOLLISION_POPPABLE_BUBBLE",
    "ENEMYCOLLISION_SWITCHHOOK_DAMAGE_ENEMY"
    ]

types_new = [
    "ENEMYCOLLISION_00",
    "ENEMYCOLLISION_ITEM",
    "ENEMYCOLLISION_DORMANT",
    "ENEMYCOLLISION_SWITCH",
    "ENEMYCOLLISION_PODOBOO",
    "ENEMYCOLLISION_IRON_MASK_DETACHED",
    "ENEMYCOLLISION_PROJECTILE",
    "ENEMYCOLLISION_PROJECTILE_WITH_RING_MOD",
    "ENEMYCOLLISION_MERGED_TWINROVA",
    "ENEMYCOLLISION_TWINROVA",
    "ENEMYCOLLISION_GANON",
    "ENEMYCOLLISION_MOTIONLESS_ENEMY",
    "ENEMYCOLLISION_STANDARD_ENEMY",
    "ENEMYCOLLISION_BURNABLE_ENEMY",
    "ENEMYCOLLISION_LYNEL",
    "ENEMYCOLLISION_BLADE_TRAP",
    "ENEMYCOLLISION_GIBDO",
    "ENEMYCOLLISION_SPARK",
    "ENEMYCOLLISION_SPIKED_BEETLE",
    "ENEMYCOLLISION_BUBBLE",
    "ENEMYCOLLISION_GHINI",
    "ENEMYCOLLISION_BUZZBLOB",
    "ENEMYCOLLISION_WHISP",
    "ENEMYCOLLISION_IRON_MASK",
    "ENEMYCOLLISION_ACTIVE_RED_ARMOS",
    "ENEMYCOLLISION_DARKNUT",
    "ENEMYCOLLISION_POLS_VOICE",
    "ENEMYCOLLISION_LIKE_LIKE",
    "ENEMYCOLLISION_GOPONGA_FLOWER",
    "ENEMYCOLLISION_WALLMASTER",
    "ENEMYCOLLISION_GIANT_BLADE_TRAP",
    "ENEMYCOLLISION_THWIMP",
    "ENEMYCOLLISION_THWOMP",
    "ENEMYCOLLISION_ZOL",
    "ENEMYCOLLISION_CUCCO",
    "ENEMYCOLLISION_FIRE_KEESE",
    "ENEMYCOLLISION_GIANT_CUCCO",
    "ENEMYCOLLISION_PEAHAT_VULNERABLE",
    "ENEMYCOLLISION_WIZZROBE",
    "ENEMYCOLLISION_CROW",
    "ENEMYCOLLISION_GEL",
    "ENEMYCOLLISION_PINCER",
    "ENEMYCOLLISION_GOHMA_GEL",
    "ENEMYCOLLISION_SWORD_MASKED_MOBLIN",
    "ENEMYCOLLISION_BALL_AND_CHAIN_SOLDIER",
    "ENEMYCOLLISION_HARDHAT_BEETLE",
    "ENEMYCOLLISION_ARM_MIMIC",
    "ENEMYCOLLISION_MOLDORM",
    "ENEMYCOLLISION_BEETLE",
    "ENEMYCOLLISION_FLYING_TILE",
    "ENEMYCOLLISION_3f",
    "ENEMYCOLLISION_BUSH",
    "ENEMYCOLLISION_TWINROVA_BAT",
    "ENEMYCOLLISION_SPIKED_BEETLE_FLIPPED",
    "ENEMYCOLLISION_ROCK",
    "ENEMYCOLLISION_UNMASKED_IRON_MASK",
    "ENEMYCOLLISION_ACTIVE_BLUE_ARMOS",
    "ENEMYCOLLISION_STALFOS_BLOCKED_WITH_SWORD",
    "ENEMYCOLLISION_DARKNUT_BLOCKED_WITH_SWORD",
    "ENEMYCOLLISION_BIG_GOPONGA_FLOWER",
    "ENEMYCOLLISION_PEAHAT",
    "ENEMYCOLLISION_LYNEL_BEAM",
    "ENEMYCOLLISION_ENEMY_SWORD",
    "ENEMYCOLLISION_FIRE",
    "ENEMYCOLLISION_FALLING_FIRE",
    "ENEMYCOLLISION_WALL_FLAME",
    "ENEMYCOLLISION_SPIKED_BALL",

    "ENEMYCOLLISION_KING_MOBLIN",
    "ENEMYCOLLISION_KING_MOBLIN_BOMB",
    "ENEMYCOLLISION_TWINROVA_PROJECTILE",
    "ENEMYCOLLISION_GANON_TRIDENT",
    "ENEMYCOLLISION_VIRE_PROJECTILE",
    "ENEMYCOLLISION_SWITCHHOOK_DAMAGE_ENEMY",
    "ENEMYCOLLISION_VIRE",
    "ENEMYCOLLISION_BURNABLE_UNDEAD",
    "ENEMYCOLLISION_UNDEAD",
    "ENEMYCOLLISION_KEESE",
    ]

ages_types_new_only = [
    *(s for s in sorted(ages_types_old)
      if s not in types_new)
    ]
seasons_types_new_only = [
    *(s for s in sorted(seasons_types_old)
      if s not in types_new)
    ]

ages_types_new = [
    *types_new,
    *ages_types_new_only
    ]
seasons_types_new = [
    *types_new,
    *seasons_types_new_only
    ]

remapped_ages    = [ages_types_old.index(n) for n in ages_types_new]
remapped_seasons = [seasons_types_old.index(n) for n in seasons_types_new]


with open(agesDataDir + "/objectCollisionTable.s") as f:
    ages_data = f.read()
with open(seasonsDataDir + "/objectCollisionTable.s") as f:
    seasons_data = f.read()


new_data = ""
for mapping, data, game in [
        (remapped_ages,    ages_data,    "ages"),
        (remapped_seasons, seasons_data, "seasons"),
        ]:
    data_lines = []
    data_val_count = 0
    for line in data.split("\n"):
        line = line.strip()
        if not data_lines:
            if "objectCollisionTable" in line and line[0] != ";":
                data_lines.append(f"objectCollisionTable_{game}:")
                data_lines.append("")

        elif line:
            data_lines[-1] += "\t" + line + "\n"
            data_val_count += line.count("$")*(
                1 if line.startswith(".db") else
                2 if line.startswith(".dw") else
                0
                )
            if data_val_count not in (0, 16, 32):
                raise ValueError(
                    f"Unexpected collision type byte count: {data_val_count}\n"
                    "Cannot merge objectCollisionTables."
                    )
            elif data_val_count == 32:
                data_lines.append("")
                data_val_count = 0

    new_data += "\n".join([
        data_lines[i+1] for i in (-1, *mapping)
        ])
    new_data += "\n\n"

with open(outputDir + "/objectCollisionTable.s", "w") as f:
    f.write(new_data)



with open(agesDataDir + "/enemyData.s") as f:
    ages_data = f.read()
with open(seasonsDataDir + "/enemyData.s") as f:
    seasons_data = f.read()


new_data = ""
for mapping, data, game in [
        (remapped_ages,    ages_data,    "ages"),
        (remapped_seasons, seasons_data, "seasons"),
        ]:
    data_lines = []
    for line in data.split("\n"):
        if ("SubidData" in line and line[0] != ";" and
            "m_EnemySubidData" not in line):
            line = line.replace("SubidData", f"SubidData_{game}")

        if "extraEnemyData" in line and line[0] != ";":
            line = line.replace("extraEnemyData", f"extraEnemyData_{game}")

        line_orig = line
        line = line.strip()

        if line.startswith("enemyData:"):
            data_lines.append(f"enemyData_{game}:")
            data_lines.append("")

        elif "m_EnemyData" in line:
            line_parts = line.replace("\t", " ").split(" ")
            coll_idx  = line_parts.index("m_EnemyData") + 2
            coll_mode = eval(line_parts[coll_idx].replace("$", "0x"))
            coll_mode = (coll_mode&0x80) | (mapping[coll_mode&0x7f])

            line_parts[coll_idx] = f"${coll_mode:02x}"
            data_lines[-1] += "\t%s\n" % " ".join(line_parts)
        else:
            data_lines.append(line_orig)


    new_data += "\n".join(data_lines)
    new_data += "\n\n"

with open(outputDir + "/enemyData.s", "w") as f:
    f.write(new_data)


with open(agesDataDir + "/partData.s") as f:
    ages_data = f.read()
with open(seasonsDataDir + "/partData.s") as f:
    seasons_data = f.read()

new_data = ""
for mapping, data, game in [
        (remapped_ages,    ages_data,    "ages"),
        (remapped_seasons, seasons_data, "seasons"),
        ]:
    data_lines = []
    for line in data.split("\n"):
        line_orig = line
        line = line.strip()

        if line.startswith("partData:"):
            data_lines.append(f"partData_{game}:")
            data_lines.append("")

        elif ".db" in line:
            line_parts = line.replace("\t", " ").split(" ")
            coll_idx  = line_parts.index(".db") + 2
            coll_mode = eval(line_parts[coll_idx].replace("$", "0x"))
            coll_mode = (coll_mode&0x80) | (mapping[coll_mode&0x7f])

            line_parts[coll_idx] = f"${coll_mode:02x}"
            data_lines[-1] += "\t%s\n" % " ".join(line_parts)
        else:
            data_lines.append(line_orig)


    new_data += "\n".join(data_lines)
    new_data += "\n\n"

with open(outputDir + "/partData.s", "w") as f:
    f.write(new_data)


new_data = f".enum 0\n"
for i in range(max(len(ages_types_new),
                   len(seasons_types_new))
               ):
    enum_name = ""
    if i in range(len(ages_types_new)):
        enum_name = ages_types_new[i]

    if i >= len(types_new) and i in range(len(seasons_types_new)):
        if enum_name:
            new_data += f"\t{enum_name}\t.db ; ${i:02x}\n"

        enum_name = seasons_types_new[i]

    new_data += f"\t{enum_name}\tdb ; ${i:02x}\n"


new_data += ".ende"
with open(outputDir + "/enemyCollisionModes.s", "w") as f:
    f.write(new_data)
