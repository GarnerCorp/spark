#!/usr/bin/env bash
echo "Copying new distribution"
cp -r  ${SPARK_PARENT_LOCATION}/dist ${SPARK_PARENT_LOCATION}/garner
wait
echo "Copying in conf"
cp -r  ${SPARK_PARENT_LOCATION}/conf ${SPARK_PARENT_LOCATION}/garner/dist