if [ $# -ne 1 ]; then
    echo "USAGE: bash $0 PROJECTS_FILE"
    exit
fi

PROJECTS_FILE=$1

SCRIPT_DIR=$( cd $( dirname $0 ) && pwd )
TRACES_DIR=${SCRIPT_DIR}/project-traces
WORKDIR=${SCRIPT_DIR}/ws/javert
mkdir -p ${WORKDIR}

bash ${SCRIPT_DIR}/obtain-traces.sh ${PROJECTS_FILE}

while read url sha name; do
    (
        cd ${WORKDIR}
        if [ -f ${TRACES_DIR}/${name}/all-tests.txt.gz ]; then
            javert_traces_file=${TRACES_DIR}/${name}/all-tests.txt
            out=${WORKDIR}/gol-javert-${name}
            if [ ! -f ${javert_traces_file} ]; then
                ( gunzip -c ${TRACES_DIR}/${name}/all-tests.txt.gz ) > ${javert_traces_file}
            fi
            timeout 100m java -jar ${SCRIPT_DIR}/javert.jar -flat ${javert_traces_file} &> ${out}
            echo "[javert.sh] Wrote Javert spec mining results to ${out}"
        fi
    )
done < ${PROJECTS_FILE}



