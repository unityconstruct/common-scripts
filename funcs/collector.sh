#!/bin/bash
echo "collector: PARAMS $@"
echo "loading sources from: $(dirname "$0")"
source $(dirname "$0")/props.sh
source $(dirname "$0")/audio_funcs.sh
source $(dirname "$0")/array_funcs.sh
source $(dirname "$0")/is_funcs.sh
source $(dirname "$0")/iso_funcs.sh
source $(dirname "$0")/list_funcs.sh
source $(dirname "$0")/log_funcs.sh
source $(dirname "$0")/prompt_funcs.sh
source $(dirname "$0")/string_funcs.sh
source $(dirname "$0")/test_funcs.sh
source $(dirname "$0")/wget_funcs.sh
source $(dirname "$0")/zip_funcs.sh
