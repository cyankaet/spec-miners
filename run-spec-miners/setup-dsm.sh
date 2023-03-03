#!/bin/bash

### REQUIRED:
###  Make sure you install conda (https://docs.conda.io/en/latest/miniconda.html)
###  This script was tested on conda version 4.12.0 ($> conda --version)

# clone the repo, cd into it
# git clone git@github.com:hvdthong/DSM.git
cd DSM
# create python environment, activate it, and install packages on it
conda update -y conda
conda create -y --name dsm
source activate dsm
conda install -y -c jjhelmus tensorflow=0.12.0
conda install -y graphviz python-graphviz scikit-learn
# # test DSM on a sample
# cd data/StringTokenizer
# bash execute.sh # will take ~3m (if you don't have a GPU enabled machine)
# # show generated FSM
# cat work_dir/FINAL_mindfa.txt
