if [ $# -ne 1 ]; then
    echo "USAGE: bash $0 PROJECTS_FILE"
    exit
fi

PROJECTS_FILE=$1

SCRIPT_DIR=$( cd $( dirname $0 ) && pwd )
TRACES_DIR=${SCRIPT_DIR}/project-traces
WORKDIR=${SCRIPT_DIR}/ws/bdd-3
mkdir -p ${WORKDIR}

PATTERNS=("(ab*c)*" "(a+b*c+)?" "(a+b*c+)*") # some three letter regex patterns

bash ${SCRIPT_DIR}/obtain-traces.sh ${PROJECTS_FILE}

while read url sha name; do
    (
        cd ${WORKDIR}
        if [ -f ${TRACES_DIR}/${name}/all-tests.txt.gz ]; then
            bdd_traces_file=${TRACES_DIR}/${name}/all-tests-processed.txt
            bdd_dir=${WORKDIR}/${name}
            mkdir -p ${bdd_dir}
            if [ ! -f ${bdd_traces_file} ]; then
                ( gunzip -c ${TRACES_DIR}/${name}/all-tests.txt.gz | cut -d' ' -f3 ) > ${bdd_traces_file}
            fi
            for pattern in ${PATTERNS[@]}; do
                pattern_filename=$( echo "${pattern}" | sed 's/\*/s/g' | sed 's/?/q/g' )
                ( timeout 100m java -jar ${SCRIPT_DIR}/bddminer.jar -mine "${pattern}" ${bdd_traces_file} ) &> ${bdd_dir}/gol-bdd-${pattern_filename}
                echo "[$0] Wrote BDD-3 spec mining results for pattern ${pattern} to ${bdd_dir}/gol-bdd-${pattern_filename}"
            done
        fi
    )
done < ${PROJECTS_FILE}
