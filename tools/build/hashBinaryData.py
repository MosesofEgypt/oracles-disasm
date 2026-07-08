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

with open(out_fp, 'w') as f:
    f.write(hash_digest.lower()+"\n")

hash_file_output_path = os.path.join(
    os.path.dirname(out_fp),
    "%s.cmp" % hash_digest
    )
shutil.copyfile(inp_fp, hash_file_output_path)
