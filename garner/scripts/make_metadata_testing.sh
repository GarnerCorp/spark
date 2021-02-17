#!/usr/bin/env zsh
source ${0:a:h}/garner.env
/bin/bash $SPARK_HOME/bin/beeline <<EOF
!connect jdbc:hive2://localhost:10001/default?hive.server2.transport.mode=http;hive.server2.thrift.http.path=cliservice;
$LOCAL_AUTH_EMAIL
$LOCAL_AUTH_PASSWORD
DROP TABLE IF EXISTS default.dummy_base;
CREATE EXTERNAL TABLE dummy_base (Value STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE location  '$DUMMY_EXTERNALS_LOCATION';

DROP FUNCTION IF EXISTS default.auth_session;
create function auth_session as 'com.garnercorp.udfs.debugViews.AuthSessionData';
DROP VIEW IF EXISTS default.auth_data;
CREATE VIEW auth_data AS SELECT auth_session(Value) FROM dummy_base;

DROP FUNCTION IF EXISTS default.path_env_session_f;
create function path_env_session_f as 'com.garnercorp.udfs.debugViews.PathEnvVariables';
DROP VIEW IF EXISTS default.path_env_session;
CREATE VIEW path_env_session AS SELECT path_env_session_f(Value) FROM dummy_base;

DROP FUNCTION IF EXISTS default.session_env_session_f;
create function session_env_session_f as 'com.garnercorp.udfs.debugViews.SessionEnvVariables';
DROP VIEW IF EXISTS default.session_env_session;
CREATE VIEW session_env_session AS SELECT session_env_session_f(Value) FROM dummy_base;

EOF


