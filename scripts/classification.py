'''
This classification script separates mined specifications into either:
Persistent, the specification stays during the entirety of the repos lifespan
Intermittent, the specification appears and disappears at different stages
Disappearing, the specification appears at a single stage and disappears for the rest
'''

import os
import re
import random
from pathlib import Path

'''Lookup table for each spec and its respective miner'''
b_table = {'BDD': None}
j_table = {'Javert': None}
t_table = {'Texada': None}
d_dable = {'Dice': None}

spec_table = [{"persistent": None},
				{"intermittent": None},
				{"disappearing": None}]

''' BDD file analysis'''


def bdd_filter(file):
	spec = []
	filename = os.path.dirname(file).split("/")[-1]
	with open(file, "r") as f:
		for line in f:
			if ("Pattern:" in line):
				spec.append([line.strip()])
				spec[-1].append(filename)
			elif ("a = " in line) or ("b = " in line) or ("c = " in line):
				spec[-1].append(line.strip())
	return spec

def javert_filter(file): # will need to count parens and append pattern
	filename = re.sub(r'gol-javert-', '', file.split("/")[-1])
	specs = []
	with open(file, "r") as f:
		for line in f:
			if ("Specification") in line:
				# if (not specs): #some spec has just been completed
				# 	pat_str = "pattern (ab*c)*" if specs[-1].count("(") > 1 else "pattern (ab)*"
				# 	specs[-1].insert(0,pat_str) #prepend with pattern as in bdd
				# 	# currently not including pattern string bc info is encoded in string
				specs.append([])
				specs[-1].append(filename)
			elif ("(" in line) or (")" in line):
				specs[-1].append(line.strip())
	# print(f"specs: {specs}")
	return specs


# outputs hashable string list where first two are pattern, folder #

'''Control flow for each miner'''

def fractional_pred(analysis_func, full_number=52, partial_number = 40):
	full_set = analysis_func(full_number, False)
	# persisent_full_set = {k for k,v in full_set.items() if len(v) >= full_number}
	# partial_set = analysis_func(partial_number, False)
	# persisent_partial_set = {k for k,v in partial_set.items() if len(v) >= partial_number}
	# successful_infers = {spec for spec in persisent_partial_set if spec in persisent_full_set}
	# print(f"successful infers: {len(successful_infers)}")
	# print(f"num of persistent specs at {partial_number} commits: {len(persisent_partial_set)}")


def bdd_analysis(num_commits, random):
	'''Setup initial table value for BDD'''
	specs_dirs = f'../miners/ws/bdd-3'
	# Get base name for the repository, this repo can be chosen randomly
	# repo = re.sub(
	# 	r'[0-9]', '', random.choice(os.listdir(specs_dirs)))
	# b_table['BDD'] = {repo: None}
	# b_table['BDD'][repo] = spec_table
	spec_presence = {}
	selected_commits = os.listdir(specs_dirs)[:num_commits] \
		if not random else random.sample(os.listdir(specs_dirs), num_commits) 
	for specs_d in selected_commits:
		# pattern = re.sub(r'[0-9]', '', specs_d)
		# if (repo == pattern):
		# 	pass
		# else:
		# 	repo = pattern
		# 	b_table['BDD'][repo] = spec_table
		specs_loc = f'../miners/ws/bdd-3/{specs_d}'
		for s in os.listdir(specs_loc):
			filt = bdd_filter(f'{specs_loc}/{s}')
			print(len(filt))
			for line in filt:
				filename = line[1]
				rel_commit_number = re.search(r'\d+', filename).group()
				line.remove(filename)
				string_spec = ' '.join(line)
				if string_spec in spec_presence:
					spec_presence[string_spec].append(rel_commit_number)
				else:
					spec_presence[string_spec] = [rel_commit_number]
	# print(spec_presence)
	persistent_specs = list(filter(lambda x: len(x) > 51, spec_presence.values()))
	# print(reappearing_specs)
	# print(len(reappearing_specs))
	return spec_presence


def javert_analysis(num_commits, random):
	specs_dir = f'../miners/ws/javert'
	# Get base name for the repository, this repo can be chosen randomly
	# repo = re.sub(
	#     r'[0-9]', '', re.sub(r'gol-javert-', '', random.choice(os.listdir(specs_dir))))
	selected_commits = os.listdir(specs_dir)[:num_commits] \
		if not random else random.sample(os.listdir(specs_dir), num_commits)
	spec_presence = {}
	for spec_file in selected_commits:
		for line in javert_filter(f"{specs_dir}/{spec_file}"):
			filename = line[0] # pattern variable not currently inserted
			rel_commit_number = re.search(r'\d+', filename).group()
			line.remove(filename)
			string_spec = ' '.join(line)
			if string_spec in spec_presence:
				spec_presence[string_spec].append(rel_commit_number)
			else:
				spec_presence[string_spec] = [rel_commit_number]
	# print(f"spec pres: {spec_presence}")
	# persistent_specs = list(filter(lambda x: len(x) > 51, spec_presence.values()))
	# print(persistent_specs)
	# print(len(persistent_specs))
	return spec_presence


def texada_analysis():
	return None


def dice_analysis():
	return None


'''Output each table with categorized data'''
# bdd_analysis()
# fractional_pred(bdd_analysis)
# javert_analysis()
for i in range(1, 10, 1):
	fractional_pred(javert_analysis, partial_number=i)
print("bdd analysis")
# for i in range(1, 10, 1):
fractional_pred(bdd_analysis, partial_number=i)
texada_analysis()
dice_analysis()
