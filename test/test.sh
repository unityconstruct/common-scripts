11#!/bin/bash
source $(dirname "$0")/collector.sh
_LOG=test.log

# GLOBAL VARS ---------------------------------------------------------

# GLOBALS for TEST
 #DIR2ISOTEST
 # SRCDIR=/home/uc/data/git/common-scripts/test/tmp/
 # DSTDIR=/home/uc/data/git/common-scripts/test/tmp/
 # LIST=dir2iso.txt
 #ZIPTEST
 # SRCDIR=/home/uc/mm3/s/000
 # DSTDIR=/tmp/tar
 #NRGTEST
 # SRCDIR=/home/uc/mm3/s/iso-not-wav_sort/
 # DSTDIR=/tmp/tar
 #ISOTEST
 # SRCDIR=/home/uc/mm3/s/000
 # DSTDIR=/tmp/tar
 #TARTEST
 # SRCDIR=/tmp/tar
 # DSTDIR=/tmp/tar


SRCDIR=/tmp/tar
DSTDIR=/tmp/tar
LIST=list.txt

#---------------------------------------------------------------------
# NOT IMPLEMENTED YET 
#---------------------------------------------------------------------
FLAG_USE_DEFAULTS=false   ## when set to true, update GLOBAL VARS from the array's [srcdir,destdir,list] items
## update GLOBAL VARS from an ARRAY if FLAG_USE_DEFAULES=true
 #
_use_array_defaults_or_globals() {
  local -n _d=$1
  if [ "$FLAG_USE_DEFAULTS" = "true"  ] ; then
    SRCDIR="${_d["srcdir"]}"
    DSTDIR="${_d["destdir"]}"
    LIST="${_d["list"]}"
  fi
}

#---------------------------------------------------------------------
# DATA OBJECTS
#---------------------------------------------------------------------
declare -A _dexample=(["func"]="null"
  ["list"]="null"
  ["srcdir"]="null"
  ["destdir"]="null"
  ["ext"]="null"
  ["filename"]="null"
  ["line"]="null"
)

declare -A _disotest=(["func"]="_process_isotest"
  ["list"]="isolist.txt"
  ["srcdir"]="/media/media3/s/000"
  ["destdir"]="/media/media3/s/000"
  ["ext"]="iso"
  ["filename"]="USB Soundscan vol.34 - Burning Grunge Hip Hop.iso"
  ["line"]="null"
  ["mountpoint"]="/media/isomount"
)

#TESTED
declare -A _dmkiso=(["func"]="_process_dir2iso"
  ["list"]="isolist.txt"
  ["srcdir"]="/media/media3/s/000"
  ["destdir"]="/media/media3/s/000"
  ["ext"]="null"
  ["filename"]="null"
  ["line"]="null"
  ["out_file"]="null"
  ["src_folder"]="null"
  ["volume"]="null"
  ["mountpoint"]="/media/isomount"
)

#TESTED
declare -A _dnrgiso=(["func"]="_process_nrg2iso"
  ["list"]="nrglist.txt"
  ["srcdir"]="/media/media3/s/iso-not-wav_sort"
  ["destdir"]="/media/media3/s/000"
  ["ext"]="nrg"
  ["filename"]="null"
#  ["filename"]="USB Soundscan vol.43 - ArabianTraditions.nrg"
  ["line"]="null"
)

#TESTED
declare -A _dtarc=(["func"]="_process_tar_create"
  ["list"]="tarlist.txt"
  ["srcdir"]="/tmp"
  ["destdir"]="/tmp"
  ["ext"]="null"
  ["filename"]="null"
  ["line"]="null"
  ["out_file"]="null"
)

#TESTED
declare -A _dtarx=(["func"]="_process_tar_extract"
  ["list"]="tarlist.txt"
  ["srcdir"]="/tmp/tar"
  ["destdir"]="/tmp/tar"
  ["ext"]="tar"
  ["filename"]="null"
  ["line"]="null"
  ["out_file"]="null"
  ["src_folder"]="null"
)

#TESTED
declare -A _dunzip=(["func"]="_process_unzip"
  ["list"]="ziplist.txt"
  ["srcdir"]="/media/media3/s/000"
  ["destdir"]="/media/media3/s/000/unzip"
  ["ext"]="zip"
  ["filename"]="AMG Black II Black Killer Vocals Vol. 1.zip"
  ["line"]="null"
)

## WGET-ONLY -------------------------------------------------------------
 # SRCDIR="/home/uc/Downloads/wget/imgs" #"/home/uc/mm3/s/000"
 # DSTDIR="/home/uc/Downloads/wget/imgsnum" #"/home/uc/mm3/s/000"
 WGET_LIST="/home/uc/Downloads/wget/imgs/wglist.txt"
#  WGET_LOG="wget_list.log"
 declare -A _dwgetenum=(["func"]="_loop_wget_dllist_copy_to_enumerated_fileset"
   ["list"]="/home/uc/Downloads/wget/imgs/wglist.txt"
   ["srcdir"]="/home/uc/Downloads/wget/imgs"
   ["destdir"]="/home/uc/Downloads/wget/imgsnum"
   ["ext"]="http"
   ["filename"]="null"
   ["line"]="null"
 )


 ## WGET-ONLY -------------------------------------------------------------





#---------------------------------------------------------------------
# MAIN INIT FUNCTION
#---------------------------------------------------------------------

## main controller func - calls _menu
 #
_runme () {
	_menu
}

# MAIN MENU --------------------------------------------------------------------

## Menu Text
 #
_menu_show() {
 echo " -------------------------------------------- 
 -- list-iterator [LOG: ${_LOG}] --
 -------------------------------------------- 
 SRCDIR:          [${SRCDIR}]
 DSTDIR:          [${DSTDIR}]
 LIST:            [${LIST}]
 MOUNTPOINT:      [${ISO_MOUNTPOINT}]
 [S] Update the SRCDIR holding the sample folders
 [D] Update the DSTDIR to create iso in
 [L] Update the LIST name [list.txt]
 ------------------------------------------------                                        
 [1] Read in & Process SINGLE Folder to ISO
 [2] Test SINGLE ISO Image
  [4] dir2iso
 [5] Edit             [${SRCDIR}/${LIST}]
 ------------------------------------------------
 [11] tar extract from list
 [12] tar create from list
 [N] Convert NRG=>ISO
 [T] Test ISO images in [${DSTDIR}]
 [W] enumerate files/urls
 [Z] unZIP to FOLDER using [${SRCDIR}/${ZIP_LIST}]
 ------------------------------------------------
 [0][x]-exit 0 
 [*]-Prompt again"
}

## Menu Logic
 #
_menu () {
  _menu_show
	echo "------------------------------------------------"
	read -p "enter option: " opt
	echo "------------------------------------------------"
	echo "Typed: $opt"
	case "$opt" in
	"1")  echo "Processing Single Folder to ISO"; _process_testiso_prompt_single;; # _process_single_folder ;;
  "2")  echo "Testing SINGLE ISO Image"; _process_testiso_prompt_single ;;
	"4")  echo "dir2iso"            ; _create_folder_list "${SRCDIR}" "${LIST}"; _dmkiso["list"]="${LIST}"               ; _loop_list_do _dmkiso ;;
	"S")  echo "Update Src BaseDir" ; _get_user_resp "Enter NEW SRC BASEDIR ( Current:[${SRCDIR}] ): "; SRCDIR="${__DATA}" ;;
  "D")  echo "Update Dest BaseDir"; _get_user_resp "Enter NEW DST BASEDIR ( Current:[${DSTDIR}] ): "; DSTDIR="${__DATA}" ;;
  "L")  echo "Update List Path"   ; _get_user_resp "Enter LIST filename [list.txt]: "               ; LIST="${__DATA}"   ;;
  "N")  echo "NRG=>ISO"           ; _create_file_list_by_ext "${SRCDIR}" "${_dnrgiso["list"]}" "${_dnrgiso["ext"]}"    ; _loop_list_do_ext _dnrgiso ;;
  "T")  echo "Testing ISO images" ; _create_file_list_by_ext "${SRCDIR}" "${_disotest["list"]}" "${_disotest["ext"]}"  ; _loop_list_do_ext _disotest ;;
  "Z")  echo "unZIP to FOLDER"    ; _create_file_list_by_ext "${SRCDIR}" "${_dunzip["list"]}"   "${_dunzip["ext"]}"    ; _loop_list_do_ext _dunzip;;     ## "${SRCDIR}" "${ZIP_LIST}" "${DSTDIR}" ;;
	"11") echo "tar extract"; _create_file_list_by_ext "${DSTDIR}" "${_dtarx["list"]}" "${_dtarx["ext"]}"; _loop_list_do_ext _dtarx ;;
	"12") echo "tar create";  _create_folder_list "${SRCDIR}" "${_dtarc["list"]}" ; _loop_list_do _dtarc ;;
  

  #  "w") echo "wget enumerate filenames"; _loop_wget_dllist_copy_to_enumerated_fileset   "${_dwgetenum["srcdir"]}" "${_dwgetenum["list"]}" "${_dwgetenum["destdir"]}" ;;

   "w") echo "wget enumerate filenames"; ( ${_dwgetenum["func"]}   "${_dwgetenum["srcdir"]}" "${_dwgetenum["list"]}" "${_dwgetenum["destdir"]}") ;;
  
  #  "w") echo "wget enumerate filenames"; _loop_wget_dllist_copy_to_enumerated_fileset   "${_dwgetenum["srcdir"]}" "${_dwgetenum["list"]}" "${_dwgetenum["destdir"]}";;

  
  "0") echo "exiting..."; exit 0;;
	"x") echo "exiting..."; exit 0;;
	*) echo "Invalid Option selected, Retrying"; _menu ;;
	esac
	_menu	# show the menu again
  

# NOT IMPLEMENTED --------------------------------------------------------------------
	# "5") echo "Edit samplefolders.txt"; nano "${SRCDIR}"/"${FOLDER_LIST}";;
  # "3") echo "Create list of folders [ie: list.txt]"; _create_folder_list "${SRCDIR}" "${LIST}" ;;
  # "R") echo "unRAR to FOLDER"
   #     create_file_list_by_ext "${SRCDIR}" $"{ZIP_LIST}" "rar"
   #     loop_src_zipfile_list_unzip "${SRCDIR}" "${RAR_LIST}" "${DSTDIR}"
   #     ;;
# NOT IMPLEMENTED --------------------------------------------------------------------
}


#---------------------------------------------------------------------
# Read Loops
#---------------------------------------------------------------------

_loop_list_do() {
  local -n _a=$1   # named array
  ### ---------------------------------- TODO: add [FLAG_USE_DEFAULTS] logic
  ((_c=0))    # reset counter
  while IFS="" read -r _line || [ -n "$_line" ]; do
    #  _log "loopstart:[${_line}]"
     _process_run_line_is_tests "${_line}"
     if [ "${_flag_is_comment}" = "false" -a "${_flag_is_empty}" = "false" ]; then
       ((++_c))
       _log "[#$_c]loopdo   :[${_line}]"
                                                #  ${_a["func"]}        ## call custom method
       _a["line"]="${_line}"    ## assign the line to the array
       ${_a["func"]} _a             ## call custom method and pass array to it [ ie: _a["func"](_a) ]
     else
       _log "loopskip :[${_line}]"
     fi
    #  _log "loopend  :[${_line}]"
  done < "${_a["list"]}"
}

## parse list for file extension, then run the function specified in ["func"]
 # 
_loop_list_do_ext() {
  local -n _a=$1                    ## named array
  ### ---------------------------------- TODO: add [FLAG_USE_DEFAULTS] logic
  ((_c=0))                          ## reset counter
  while IFS="" read -r _line || [ -n "$_line" ]; do
                                    #  _log "loopstart:[${_line}]"
     _process_run_line_is_tests "${_line}"
     _is_expected_extension "${_line}" "${_a["ext"]}" "true"
     if [ "${_flag_is_comment}" = "false" -a "${_flag_is_empty}" = "false" -a "${_flag_return}" = "true" ]; then
       ((++_c))                     ## increment counter
       _log "[#$_c]loopdo:[${_line}]"
       _a["filename"]="${_line}"    ## assign the line to the array
       ${_a["func"]} _a             ## call custom method and pass array to it [ ie: _a["func"](_a) ]
     else
       _log "loopskip :[${_line}]"
     fi
                                    ##  _log "loopend  :[${_line}]"
  done < "${_a["list"]}"
}

#---------------------------------------------------------------------
# Processors
#---------------------------------------------------------------------

## create iso image - prompt for values
 #
_process_dir2iso_promptfor() {
  _get_user_resp "Enter source dir [/var/tmp/datadisc]   : " ; local _srcdir="${__DATA}"
  _get_user_resp "Enter output image [/var/tmp/image.iso]: " ; local _isoname="${__DATA}"
  _get_user_resp "Enter volume name [datadisc04]         : " ; local _volname="${__DATA}"
  mkisofs -lJR -pad -input-charset "utf-8" -V "${_volname:0:31}" -o "${_isoname}" "${_srcdir}"
}

#TESTED
## create iso image - use array of values
 # _process_iso_mkiso "${_ddir2iso["srcdir"]}" "${_ddir2iso["foldername"]}" "${_ddir2iso["volume"]}" "${_ddir2iso["filename"]}" "${_ddir2iso["destdir"]}"
 #
_process_dir2iso(){ 
  local -n _z=$1
  # SRCDIR=${_z["srcdir"]}
  # DSTDIR=${_z["destdir"]}
  mkisofs -lJR -pad -input-charset "utf-8" -V "${_z["line"]:0:31}" -o "${DSTDIR}/${_z["line"]}.iso" "${SRCDIR}/${_z["line"]}"
}

#TESTED
# convert NRG to ISO - use array of values
 # requires package: sudo apt-get install nrg2iso
 # _convert_nrg_2_iso "${__src_base_dir}" "${_nrgfile}" "${__dest_base_dir}"
  # _log "Converting NRG to ISO: ${_nrg["srcdir"]}/${_nrg["filename"]} ${_nrg["destdir"]}/${_nrg["filename"]:0:${#_nrg["filename"]}-4}.iso"   # | tee -a "${SRCDIR}/${NRG_LOG}"
  # nrg2iso "${_nrg["srcdir"]}/${_nrg["filename"]}" "${_nrg["destdir"]}/${_nrg["filename"]:0:${#_nrg["filename"]}-4}.iso"
_process_nrg2iso () {
  local -n _nrg=$1
  # SRCDIR=${_nrg["srcdir"]}
  # DSTDIR=${_nrg["destdir"]}
  _log "Converting NRG to ISO: ${SRCDIR}/${_nrg["filename"]} ${DSTDIR}/${_nrg["filename"]:0:${#_nrg["filename"]}-4}.iso"   # | tee -a "${SRCDIR}/${NRG_LOG}"
  nrg2iso "${SRCDIR}/${_nrg["filename"]}" "${DSTDIR}/${_nrg["filename"]:0:${#_nrg["filename"]}-4}.iso"
}

#TESTED
## test iso image - - use array of values
 #
_process_isotest() {
  local -n _d=$1
  SRCDIR=${_d["srcdir"]}
  # DSTDIR=${_d["destdir"]}
  _process_testiso_mountimg "${SRCDIR}/" "${_d["filename"]}" "${_d["mountpoint"]}" 
  _process_testiso_umountimg "${_d["mountpoint"]}"
  # _process_testiso_mountimg "${_d["srcdir"]}/" "${_d["filename"]}" "${_d["mountpoint"]}" 
  # _process_testiso_umountimg "${_d["mountpoint"]}"
}

#TESTED
# create zip file from folder - use array of values
  # local __src_base_dir="${1}"
	# local __src_zipfile="${2}"	    # single 
	# local __dest_base_folder="${3}"
  # unzip "${__src_base_dir}/${__src_zipfile}" -d "${__dest_base_folder}/"  | tee -a "${SRCDIR}/${ZIP_LOG}"
 #
_process_unzip() {
  local -n _d=$1
  # SRCDIR=${_d["srcdir"]}
  # DSTDIR=${_d["destdir"]}
  unzip "${SRCDIR}/${_d["filename"]}" -d "$DSTDIR}/"  #| tee -a "${_LOG}"
  # unzip "${_d["srcdir"]}/${_d["filename"]}" -d "${_d["destdir"]}/"  #| tee -a "${_LOG}"
}

#TESTED
## extract tar to destination dir
 #
_process_tar_extract() {
  local -n _d=$1;
  # SRCDIR=${_d["srcdir"]}
  # DSTDIR=${_d["destdir"]}
  _tar_extract_to_dest "${SRCDIR}/${_d["filename"]}" "${DSTDIR}"
}

#TESTED
## create tar from folder
 #
  #  tar cvf -o "${__destdir}/${__tarfile}" "${__srcdir}"
  # _tar_create_from_dest srcdir tarfile destdir
_process_tar_create() {
    local -n _d=$1;
  # SRCDIR=${_d["srcdir"]}
  # DSTDIR=${_d["destdir"]}    
  echo "_tar_create_from_dest ${DSTDIR} ${_d["line"]}.tar ${SRCDIR}/${_d["line"]}" 
  _tar_create_from_dest "${SRCDIR}" "${DSTDIR}" "${_d["line"]}.tar"  "${_d["line"]}"  
}

# RUNNER --------------------------------------------------------------------
_runme

# --------------------------------------------------------------------
# Test code
# --------------------------------------------------------------------
 # ${_disotest["func"]} _disotest
 # ${_dunzip["func"]} _dunzip
 # _loop_list_do_ext _disotest
 # ${_dngriso["func"]} _dngriso
 # _loop_list_do _data
 # _loop_list_do_ext _dngriso
 # _log "test message"
 # _p_string "STRING1"
 # _p_array  _data
 # _p_string_array "STRING1" _data
 # _p_string_array_string "STRING1" _data "STRING2"
 # _p_call_func_stored_in_array _data
 # _log "MESSAGE"

