#!/usr/bin/env bash

/bin/bash $SPARK_HOME/garner_scripts/stop_all_custom.sh
wait
/bin/bash $SPARK_HOME/garner_scripts/clear_meta_work.sh
wait
/bin/bash $SPARK_HOME/garner_scripts/start_custom.sh
wait
echo sleeping 10s, waiting for hiveserver2 to get its s**t together
sleep 5s
echo sleeping 5s, waiting for hiveserver2 to get its s**t together
sleep 5s
wait
/bin/bash $SPARK_HOME/garner_scripts/make_metadata.sh


