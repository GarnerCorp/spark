#!/usr/bin/env bash
export DUMMY_EXTERNALS_LOCATION=$SPARK_HOME/externals
#export SPARK_HOME=/opt/spark

/bin/bash $SPARK_HOME/work-dir/scripts/start_custom.sh
wait
echo sleeping 20s, waiting for hiveserver2 to get its s**t together
sleep 10s
echo sleeping 10s, waiting for hiveserver2 to get its s**t together
sleep 10s
wait
/bin/bash $SPARK_HOME/work-dir/scripts/make_metadata.sh
wait
/bin/bash $SPARK_HOME/work-dir/scripts/make_metadata_testing.sh

exec tail -f $SPARK_HOME/logs/*org.apache.spark.sql.hive.thriftserver.HiveThriftServer*.out
