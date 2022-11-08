#!/bin/bash
## main application template for implementing the common-scripts framework
##  1. FRAMEWORKPATH: 
##    $(dirname "$0"): this command will return the path WHERE THIS FILE IS AT
##  2. source "${FRAMEWORKPATH}"/funcs/collector_remote.sh
##    this statement handles all the complexity with working with the framework
##    The collector_remote.sh script does all the 'source imports' 
##      and exposes everything via this one call
##    This main_* script MIGHT be portable and if relocated
##     tweaking FRAMEWORKPATH and the [source * collector_remote.sh] statement might resolve
##  3. collect_remote.sh can be copied and updated to handle specific needs or
##       to handle other file configurations where the caller is not in the expected location.
##  4. _LOG: this reference is used for with the [_log] method
##       which send the text to both STDOUT and the specified logfile.
##     It usage is not required and this API is merely a convience tool
##  OTHER:
##    /funcs: this holds the library of loosely-bound reusable components that should accept arguments
##     rather than implemnting GLOBAL vars so reuse is encouraged.
##     - where hardcoded values are desired, they should be in made in the main_* scripts,
##      and these should call into the funcs lib with required arguments
##
###############################################################
#-----------------------------------------------------------------------
# TEMPLATE CODE HERE
#-----------------------------------------------------------------------
FRAMEWORKPATH="$(dirname "$0")/.."
source "${FRAMEWORKPATH}"/funcs/collector_remote.sh
echo "[main][framworkpath:${FRAMEWORKPATH}][Testing Timestamp:$(getTimestamp)]"
_LOG="$FRAMEWORKPATH/log/test.log"
_log "verifying log location:"
ls -la ${_LOG}
_log ----------------------------------

#-----------------------------------------------------------------------
# YOUR CODE HERE
#-----------------------------------------------------------------------
