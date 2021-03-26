#!/usr/bin/env zsh
source ${0:a:h}/garner.env
# To be used when csv tables have been mounted to the containers under opt/bitnami/spark/externals
/bin/bash $SPARK_HOME/bin/beeline <<EOF
!connect jdbc:hive2://localhost:$HIVE_SERVER_PORT/default?hive.server2.transport.mode=http;hive.server2.thrift.http.path=cliservice;
$LOCAL_AUTH_EMAIL
$LOCAL_AUTH_PASSWORD
DROP TABLE IF EXISTS default.dummy_base;
CREATE EXTERNAL TABLE dummy_base (Value STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE location  '$DUMMY_EXTERNALS_LOCATION';

DROP FUNCTION IF EXISTS default.materialIsAt_func;
create function materialIsAt_func as 'com.garnercorp.udfs.views.materialIsAt.MaterialIsAtTable';
DROP VIEW IF EXISTS default.materialIsAt;
CREATE VIEW materialIsAt AS SELECT materialIsAt_func(Value) FROM dummy_base;


EOF

