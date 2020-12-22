#!/usr/bin/env bash

/bin/bash $SPARK_HOME/sbin/start-master.sh --host 0.0.0.0
/bin/bash $SPARK_HOME/sbin/start-slave.sh spark://localhost:7077
/bin/bash $SPARK_HOME/sbin/start-thriftserver.sh --total-executor-cores 2 --master spark://localhost:7077 --hiveconf testArg="guug"

#--hiveconf hive.aux.jars.path=file:///opt/lib/custom-udfs.jar

