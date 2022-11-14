#!/bin/tcsh

#=================================
# Shell script for setting up V4r4 Sampling Tool
#=================================

echo " "
echo "... Setting up ECCO V4r4 Sampling Tool ..."
echo "    See PUBLICDIR/README_samp "
echo " "

# Set directory names for the tool. 
set tooldir = SETUPDIR

# Set up sampling program (samp.x)
/bin/cp -fp ${tooldir}/emu/samp.x .
echo ${tooldir} > tool_setup_dir

# Set up data.ecco namelist file 
# The namelist file will be modified by samp.x
/bin/cp -fp ${tooldir}/emu/data.ecco_adj .

exit
