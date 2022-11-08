#!/bin/bash
#-----------------------------------------------------------------------
# LIST FUNCS
#-----------------------------------------------------------------------
# notes ----------------------------------------------------------------
#	ls -d */ | sed -e 's-/$--' >> "${__filename}" # samplefolders.txt
#-----------------------------------------------------------------------


## test func to echo passed param
 #
echopath() {
  local _path="${1}"
  echo "${_path}"
}

## 
 #
list_files() {
  for f in $( find "." -name '*.*'   ); do echo $f; done;
}



## List a Path's DIRECTORIES & save to text file
 #
_create_folder_list () {
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
_create_file_list_by_ext () {
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
