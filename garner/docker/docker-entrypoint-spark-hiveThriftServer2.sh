#!/usr/bin/env bash

echo "spark-hive-entrypoint-88"

#TODO is this used? check and remove if not
if [[ -z ${LIGHTHOUSE_URL} ]]; then
 export LIGHTHOUSE_URL=TEST_LIGHTHOUSE_INTERNAL_BACKEND_PORT
fi

/bin/bash $SPARK_HOME/sbin/start-thriftserver.sh --total-executor-cores 2 --master $SPARK_MASTER_URL \
  --hiveconf javax.jdo.option.ConnectionURL=$SPARK_METASTORE_URL \
  --hiveconf javax.jdo.option.ConnectionUserName=$METASTORE_USER \
  --hiveconf javax.jdo.option.ConnectionPassword=$METASTORE_PASSWORD \
  --hiveconf hive.server2.thrift.http.port=$HIVE_SERVER_PORT

exec tail -f $SPARK_HOME/logs/*org.apache.spark.sql.hive.thriftserver.HiveThriftServer*.out


