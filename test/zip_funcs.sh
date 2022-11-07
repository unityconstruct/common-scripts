#!/bin/ash

## unzip *.zip file to destination dir
 # $1: absolute path to zip file (/var/tmp/zipfile.zip)
 # $2: destination path to extract to
 #
_unzip_to_dest(){
  local __input_zip="{1}"
  local __destdir="{2}"
  unzip "${__input_zip}" -d "${__destdir}/"
}

## extract tar to specified directory
 # $1: absolute path to zip file
 # $2: absolute path to output directory
 #
_tar_extract_to_dest(){
  local __input_zip="${1}"
  local __destdir="${2}"
  _log "tar xvf ${__input_zip} --directory ${__destdir}"
  tar xvf "${__input_zip}" --directory "${__destdir}"
}

## extract tar to specified directory
 # $1: absolute path to zip file
 # $2: absolute path to output directory
 #
_tar_create_from_dest(){
  local __cddir="${1}"
  local __destdir="${2}"
  local __tarfile="${3}"
  local __srcdir="${4}"
  
  cd "${__cddir}"
  _log "tar cvf -o ${__destdir}/${__tarfile} ${__srcdir}"
  tar cvf "${__destdir}/${__tarfile}" "${__srcdir}"

  # _log "tar xvf ${__input_zip} --directory ${__destdir}"
  # tar xvf "${__input_zip}" --directory "${__destdir}"
}