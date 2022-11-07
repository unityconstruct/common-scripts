#!/bin/bash
source $(dirname "$0")/collector.sh
_LOG=test.log

# GLOBAL VARS ---------------------------------------------------------
SRCDIR=
DSTDIR=
LIST=
## WGET-ONLY
# SRCDIR="/home/uc/Downloads/wget/imgs" #"/home/uc/mm3/s/000"
# DSTDIR="/home/uc/Downloads/wget/imgsnum" #"/home/uc/mm3/s/000"
WGET_LIST="/home/uc/Downloads/wget/imgs/wglist.txt"
WGET_LOG="wget_list.log"

#---------------------------------------------------------------------
# DATA OBJECTS
#---------------------------------------------------------------------
declare -A _data=(["list"]="/home/uc/data/git/common-scripts/test/list.txt"
  ["func"]="_p_stored_in_array"
  ["func_param1"]="p1"
  ["func_param2"]="p2"
)

declare -A _dngriso=(["list"]="nrglist.txt"
  ["func"]="_process_nrg2iso"
  ["ext"]="nrg"
  ["srcdir"]="/media/media3/s/iso-not-wav_sort"
  ["destdir"]="/media/media3/s/000"
  ["filename"]="USB Soundscan vol.43 - ArabianTraditions.nrg"
)

declare -A _dunzip=(["list"]="ziplist.txt"
  ["func"]="_process_unzip"
  ["ext"]="zip"
  ["srcdir"]="/media/media3/s/000"
  ["destdir"]="/media/media3/s/000/unzip"
  ["filename"]="AMG Black II Black Killer Vocals Vol. 1.zip"
)

declare -A _dwget=(["list"]="/home/uc/Downloads/wget/imgs/wglist.txt"
  ["func"]="_process_wgetimgs"
  ["ext"]="http"
  ["srcdir"]=""
  ["destdir"]="/media/media3/s/000"
  ["filename"]=""
)

declare -A _disotest=(["list"]="isolist.txt"
  ["func"]="_process_isotest"
  ["ext"]="iso"
  ["srcdir"]="/media/media3/s/000"
  ["destdir"]="/media/media3/s/000"
  ["filename"]="USB Soundscan vol.34 - Burning Grunge Hip Hop.iso"
  ["mountpoint"]="/media/isomount"
)

declare -A _dmkiso=(["list"]="isolist.txt"
  ["func"]="_process_dir2iso"
  ["line"]="null"
  ["srcdir"]="/media/media3/s/000"
  ["destdir"]="/media/media3/s/000"
  ["out_file"]=" "
  ["src_folder"]=" "
  ["volume"]=" "
  ["mountpoint"]="/media/isomount"
)

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
 [S]- Update the SRCDIR holding the sample folders
 [D]- Update the DSTDIR to create iso in
 [L]- Update the LIST name [list.txt]
 ------------------------------------------------                                        
 [1]- Read in & Process SINGLE Folder to ISO
 [2]- Test SINGLE ISO Image
 [3]- Create File List [${SRCDIR}/${FOLDER_LIST}]
 [4]- Read & Process   [${SRCDIR}/${FOLDER_LIST}]
 [5]- Edit             [${SRCDIR}/${FOLDER_LIST}]
 ------------------------------------------------
 [N]- Convert NRG images to ISO using [${SRCDIR}/${NRG_LIST}]
 [T]- Test ISO images in [${DSTDIR}] using [${DSTDIR}/${ISO_LIST}]
 [W]- enumerate files/urls
 [Z]- unZIP to FOLDER using [${SRCDIR}/${ZIP_LIST}]
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
	# "1") echo "Processing Single Folder to ISO"; process_single_folder ;;
  "2") echo "Testing SINGLE ISO Image"; _process_testiso_prompt_single ;;
	"3") echo "Create list of folders [ie: list.txt]"; _create_folder_list "${SRCDIR}" "${LIST}" ;;
	"4") echo "dir2iso"; _dmkiso["list"]="${LIST}"; _loop_list_do _dmkiso ;;
	# "5") echo "Edit samplefolders.txt"; nano "${SRCDIR}"/"${FOLDER_LIST}";;
	"S") echo "Update Src BaseDir"; _get_user_resp "Enter NEW SRC BASEDIR ( Current:[${SRCDIR}] ): "; SRCDIR="${__DATA}" ;;
  "D") echo "Update Dest BaseDir"; _get_user_resp "Enter NEW DST BASEDIR ( Current:[${DSTDIR}] ): "; DSTDIR="${__DATA}" ;;
  "L") echo "Update List Path"; _get_user_resp "Enter LIST filename [list.txt]: " ; LIST="${__DATA}" ;;
  # "w") echo wget filename; _loop_WGET_LIST_copy_enumeration  "${SRCDIR}" "${WGET_LIST}" "${DSTDIR}" ;;
  "T") echo "Testing ISO images"; create_file_list_by_ext "${DSTDIR}" "${_disotest["list"]}" "${_disotest["ext"]}"; _loop_list_do_ext _disotest ;;
  # "Z") echo "unZIP to FOLDER"
   #     create_file_list_by_ext "${SRCDIR}" $"{ZIP_LIST}" "zip"
   #     loop_src_zipfile_list_unzip "${SRCDIR}" "${ZIP_LIST}" "${DSTDIR}"
   #     ;;
  # "R") echo "unRAR to FOLDER"
   #     create_file_list_by_ext "${SRCDIR}" $"{ZIP_LIST}" "rar"
   #     loop_src_zipfile_list_unzip "${SRCDIR}" "${RAR_LIST}" "${DSTDIR}"
   #     ;;
	"0") echo "exiting..."; exit 0;;
	"x") echo "exiting..."; exit 0;;
	*) echo "Invalid Option selected, Retrying"; menu ;; 
	esac
	menu	# show the menu again
}

#---------------------------------------------------------------------
# Read Loops
#---------------------------------------------------------------------

_loop_list_do() {
  local -n _a=$1   # named array
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

## process a folder => iso image
 # _process_iso_mkiso "${_ddir2iso["srcdir"]}" "${_ddir2iso["foldername"]}" "${_ddir2iso["volume"]}" "${_ddir2iso["filename"]}" "${_ddir2iso["destdir"]}"
 #
_process_dir2iso(){ 
  local -n _z=$1
  mkisofs -lJR -pad -input-charset "utf-8" -V "${_z["line"]:0:31}" -o "${DSTDIR}/${_z["line"]}.iso" "${SRCDIR}/${_z["line"]}"
}

# convert NRG to ISO
 # requires package: sudo apt-get install nrg2iso
 # _convert_nrg_2_iso "${__src_base_dir}" "${_nrgfile}" "${__dest_base_dir}"
_process_nrg2iso () {
  local -n _nrg=$1
  _log "Converting NRG to ISO: ${_nrg["srcdir"]}/${_nrg["filename"]} ${_nrg["destdir"]}/${_nrg["filename"]:0:${#_nrg["filename"]}-4}.iso"   # | tee -a "${SRCDIR}/${NRG_LOG}"
  nrg2iso "${_nrg["srcdir"]}/${_nrg["filename"]}" "${_nrg["destdir"]}/${_nrg["filename"]:0:${#_nrg["filename"]}-4}.iso"
}

# Process a SINGLE ZIPFILE
 #
_process_unzip() {
  local -n _d=$1
  # local __src_base_dir="${1}"
	# local __src_zipfile="${2}"	    # single 
	# local __dest_base_folder="${3}"
  # unzip "${__src_base_dir}/${__src_zipfile}" -d "${__dest_base_folder}/"  | tee -a "${SRCDIR}/${ZIP_LOG}"
    unzip "${_d["srcdir"]}/${_d["filename"]}" -d "${_d["destdir"]}/"  | tee -a "${_LOG}"
}

_process_isotest() {
  local -n _d=$1
  _process_testiso_mountimg "${_d["srcdir"]}/" "${_d["filename"]}" "${_d["mountpoint"]}" 
  _process_testiso_umountimg "${_d["mountpoint"]}"
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

