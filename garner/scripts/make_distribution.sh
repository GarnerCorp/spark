#!/usr/bin/env bash
source ${0:a:h}/garner.env

/bin/bash ${SPARK_PARENT_LOCATION}/dev/make-distribution.sh  --name garner-spark --tgz -Phive -Phive-thriftserver -Pmesos -Pyarn -Pkubernetes -Pscala-2.13;
wait
echo "Removing old distrubution"
rm -r ${0:a:h}/../../garner/dist
wait
echo "Copying new distribution"
cp -r  ${0:a:h}/../../dist ${0:a:h}/../../garner
wait
echo "Copying in conf"
cp -r  ${0:a:h}/../conf ${0:a:h}/../../garner/dist
