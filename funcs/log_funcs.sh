#!/bin/bash
#----------------------------------------------------------------------
# LOG FUNCS
#----------------------------------------------------------------------

## GetTime to TIMESTAMP
 # Uses: TIMESTAMP
 #
TIMESTAMP=      # init global var
getTimestamp () {
 TIMESTAMP=`date +"%Y-%m%d-%H%M"`
 echo "${TIMESTAMP}"
}


## Dump the textfile to logfile 1:LIST, 2:LOG
 #
#cat "${SRC_BASE_DIR}/${FOLDER_LIST}" | tee -a "${SRC_BASE_DIR}/${SRC_BASE_DIR_LOG}"
_LOG=
_cat_file_to_log () {
  local _file=$"{1}"
  cat "${_file}" | tee -a "${_LOG}"
}

## utility to log text to logfile
 #
#echo "${__msg}" | tee -a "${SRC_BASE_DIR}/${SRC_BASE_DIR_LOG}"
_LOG=
_log () {
  local _m="${1}"
  local _tsoff="{2}"
  if [ "${_tsoff}" = "1" ] ; then
   echo "${_m}" | tee -a "${_LOG}"
  else
   echo "[$(getTimestamp)]${_m}" | tee -a "${_LOG}"
  fi
}

# _LOG=
# _log () {
#    local _m="${1}"
#    echo "${_m}" | tee -a "${_LOG}"
# }