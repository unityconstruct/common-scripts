#!/bin/bash
#-----------------------------------------------------------------------
# LIST FUNCS
#-----------------------------------------------------------------------
# notes ----------------------------------------------------------------
#	ls -d */ | sed -e 's-/$--' >> "${__filename}" # samplefolders.txt
#-----------------------------------------------------------------------

## List a Path's files & save to text file
 #  do not include '.'
 # $1=path
 # $2=output list filename
 # $3=filename extension to filter on
 # 
 # 1. cd to path
 # 2. ls *.ext
 # 3. cat list
 # 4. nano list
 #
create_file_list_by_ext () {
	local __path="${1}"
	local __filename="${2}"
  local __file_ext="${3}"
	getTimestamp
	cd "${__path}"
	echo '#
#---------------------------------------------------------------------
#----- '${TIMESTAMP}' ----------------------' > "${__filename}"
 cd "${__path}"
 ls *.${__file_ext} >> "${__filename}"
 echo '#
#----- '${TIMESTAMP}' ----------------------
#---------------------------------------------------------------------' >> "${__filename}"
 cat "${__filename}"
 nano "${__filename}"
}
