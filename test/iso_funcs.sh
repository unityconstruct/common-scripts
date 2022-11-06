#!/bin/bash
#-----------------------------------------------------------------------
# ISO FUNCS
#-----------------------------------------------------------------------



## use absolute path
 #
_process_iso_mkiso_absolute_path() {
	local __fullpath="${1}"	    # single 
	local __isofile="${2}"		    # output filename base WITHOUT .iso extension
	local __volname="${3:0:31}"		# truncate at 31 chars for juliet
	local __destdir="${6}"
    
	local __isoname="${__fname}.iso"
    _log "CREATING ISO IMAGE: VOLUME:[${__volname}] -- FOLDER:[${__fullpath}] -- ISO FILENAME:[${__destdir}/${__isofile}]" | tee -a "${SRC_BASE_DIR}/${FOLDER_LOG}"
    mkisofs -lJR -pad -input-charset "utf-8" -V "${__volname}" -o "${__destdir}/${__isofile}" "${__fullpath}/"
    # save error code from command
	status=$?;
   	# if rip fails, rename iso then try to tar it
    if [ ${status} -ne 0 ] ; then
        _log "[#$_counter]FAILED!! STATUS:[${status}] :: CREATING ISO IMAGE: VOLUMNE:[${__volname}] -- FOLDER:[${__fullpath}] -- ISO FILENAME:[${__destdir}/${__isofile}]"
    else
        _log "[#$_counter]SUCCESS: STATUS:[${status}] :: CREATING ISO IMAGE: VOLUMNE:[${__volname}] -- FOLDER:[${__fullpath}] -- ISO FILENAME:[${__destdir}/${__isofile}]"
    fi

}

## Process a SINGLE FOLDER to ISO with Joliet directory records in addition to regular iso9660 file names
 # -l full 31 char filenames
 # -J juliet + iso9660 file names
 # -R Generate System Use Sharing Protocol (SUSP) + Rock Ridge (RR) records using RR protocol
 # -joliet-long = 103 unicode chars
 #
_process_iso_mkiso() {
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




## prompt for single image to test
 #
_process_testiso_prompt_single () {
    # local _basedir="${1}"
    # local _fname="${2}"
    # local _mountpoint="${3}"
    _get_user_resp "Enter image src dir path: "
    _basedir="${__DATA}"
    _get_user_resp "Enter image filename: "
    __isoimage="${__DATA}"
    _get_user_resp "Enter mountpoint: (/media/isomount): "
    _mountpoint="${__DATA}"
    _process_testiso_mountimg "${_basedir}"  "${__isoimage}"  "${_mountpoint}"
    _process_testiso_umountimg "${_mountpoint}"
}

## MOUNT ISO image
 #
_process_testiso_mountimg () {
    local _basedir="${1}"
    local _fname="${2}"
    local _mountpoint="${3}"

    # attempt to UN-MOUNT any previously mounted iso image to the mountpoint
    _log "TEST PREP: ATTEMPT UN-MOUNT: [umount ${_mountpoint}]"
    sudo umount "${_mountpoint}"
    sleep 3

    # MOUNT iso image and list root
    _log "TEST START: ATTEMPT MOUNT: [fuseiso -n ${_basedir}/${_fname} ${_mountpoint}]"
    sudo fuseiso -n "${_basedir}/${_fname}" "${_mountpoint}"    
    status=$?       # save error code from command ## Test status for SUCCESS [0] 
    sleep 3
    sudo ls "${_mountpoint}"
    # if mount fails, log it
    if [ ${status} -ne 0 ] ; then
        _log "[#$_counter]FAILED!! STATUS:[${status}] :: MOUNT ISO IMAGE: [fuseiso -n ${_basedir}/${_fname} ${_mountpoint}]"
    else
        _log "[#$_counter]SUCCESS: STATUS:[${status}] :: MOUNT ISO IMAGE: [fuseiso -n ${_basedir}/${_fname} ${_mountpoint}]"
    fi
}

# UNMOUNT ISO image
#
_process_testiso_umountimg () {
    local _mountpoint="${1}"
    # unmount iso image
    _log "TEST START: ATTEMPT UN-MOUNT: [umount ${_mountpoint}]"
    sudo umount "${_mountpoint}"
	status=$?   # save error code from command ## Test status for SUCCESS [0]
    # if umount fails, log it
    if [ ${status} -ne 0 ] ; then
        _log "[#$_counter]FAILED!! STATUS:[${status}] :: UN-MOUNT ISO IMAGE: [umount ${_mountpoint}]"
    else
        _log "[#$_counter]SUCCESS: STATUS:[${status}] :: UN-MOUNT ISO IMAGE: [umount ${_mountpoint}]"
    fi
}
