#!/usr/bin/env zsh
echo "Copying in conf"
cp -r  ${0:a:h}/../conf ${0:a:h}/../../garner/dist
/bin/bash $SPARK_HOME/sbin/start-master.sh --host 0.0.0.0
/bin/bash $SPARK_HOME/sbin/start-slave.sh spark://localhost:7077
/bin/bash $SPARK_HOME/sbin/start-thriftserver.sh --total-executor-cores 2 --master spark://localhost:7077 \
    --hiveconf javax.jdo.option.ConnectionURL=$SPARK_METASTORE_URL \
    --hiveconf javax.jdo.option.ConnectionUserName=$METASTORE_USER \
    --hiveconf javax.jdo.option.ConnectionPassword=$METASTORE_PASSWORD \
    --hiveconf hive.server2.thrift.http.port=$HIVE_SERVER_PORT

#--hiveconf javax.jdo.option.ConnectionURL="jdbc:derby:;databaseName=$SPARK_HOME/metastore_db;create=true"
#--hiveconf javax.jdo.option.ConnectionURL= "jdbc:postgresql://localhost:5432/postgres?createDatabaseIfNotExist=true;autoReconnect=true;useSSL=false"

# see package org.apache.spark.sql.hive.client.HiveClientImpl for why we need to set javax.jdo.option.ConnectionURL.
# otherwise spark will put the metastore_db somewhere else on your computer depending on local settings, env whether there is a Hadoop_home set or
# or some other stupid place like a toddler leaving its jacket on the ground in the entranceway. Usually at the ~/ level.

#--hiveconf hive.aux.jars.path=file:///opt/lib/custom-udfs.jar

