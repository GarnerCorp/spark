#!/usr/bin/env bash
/bin/bash $SPARK_HOME/bin/beeline <<EOF
!connect jdbc:hive2://localhost:10001/default?hive.server2.transport.mode=http;hive.server2.thrift.http.path=cliservice;
help
me
CREATE EXTERNAL TABLE dummy_base (Name STRING, Lastname STRING) ROW FORMAT DELIMITED FIELDS TERMINATED BY ',' STORED AS TEXTFILE location  './externals/dummy';
create function zar as 'com.example.hive.udf.RandintUDTF_test' USING JAR './jars/udf_test_2.12-0.1.jar';
CREATE VIEW randpudf
AS SELECT zar(Name) FROM dummy_base;
create function session_udtf as 'com.example.hive.udf.UDFT_sessiondata' USING JAR './jars/udf_test_2.12-0.1.jar';
CREATE VIEW tempudf2
AS SELECT session_udtf(Name) FROM dummy_base;
create function test_udf as 'com.example.hive.udf.udf_session' USING JAR './jars/udf_test_2.12-0.1.jar';
SELECT * FROM dummy_base;
SELECT * FROM tempudf2;
SELECT * FROM randpudf;
EOF
