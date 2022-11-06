#!/bin/bash
source $(dirname "$0")/collector.sh
_LOG=test.log
declare -A _data=(["list"]="/home/uc/data/git/common-scripts/test/list.txt"
  ["func"]="_p_stored_in_array"
  ["func_param1"]="p1"
  ["func_param2"]="p2"
)

declare -A _dngriso=(["list"]="/home/uc/data/git/common-scripts/test/list.txt"
  ["func"]="_convert_nrg_2_iso"
  ["ext"]="nrg"
  ["srcdir"]="/media/media3/s/iso-not-wav_sort"
  ["destdir"]="/media/media3/s/000"
  ["filename"]="USB Soundscan vol.43 - ArabianTraditions.nrg"
)

_loop_list_do() {
  local -n _a=$1   # named array
  ((_c=0))    # reset counter
  while IFS="" read -r _line || [ -n "$_line" ]; do
    #  _log "loopstart:[${_line}]"
     _process_run_line_is_tests "${_line}"
     if [ "${_flag_is_comment}" = "false" -a "${_flag_is_empty}" = "false" ]; then
       ((++_c))
       _log "[#$_c]loopdo   :[${_line}]"
       ${_a["func"]}        ## call custom method
     else
       _log "loopskip :[${_line}]"
     fi
    #  _log "loopend  :[${_line}]"
  done < "${_a["list"]}"
}

## parse list for file extension, then run the function specified in ["func"]
 # 
_loop_list_do_ext() {
  local -n _a=$1   # named array
  ((_c=0))    # reset counter
  while IFS="" read -r _line || [ -n "$_line" ]; do
    #  _log "loopstart:[${_line}]"
     _process_run_line_is_tests "${_line}"
     _is_expected_extension "${_line}" "${_a["ext"]}" "true"
     if [ "${_flag_is_comment}" = "false" -a "${_flag_is_empty}" = "false" -a "${_flag_return}" = "true" ]; then
       ((++_c))
       _log "[#$_c]loopdo   :[${_line}]"
       _a["filename"]="${_line}"    ## assign the line to the array
       ${_a["func"]} _a             ## call custom method and pass array to it
     else
       _log "loopskip :[${_line}]"
     fi
    #  _log "loopend  :[${_line}]"
  done < "${_a["list"]}"
}


# convert NRG to ISO
# requires package: sudo apt-get install nrg2iso
# _convert_nrg_2_iso "${__src_base_dir}" "${_nrgfile}" "${__dest_base_dir}"
_convert_nrg_2_iso () {
  local -n _nrg=$1
  _log "Converting NRG to ISO: ${_nrg["srcdir"]}/${_nrg["filename"]} ${_nrg["destdir"]}/${_nrg["filename"]:0:${#_nrg["filename"]}-4}.iso"   # | tee -a "${SRC_BASE_DIR}/${NRG_LOG}"
  nrg2iso "${_nrg["srcdir"]}/${_nrg["filename"]}" "${_nrg["destdir"]}/${_nrg["filename"]:0:${#_nrg["filename"]}-4}.iso"
}
#-------------------------------------------
# testing passing array and strings
#-------------------------------------------

_p_string() {
  local _string1="${1}"
  _log "S:[${_string1}]"
}

_p_array() {
  local -n _array=$1
  _log "A:[${_array["list"]}]"
}

_p_string_array() {
  local _string1="${1}"
  local -n _array=$2
  _log "S:[${_string1}]"
  _log "A:[${_array["list"]}]"
}

_p_string_array_string() {
  local _string1="${1}"
  local -n _array=$2
  local _string2="${3}"
  _log "S:[${_string1}]"
  _log "A:[${_array["list"]}]"
  _log "S:[${_string2}]"
}

_p_stored_in_array() {
  _log "called _p_stored_in_array"
}

_p_call_func_stored_in_array() {
  local -n _a=$1
  _log "about to call:[${_a["func"]}]"
  ${_a["func"]}
}

# ${_dngriso["func"]} _dngriso
# _loop_list_do _data
_loop_list_do_ext _dngriso

# _log "test message"

# _p_string "STRING1"
# _p_array  _data
# _p_string_array "STRING1" _data
# _p_string_array_string "STRING1" _data "STRING2"
# _p_call_func_stored_in_array _data
# _log "MESSAGE"
