CONDA_DIR=${HOME}/conda

if [ ! -d ${CONDA_DIR} ]; then
    # Install miniconda
    wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && /bin/bash ~/miniconda.sh -b -p ~/conda
fi

