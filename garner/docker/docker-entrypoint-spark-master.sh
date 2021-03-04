#!/usr/bin/env bash

echo "spark-master-entrypoint-mar3"

/bin/bash $SPARK_HOME/sbin/start-master.sh --host 0.0.0.0

exec tail -f $SPARK_HOME/logs/*org.apache.spark.deploy.master*.out
