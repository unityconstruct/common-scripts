#!/bin/bash


#-----------------------------------------------------------------------
# ARRAY FUNCS
#-----------------------------------------------------------------------

## dump NAMED ARRAY to console
 # 
_dump_props() {
	local -n __props=$1
  for j in ${!__props[*]} ; do
      echo "values: [${j}] = [${__props[$j]}]"
  done
}
