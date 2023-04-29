'''
This classification script separates mined specifications into either:
Persistent, the specification stays during the entirety of the repos lifespan
Intermittent, the specification appears and disappears at different stages
Disappearing, the specification appears at a single stage and disappears for the rest
'''

import os
import re
import random

'''Lookup table for each spec and its respective miner'''
b_table = {'BDD': None}
j_table = {'Javert': None}
t_table = {'Texada': None}
d_dable = {'Dice': None}

'''Control flow for each miner'''
miner_dir = input(
	"Please specify the miner specs you wish to classify (b/j/t/d): ")

if (miner_dir.lower() == "b"):
	'''Setup initial table value for BDD'''
	specs_dirs = f'../miners/ws/bdd-3'
  # Get base name for the repository, this can be random
	repo = re.sub(r'[0-9]', '', random.choice(os.listdir(specs_dirs)))
	b_table['BDD'] = {repo: None}
	b_table['BDD'][repo] = [{"persistent": None},
								 {"intermittent": None},
								 {"disappearing": None}]
	# commit = 0
	for specs_d in os.listdir(specs_dirs):
		specs_loc = f'../miners/ws/bdd-3/{specs_d}'
		for s in os.listdir(specs_loc):
			f = open(f'{specs_loc}/{s}', 'r')

			# keep track of files for debugging
			# commit += 1
			# if(commit % 3 == 0):
			#   print('---')
			# else:
			#   print(s)
elif (miner_dir.lower() == "j"):
	print("")
