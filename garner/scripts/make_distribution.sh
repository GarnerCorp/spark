#!/usr/bin/env bash
source ${0:a:h}/garner.env

/bin/bash ${SPARK_PARENT_LOCATION}/dev/make-distribution.sh  --name garner-spark --tgz -Phive -Phive-thriftserver -Pmesos -Pyarn -Pkubernetes -Pscala-2.13;
wait
echo "Removing old distrubution"
rm -r ${0:a:h}/../../garner/dist
wait
/bin/bash ${0:a:h}/copy_files_in.sh
