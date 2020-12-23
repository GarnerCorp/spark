#!/usr/bin/env bash
/bin/bash ../bin/beeline <<EOF
!connect jdbc:hive2://localhost:10001/default?hive.server2.transport.mode=http;hive.server2.thrift.http.path=cliservice;
help
me
DROP TABLE IF EXISTS default.dummy_base;
CREATE EXTERNAL TABLE dummy_base (Value STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE location  '$SPARK_HOME/externals';
SELECT * FROM dummy_base;
EOF
