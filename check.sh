#!/bin/bash

## Usage
##
## Define and pull a Docker image
# export IMAGE="rhub/ubuntu-release"
# export IMAGE="eddelbuettel/r2u:22.04"
# docker pull $IMAGE
##
## Clean up artifact folder
# rm -rf _tmp
# mkdir _tmp
##
## Run the check.sh script
# docker run -it --rm --platform linux/amd64 -v $PWD:/home/root/phacking -w /home/root $IMAGE /bin/bash phacking/check.sh
##
## Now check files in the _tmp folder

PKG=phacking
TMP=$PKG/_tmp
FILE=$TMP/$PKG-check-logs.log
echo $(date) - Script started > $FILE

echo $(date) - Installing package dependencies >> $FILE
R -q -e "remotes::install_deps('$PKG', upgrade='never', dependencies=TRUE)"

echo $(date) - Building package >> $FILE
R CMD build $PKG

echo $(date) - Running checks >> $FILE
# R_CHECK_DONTTEST_EXAMPLES=false R CMD check --no-manual --no-tests $PKG_*.tar.gz
R_CHECK_DONTTEST_EXAMPLES=false R CMD check --no-manual --as-cran $PKG_*.tar.gz

echo $(date) - Moving artifacts >> $FILE
cp $PKG_*.tar.gz $TMP
cp -r $PKG.Rcheck $TMP
echo $(date) - Done >> $FILE
