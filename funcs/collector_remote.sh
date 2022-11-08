#!/bin/bash
echo "[collector_remote]:FRAMEWORKPATH:[${FRAMEWORKPATH}]"
COLLECTOR_PROPS=${FRAMEWORKPATH}/props
COLLECTOR_FUNCS=${FRAMEWORKPATH}/funcs

echo "[collector_remote]:loading props from: [${COLLECTOR_PROPS}]"
source "${COLLECTOR_PROPS}"/props.sh
echo "[collector_remote]:loading funcs from: [${COLLECTOR_FUNCS}]"
source "${COLLECTOR_FUNCS}"/audio_funcs.sh
source "${COLLECTOR_FUNCS}"/array_funcs.sh
source "${COLLECTOR_FUNCS}"/is_funcs.sh
source "${COLLECTOR_FUNCS}"/iso_funcs.sh
source "${COLLECTOR_FUNCS}"/list_funcs.sh
source "${COLLECTOR_FUNCS}"/log_funcs.sh
source "${COLLECTOR_FUNCS}"/prompt_funcs.sh
source "${COLLECTOR_FUNCS}"/string_funcs.sh
source "${COLLECTOR_FUNCS}"/test_funcs.sh
source "${COLLECTOR_FUNCS}"/wget_funcs.sh
source "${COLLECTOR_FUNCS}"/zip_funcs.sh
echo "[collector_remote][$(getTimestamp)]Done"