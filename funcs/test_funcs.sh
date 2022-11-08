#!/bin/bash
#-------------------------------------------
# TEST FUNCS
#-------------------------------------------

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
