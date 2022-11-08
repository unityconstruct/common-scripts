#!/bin/bash




#-----------------------------------------------------------------------
# WGET LIST
#-----------------------------------------------------------------------

## Iterate a text file, creating ISOs from each entry
 # dump timestamp & filelist path/contents to log file
 # When WGET download speeds are high, the timestamps can't be used for sorting
 # if the the images are part of a sequence, but the names aren't serialized,
 #   could be impossible to know their order
 # since wget downloads from a file list, this can be used as a MASTER to copy each image to a new location with a numberic prefix.
 # TODO: ADD padding for 3-digit ids.
 #
_loop_wget_dllist_copy_to_enumerated_fileset() {
  local __src_base_dir="${1}"                         # path with original imaes
  local __list="${2}"                                 # file list wget used for downloading originals
  local __dest_base_folder="${3}"                     # path to copy NEWLY enumerated images
  
  ((_counter=0))                                      # reset counter
  while IFS="" read -r _folder || [ -n "$_folder" ]   # read list text file and iterate through each line, skipping comments ( # )
  do
    _log "[$(getTimestamp)]:LOOPSTART:[${_folder}]"
    _process_run_line_is_tests "${_folder}"
    _log "SIZE:[${#_folder}][${_folder}]"
    if [ "${_flag_is_comment}" = "false" -a "${_flag_is_empty}" = "false"  ] ; then
     ((++_counter))
     _log "[#$_counter] LOOP: Processing:[${_folder}]"
     process_copy_to_enumerated_filename "${_folder}" "${__src_base_dir}" "$_counter" "${__dest_base_folder}"
    else
    _log "[$(getTimestamp)]:LOOPSKIP:[${_folder}]"
     continue; # skip the rest of the loop
    fi
    _log "[$(getTimestamp)]:LOOPEND:[${_folder}]"
  done < "${__list}" #samplefolders.txt
}



## prepends filename with a counter so it may be sorted regardless of files timestamp
 # fetches basename from a string(file path), prepends it with the passed counter
 # initially created for dealing with files 
 #  1. downloaded extremely fast with wget,
 #  2. had no indexing filename prefix to allow sorting
 #  3. and timestamps were all the same due to download speed
 #
 #  1. This func will strip the path/url, leaving the extension, 
 #  2. then prepend a number that is passed in to this func 
 #  3. and perform a copy from its SOURCE dir to a DEST dir
 #
process_copy_to_enumerated_filename() {
  local _fname="${1}"
  local _srcdir="${2}"
  local _c="${3}"
  local _destdir="${4}"
  local _file=$(basename "${_fname}" )
  _log  "SRCDIR:[${_srcdir}] --- DSTDIR:[${_destdir}] --- COUNT-FILE:[${_c}]-[${_file}]" 
  _log cp "${_srcdir}"/"${_file}" "${_destdir}"/"${_c}"-"${_file}"
  cp -v "${_srcdir}"/"${_file}" "${_destdir}"/"${_c}"-"${_file}"
}

