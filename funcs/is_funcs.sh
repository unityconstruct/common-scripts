#!/bin/bash
#-----------------------------------------------------------------------
# IS EXPECTED FUNCS
#-----------------------------------------------------------------------

_process_run_line_is_tests() {
  local _line="${1}"
  # test file entry for comment and iso extension
#   _log "---------- test-start -----------------"
  _is_comment "${_line}"      # _flag_is_comment
  _is_empty   "${_line}"      # _flag_is_empty
  _is_url     "${_line}"      # _flag_is_url
#   _log "---------------------------------------"
#   _log "COMMENT: [${_line}]:${_flag_is_comment}"
#   _log "EMPTY  : [${_line}]:${_flag_is_empty}"
#   _log "URL    : [${_line}]:${_flag_is_url}"
#   _log "---------- test-done-------------------"
}

# Check string if contains needle and sets flag 
 #
_flag_return=false  # global var for use outside function to test result
_is_expected () {
 local __haystack="${1}"            # haystack to search in
 local __needle="${2}"              # search term
 local __expected_result="${3}"     # set to "true" or "false"
 local __flag_is=false              # raise flag if found
 _flag_return=false                 # init the global flag

 # parse haystack for needle
 case "${__haystack}" in
    "${__needle}") __flag_is=true ;;
 esac

 # set flag
 if [ "${__flag_is}" == "${__expected_result}" ]; then
    _flag_return=true
 else 
 	_flag_return=false
 fi
 _log "_is_expected::__haystack:[${__haystack}] needle:[${__needle}]::flag:[${__flag_is}]::returning:[${_flag_return}]"

}

# Check extension if contains needle and sets flag 
 # _flag_return=false  # global var for use outside function to test result
 #
_flag_return=false
_is_expected_extension () {
 local __line="${1}"                # haystack to search in
 local __needle="${2}"              # search term
 local __expected_result="${3}"     # set to "true" or "false"
 local __flag_is=false              # raise flag if found
 _flag_return=false                 # init the global flag

 # parse last 4 chars ( ${#__line} = LENGTH )
 case "${__line:${#__line}-4:4}" in
   #  "${__needle}") __flag_is=true ;;
    *${__needle}*) __flag_is=true;;
 esac

 # set flag
 if [ "${__flag_is}" == "${__expected_result}" ]; then
    _flag_return=true
 else 
 	_flag_return=false
 fi
 _log "_is_expected_extension::item:[${__line}]::needle:[${__needle}]::found:[${__flag_is}]::expected:[${__expected_result}]::returning:[${_flag_return}]"

}

# if list item starts with '#', treat as COMMENT and SKIP
 # uses flag: _flag_is_comment
 #
_flag_is_comment=false
_is_comment () {
 local __item="${1}"
 _flag_is_comment=false # init global var
 case "${__item}" in
   *\#*) # if item contains '#' (for comment)
   _flag_is_comment=true
   ;;
 esac
#  _log "_is_comment::item:[${__item}]::returning:[${_flag_is_comment}]"
}

## 
 #
_flag_is_isofile () {
 local __item="${1}"
 _flag_is_isofile=false # init global var
 # parse last 4 chars ( ${#__item} = LENGTH )
 case "${__item:${#__item}-4:4}" in
    ".iso")
   #*\#*) # if item contains '#' (for comment)
   _flag_is_isofile=true
   ;;
 esac
#  _log "_is_isofile::item:[${__item}]::result:[${_flag_is_isofile}]"
}

##
 #
_flag_is_nrgfile=
_is_nrgfile () {
 local __item="${1}"
 _flag_is_nrgfile=false # init global var
 # parse last 4 chars ( ${#__item} = LENGTH )
 case "${__item:${#__item}-4:4}" in
    ".nrg")
   _flag_is_nrgfile=true
   ;;
 esac
#  _log "_is_nrgfile::item:[${__item}]::result:[${_flag_is_nrgfile}]"
}

# LIST: sets _flag_is_url if item is a url
 # uses GLOBAL flag: _flag_is_url
 #
_flag_is_url=false
_is_url () {
 local __item="${1}"
  _flag_is_url=false
 case "${__item:0:4}" in
   *"http"*) # if item STARTS-WITH 'http' (for url)
     _flag_is_url=true
     ;;
 esac
#  _log "_is_url::item:[${__item}]::result:[${_flag_is_url}]"
}

## if list item starts with '#', treat as COMMENT and SKIP
 # uses GLOBAL flag: _flag_is_comment
 #
_flag_is_empty=false
_is_empty () {
 local __item="${1}"
 _flag_is_empty=false # init global var
 if [ -z "$__item" ] ; then
    _flag_is_empty=true
 fi
#  _log "_is_empty::item:[${__item}]::returning:[${_flag_is_empty}]"
}


