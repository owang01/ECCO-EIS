#!/bin/bash

#=================================
# Shell script for setting up V4r4 Adjoint Tool
#=================================

echo " "
echo "... Setting up ECCO V4r4 Adjoint Tool ..."
echo "    See PUBLICDIR/README_adj "
echo " "

# Set directory names for the tool. 

setup=SETUPDIR
echo $setup > tool_setup_dir

# Set up objective function specifying program (adj.x)
/bin/cp -fp ${setup}/emu/adj.x .

# Set up data namelist file to be used by MITgcm (data, data.ecco).
# The namelist files will be modified by adj.x
/bin/cp -fp ${setup}/emu/data_emu .
/bin/cp -fp ${setup}/emu/data.ecco_adj .

## 
#echo " "
#echo '********************************************'
#echo '    Run adj.x to specify computation.'
#echo '********************************************'
#echo " "

