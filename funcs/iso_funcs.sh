#!/bin/bash
#-----------------------------------------------------------------------
# ISO FUNCS
#-----------------------------------------------------------------------

#-----------------------------------------------------------------------
# MKISOFS FUNCS
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

#-----------------------------------------------------------------------
# MOUNT/UMOUNTS FUNCS
#-----------------------------------------------------------------------

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


#-----------------------------------------------------------------------
# DD RIP FUNCS
#-----------------------------------------------------------------------

_dd_select_dev() {

	echo "listing devices"
	lsblk
	echo "Current DRIVE:[${DRIVE}]"
	read -p "Enter DRIVE #: /dev/sr" resp
	echo "Typed:[${resp}]"
	
	if [ -z ${resp} ] ; then
		echo "Using default DRIVE:[${DRIVE}]"
    elif [ ${resp} = "r" ] ; then
        _dd_select_dev
	else
		echo "Drive OLD:[${DRIVE}]"
		DRIVE="/dev/sr${resp}";
		echo "Drive NEW:[${DRIVE}]"
	fi

}



_dd_show_isosize_values () {
  local _DRIVE="${1}"
  local _blocksize="${2}"
  local _blocks="${3}"
  echo "${_DRIVE}"
  echo "${_blocks}"
  echo "${_blocksize}"
}


declare -A _dromcopy=(["discname"]="discname"
  ["fname"]="*discname.iso"
  ["DRIVE"]=""
  ["blocksize"]=""
  ["dstdir"]=""
  ["srcdir"]=""
  ["tardir"]=""
  ["stordir"]=""

)


_dd_device_to_file(){
    local _drive="$1"
    local _DSTDIR="$2"
    local _fname="$3"
    local _blocksize="$4"

    # get size
	local blocks="$(isosize -d ${_blocksize} ${_drive})"
	_dd_show_isosize_values  ${_drive} ${_blocksize} ${blocks}
	_log "sudo dd if=${_drive} of=${_DSTDIR}/${_fname} bs=${_blocksize} count=${blocks} status=progress"
    sudo dd if=${_drive} of=${_DSTDIR}/${_fname} bs=${_blocksize} count=${blocks} status=progress
}

_dd_command(){
 echo .
}

_ripdiscs() {
	# prompt for filename, then rip to ISO
	echo "Add disc to drive"
	echo "Type filename ( '.iso' will be appended) :"
	read -p "Filename: " resp
	fname="${resp}".iso
	tardir="${resp}"
	echo "Creating:[${DSTDIR}${fname}]";
	_close_drive
	_ripdisc
	_doagain

}


_doagain() {
	# prompt for ripping another 
	read -p "RIP another? : " resp
	echo "Typed:[${resp}]"
	if [ "${resp}" == "y" -o "${resp}" == "Y" ] ; then
		echo "ripping another"
		_ripdiscs;
	elif [ "${resp}" == "a" -o "${resp}" == "A" ] ; then
		__abcde_discs
	else 
		echo "returning to menu"
		__menu
	fi
	_paused

}

## rip cdrom device at low level with 'dd'
 #
_ripdisc () {
	# rip to filename specificed in CLI call
	echo "stordir  : [${stordir}]"      # 
	echo "DSTDIR  : [${DSTDIR}]"
	echo "fname    : [${fname}]"
	echo "drive    : [${drive}]"
	echo "blocksize: [${blocksize}]"


    _dd_device_to_file ${drive} ${DSTDIR} ${fname} ${blocksize}
    # ------------ __dd_device_to_file ------------------------
	# get size
	# blocks=$(isosize -d ${blocksize} ${drive});
	# _dd_show_isosize_values
	# sudo dd if=${drive} of=${DSTDIR}${fname} bs=${blocksize} count=$blocks status=progress;
    # ------------ __dd_device_to_file ------------------------



	# save error code from the dd rip
	status=$?
	echo "\nRIPSSTATUS: [${status}]\n"
	if [ ${status} -eq 0 ] ; then
		echo ""
		echo ""
		echo "************************"
		echo "RIP SUCCESS :: IMAGE [${DSTDIR}/${fname}]"
		echo "************************"
		echo ""
		echo ""
		echo "pausing for 30s to let write buffer clear before flushing with sync..."; 
		sleep 30
	fi

	sync

	echo "making file writeable for all with 777.."
	sudo chmod 777 ${DSTDIR}/${fname}

	# if disc rip fails, then tar it
	if [ ${status} -ne 0 ] ; then
		echo "RIP ERROR: Status: [${status}]: [${DSTDIR}/${fname}]" >&2
		# Rename image with '_' prefix
		echo "RENAMING ISO IMAGE:[${fname}] to [_${fname}]"
		mv ${DSTDIR}/${fname} ${DSTDIR}/"_"${fname}
		# move incomplete image to remote storage
		echo "Moving FROM:[${DSTDIR}*.iso] TO:[${stordir}]..."
		mv ${DSTDIR}/*.iso ${stordir}
		status=$?
		if [ ${status} -eq 0 ] ; then
	    	echo "MOVE SUCCESS :: FROM:[${DSTDIR}*.iso] TO:[${stordir}]"
		else       
	   		echo "MOVE ERROR: Status[${status}] :: FROM:[${DSTDIR}*.iso] TO:[${stordir}]"
	    fi
	    echo "Done, Listing local then remote..."
	    echo "[${DSTDIR}/${fname}]"
		ls -la ${DSTDIR}/${fname}
		echo "[${stordir}/${fname}]"
	    ls -la ${stordir}/${fname}
		echo "TAR'ing disc now...";





		_tardisc











	fi
	echo "************************"
	echo "Done with disc. Listing destination iso/tars: "[${DSTDIR}/*.iso/tar]
	ls -la  ${DSTDIR}/*.{iso,tar}
	echo "************************"
	echo "CURRENT IMAGE [${DSTDIR}/${fname}]"
	echo "************************"

	# attempt to eject disc
	_eject_drive
}


#-----------------------------------------------------------------------
# ABCDE FUNCS
#-----------------------------------------------------------------------

# abcde -o ogg,mp3 -V -L -d disc.flac # to rip ogg files from the flac.
  # -d ${drive}
  # -k  keep WAV source
  # -L  use local cddb repo
  # -1  encode entire CD in a single file
  # -c config_file.conf
  # -o  output file type
_abcde_discs () {
	echo "Encoding audio cd with abcde to ${DSTDIR}"
    local _drive=${1}
    local _destdir=${2}
    local _stordir=${3}
    local _artistname=${4}
    local _volname=${5}
    local _types=${6}
	local _discdir="${_artistname}-${_volname}"
	local _flacname="${_volname}.flac"
	_close_drive

	echo "Creating:[${_destdir}/${_volname}]";
	mkdir -p ${_destdir}/${_volname}		# create new folder
	cd ${_destdir}/${_volname}				# and enter it
    echo "_abcde_rip ${_drive}"				# rip disc to flac
    _abcde_rip ${_drive}					# rip disc to flac'

    _abcde_rename_move_wav_clean_temp_dir ${_discdir}    # pull WAV file & remove status file that prevents encoding
	_abcde_flac_encode ${_destdir} ${_volname} ${_types} # encode the flac to wav,mp3
    _abcde_rename_move_flac_cue ${_discdir}              # pull & rename flac/cue files from UnknownArtist

	cd ${_destdir}						                 # return to working dir
	echo "Moving ${_destdir}/${_volname} TO ${_stordir}"
    mv ${_destdir}/${_volname} ${_stordir}               # move to perm storage

	_doagain                                             # prompt for next iteration
}

## pull wav file from abcde working dir
 #
_abcde_rename_move_wav_clean_temp_dir(){
    local _fname="${1}"
    for _f in $( find "." -maxdepth 4 -name '*.wav') ; do   # find wav in subdir
        mv ${_f} "${_fname}.wav"                            # move & rename
    done
}

## ## pull cue and flac file from initual Unknown Artist dir, then remove it
 #
_abcde_rename_move_flac_cue(){
    local _fname="${1}"
    for _f in $( find "." -maxdepth 4 -name '*.flac') ; do  # find flac in subdirs
        mv ${_f} "${_fname}.flac"                           # move and rename
    done
    for _f in $( find "." -maxdepth 4 -name '*.cue') ; do   # find cue in subdirs
        mv ${_f} "${_fname}.cue"                            # move and rename
    done
    rm -d "Unknown_Artist-Unknown_Album"                    # then remove UnkownArtist IF EMPTY
}

## encode RAW disc data from abcde
 #
_abcde_flac_encode () {
    local _dstdir=${1}
    local _volname=${2}
    local _types=${3}
	echo "-----------------------"
	echo "Encoding flac to ogg,mp3: [${_dstdir}/${_volname}] starting..."
    _process_flac_audio_folder ${_types}
	echo "Encoding flac to ogg,mp3: [${_dstdir}/${_volname}] Done."
    echo "-----------------------"
}

## search path for *.flac files, the process to mp3, etc
 #
_process_flac_audio_folder() {
    local _types="${1}"
  for _f in $( find "." -maxdepth 4 -name '*.flac') ; do 
     echo "_process_flac_audio_file: [${_f}]"
    _process_flac_audio_file ${_f} ${_types}
  done;
}

## process a flac file to mp3, etc - clean status files from subdir that prevent encoding
 # 
_process_flac_audio_file(){
    local _flac="${1}"
    local _types="${2}"
    for _f in $( find "." -maxdepth 4 -name 'status') ; do  # find staus files in subdir
        rm ${_f}                                            # remove them
    done
    echo "abcde -o ${_types} -V -L -d ${_flac}"
    abcde -o ${_types} -V -L -p -m -d ${_flac}              # encode 'types'- ex: "mp3,wav"
}

## rip media disc to FLAC
 #  requires:
 #  sudo apt install abcde flac mkcue eyed3 lame
_abcde_rip () {
    local _drive=${1}
	echo "-----------------------"
	echo "Ripping entire disk to 1 flac: starting..."
	abcde -d ${_drive} -V -L -k -p -N -1 -x -o flac -a default,cue,  # to rip the flac
	echo "Ripping entire disk to 1 flac: Done."
	echo "-----------------------"
	echo "OUTPUT:"
	ls
	echo "-----------------------"
}





#-----------------------------------------------------------------------
# TAR FUNCS
#-----------------------------------------------------------------------

##
 #
tardiscs () {
	# prompt for filename, then rip to TAR
	echo "Type filename ( '.tar' will be appended) :";
	read -p "Filename: " resp;
	fname="${resp}".tar
	tardir="${resp}"
	echo "Creating:[${DSTDIR}/${fname}]";
	tardisc
	taragain

}

##
 #
taragain () {
    # prompt for ripping another 
    read -p "TAR another? : " resp
    echo "Typed:[${resp}]"
    if [ "${resp}" == "y" -o "${resp}" == "Y" ] ; then
        echo "tar-ing another"
        tardiscs;
    else 
        echo "exiting"
        exit 0;
    fi
    _paused;

}


# Mount DRIVE and create TAR from contents
 # _tardisc ${DRIVE} ${DSTDIR} "${DSTDIR}/mnt" "TARNAME" ${STORDIR} ;;
 #
_tardisc () {
    local _drive=${1}
    local _dstdir=${2}
    local _mountpoint=${3}
    local _tarname=${4}
    local _stordir=${5}
    
    _dev_unmount ${_drive}      # _cdrom_umount ${_drive} ${_mountpoint}
    _close_drive ${_drive}
    # device might be automounted elsehere by the OS, so unmount using the device handle
    _cdrom_mount ${_drive} ${_mountpoint}   # now ok to try mount to specified mountpoint

# SKIPPING CREATING TEMP DIR & TAR'ING DIRECT FROM DISC/MOUNTPOINT
# echo "Creating tempdir: [${DSTDIR}/${_tempdir}]"
# mkdir ${DSTDIR}/${_tempdir}

# echo "Copying files FROM:[${DSTDIR}mnt/] :: TO:[${DSTDIR}/${_tempdir}]" 
# cp -Rv ${_mountpoint}/* ${DSTDIR}/${_tempdir}/
# sudo chmod -R 777 ${DSTDIR}/${_tempdir}

# echo "sleeping 10s"; sleep 10



    # echo "Taring files to:[${DSTDIR}${_tempdir}.tar]"
    # cd ${DSTDIR}/${_tempdir}
    # tar -cv --ignore-failed-read -f ${DSTDIR}/${_tempdir}.tar * | tee ${_LOG}
    # chmod 777 ${DSTDIR}/${_tempdir}.tar  | tee ${_LOG}
    # cd ..
	echo "Taring files to:[${_dstdir}/${_tarname}.tar]"
    cd ${_mountpoint}
    echo "tar -cv --ignore-failed-read  --directory=${_mountpoint} -f ${_dstdir}/${_tarname}.tar *   "
	tar -cv --ignore-failed-read   -f ${_dstdir}/${_tarname}.tar  *     | tee ${_dstdir}${_LOG}
    cd ..
    chmod 777 ${DSTDIR}/*.tar                                           | tee ${_dstdir}${_LOG}

    # device might be automounted elsehere by the OS, so unmount using the device handle
    _dev_unmount ${_drive}      # _unmount_disc ${_drive} ${_mountpoint}
        
    echo "Done, Listing local tars: [${_dstdir}/*.tar]..."
    ls -la ${_dstdir}/*.tar

	# MOVING TAR to remote folder
	echo "Moving FROM:[${_dstdir}/*.tar] TO:[${_stordir}]..."
	mv ${_dstdir}/*.tar ${_stordir}
	status=$?
	if [ ${status} -eq 0 ] ; then
		echo "Move SUCCESS"
	else       
		echo "Move ERROR: Status[${status}] ";
	fi

	_log "Done."
    _log "local tars..."
	echo "[${_dstdir}/*.tar]"
	ls -la ${_dstdir}/*.tar

    _log "remtoe tars..."
	echo "[${_stordir}/*.tar]"
	ls -la ${_stordir}/*.tar

    _eject_drive
}


## call CLOSE on CDROM device, then wait 30s for disc to load
 #
_close_drive () {
    local _drive=${1}
    local _wait=${2}

    if [ -z "${_wait}" ]; then      # if no wait is passed, use a default
        _wait=30
    fi

	echo "loading disc tray & waiting [${_wait}] seconds"
	 eject -t ${drive} 
     sleep ${_wait}
}

## wait for a bit, the eject CDROM device
 # wait is to allow media to spin down
 #
_eject_drive () {
	sleep 10
	eject ${drive}
}

##
 #
_cdrom_mount(){
    local _drive=${1}
    local _mountpoint=${2}
	echo "Mounting disc:[${_drive}]"
	sudo mount ${_drive} ${_mountpoint}
}

##
 #
_cdrom_unmount () {
    local _drive=${1}
    local _mountpoint=${2}
	echo "UnMounting disc:[${_drive}]"
	sudo umount ${_mountpoint}
}

_dev_unmount () {
    local _drive=${1}
	echo "UnMounting disc:[${_drive}]"
	sudo umount ${_drive}
}