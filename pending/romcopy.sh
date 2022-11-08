#!/bin/bash
#----------------------------------------------------
# ROMCOPY v2020.0621
# Util for Ripping DiscMedia to ISO Image using dd
#  rips disc media to ISO
#  if disc read error occurs, then TAR what is readable
#----------------------------------------------------
FRAMEWORKPATH="$(dirname "$0")/.."
source ${FRAMEWORKPATH}/funcs/collector_remote.sh
echo "[main][framworkpath:${FRAMEWORKPATH}][Testing Timestamp:$(getTimestamp)]"
_LOG=test.log


# Vars
#STORDIR=/media/iso1
#STORDIR=/media/media1/000
#STORDIR=/media/media1/iso/
DSTDIR=/tmp/rom
STORDIR=/media/media1/iso/
fname=disc.iso
tardir=disc
# source DRIVE
DRIVE=/dev/sr0
# blocksize
blocksize=2048
__logfile=romcopy.log

# __show_dd_values () {
#   echo "${DRIVE}"
#   echo "${blocks}"
#   echo "${blocksize}"

# }



# ##  ISO FUNCTIONS
# ripdisc () {
# 	# rip to filename specificed in CLI call
# 	echo "STORDIR  : [${STORDIR}]"
# 	echo "DSTDIR  : [${DSTDIR}]"
# 	echo "fname    : [${fname}]"
# 	echo "DRIVE    : [${DRIVE}]"
# 	echo "blocksize: [${blocksize}]"

# 	# get size
# 	blocks=$(isosize -d ${blocksize} ${DRIVE});
# 	__show_dd_values
# 	sudo dd if=${DRIVE} of=${DSTDIR}${fname} bs=${blocksize} count=$blocks status=progress;

# 	# save error code from the dd rip
# 	status=$?
# 	echo "\nRIPSSTATUS: [${status}]\n"
# 	if [ ${status} -eq 0 ] ; then
# 		echo ""
# 		echo ""
# 		echo "************************"
# 		echo "RIP SUCCESS :: IMAGE [${DSTDIR}${fname}]"
# 		echo "************************"
# 		echo ""
# 		echo ""
# 		echo "pausing for 30s to let write buffer clear before flushing with sync..."; 
# 		sleep 30
# 	fi

# 	sync

# 	echo "making file writeable for all with 777.."
# 	sudo chmod 777 ${DSTDIR}${fname}

# 	# if disc rip fails, then tar it
# 	if [ ${status} -ne 0 ] ; then
# 		echo "RIP ERROR: Status: [${status}]: [${DSTDIR}${fname}]" >&2
# 		# Rename image with '_' prefix
# 		echo "RENAMING ISO IMAGE:[${fname}] to [_${fname}]"
# 		mv ${DSTDIR}${fname} ${DSTDIR}"_"${fname}
# 		# move incomplete image to remote storage
# 		echo "Moving FROM:[${DSTDIR}*.iso] TO:[${STORDIR}]..."
# 		mv ${DSTDIR}*.iso ${STORDIR}
# 		status=$?
# 		if [ ${status} -eq 0 ] ; then
# 	    	echo "MOVE SUCCESS :: FROM:[${DSTDIR}*.iso] TO:[${STORDIR}]"
# 		else       
# 	   		echo "MOVE ERROR: Status[${status}] :: FROM:[${DSTDIR}*.iso] TO:[${STORDIR}]"
# 	    fi
# 	    echo "Done, Listing local then remote..."
# 	    #echo "[${DSTDIR}*.iso]"
# 	    #ls -la ${DSTDIR}*.iso
# 	    echo "[${DSTDIR}${fname}]"
# 		ls -la ${DSTDIR}${fname}
# 	    #echo "[${STORDIR}*.iso]"
# 	    #ls -la ${STORDIR}*.iso
# 		echo "[${STORDIR}${fname}]"
# 	    ls -la ${STORDIR}${fname}
# 		#echo "Listing the new image: "${DSTDIR}"_"${fname}
# 		#ls -la ${DSTDIR}
# 		echo "TAR'ing disc now...";
# 		tardisc
# 	fi
# 	echo "************************"
# 	echo "Done with disc. Listing destination iso/tars: "[${DSTDIR}*.iso/tar]
# 	ls -la  ${DSTDIR}*.{iso,tar}
# 	echo "************************"
# 	echo "CURRENT IMAGE [${DSTDIR}${fname}]"
# 	echo "************************"

# 	# attempt to eject disc
# 	eject_drive

# }

# _ripdiscs () {
# 	# prompt for filename, then rip to ISO
# 	echo "Add disc to DRIVE"
# 	echo "Type filename ( '.iso' will be appended) :"
# 	read -p "Filename: " resp
# 	fname="${resp}".iso
# 	tardir="${resp}"
# 	echo "Creating:[${DSTDIR}${fname}]";
# 	close_drive
# 	ripdisc
# 	doagain

# }



# doagain () {
# 	# prompt for ripping another 
# 	read -p "RIP another? : " resp
# 	echo "Typed:[${resp}]"
# 	if [ "${resp}" == "y" -o "${resp}" == "Y" ] ; then
# 		echo "ripping another"
# 		ripdiscs;
# 	elif [ "${resp}" == "a" -o "${resp}" == "A" ] ; then
# 		__abcde_discs
# 	else 
# 		echo "returning to menu"
# 		__menu
# 	fi
# 	_paused

# }


__copy_disc () {
	echo "copying data cd ${STORDIR}"
	read -p "VolumeName: " resp
	volname="${resp}"
	discdir="${volname}"
	echo "Creating:[${STORDIR}${volname}]";
	close_drive
	# create new folder and enter it
	mkdir -p ${STORDIR}${volname}
	# sudo apt install abcde flac mkcue eyed3 lame
	echo "-----------------------"
	echo "Copying entire disk to [${STORDIR}${volname}]: starting..."
	cp "${DRIVE}" "${STORDIR}${volname}"
	# abcde -d ${DRIVE} -k -L -1 -M -o flac # to rip the flac
	echo "Copying entire disk to [${STORDIR}${volname}]: Done."
	echo "-----------------------"
	echo "OUTPUT:"
	ls
	echo "-----------------------"
	_paused
}

# # abcde -o ogg,mp3 -V -L -d disc.flac # to rip ogg files from the flac.
#   # -d ${DRIVE}
#   # -k  keep WAV source
#   # -L  use local cddb repo
#   # -1  encode entire CD in a single file
#   # -c config_file.conf
#   # -M 
#   # -o  output file type
# __abcde_discs () {
# 	echo "Encoding audio cd with abcde to ${DSTDIR}"
# 	# setup vars
# 	read -p "VolumeName: " volname		# volname="${resp}"
# 	read -p "ArtistName: " artistname	# artistname="${resp}"
# 	discdir="${artistname}-${volname}"
# 	flacname="${volname}.flac"
# 	close_drive

# 	echo "Creating:[${DSTDIR}${volname}]";
# 	mkdir -p ${DSTDIR}${volname}		# create new folder
# 	cd ${DSTDIR}${volname}				# and enter it
# 	__abcde_rip							# rip disc to flac
# 	__abcde_flac_encode					# encode flac to mp3, ogg, etc
# 	# __abcde_flac_encode "${DSTDIR}${volname}/${artistname}-${volname}/${flacname}"		# encode flac to mp3, ogg, etc
# 	cd ${DSTDIR}						#return to working dir
# 	echo "Moving ${DSTDIR}${volname} TO ${STORDIR}"
# 	mv ${DSTDIR}${volname} ${STORDIR}

# 	eject_drive
# 	doagain

# }

# __abcde_rip () {
# 	# sudo apt install abcde flac mkcue eyed3 lame
# 	echo "-----------------------"
# 	echo "Ripping entire disk to 1 flac: starting..."
# 	abcde -d ${DRIVE} -k -L -1 -M -o flac # to rip the flac
# 	echo "Ripping entire disk to 1 flac: Done."
# 	echo "-----------------------"
# 	echo "OUTPUT:"
# 	ls
# 	echo "-----------------------"

# }


# __abcde_flac_encode_prep () {
# 	# setup vars
# 	read -p "VolumeName: " volname		# volname="${resp}"
# 	read -p "ArtistName: " artistname	# artistname="${resp}"
# 	discdir="${artistname}-${volname}"
# 	flacname="${volname}.flac"
	
# 	close_drive

# }

# __abcde_flac_encode () {
# 	echo "-----------------------"
# 	echo "Encoding flac to ogg,mp3: [${DSTDIR}${volname}/${discdir}/${flacname}] starting..."
# 	# echo "Encoding flac to ogg,mp3: [${DSTDIR}${volname}/${artistname}-${volname}/${flacname}] starting..."
# 	cd "${DSTDIR}${volname}/${artistname}-${volname}"
# 	abcde -o mp3 -V -L -d ${flacname} # to rip ogg files from the flac.
# 	echo "Encoding flac to ogg,mp3: [${DSTDIR}${volname}/${discdir}/${flacname}] Done."
# 	echo "-----------------------"
# 	# abcde -o ogg,mp3 -V -L -d "${flacname}.flac" # to rip ogg files from the flac.
# 	# cd "${DSTDIR}${volname}/${volname}-${volname}"
# 	# cd "${DSTDIR}${volname}/${artistname}-${volname}/${flacname}"

# }



__cdadiscs () {
  # sudo apt install vorbis-tools
  for t in /path/to/mp3/dir/album-1/track{01..18}*.wav
  do 
    oggenc "${t}" -q 6 -o "${t}.ogg"
  done

}

# ##
# ##  TARING FUNCTIONS
# ##

# tardiscs () {
# 	# prompt for filename, then rip to TAR
# 	echo "Type filename ( '.tar' will be appended) :";
# 	read -p "Filename: " resp;
# 	fname="${resp}".tar
# 	tardir="${resp}"
# 	echo "Creating:[${DSTDIR}/${fname}]";
# 	tardisc
# 	taragain

# }


# # Mount DRIVE and create TAR from contents
# #
# tardisc () {
#  _cdrom_mount ${DRIVE} ${DSTDIR}/mnt

# 	echo "Creating [${DSTDIR}/${tardir}]"
# 	mkdir ${DSTDIR}/${tardir}

# 	echo "Copying files FROM:[${DSTDIR}mnt/] :: TO:[${DSTDIR}/${tardir}]" 
# 	cp -Rv ${DSTDIR}mnt/* ${DSTDIR}/${tardir}/
# 	sudo chmod -R 777 ${DSTDIR}/${tardir}

# 	echo "sleeping 10s"
# 	sleep 10

# 	echo "Taring files to:[${DSTDIR}${tardir}.tar]"
# 	cd ${DSTDIR}${tardir}
# 	tar -cvf ${DSTDIR}/${tardir}.tar * | tee ${_LOG}
# 	chmod 777 ${DSTDIR}/${tardir}.tar  | tee ${_LOG}
# 	cd ..

# 	_unmount_disc ${DSTDIR}/mnt
			
# 	echo "Done, Listing local tars: [${DSTDIR}*.tar]..."
# 	ls -la ${DSTDIR}/*.tar
			
# 	#
# 	# MOVING TAR to remote folder
# 	#
# 	echo "Moving FROM:[${DSTDIR}*.tar] TO:[${STORDIR}]..."
# 	mv ${DSTDIR}/*.tar ${STORDIR}
# 	status=$?
# 	if [ ${status} -eq 0 ] ; then
# 		echo "Move SUCCESS"
# 	else       
# 		echo "Move ERROR: Status[${status}] ";
# 	fi

# 	echo "Done, Listing local then remote..."
# 	echo "[${DSTDIR}*.tar]"
# 	ls -la ${DSTDIR}/*.tar
			
# 	echo "[${STORDIR}/*.tar]"
# 	ls -la ${STORDIR}/*.tar

# 	eject_drive

# }

# close_drive () {
# 	echo "loading disc tray"
# 	 eject -t ${DRIVE} 
# 	echo "Press ENTER when ready"
# 	_paused
# }

# eject_drive () {
# 	#echo "Ejecting Drive after 3 seconds"
# 	sleep 10
# 	eject ${DRIVE}


# }

# taragain () {
# 	# prompt for ripping another 
# 	read -p "TAR another? : " resp
# 	echo "Typed:[${resp}]"
# 	if [ "${resp}" == "y" -o "${resp}" == "Y" ] ; then
# 		echo "tar-ing another"
# 		tardiscs;
# 	else 
# 		echo "exiting"
# 		exit 0;
# 	fi
# 	_paused;

# }

# chgRomDrive () {
# 	echo "listing DRIVEs"
# 	lsblk
# 	echo "Current DRIVE:[${DRIVE}]"
# 	read -p "Enter DRIVE #: /dev/sr" resp
# 	echo "Typed:[${resp}]"
	
# 	if [ -z ${resp} ] ; then
# 		echo "Using default DRIVE:[${DRIVE}]"
# 	else
# 		echo "Drive OLD:[${DRIVE}]"
# 		DRIVE="/dev/sr${resp}";
# 		echo "Drive NEW:[${DRIVE}]"
# 	fi

# }

# __set_stordir () {
#     echo "StorDir:[${STORDIR}]"
#     local __resp=
#     read -p "Enter remote storage dir [ex: /media/media3/cds]" __resp
#     echo "Typed: [${__resp}]"
#     echo "StorDir:[${STORDIR}]"
#     if [ -z "${__resp}" ] ; then
#       echo "no change"
#     else
#       STORDIR="${__resp}"
#     fi

# }

# __set_temp_destdir () {
#     echo "DestDir:[${DSTDIR}]"
#     local __resp=
#     read -p "Enter temp dest dir [ex: /var/tmp/rom/]" __resp
#     echo "Typed: [${__resp}]"
#     if [ -z "${__resp}" ] ; then
#       echo "no change"
#     else
#       DSTDIR="${__resp}"
#     fi

#     echo "DestDir:[${DSTDIR}]"

# }




# _paused () {
# 	read -p "Press ENTER to CONTINUE or CTRL-C to ABORT" __paused
# 	echo "Continuing...."
# }



__show_paths () {
  echo "---------------------"
  echo "DestDir :[${DSTDIR}]"
  echo "StorDir :[${STORDIR}]"
  echo "ROMDRIVE:[${DRIVE}]"
  echo "---------------------"

}

__menu () {
	echo ""
	__show_paths
	echo '
---------------------
[1] change temp dest dir
[2] change remote store dir
[3] make iso images
[4] rip audio cd
[5] copy disc to folder
--------------------- 
[x] exit
---------------------
[g] GO
---------------------
'        
	local __resp=
	read -p "Enter selection: " __resp
	echo "Typed: [${__resp}]"
	opt="${__resp}"

	case "${opt}" in
	# "1") echo "change temp dest dir"   ; __set_temp_destdir ;;
	"1") _get_user_resp "Enter temp dest dir [ex: /var/tmp/rom/]"; DSTDIR="${__DATA}";;
	# "2") echo "change remote store dir"; __set_stordir ;;
	"2") "Enter remote storage dir [ex: /media/media3/cds]"; STORDIR="${__DATA}";;
	"3") echo "copy data cd to..."       ; __copy_disc ;;

	#TESTED
	# "4") echo "rip audio cd to..."       ; _abcde_discs ;;
	"4") echo "rip audio cd to...";
		_get_user_resp "Artist name: "; local _artistname=${__DATA}
		_get_user_resp "Volume name: "; local _volname=${__DATA}
		echo "_abcde_discs ${DRIVE} ${DSTDIR} ${STORDIR} ${_artistname} ${_volname}"
		_abcde_discs ${DRIVE} ${DSTDIR} ${STORDIR} ${_artistname} ${_volname} "mp3,wav"
		#_abcde_discs ${_drive} ${_destdir} ${_stordir} ${_artistname} ${_volname}
		;;
	# "F") _abcde_flac_encode ${DSTDIR} "VOL5" "ART5-VOL5" "mp3"
	"F") cd "${DSTDIR}/VOL8"; _abcde_rename_move_flac "${DSTDIR}/VOL8" "ART8-VOL8" ;;
	
	"T") _tardisc ${DRIVE} ${DSTDIR} "${DSTDIR}/mnt" ${STORDIR} "TARNAME" ;;
	"T2") _tardiscs ${DRIVE} ${DSTDIR} "${DSTDIR}/mnt" ${STORDIR}  ;;



	"x") echo "Exiting..."             ; exit 0 ;;
	"g") echo "START!";
	 _ripdiscs ${DRIVE} ${DSTDIR} "${DSTDIR}/mnt" ${STORDIR}
	#  _ripdiscs ${_drive} ${_dstdir} ${_mountpoint} ${_stordir}
	;;
		*) ;;
	esac
	__menu

}

		# "g") echo "START!"; ripdiscs ;;



#
# MAIN BLOCK
#
echo "---------------------"
echo "DestDir:[${DSTDIR}]"
echo "StorDir:[${STORDIR}]"
echo "---------------------"

# chgRomDrive
_dd_select_dev

if [ -z "$1" ] ; then
	__menu
	#ripdiscs
elif [ "$1" == "-t" ] ; then
	echo "Using option [-t] for TARONLY"
	tardiscs
else 
	volname="${1}"
	fname="{$1}".iso
	echo "using filename: [${fname}]"
	_ripdisc
fi




# __set_srcdir () {
#     local __resp=
#     read -p "Enter source dir [ex: /var/tmp/rom/]" __resp
#     echo "Typed: [${__resp}]"
#     src="${__resp}"
# }

# __get_isoinfo () {
# }

#eject disc notes
#_paused
#echo "umount ${DRIVE}"
#umount ${DRIVE}
#_paused

## EJECT DISC CALLS
# echo "ejecting disc..."
# eject -T ${DRIVE}
# _paused
		
# echo "testing CLOSE TRAY command : [eject -t]"
# eject -t ${DRIVE} 
# _paused