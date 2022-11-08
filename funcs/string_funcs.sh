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




## Search a string and perform one-or-more character replacements
 # returns the result with `echo`
 # Params:
 #  1 - string input ( original string/HAYSTACK ) 
 #  2 - OLD character(NEEDLE) to SEARCH  [ DEFAULT=' ']
 #  3 - NEW character                    [ DEFAULT='-']
 #
 # tr replaces a character in a string
_replace_char () {
  local stringinput="${1}"
  local char_needle="${2:0:1}"
   if [ -z "$char_needle" ] ; then
     char_needle=" "
   fi
  local char_replace="${3:0:1}"
   if [ -z "$char_replace" ] ; then
     char_replace="-"
   fi
   ## ONE LINER
  echo "${1}" | tr "${char_needle:0:1}" "${char_replace:0:1}"
  ## DEBUG OUTPUT
  #echo "[DEBUG OUPUT] Needle:[$char_needle] Replace:[$char_replace] ==> StringInput:[${stringinput}] ==> StringOutput:[${stringoutput}]"
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


#-----------------------------------------------------------------------
# STRING PADDING FUNCS
#-----------------------------------------------------------------------

## pad single digit numbers with '0'
 #
_padnums () {
 temp=$1 ;
 length=$2 ;
 padding="$(make_padding 1)" ;

 if [ ${#temp} -eq 1 ] ; then
  echo "${padding}${temp}" ;
 else
  echo "${temp}" ;
 fi
}

## add padding of '0'
 #
_make_padding () {
 length=$1 ;
 pads="" ;
 for (( c=1; c<=${length}; c++ )) ;
 do
  pads="${pads}0" ;
  echo ${pads} ;
 done
}

## pad a single char string
 #
_padnum () {
 temp=$1
 if [ ${#temp} -eq 1 ] ; then
  echo "0${temp}" ;
 else
  echo "${temp}" ;
 fi
}
