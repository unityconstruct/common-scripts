#!/bin/bash
#-----------------------------------------------------------------------
# PROMTING FUNCS
#-----------------------------------------------------------------------

## prompt for data with passed message & loop until confirmed or skipped
 # Depency : [__DATA] global variable
 # 1. prompt message
 # 2. read DATA from STDIN
 # 3. display DATA
 # 4. prompt for confirmation with ok/skip
 #   4.1 ok = KEEP DATA and exit
 #   4.2 skip = DROP DATA and exit
 #   4.3 otherwise, LOOP
 #
 __DATA=       # initialize Global Var to hold response
_get_user_resp() {
	local msg="${1}"									# set message
	__DATA=														# clear RETURN VAR
	if [ -z "${msg}" ] ; then 				# if msg is empty, bail
		return 1
	fi

	# prompt for data, loop until ok or exit
	__confirm=												# clear confirm var
	until [ "$__confirm" = "ok" -o "$__confirm" = "exit" ] ;
	do
		__resp=													# clear response var
		echo "GETDATA: [${msg}]"									# prompt message
		read __resp											# get response
		echo "entered: [${__resp}]"			# show response
		echo "-------------------------------------------------"
		__confirm=											# clear confirm var
		echo "type [ok] to continue ( or 'skip' not change value )"		# confirm entry ok
		read __confirm
		echo "${__confirm}"
		if [ "$__confirm" == "ok" ]; then     # keep DATA and exit
			__DATA="${__resp}"
		elif [ "$__confirm" == "skip" ]; then # DROP DATA and exit
			echo "SKIPPING, NO CHANGE APPLIED"
		  return 0
		elif [ "$__confirm" == "exit" ]; then # EXIT APP
			echo "exiting..." 
			exit 1
		fi                                    # else LOOP
	done

	echo "RETURN DATA: [${__DATA}]"         # return DATA
}

## Pause Function
 #
_paused () {
	read -p "Press ENTER to CONTINUE or CTRL-C to ABORT" __ignored
	echo "Continuing...."
}	
