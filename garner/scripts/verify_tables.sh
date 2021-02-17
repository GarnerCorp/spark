#!/usr/bin/env zsh
source ${0:a:h}/garner.env
/bin/bash $SPARK_HOME/bin/beeline <<EOF
!connect jdbc:hive2://localhost:10001/default?hive.server2.transport.mode=http;hive.server2.thrift.http.path=cliservice;
$LOCAL_AUTH_EMAIL
$LOCAL_AUTH_PASSWORD
SELECT * FROM dummy_base;
SELECT * FROM auth_data;
SELECT * FROM path_env_session;
SELECT * FROM session_env_session;
SELECT * FROM materialIsAt;
EOF


