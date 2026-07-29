#!/usr/bin/python3
import hashlib
import os
import shutil
import sys

if len(sys.argv) < 3:
    print('Usage: ' + sys.argv[0] + 'binaryFile hashFile')
    sys.exit(1)

inp_fp = sys.argv[1]
out_fp = sys.argv[2]

with open(inp_fp, 'rb') as f:
    # prepending "aa" to ensure hash value doesnt begin with an integer
    hash_digest = "aa"+(hashlib.sha3_224(f.read()).hexdigest()[:20])

hash_file_output_path   = out_fp
hashed_file_output_path = os.path.join(
    os.path.dirname(out_fp),
    "%s.cmp" % hash_digest
    )
with open(hash_file_output_path, 'w') as f:
    # NOTE: we're still writing this file since it would be complex to
    #       do this check in the makefile, and this file is specified
    #       as a target, so it existing is kinda required for the build
    f.write(hash_digest.lower()+"\n")

game_prefix, filename = os.path.basename(out_fp).split("_", 1)
if game_prefix.lower() in ("ages", "seasons"):
    # This is a file located in either the ages or seasons game
    # folder instead of the common one. In most cases we can go
    # without prefixing the game to the filename since the name
    # is usually unique to that game, which simplifies code a lot.
    # to that end, we're creating another hashfile without the
    # prefix, but if it's used or not is determined by the linker
    hash_file_output_path = os.path.join(os.path.dirname(out_fp), filename)
    with open(hash_file_output_path, 'w') as f:
        f.write(hash_digest.lower()+"\n")

shutil.copyfile(inp_fp, hashed_file_output_path)
