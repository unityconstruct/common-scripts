#!/bin/bash
#---------------------------------------------------------------------
# AUDIO FUNCS
#---------------------------------------------------------------------

#---------------------------------------------------------------------
# CLI FUNCS
# call by audio_funcs.sh "func_name" "file/path" "extension"
#---------------------------------------------------------------------
# functions that are called directly from cli
#  $@ is passed through
#  so param1 is the function name & not used by the cli functions
#---------------------------------------------------------------------

## process audio file direct from cli
 # $1 - function to call
 # $2 - file
 # $3 - extension
 # 
_process_audio_file_cli() {
  _process_audio_file "${2}" "${3}"
}

## find and process supported audio files  direct from cli
 # $1 - function to call
 # $2 - path
 # $3 - extension
 #
_process_audio_folder_cli() {
  _process_audio_folder "${2}" "${3}"
}

## process image file  direct from cli
 # $1 - function to call
 # $2 - file
 # $3 - extension
 #
_process_img_file_cli() {
  _process_img_file "${2}" "${3}"
}

## find and process supported image files  direct from cli
 # $1 - function to call
 # $2 - path
 # $3 - extension
 #
_process_img_folder_cli() {
 _process_img_folder "${2}" "${3}"
}

#---------------------------------------------------------------------
# MENU FUNCS
# call by audio_funcs.sh "file/path" "extension"
#---------------------------------------------------------------------

## find and process supported audio files
 # $1 - path
 # $2 - extension
 # 
_process_audio_folder() {
  local _path="${1}"
  local _ext="${2}"
  for f in $( find "${_path}" -maxdepth 1 -name '*.m4a' -o \
   -name '*.wav' -o \
   -name '*.3gp' -o \
   -name '*.3ga' -o \
   -name '*.amr' -o \
   -name '*.M4A' -o \
   -name '*.WAV' -o \
   -name '*.3GP' -o \
   -name '*.3GA' -o \
   -name '*.AMR' );
    do 
      _process_audio_file "${f}" "${_ext}"
    done;
}

## process audio file
 # $1 - file
 # $2 - extension
 # 
_process_audio_file() {
  local _file="${1}"
  local _ext="${2}"
  echo ffmpeg -i "${_file}" -ar 44100 $(_trim_ext "${_file}")"${_ext}"
  ffmpeg -i "${_file}" -ar 44100 $(_trim_ext "${_file}")"${_ext}"
}

## find and process supported image files
 # $1 - path
 # $2 - extension
 #
_process_img_folder() {
  local _path="${1}"
  local _ext="${2}"
  for f in $( find "${_path}" -maxdepth 1 -name '*.svg' -o \
   -name '*.jpg' -o \
   -name '*.jpeg' -o \
   -name '*.png' -o \
   -name '*.tiff' -o \
   -name '*.ico' -o \
   -name '*.webp' \
   );
    do 
      _process_img_file "${f}" "${_ext}"
    done;
}

## process img file
 # $1 - file
 # $2 - extension
 # 
_process_img_file() {
  local _file="${1}"
  local _ext="${2}"
  echo ffmpeg -i "${_file}" $(_trim_ext "${_file}")"${_ext}"
  ffmpeg -i "${_file}" $(_trim_ext "${_file}")"${_ext}"
}

## find and process webp image files
 # $1 - path
 # $2 - FROM extension
 # $3 - TO extension
 # $4 - MAX depth (recurse folders)
_process_img_folder_by_single_type() {
  echo "PARAMS: [$@]"
  local _path="${1}"
  local _fromext="${2}"
  local _toext="${3}"
  local _maxdepth="${4}"
  for _f in $( find "${_path}" -maxdepth ${_maxdepth} -name "*.${_fromext}" ); do 
      _process_img_file "${_f}" "${_toext}"
    done;
}

_process_img_folder_by_single_type_webp_png() {
  echo "PARAMS: [$@]"
  local _path="${1}"
  local _fromext="webp"
  local _toext="png"
  local _maxdepth=3
  _process_img_folder_by_single_type "${_path}" "${_fromext}" "${_toext}" "${_maxdepth}"
}



