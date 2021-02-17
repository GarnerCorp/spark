#!/usr/bin/env zsh
export work_list=(${SPARK_HOME}/work/app-*/*/stderr)
export log_list=(${SPARK_HOME}/logs/*)
echo $work_list




#tail  -f $work_list $log_list |
#    awk '/^==> / {a=substr($0, 5, length($0)-10); next}
#                 {print a":"$0}'

