# common-scripts

# layout

layout is organized with the following folders:

* apps
  * utilities that have more than one file
* funcs
  * categorized granular functions that mimick static classes/methods
  * these are desined to be standalone, accepting arguments for any values it needs
  * this allows them to be used by any implementing script
  * `collector*.sh` scripts are the only scripts that DIRECTLY source the `*_funcs.sh` scripts and allow for customization of both what is sourced and how 
* logs
  * _LOG is one of the few GLOBAL VARS and it should always point here.
  * actual filename for the log is irrelevnt
  * _log() function echos text sent to it & then pipes to `tee -a ${_LOG}`
  * _log() usage is compeletely optional & implemented for convenience
* main
  * contains the 'application' scripts that serve a purpose and `source` the various funcs
  * main_*.sh scripts that need to access the `*_funcs.sh` scripts should use an existing `collector*.sh` script, or implent a new one
  * the main scripts should not normally source the `funcs` scripts directly and should instead source from a SINGLE `collector` script, than in turn manages all the source requirements.
* props
  * configuration and job properties, VARS, and GLOBALS should be managed in the props folder
  * named arrays allow many values to be passed around with a single identifer, simplifying calling those funcs that take many arguments.
  * another top-level folder is planned to act as the 'middle-man' API from `named arrays` to the multiple-parameter funcs
* test
  * using this folder for porting existing script into this framework
    * copy script in
    * commit to save it for reference
    * copy chunks of functionality to a `*_funcs.sh` script
    * comment(not remove) the code func in the old scripts so it is effectively gone, but allows for reference while integrating
    * transform ported code to proper design pattern/schema
    * parameterize any global vars
    * use the old script as the MAIN and run from it at each waypoint to debug and ensure the script is always working
    * once ALL the code is commented it can then be pushed to the untracked `done` folder
  * STAGE and COMMIT OFTEN so if something gets irrevocably destroyed, it can be reverted with relative ease
* more to come....
  * the main purpose of this repo is to
    * reduce massive redundancy from hundreds of scripts that were created off-the-cuff for some immediate one-off purpose
    * sterilize personal info from these scripts
    * consolidate tricks and complex routines so they may be reused
    * act as a living library of design patterns, API calls, and `ways of doing things` that I always have to relearn when something sits unused for 3 years and I need it again for a slightly different purpose.
    * organize scripts into
      * examples
      * reuzable function components
      * utilities with a actual purpose
    * archive `all things bash`
    * make it publicly availble to help others


# main_*.sh template

```bash
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

```


