#!/bin/bash
#
# File Iterator
# Utility for reading items in from text file, then processing
#
#------------------
source $(dirname "$0")/collector.sh
_LOG=test.log

# TODO: 
# - breakout to individual scripts
# - push common funcs to common
#
#
#---------------------------------------------------------------------
# CONFIG VARS
#---------------------------------------------------------------------
# TODO: load defaults bas on job
#
#
#---------------------------------------------------------------------
## BASIC LIST/LOG
FOLDER_LIST="folder_list.txt"
FOLDER_LOG="folder_list.log"
#-----------------------------------
## DIR2ISO ONLY 
declare -A _it_dir2iso=(["list"]="/home/uc/data/git/common-scripts/test/list.txt"
  ["func"]="_p_stored_in_array"
  ["func_param1"]="p1"
  ["func_param2"]="p2"
)
# SRC_BASE_DIR="/mnt/data/000/_isomake" #"/home/uc/mm3/s/000"
# DST_BASE_DIR="/mnt/data/000/_isomake" #"/home/uc/mm3/s/000"
ISO_LIST="iso_list.txt"
SRC_FOLDER_LIST="samplefolders.txt"
SRC_BASE_DIR_LOG="dir2iso.log"
ISO_LOG="iso_list.log"
ISO_MOUNT_LOG="iso_mount.log"
ISO_MOUNTPOINT="/media/isomount"
DST_ISO_LIST="iso_list.txt"
#-----------------------------------
## WGET-ONLY
SRC_BASE_DIR="/home/uc/Downloads/wget/imgs" #"/home/uc/mm3/s/000"
DST_BASE_DIR="/home/uc/Downloads/wget/imgsnum" #"/home/uc/mm3/s/000"
WGET_LIST="/home/uc/Downloads/wget/imgs/wglist.txt"
WGET_LOG="wget_list.log"
#-----------------------------------
## NRG-ONLY
NRG_LIST="nrg_list.txt"
NRG_LOG="nrg_list.log"
#-----------------------------------
## RAR ONLY
RAR_LIST="rar_list.txt"
RAR_LOG="rar_list.log"
#-----------------------------------
## ZIP ONLY
ZIP_LIST="zip_list.txt"
ZIP_LOG="zip_list.log"
#-----------------------------------
SRC_FOLDER=""   # relative path under SRC_BASE_DIR
SRC_PATH=""     #absolute path

#---------------------------------------------------------------------
# VARS
fname=""
volname=""
isoname=""
srcfolder=""
#---------------------------------------------------------------------
declare -i _counter=0 # declare a global counter for logging iteration #
 # NOTE: counter usage
 #echo "COUNTER is [$_counter]"
 #echo "++COUNTER is [$((++_counter))]"
 #((_counter=0))
#---------------------------------------------------------------------
                    #SRC_FOLDER=""
                    #DEST="/home/uc/proj/s/samples.iso.incoming"
                    #DEST="${REPO_DEST_ISO_STALLED}"
RESP=""	# Readline temp storage
TIMESTAMP=					# used when creating folder list text file

# removed.. delete once tested ok
# _flag_is_valid=false		# use to flag comment lines




_loop_list_do() {
  local __src_base_dir="${1}"                 #local __txt_path="${1}"
  local __list="${2}"
  local __dest_base_folder="${3}"
  # read list text file and iterate through each line, skipping comments ( # )
  ((_counter=0))    # reset counter
  while IFS="" read -r _folder || [ -n "$_folder" ]
  do
    echo "[$(getTimestamp)]:LOOPSTART:[${_folder}]"     | tee -a "${SRC_BASE_DIR}/${WGET_LOG}"
    _process_run_line_is_tests "${_folder}"
    echo "SIZE:[${#_folder}][${_folder}]"
    if [ "${_flag_is_comment}" = "false" -a "${_flag_is_empty}" = "false"  ] ; then
     ((++_counter))
     echo "[#$_counter] LOOP: Processing:[${_folder}]"  | tee -a "${SRC_BASE_DIR}/${WGET_LOG}"
     process_copy_to_enumerated_filename "${_folder}" "${__src_base_dir}" "$_counter" "${__dest_base_folder}"
    else
    echo "[$(getTimestamp)]:LOOPSKIP:[${_folder}]"      | tee -a "${SRC_BASE_DIR}/${WGET_LOG}"
     continue; # skip the rest of the loop
    fi
    echo "[$(getTimestamp)]:LOOPEND:[${_folder}]"       | tee -a "${SRC_BASE_DIR}/${WGET_LOG}"
  done < "${__list}" #samplefolders.txt

}











#---------------------------------------------------------------------
# MAIN INIT FUNCTION
#---------------------------------------------------------------------
 #
runme () {
	menu
}

#---------------------------------------------------------------------
# MAIN MENU
#---------------------------------------------------------------------
 #
menu () {
    #clear
	echo "
    -------------------------------------------- 
    -- list-iterator ---------------------------------
    -------------------------------------------- 
    SRCDIR:          [${SRC_BASE_DIR}]
    DSTDIR:          [${DST_BASE_DIR}]
    WGET_LIST:       [${WGET_LIST}]
    MOUNTPOINT:      [${ISO_MOUNTPOINT}]
    S- Update the SRCDIR holding the sample folders
    D- Update the DSTDIR to create iso in
    F- Update wget file list path
    ------------------------------------------------                                        
    1- Read in & Process SINGLE Folder to ISO
    2- Test SINGLE ISO Image
    3- Create File List [${SRC_BASE_DIR}/${FOLDER_LIST}]
    4- Read & Process   [${SRC_BASE_DIR}/${FOLDER_LIST}]
    5- Edit             [${SRC_BASE_DIR}/${FOLDER_LIST}]
    ------------------------------------------------
    N- Convert NRG images to ISO using [${SRC_BASE_DIR}/${NRG_LIST}]
    T- Test ISO images in [${DST_BASE_DIR}] using [${DST_BASE_DIR}/${ISO_LIST}]
    W- enumerate files/urls
    Z- unZIP to FOLDER using [${SRC_BASE_DIR}/${ZIP_LIST}]
    ------------------------------------------------
    0-exit 0
    *-Prompt again
    "
	echo "------------------------------------------------"
	read -p "enter option: " opt
	echo "------------------------------------------------"
	echo "Typed: $opt"

	case "$opt" in
	"1")echo "Processing Single Folder to ISO"
        process_single_folder 
        ;;
	"2")echo "Testing SINGLE ISO Image"
        test_single_iso_image
        ;;
	"3")echo "Create samplefolders.txt"
		create_folder_list "${SRC_BASE_DIR}" "${FOLDER_LIST}"
		;;
	"4")echo "Read & Process samplefolders.txt"
		loop_ISO_LIST_create_iso "${SRC_BASE_DIR}" "${FOLDER_LIST}" "${DST_BASE_DIR}"
		;;
	"5") echo "Edit samplefolders.txt"
		nano "${SRC_BASE_DIR}"/"${FOLDER_LIST}"
		;;
	"S") echo "Update Src BaseDir"
        _get_user_resp "Enter NEW SRC BASEDIR ( Current:[${SRC_BASE_DIR}] ): "
        SRC_BASE_DIR="${_DATA}"
        # get_src_base_dir_folder ;;  
        ;;
    "D") echo "Update Dest BaseDir"
        _get_user_resp "Enter NEW DST BASEDIR ( Current:[${DST_BASE_DIR}] ): "
        DST_BASE_DIR="${_DATA}"
		# get_dst_base_dir_folder
		;;
    "w") echo wget filename
        _loop_WGET_LIST_copy_enumeration  "${SRC_BASE_DIR}" "${WGET_LIST}" "${DST_BASE_DIR}" 
        ;;
    "T") echo "Testing ISO images"
        echo "$(getTimestamp)" > "${DST_BASE_DIR}/${ISO_MOUNT_LOG}"
        create_file_list_by_ext "${DST_BASE_DIR}" "${ISO_LIST}" "iso"
        loop_isofile_list_mount_umount "${DST_BASE_DIR}" "${ISO_LIST}" "${ISO_MOUNTPOINT}"
        ;;
    "N") echo "NRG2ISO"
        create_file_list_by_ext "${SRC_BASE_DIR}" $"{NRG_LIST}" "nrg"
        _iterate_nrgfile_list_convert_nrg2iso "${SRC_BASE_DIR}" "${DST_BASE_DIR}" "${NRG_LIST}"
        ;;
    "Z") echo "unZIP to FOLDER"
        create_file_list_by_ext "${SRC_BASE_DIR}" $"{ZIP_LIST}" "zip"
        loop_src_zipfile_list_unzip "${SRC_BASE_DIR}" "${ZIP_LIST}" "${DST_BASE_DIR}"
        ;;
    "R") echo "unRAR to FOLDER"
        create_file_list_by_ext "${SRC_BASE_DIR}" $"{ZIP_LIST}" "rar"
        loop_src_zipfile_list_unzip "${SRC_BASE_DIR}" "${RAR_LIST}" "${DST_BASE_DIR}"
        ;;
	"0") echo "exiting..."
	    exit 0;;
	"x") echo "exiting..."
	    exit 0;;
	*) echo "Invalid Option selected, Retrying"
        menu
        ;; 
	esac
	menu	# show the menu again
}

#-----------------------------------------------------------------------
# WGET LIST
#-----------------------------------------------------------------------

# Iterate a text file, creating ISOs from each entry
  # dump timestamp & filelist path/contents to log file
  # echo "${__src_base_dir}/${__WGET_LIST}"             | tee -a "${SRC_BASE_DIR}/${WGET_LOG}"
  # cat "${SRC_BASE_DIR}/${WGET_LOG}"                   | tee -a "${SRC_BASE_DIR}/${WGET_LOG}"
 #
_loop_WGET_LIST_copy_enumeration() {
  local __src_base_dir="${1}"                 #local __txt_path="${1}"
  local __WGET_LIST="${2}"
  local __dest_base_folder="${3}"
  # read list text file and iterate through each line, skipping comments ( # )
  ((_counter=0))    # reset counter
  while IFS="" read -r _folder || [ -n "$_folder" ]
  do
    echo "[$(getTimestamp)]:LOOPSTART:[${_folder}]"     | tee -a "${SRC_BASE_DIR}/${WGET_LOG}"
    _process_run_line_is_tests "${_folder}"
    echo "SIZE:[${#_folder}][${_folder}]"
    if [ "${_flag_is_comment}" = "false" -a "${_flag_is_empty}" = "false"  ] ; then
     ((++_counter))
     echo "[#$_counter] LOOP: Processing:[${_folder}]"  | tee -a "${SRC_BASE_DIR}/${WGET_LOG}"
     process_copy_to_enumerated_filename "${_folder}" "${__src_base_dir}" "$_counter" "${__dest_base_folder}"
    else
    echo "[$(getTimestamp)]:LOOPSKIP:[${_folder}]"      | tee -a "${SRC_BASE_DIR}/${WGET_LOG}"
     continue; # skip the rest of the loop
    fi
    echo "[$(getTimestamp)]:LOOPEND:[${_folder}]"       | tee -a "${SRC_BASE_DIR}/${WGET_LOG}"
  done < "${__WGET_LIST}" #samplefolders.txt

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
  echo  "SRCDIR:[${_srcdir}] --- DSTDIR:[${_destdir}] --- COUNT-FILE:[${_c}]-[${_file}]" 
  echo cp "${_srcdir}"/"${_file}" "${_destdir}"/"${_c}"-"${_file}"
  cp -v "${_srcdir}"/"${_file}" "${_destdir}"/"${_c}"-"${_file}"
}

#---------------------------------------------------------------------
# FOLDER to ISO
#---------------------------------------------------------------------

## List a Path's DIRECTORIES & save to text file
 #
create_folder_list () {
	local __path="${1}"
	local __fname="${2}"
	getTimestamp

	cd "${__path}"

	echo '#
#=====================================================
#===== '${TIMESTAMP}' =====================' > "${__fname}"
	ls -d */ | sed -e 's-/$--' >> "${__fname}"
	echo '#
#===== '${TIMESTAMP}' =====================
#=====================================================' >> "${__fname}"
	cat "${__fname}"
	nano "${__fname}"

}

## Iterate a text file, creating ISOs from each entry
 #
loop_ISO_LIST_create_iso() {
  local __src_base_dir="${1}"                 #local __txt_path="${1}"
  local __iso_file_list="${2}"
  local __dest_base_folder="${3}"

  # dump timestamp & filelist path/contents to log file
  echo "${__src_base_dir}/${__iso_file_list}"           | tee -a "${SRC_BASE_DIR}/${FOLDER_LOG}"
  cat "${SRC_BASE_DIR}/${FOLDER_LOG}"                   | tee -a "${SRC_BASE_DIR}/${FOLDER_LOG}"

  # read list text file and iterate through each line, skipping comments ( # )
  ((_counter=0))    # reset counter
  while IFS="" read -r _folder || [ -n "$_folder" ]
  do
    echo $(getTimestamp)                                | tee -a "${SRC_BASE_DIR}/${FOLDER_LOG}"
    # test file entry for comment and iso extension
	  # _is_comment "$_folder"      # _flag_is_comment
    _process_run_line_is_tests "${_folder}"
    if [ "${_flag_is_comment}" = "false" -a "${_flag_is_empty}" = "false" ] ; then
     $((++_counter))
     echo "[#$_counter] LOOP: Processing:[${_folder}]"  | tee -a "${SRC_BASE_DIR}/${FOLDER_LOG}"
     process_with_lJR "${__src_base_dir}" "${_folder}" "${_folder}" "${_folder}" "${__dest_base_folder}"
    else
     echo "LOOP::Skipping:[${_folder}]"                 | tee -a "${SRC_BASE_DIR}/${FOLDER_LOG}"
     continue; # skip the rest of the loop
    fi
  done < "${__src_base_dir}/${__iso_file_list}" #samplefolders.txt

}

## SINGLE FOLDER prompt for src folder/image and dest folder
 #
process_single_folder () {
    local __src_base_dir=               #local __txt_path="${1}"
    local __dst_base_dir=
    local __folder=
    local __volumename=

    read -p "enter source basedir [ie: /media/uc]: " __src_base_dir
    echo "Typed: ${__src_base_dir}"
    read -p "enter source folder [ie: foldername]: " __folder
    echo "Typed: ${__folder}"
    read -p "enter volume name [ie: VolumeName]: " __volumename
    echo "Typed: ${__volumename}"
    read -p "enter destination folder [ie: /home/uc/mm3/s/000]: " __dst_base_dir
    echo "Typed: ${__dst_base_dir}"

    ((_counter=0))  #reset counter to zero just for the process func
    echo "Processing:[${_folder}]: START"           | tee -a "${SRC_BASE_DIR}/${FOLDER_LOG}"
    process_with_lJR "${__src_base_dir}" "${__folder}" "${__folder}" "${__folder}" "${__dst_base_dir}"
    echo "Processing:[${_folder}]: DONE"            | tee -a "${SRC_BASE_DIR}/${FOLDER_LOG}"
}

## Fetch values, then create iso image
 #
process_with_lJR_fetch_values() {
    get_src_folder
    get_volname
    get_fname
	process_with_lJR "${SRC}" "${volname}" "${fname}" "${DEST}"
}

## Process a SINGLE FOLDER to ISO with Joliet directory records in addition to regular iso9660 file names
 # -l full 31 char filenames
 # -J juliet + iso9660 file names
 # -R Generate System Use Sharing Protocol (SUSP) + Rock Ridge (RR) records using RR protocol
 # -joliet-long = 103 unicode chars
 #
process_with_lJR() {
    local __src_base_dir="${1}"
	local __src_folder="${2}"	    # single 
	local __volname="${3:0:31}"		# truncate at 31 chars for juliet
	local __fname="${4}"		#get_fname
	local __dest_base_folder="${5}"
    
	local __isoname="${__fname}.iso"
    echo "CREATING ISO IMAGE: VOLUME:[${__volname}] -- FOLDER:[${__src_base_dir}/${__src_folder}] -- ISO FILENAME:[${__dest_base_folder}/${__isoname}]" | tee -a "${SRC_BASE_DIR}/${FOLDER_LOG}"
    mkisofs -lJR -pad -input-charset "utf-8" -V "${__volname}" -o "${__dest_base_folder}/${__isoname}" "${__src_base_dir}/${__src_folder}/"
    # save error code from command
	status=$?;
   	# if rip fails, rename iso then try to tar it
    if [ ${status} -ne 0 ] ; then
        echo "[#$_counter]FAILED!! STATUS:[${status}] :: CREATING ISO IMAGE: VOLUMNE:[${__volname}] -- FOLDER:[${__src_base_dir}/${__src_folder}] -- ISO FILENAME:[${__dest_base_folder}/${__isoname}]" \
        | tee -a "${SRC_BASE_DIR}/${FOLDER_LOG}"
    else
        echo "[#$_counter]SUCCESS: STATUS:[${status}] :: CREATING ISO IMAGE: VOLUMNE:[${__volname}] -- FOLDER:[${__src_base_dir}/${__src_folder}] -- ISO FILENAME:[${__dest_base_folder}/${__isoname}]" \
        | tee -a "${SRC_BASE_DIR}/${FOLDER_LOG}"
    fi

}

#-----------------------------------------------------------------------
# ISO TEST MOUNT
#-----------------------------------------------------------------------

# Iterate a isofile, test by mount/umount
#
loop_isofile_list_mount_umount () {
  local __dest_base_folder="${1}"                 #local __txt_path="${1}"
  local __iso_file_list="${2}"
  local __iso_mount_point="${3}"

  # dump timestamp & filelist path/contents to log file
  echo "$(getTimestamp)"                                | tee -a "${DST_BASE_DIR}/${ISO_MOUNT_LOG}"
  echo "${__dest_base_folder}/${__iso_file_list}"       | tee -a "${DST_BASE_DIR}/${ISO_MOUNT_LOG}"
  # read list text file and iterate through each line, skipping comments ( # )
  ((_counter=0))    # reset counter
  while IFS="" read -r _isofile || [ -n "$_isofile" ]
  do
    echo $(getTimestamp)                                | tee -a "${DST_BASE_DIR}/${ISO_MOUNT_LOG}"
    # test file entry for comment and iso extension
    _is_comment "$_isofile"                             # _flag_is_comment
    _is_expected_extension "$_isofile" ".iso" "true"    # _flag_return
    if [ "${_flag_is_comment}" == "false" ] && [ "${_flag_return}" == "true" ] ; then
     ((++_counter))
     echo "LOOP:[$_counter]:Processing:[${_isofile}]"   | tee -a "${DST_BASE_DIR}/${ISO_MOUNT_LOG}"
     _test_mount_iso_image "${__dest_base_folder}" "${_isofile}" "${__iso_mount_point}" 
     _test_umount_iso_image "${__iso_mount_point}"
    else
     echo "LOOP::Skipping:[${_isofile}]"                | tee -a "${DST_BASE_DIR}/${ISO_MOUNT_LOG}"
     continue; # skip the rest of the loop
    fi
  done < "${__dest_base_folder}/${__iso_file_list}" #samplefolders.txt

}

## prompt for single image to test
 #
test_single_iso_image () {
    local _basedir="${1}"
    local _fname="${2}"
    local _mountpoint="${ISO_MOUNTPOINT}"

    read -p "Enter image file path: " _basedir
    echo "Typed: ${_basedir}"

    read -p "Enter image file path: " __isoimage
    echo "Typed: ${__isoimage}"

    _test_mount_iso_image "${_basedir}"  "${__isoimage}"  "${_mountpoint}"
    _test_umount_iso_image "${_mountpoint}"

}

## MOUNT ISO image
 #
_test_mount_iso_image () {
    local _basedir="${1}"
    local _fname="${2}"
    local _mountpoint="${3}"

    # attempt to UN-MOUNT any previously mounted iso image to the mountpoint
    echo "TEST PREP: ATTEMPT UN-MOUNT: [umount ${_mountpoint}]"                         | tee -a "${DST_BASE_DIR}/${ISO_MOUNT_LOG}"
    sudo umount "${_mountpoint}"
    sleep 3

    # MOUNT iso image and list root
    echo "TEST START: ATTEMPT MOUNT: [fuseiso -n ${_basedir}/${_fname} ${_mountpoint}]" | tee -a "${DST_BASE_DIR}/${ISO_MOUNT_LOG}"
    sudo fuseiso -n "${_basedir}/${_fname}" "${_mountpoint}"    
    status=$?       # save error code from command ## Test status for SUCCESS [0] 
    sleep 3
    sudo ls "${_mountpoint}"                                                            | tee -a "${DST_BASE_DIR}/${ISO_MOUNT_LOG}"
    # if mount fails, log it
    if [ ${status} -ne 0 ] ; then
        echo "[#$_counter]FAILED!! STATUS:[${status}] :: MOUNT ISO IMAGE: [fuseiso -n ${_basedir}/${_fname} ${_mountpoint}]" | tee -a "${DST_BASE_DIR}/${ISO_MOUNT_LOG}"
    else
        echo "[#$_counter]SUCCESS: STATUS:[${status}] :: MOUNT ISO IMAGE: [fuseiso -n ${_basedir}/${_fname} ${_mountpoint}]" | tee -a "${DST_BASE_DIR}/${ISO_MOUNT_LOG}"
    fi

}

# UNMOUNT ISO image
#
_test_umount_iso_image () {
    local _mountpoint="${1}"
    # unmount iso image
    echo "TEST START: ATTEMPT UN-MOUNT: [umount ${_mountpoint}]"                                        | tee -a "${DST_BASE_DIR}/${ISO_MOUNT_LOG}"
    sudo umount "${_mountpoint}"
	status=$?   # save error code from command ## Test status for SUCCESS [0]
    # if umount fails, log it
    if [ ${status} -ne 0 ] ; then
        echo "[#$_counter]FAILED!! STATUS:[${status}] :: UN-MOUNT ISO IMAGE: [umount ${_mountpoint}]"   | tee -a "${DST_BASE_DIR}/${ISO_MOUNT_LOG}"
    else
        echo "[#$_counter]SUCCESS: STATUS:[${status}] :: UN-MOUNT ISO IMAGE: [umount ${_mountpoint}]"   | tee -a "${DST_BASE_DIR}/${ISO_MOUNT_LOG}"
    fi

}



#-----------------------------------------------------------------------
# NRG
#-----------------------------------------------------------------------

_iterate_nrgfile_list_convert_nrg2iso () {
  local __src_base_dir="${1}"
  local __dest_base_dir="${2}"                 #local __txt_path="${1}"
  local __nrg_file_list="${3}"

  # dump timestamp & filelist path/contents to log file
  echo "$(getTimestamp)"                            | tee -a "${SRC_BASE_DIR}/${NRG_LOG}"
  echo "${__src_base_dir}/${__nrg_file_list}"       | tee -a "${SRC_BASE_DIR}/${NRG_LOG}"
  
  # read list text file and iterate through each line, skipping comments ( # )
  ((_counter=0))    # reset counter
  while IFS="" read -r _nrgfile || [ -n "$_nrgfile" ]
  do
    # printf '%s\n' "$_nrgfile"
    echo $(getTimestamp)                                | tee -a "${SRC_BASE_DIR}/${NRG_LOG}"
    # test file entry for comment and iso extension
    _is_comment "$_nrgfile"                             # _flag_is_comment
    _is_expected_extension "$_nrgfile" ".nrg" "true"    # _flag_return
    if [ "${_flag_is_comment}" == "false" ] && [ "${_flag_return}" == "true" ] ; then
     ((++_counter))
     echo "[$_counter] LOOP: Processing:[${_nrgfile}]"  | tee -a "${SRC_BASE_DIR}/${NRG_LOG}"
     _convert_nrg_2_iso "${__src_base_dir}" "${_nrgfile}" "${__dest_base_dir}"
    else
     echo "LOOP::Skipping:[${_nrgfile}]"                | tee -a "${SRC_BASE_DIR}/${NRG_LOG}"
     continue; # skip the rest of the loop
    fi
  done < "${__src_base_dir}/${__nrg_file_list}" #samplefolders.txt

}

# convert NRG to ISO
# requires package: sudo apt-get install nrg2iso
#
_convert_nrg_2_iso () {
    local __src_base_dir="${1}"
	local __fname="${2}"
	local __dest_base_dir="${3}"
    echo "Converting NRG to ISO: ${__src_base_dir}/${__fname} ${__dest_base_dir}/${__fname:0:${#__fname}-4}.iso"    | tee -a "${SRC_BASE_DIR}/${NRG_LOG}"
    nrg2iso "${__src_base_dir}/${__fname}" "${__dest_base_dir}/${__fname:0:${#__fname}-4}.iso"                      | tee -a "${SRC_BASE_DIR}/${NRG_LOG}"

}


#-----------------------------------------------------------------------
# ZIP FILES
#-----------------------------------------------------------------------

# Iterate a text file, unziping each file to dir
#
loop_src_zipfile_list_unzip() {
  local __src_base_dir="${1}"                 #local __txt_path="${1}"
  local __WGET_LIST="${2}"
  local __dst_base_folder="${3}"

  # read list text file and iterate through each line, skipping comments ( # )
  ((_counter=0))    # reset counter
  while IFS="" read -r _zipfile || [ -n "$_zipfile" ]
  do
    echo $(getTimestamp)                                    | tee -a "${SRC_BASE_DIR}/${ZIP_LOG}"
      # test file entry for comment and iso extension
    _is_comment "${_zipfile}"                           # _flag_is_comment
    _is_expected_extension "${_zipfile}" ".zip" "true"  # _flag_return
    if [ "${_flag_is_comment}" == "false" ] && [ "${_flag_return}" == "true" ] ; then
    ((++_counter))
     echo "[$_counter] LOOP::Processing:[${_zipfile}]"      | tee -a "${SRC_BASE_DIR}/${ZIP_LOG}"
     process_with_unzip "${__src_base_dir}" "${_zipfile}" "${__dst_base_folder}"
    else
     echo "LOOP::Skipping:[${_zipfile}]"                    | tee -a "${SRC_BASE_DIR}/${ZIP_LOG}"
     continue; # skip the rest of the loop
    fi
  done < "${__src_base_dir}"/"${__WGET_LIST}"

}

# Process a SINGLE ZIPFILE
#
process_with_unzip() {
    local __src_base_dir="${1}"
	local __src_zipfile="${2}"	    # single 
	local __dest_base_folder="${3}"
    unzip "${__src_base_dir}/${__src_zipfile}" -d "${__dest_base_folder}/"  | tee -a "${SRC_BASE_DIR}/${ZIP_LOG}"

}


#-----------------------------------------------------------------------
# GET Data FUNCS
#-----------------------------------------------------------------------

# # Prompt for RELATIVE folder path for processing multiple items from [ls] or [filelist]
# #
# get_src_folder(){
#     read -p "Enter SRC_FOLDER ( absolute path: /home/uc/Downloads/coolfolder ): " RESP
#     echo "Typed: $RESP"
#     SRC_FOLDER="${RESP}"
# }

# # Prompt for ABSOLUTE folder path for processing single item
# #
# get_src_folder_absolute(){
#     read -p "Enter SRC_FOLDER ( absolute path: /home/uc/Downloads/coolfolder ): " RESP
#     echo "Typed: $RESP"
#     SRC_FOLDER="${RESP}"
# }

# # Update SRC_BASE_DIR
# #
# get_src_base_dir_folder(){
#     read -p "Enter NEW SRC BASEDIR ( Current:[${SRC_BASE_DIR}] ): " RESP
#     echo "Typed: $RESP"
#     SRC_BASE_DIR="${RESP}"

# }

# Prompt for iso destination FOLDER
#
get_dst_base_dir_folder(){
    read -p "Enter NEW DST BASEDIR ( Current:[${DST_BASE_DIR}] ): " RESP
    echo "Typed: $RESP"
    DST_BASE_DIR="${RESP}"

}

# Prompt for VOLUMENAME for iso from ( MAX 31 chars)
#
get_volname(){
    read -p "Enter Volume Name: " RESP
    echo "Typed: $RESP"
    volname="${RESP}"

}

# Prompt for FILENAME to make iso from
#
get_fname() {
    read -p "Enter File Name: " RESP
    echo "Typed: $RESP"
    fname="${RESP}"

}



## List a Path's files & save to text file
 #  do not include '.'
 #
create_file_list_by_ext () {
	local __path="${1}"
	local __filename="${2}"
    local __file_ext="${3}"
	getTimestamp

	cd "${__path}"

	echo '#
#=====================================================
#===== '${TIMESTAMP}' =====================' > "${__filename}"
    cd "${__path}"
    ls *.${__file_ext} >> "${__filename}"
#	ls -d */ | sed -e 's-/$--' >> "${__filename}" # samplefolders.txt

	echo '#
#===== '${TIMESTAMP}' =====================
#=====================================================' >> "${__filename}"

	cat "${__filename}"
	nano "${__filename}"

}



#---------------------------------------------------------------------
# MAIN
#---------------------------------------------------------------------
# MAIN entrance block
 #  if there are NO ARGS, call 'runme'
 #  if there ARE ARGS, use the FIRST as a FUNCTION CALL
 #
if [ -z "$1" ]; then
	runme
else
	$1
fi

echo "Done, Exiting..."

