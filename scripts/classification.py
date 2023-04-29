# This classification script separates mined specifications into either:
# Persistent, the specification stays during the entirety of the repos lifespan
# Intermittent, the specification appears and disappears at different stages
# Disappearing, the specification appears at a single stage and disappears for the rest

import os

miner_dir = input("Please specify the miner specs you wish to classify (b/j/t/d): ")

if (miner_dir.lower() == "b"):
  # commit = 0
  specs_dirs = f'../miners/ws/bdd-3'
  for specs_d in os.listdir(specs_dirs):
    specs_loc = f'../miners/ws/bdd-3/{specs_d}'
    for s in os.listdir(specs_loc):
      f = open(f'{specs_loc}/{s}', 'r')
      f.read()
      # keep track of files for debugging
      # commit += 1
      # if(commit % 3 == 0):
      #   print('---')
      # else:
      #   print(s)
elif (miner_dir.lower() == "j"):
  print("")