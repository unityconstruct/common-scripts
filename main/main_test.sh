#!/bin/bash
FRAMEWORKPATH="$(dirname "$0")/.."
source ${FRAMEWORKPATH}/funcs/collector_remote.sh
echo "[main][framworkpath:${FRAMEWORKPATH}][Testing Timestamp:$(getTimestamp)]"