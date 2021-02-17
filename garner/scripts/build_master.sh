#!/usr/bin/env zsh
echo ${0:a:h}/../../
#/bin/zsh {${0:a:h}/../../dev/make-distribution.sh --name garner-spark --tgz -Phive -Phive-thriftserver -Pmesos -Pyarn -Pkubernetes -Pscala-2.13  -pl core;};
wait;
cp -f ${0:a:h}/../../core/target/spark-core_2.13-3.2.0-SNAPSHOT.jar $SPARK_HOME/jars