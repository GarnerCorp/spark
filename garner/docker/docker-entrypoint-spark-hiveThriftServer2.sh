#!/usr/bin/env bash

echo "spark-hive-entrypoint-88"

if [[ -z ${LIGHTHOUSE_URL} ]]; then
 export LIGHTHOUSE_URL=TEST_LIGHTHOUSE_INTERNAL_BACKEND_PORT
fi

/bin/bash $SPARK_HOME/sbin/start-thriftserver.sh --total-executor-cores 2 --master $SPARK_MASTER_URL --hiveconf javax.jdo.option.ConnectionURL="jdbc:derby:;databaseName=$SPARK_HOME/metastore_db;create=true"
exec tail -f $SPARK_HOME/logs/*org.apache.spark.sql.hive.thriftserver.HiveThriftServer*.out

