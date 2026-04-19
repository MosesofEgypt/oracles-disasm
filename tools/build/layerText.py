#!/usr/bin/python3
import sys
import os
import io
import yaml

if len(sys.argv) < 5:
    print('Usage: ' + sys.argv[0] + ' baseYaml yamlsDir gameYamlsDir outFile [reduxDefines]')
    print('baseYaml: the base text yaml to layer onto.')
    print('yamlsDir: the dir containing the game-independent yaml layers.')
    print('gameYamlsDir: the dir containing the game-specific yaml layers.')
    print('outFile: the file to dump the layered yaml to.')
    print('reduxDefines: string of defines specifying what redux features are enabled.')
    sys.exit(1)

baseYaml       = sys.argv[1]
yamlsDir       = sys.argv[2]
gameYamlsDir   = sys.argv[3]
outFilepath    = sys.argv[4]
defines        = [
    define.strip() for define in
    " ".join(sys.argv[5:]).replace("-D ", " ").split(" ")
    if define
    ]

yaml_layers = [baseYaml]

if "ENABLE_REDUX_EXTRAS" in defines or "ENABLE_GASHA_REBALANCE" in defines:
    yaml_layers.append(os.path.join(gameYamlsDir, "gasha_price_text.yaml"))

if "RESIZE_RING_BOX":
    yaml_layers.append(os.path.join(yamlsDir, "ring_box_text.yaml"))

if "ENABLE_RING_REDUX":
    yaml_layers.append(os.path.join(yamlsDir, "ring_text.yaml"))

layered_data = None
for filename in yaml_layers:
    with open(filename) as f:
        data = yaml.safe_load(f)
        if layered_data is None:
            layered_data = data
            continue

    for src_group in data["groups"]:
        for dst_group in layered_data["groups"]:
            if src_group["group"] != dst_group["group"]:
                continue

            for src_data in src_group["data"]:
                data_inserted = False
                for dst_data in dst_group["data"]:
                    if src_data["name"] != dst_data["name"]:
                        continue

                    dst_data["text"] = src_data["text"]
                    data_inserted = True

                if not data_inserted:
                    dst_group["data"].append(src_data)

with open(outFilepath, 'w') as f:
    yamlData = yaml.dump(layered_data, allow_unicode=True)
    f.write(yamlData)
