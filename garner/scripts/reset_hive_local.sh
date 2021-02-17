#!/usr/bin/env zsh
source ${0:a:h}/garner.env

/bin/zsh ${0:a:h}/stop_all_custom.sh
wait
/bin/zsh ${0:a:h}/clear_meta_work.sh
wait
/bin/zsh ${0:a:h}/start_custom.sh
wait
printf 'sleeping 20s, waiting for hiveserver2 to get its s**t together\n'
sleep 10s
printf 'sleeping 10s, waiting for hiveserver2 to get its s**t together\n'
sleep 10s
wait
/bin/zsh ${0:a:h}/make_metadata.sh
wait
/bin/zsh ${0:a:h}/make_metadata_testing.sh
wait
/bin/zsh ${0:a:h}/verify_tables.sh

