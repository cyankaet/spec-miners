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
	base_name=$(echo $name | tr -d '[:digit:]')
	out_dir=${TRACES_DIR}/${name}
	if [ -d ${out_dir} ]; then
		echo "[obtain-traces.sh] Traces from ${name} exist, skipping..."
		continue
	fi
	(
		cd ${WORKDIR}/${base_name}
		# Checkout the working directory for an evolution 
		# TODO: src might change depending on the repository (maybe just get all directories?)
		git checkout ${sha} -- src/

		# Get the tests that change for a given evolution
		# !WARNING: ALWAYS MAKE SURE THE REPOSITORY IS CLEAN (mvn starts:clean)
		export JDK_JAVA_OPTIONS=-Djdk.attach.allowAttachSelf=true
		mvn starts:select > ../incremental_tests/tests_$name.txt
		grep "INFO: org." ../incremental_tests/tests_$name.txt | sed 's/INFO: //g' > ../incremental_tests/parsedtests_$name.txt
		mvn starts:run

		# TODO: Run methodtracer to obtain traces from the diff set of tests
		mvn test ${SKIPS} -DargLine="-javaagent:${SCRIPT_DIR}/methodtracer.jar=all-tests@trace.include=*;instrument.include=*"
		if [ ! -d traces ]; then 
			mkdir traces 
			cp -r traces ${out_dir}
		else (
			cp -r traces ${out_dir}
		)
        fi
	)
	echo "[obtain-traces.sh] Traces from ${name} are written to ${out_dir}"
done < ${PROJECTS_FILE}
