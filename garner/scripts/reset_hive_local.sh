#!/usr/bin/env zsh
source ${0:a:h}/garner.env

/bin/zsh ${0:a:h}/stop_all_custom.sh
wait
/bin/zsh ${0:a:h}/clear_meta_work.sh
wait
/bin/zsh ${0:a:h}/copy_files_in.sh
wait
/bin/zsh ${0:a:h}/start_custom.sh

