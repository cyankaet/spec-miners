if [ $# -ne 1 ]; then
    echo "USAGE: bash $0 PROJECTS_FILE"
    exit
fi

PROJECTS_FILE=$1

SCRIPT_DIR=$( cd $( dirname $0 ) && pwd )
TRACES_DIR=${SCRIPT_DIR}/project-traces
WORKDIR=${SCRIPT_DIR}/ws
mkdir -p ${TRACES_DIR}
mkdir -p ${WORKDIR}

SKIPS=" -Dcheckstyle.skip -Drat.skip -Denforcer.skip -Danimal.sniffer.skip -Dmaven.javadoc.skip -Dfindbugs.skip -Dwarbucks.skip -Dmodernizer.skip -Dimpsort.skip -Dpmd.skip -Dxjc.skip -Djacoco.skip=true -Dmaven.plugin.skip"

# clone the project and checkout the correct sha
while read url sha name; do
    out_dir=${TRACES_DIR}/${name}
    if [ -d ${out_dir} ]; then
        echo "[obtain-traces.sh] Traces from ${name} exist, skipping..."
        continue
    fi
    if [ ! -d ${WORKDIR}/${name} ]; then
        (
            cd ${WORKDIR}
            git clone ${url} ${name}
        )
    fi
    (
        cd ${WORKDIR}/${name}
        git checkout ${sha}
        # run methodtracer to obtain traces
        mvn test ${SKIPS} -DargLine="-javaagent:${SCRIPT_DIR}/methodtracer.jar=all-tests@trace.include=*;instrument.include=*"
        cp -r traces ${out_dir}
    )
    echo "[obtain-traces.sh] Traces from ${name} are written to ${out_dir}"
    gunzip ${out_dir}/*.gz
done < ${PROJECTS_FILE}
