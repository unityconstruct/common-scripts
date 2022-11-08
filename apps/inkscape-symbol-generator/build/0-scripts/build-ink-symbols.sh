#!/bin/bash
#
## ---------------------------------------------------------------
## STEPS
## ---------------------------------------------------------------
##    * nodejs & npm must be previously installed
##    * install guld with: [npm install gulp]
##    * build svgs
##    * push to [ build/imgsrc ]
##    * run svgo to clean svh
##    * gulp --iconset <nameofyoursymbols> --dest <nameofyoursymbols>
##    * aggregate svg file will be created with all svgs: svg-sprite.svg
##    * copy all the <symbols> elements from the generated file INTO the template.svg
##    * add creator info
##    * Add in your ```<svg>``` tag: ```style="fill:black;stroke:none"```
##    * push SVG compsite file to a dedicate folder
##    * move to inkscape symbols folder
## ~/.config/inkscape/symbo

# _copyimg() {
#   # cp -r imgsrc/*.svg imgbld/

# }

# _cleanimg(){
# }

# _gulpimgs() {

# }

# _copytemplate(){

# }

# _pull_npm_gulp() {

# }
#  _pull_npm_gulp
#  _cleanimg 
#  _gulpimgs
#  _copytemplate
  # cd /mnt/data/git/inkscape-uc-symbols/

_run(){


  # npm install gulp
  cd /mnt/data/git/inkscape-open-symbols/  
  svgo --folder  1-imgsrc --output 2-imgclean
  gulp --iconset 2-imgclean --dest .
  

  cp /mnt/data/git/inkscape-uc-symbols/build/res/template.svg /mnt/data/git/inkscape-uc-symbols/build/3-imgbld/template.svg

/mnt/data/git/inkscape-open-symbols/


  # cd /mnt/data/git/inkscape-open-symbols
  # svgo --folder /mnt/data/git/inkscape-uc-symbols/build/1-imgsrc --output /mnt/data/git/inkscape-uc-symbols/build/2-imgclean
  # gulp --iconset /mnt/data/git/inkscape-uc-symbols/build/2-imgclean --dest /mnt/data/git/inkscape-uc-symbols/build/3-imgbld
  # cp /mnt/data/git/inkscape-uc-symbols/build/res/template.svg /mnt/data/git/inkscape-uc-symbols/build/3-imgbld/template.svg


#   # svgo --folder 1-imgsrc --output 2-imgcleals
n
#   gulp --iconset 2-imgclean --dest 3-imgbld
#   gulp --iconset 2-imgclean --dest 3-imgbld
#  cp res/template.svg 3-imgbld/

}

_run



