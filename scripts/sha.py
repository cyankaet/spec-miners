import sys
import os
import subprocess
from functools import reduce

git_url = sys.argv[1]
base_name = sys.argv[2]
num_commits = sys.argv[3] # ALL if all committs

scripts_dir = os.path.abspath(os.getcwd())

os.chdir("../..")
if (base_name not in os.listdir()):
	subprocess.run(["git", "clone", git_url, base_name])

os.chdir(f"./{base_name}")
log = subprocess.run(
    ["git", "log", "--pretty=%H"], encoding="UTF-8", capture_output=True)

# split on tabs and lines and remove the SHA names
shas = list(log.stdout.split('\n'))[:-1] 
print(shas)
print(len(shas))

os.chdir(scripts_dir)

if (num_commits != "ALL"):
	num_commits = int(num_commits)
else:
	num_commits = len(shas)

sha_file = open(f"../miners/repos/{base_name}-sha-{str(num_commits)}.txt", "w+")

for i in range(num_commits):
	sha_file.write(f"{git_url} {shas[i]} {base_name + str(i)}\n")

sha_file.close()
