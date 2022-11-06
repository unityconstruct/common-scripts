#!/bin/bash



#-----------------------------------------------------------------------
# STRING FUNCS
#-----------------------------------------------------------------------

## 
 # NOTES: 
 # -r read raw input
 # -a read each token into an array
 # <<< assigns $str to 
 # @ = all items in array
 #   echo "${str_array[@]}"
 # $# [*] = number of items in array
 #  echo "${#str_array[*]}"
 # [6] = item index in array ( 0-based )
 # combine array index with number of items in array ( minus 1 b/c is 0-based )
 #   echo "${str_array[(${#str_array[*]}-1)]}" # last item in array
 # loop array
 #  for each in "${str_array[@]}"
 #  do
 #   echo $each;
 #  done
_split_string_by () {
  local _str="${1}"
  local _char="${2}"
  IFS=${_char:0:1}                # echo "[$IFS] split delimn IFS"
  read -ra str_array <<< "$_str"
  echo ${str_array[0]}            # return value
  IFS=""
}

## trim extension off a filename or path/filename
 # returns the value with 'echo'
 # split delim is hard-coded to '.'
 # usage varname=$(_trim_ext "path/filename.mp4")
 #
_trim_ext() {
  local _trimmed=$(_trim_by "${1}" '.')
  echo $_trimmed
}

## trim string by specified character
 #  param1: string to process
 #  param2: singe char to split by
 #   if more than one char pass, it will be ignored
 #
 # if string has char more than once, it will be rebuilt with char put back in
 #
 # returns the value with 'echo'
 # usage varname=$(_trim_by "path/filename.ext" '.')
 #
_trim_by () {
  local _str="${1}"
  local _char="${2}"
  IFS=${_char:0:1}                # echo "[$IFS] split delimn IFS"
  read -ra str_array <<< "$_str"
  IFS=""
  local _result=""
  for ((i=0; i<${#str_array[*]}-1; i++)) ; do
    _result="${_result}${str_array[${i}]}."
  done
  echo ${_result}
}

