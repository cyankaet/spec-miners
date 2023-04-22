import sys
import subprocess
from functools import reduce

git_url = sys.argv[1]
base_name = sys.argv[2]

log = subprocess.run(
    ["git","ls-remote", git_url], encoding="UTF-8", capture_output=True)

# split on tabs and lines and remove the SHA names
shas = list(reduce(lambda a, s: a + s.split('\t'), log.stdout.split('\n')[:-1], []))[::2]

sha_file = open(f"{base_name}-sha.txt", "w+")
for i in range(31):
    sha_file.write(f"{git_url} {shas[i]} {base_name + str(i)}\n")

sha_file.close()
