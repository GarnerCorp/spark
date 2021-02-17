#!/usr/bin/env zsh

/bin/bash $SPARK_HOME/sbin/start-master.sh --host 0.0.0.0
/bin/bash $SPARK_HOME/sbin/start-slave.sh spark://localhost:7077
/bin/bash $SPARK_HOME/sbin/start-thriftserver.sh --total-executor-cores 2 --master spark://localhost:7077 --hiveconf javax.jdo.option.ConnectionURL="jdbc:derby:;databaseName=$SPARK_HOME/metastore_db;create=true"


# see package org.apache.spark.sql.hive.client.HiveClientImpl for why we need to set javax.jdo.option.ConnectionURL.
# otherwise spark will put the metastore_db somewhere else on your computer depending on local settings, env whether there is a Hadoop_home set or
# or some other stupid place like a toddler leaving its jacket on the ground in the entranceway. Usually at the ~/ level.

#--hiveconf hive.aux.jars.path=file:///opt/lib/custom-udfs.jar

