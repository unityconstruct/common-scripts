#!/bin/bash
FRAMEWORKPATH="$(dirname "$0")/.."
source ${FRAMEWORKPATH}/funcs/collector_remote.sh
echo "[main][framworkpath:${FRAMEWORKPATH}][Testing Timestamp:$(getTimestamp)]"

# Vars
DSTDIR=/tmp/rom
STORDIR=/media/media1/iso
FNAME=disc.iso
tardir=disc
DRIVE=/dev/sr0
blocksize=2048



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
	"3") echo "copy data cd to..."       ; 
	_copy_disc ${DRIVE} ${DSTDIR} "${DSTDIR}/mnt" ${STORDIR} 
	;;
	
	# ${_drive} ${_dstdir} ${_mountpoint} ${_stordir} ${_volname}

	# "3") echo "copy data cd to..."       ; __copy_disc ;;

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
_dd_cdrom_select_dev

if [ -z "$1" ] ; then
	__menu
	#ripdiscs
elif [ "$1" == "-t" ] ; then
	echo "Using option [-t] for TARONLY"
	tardiscs
else 
	volname="${1}"
	FNAME="{$1}".iso
	echo "using filename: [${FNAME}]"
	_ripdisc
fi

