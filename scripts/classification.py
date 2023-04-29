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

spec_table = [{"persistent": None},
			  {"intermittent": None},
			  {"disappearing": None}]


'''Control flow for each miner'''
def bdd_analysis():
	'''Setup initial table value for BDD'''
	specs_dirs = f'../miners/ws/bdd-3'
	# Get base name for the repository, this repo can be chosen randomly
	repo = re.sub(
		r'[0-9]', '', random.choice(os.listdir(specs_dirs)))
	b_table['BDD'] = {repo: None}
	b_table['BDD'][repo] = spec_table
	for specs_d in os.listdir(specs_dirs):
		pattern = re.sub(r'[0-9]', '', specs_d)
		if (repo == pattern):
			pass
		else:
			repo = pattern
			b_table['BDD'][repo] = spec_table
		specs_loc = f'../miners/ws/bdd-3/{specs_d}'
		for s in os.listdir(specs_loc):
			f = open(f'{specs_loc}/{s}', 'r')
	print(b_table)
	return b_table

def javert_analysis():
	return None

def texada_analysis():
	return None

def dice_analysis():
	return None


'''Output each table with categorized data'''
bdd_analysis()
javert_analysis()
texada_analysis()
dice_analysis()