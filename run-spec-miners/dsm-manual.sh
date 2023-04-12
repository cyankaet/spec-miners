CONDA_DIR=${HOME}/conda

if [ $# -ne 1 ]; then
    echo "USAGE: bash $0 PROJECTS_FILE"
    echo "NOTE: You will need conda in ${CONDA_DIR} before running this script"
    echo "To do so, you can run setup-conda.sh"
    exit
fi

PROJECTS_FILE=$1

SCRIPT_DIR=$( cd $( dirname $0 ) && pwd )
TRACES_DIR=${SCRIPT_DIR}/project-traces
WORKDIR=${SCRIPT_DIR}/ws/dsm-manual
DSM=${SCRIPT_DIR}/DSM
mkdir -p ${WORKDIR}

bash ${SCRIPT_DIR}/obtain-traces.sh ${PROJECTS_FILE}

# Put conda in path so we can use conda activate
export PATH=$CONDA_DIR/bin:$PATH

function clone_resource() {
    local proj_dir=${SCRIPT_DIR}/$1
    local proj_url=$2
    if [ ! -d ${proj_dir} ]; then
	echo "cloning directory ${proj_dir}"
	git clone ${proj_url} ${proj_dir} &> /dev/null
    else
	echo "pulling from directory ${proj_dir}"
	(
	    cd ${proj_dir}
	    git pull &> /dev/null
	)
    fi
}

# setup for dsm conda environment
cd ${SCRIPT_DIR}
clone_resource DSM git@github.com:hvdthong/DSM.git
bash ${SCRIPT_DIR}/setup-dsm.sh

while read url sha name; do
    (
        cd ${WORKDIR}
        if [ -f ${TRACES_DIR}/${name}/all-tests.txt.gz ]; then
            log=${WORKDIR}/gol-dsmManual-${name}
            OUT=${WORKDIR}/${name}
            mkdir -p ${OUT}
            dsm_traces_dir=${WORKDIR}/dsm-traces-${name}
            python3 ${SCRIPT_DIR}/convert-dsi-trace-to-dsm-trace.py ${TRACES_DIR}/${name}/ ${dsm_traces_dir}
            for clz in $( ls ${dsm_traces_dir} | grep -v ^java | grep -v ^org.apache.maven | grep -v org.junit ); do
                cdir=${dsm_traces_dir}/${clz}
                source activate dsm
                ( time timeout 2h python3 ${DSM}/DSM.py --data_dir ${cdir}/input_traces --save_dir ${cdir}/saved_model --work_dir ${cdir}/work_dir ) &> ${log}
                if [ -f ${cdir}/work_dir/FINAL_mindfa.txt ]; then
                    cp ${cdir}/work_dir/FINAL_mindfa.txt ${OUT}/${clz}_model.txt
                    cp ${cdir}/work_dir/FINAL_mindfa.eps ${OUT}/${clz}_model.eps
                else
                    echo "DSM did not produce a model for class ${clz}!"
                fi
            done
            echo "[$0] Wrote DSM-Manual spec mining results to directory ${OUT}"
        fi
    )
done < ${PROJECTS_FILE}
