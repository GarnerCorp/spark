#!/usr/bin/env bash

source ${0:a:h}/garner.env
echo "Removing old distrubution"
rm -r ${0:a:h}/../../garner/dist
echo "Copying new distribution"
cp -r  ${SPARK_PARENT_LOCATION}/dist ${SPARK_PARENT_LOCATION}/garner
wait
echo "Copying in postgresql"
cp -r  ${SPARK_PARENT_LOCATION}/garner/postgres-jar-hack/* ${SPARK_PARENT_LOCATION}/garner/dist/jars
wait
echo "Copying in conf"
cp -r  ${SPARK_PARENT_LOCATION}/garner/conf ${SPARK_PARENT_LOCATION}/garner/dist