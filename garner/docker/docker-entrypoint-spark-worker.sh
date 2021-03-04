#!/usr/bin/env bash
echo "spark-worker-entrypoint-mar3"
/bin/bash $SPARK_HOME/sbin/start-slave.sh $SPARK_MASTER_URL
exec tail -f $SPARK_HOME/logs/*org.apache.spark.deploy.worker*.out
