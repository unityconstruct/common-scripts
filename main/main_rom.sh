#!/bin/bash
FRAMEWORKPATH="$(dirname "$0")/.."
source "${FRAMEWORKPATH}"/funcs/collector_remote.sh
echo "[main][framworkpath:${FRAMEWORKPATH}][Testing Timestamp:$(getTimestamp)]"
_LOG="$FRAMEWORKPATH/log/test.log"
_log "verifying log location:"
ls -la ${_LOG}
_log ----------------------------------


# Vars
DSTDIR=/tmp/rom
STORDIR=/media/media1/iso
DRIVE=/dev/sr0
blocksize=2048
# FNAME=disc.iso


_show_paths () {
  echo "---------------------"
  echo "DSTDIR :[${DSTDIR}]"
  echo "STORDIR :[${STORDIR}]"
  echo "DRIVE:[${DRIVE}]"
  echo "---------------------"
}

_menu_romcopy () {
	echo ""
	_show_paths
	echo '---------------------
 [1] change temp dest dir
 [2] change remote store dir
 [3] COPY: copy-many
 [4] abcde rip (audio/cda media)
 [r] ISO: rip-many
 [t] TAR: rip-single
 [s] TAR: rip-many
 --------------------- 
 [x] exit
 ---------------------
 [g] GO
 ---------------------'        
	local __resp=
	read -p "Enter selection: " __resp
	echo "Typed: [${__resp}]"
	opt="${__resp}"

	case "${opt}" in
	"1") _get_user_resp "Enter temp dest dir [ex: /var/tmp/rom/]"          ; DSTDIR="${__DATA}";;
	"2") _get_user_resp "Enter remote storage dir [ex: /media/media3/cds]" ; STORDIR="${__DATA}";;
	"3") echo "copy data cd to..."; _copy_disc ${DRIVE} ${DSTDIR} "${DSTDIR}/mnt" ${STORDIR} ;;
	"4") echo "rip audio cd to...";
		_get_user_resp "Artist name: "; local _artistname=${__DATA}
		_get_user_resp "Volume name: "; local _volname=${__DATA}
		echo "_abcde_discs ${DRIVE} ${DSTDIR} ${STORDIR} ${_artistname} ${_volname}"
		_abcde_discs ${DRIVE} ${DSTDIR} ${STORDIR} ${_artistname} ${_volname} "mp3,wav" ;;
	"r") _ripdiscs ${DRIVE} ${DSTDIR} "${DSTDIR}/mnt" ${STORDIR} ;;
	"t") _tardisc ${DRIVE} ${DSTDIR} "${DSTDIR}/mnt" ${STORDIR} "TARNAME" ;;
	"s") _tardiscs ${DRIVE} ${DSTDIR} "${DSTDIR}/mnt" ${STORDIR}  ;;
	"x") echo "Exiting..."; exit 0 ;;
		*) ;;
	esac
	_menu_romcopy
}

## main block ----------------------------------------------------
echo "---------------------"
echo "PARAMS : [$@]"
echo "DSTDIR :[${DSTDIR}]"
echo "STORDIR:[${STORDIR}]"
echo "DRIVE  :[$DRIVE]"
echo "---------------------"
_dd_cdrom_select_dev

# option usages --------------------------------------------------
if [ -z "$1" ] ; then                   # go to menu by default
	_menu_romcopy
elif [ "$1" == "-t" ] ; then            # TAR: rip-many-cli
	echo "Using option [-t] for TARONLY"
	_tardiscs #${DRIVE} ${DSTDIR} "${DSTDIR}/mnt" ${STORDIR}  ;;
else                                    # TAR: rip-single-clie
  volname="${1}";  echo "ripdisc: [${DSTDIR}/mnt/${volname}]"
	_ripdisc ${DRIVE} ${DSTDIR} "${DSTDIR}/mnt" ${STORDIR} ${volname} ;
fi
