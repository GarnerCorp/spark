#!/usr/bin/env bash
/bin/bash $SPARK_HOME/bin/beeline <<EOF
!connect jdbc:hive2://localhost:10001/default?hive.server2.transport.mode=http;hive.server2.thrift.http.path=cliservice;
help
me
DROP TABLE IF EXISTS default.dummy_base;
CREATE EXTERNAL TABLE dummy_base (asa STRING,ee STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE location  './externals';
DROP FUNCTION IF EXISTS default.auth_session;
create function auth_session as 'com.udfs.sessionData.AuthSessionData';
DROP VIEW IF EXISTS default.auth_data;
CREATE VIEW auth_data AS SELECT auth_session(Value) FROM dummy_base;
DROP FUNCTION IF EXISTS default.materialIsAt_func;
create function materialIsAt_func as 'com.udfs.Materials.MaterialIsAt';
DROP VIEW IF EXISTS default.materialIsAt;
CREATE VIEW materialIsAt AS SELECT materialIsAt_func(Value) FROM dummy_base;
SELECT * FROM materialIsAt;
EOF
