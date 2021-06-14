#!/usr/bin/env bash

source ${0:a:h}/garner.env
echo "Removing old distrubution"
rm -r ${0:a:h}/../../garner/dist
echo "Removeing logback-classic"
rm ${SPARK_PARENT_LOCATION}/dist/jars/logback-classic-*.jar
wait
echo "Removeing spark-sql_2.13-1.0.jar"
rm ${SPARK_PARENT_LOCATION}/dist/jars/spark-sql_2.13-1.0.jar
wait
echo "Removeing	spark-sql_2.13-1.0.jar"
rm ${SPARK_PARENT_LOCATION}/dist/jars/spark-core_2.13-1.0.jar
wait
echo "Copying new distribution"
cp -r  ${SPARK_PARENT_LOCATION}/dist ${SPARK_PARENT_LOCATION}/garner
wait
echo "Copying in postgresql"
cp -r  ${SPARK_PARENT_LOCATION}/garner/postgres-jar-hack/* ${SPARK_PARENT_LOCATION}/garner/dist/jars
wait
echo "Copying in conf"
cp -r  ${SPARK_PARENT_LOCATION}/garner/conf ${SPARK_PARENT_LOCATION}/garner/dist
