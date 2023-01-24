#!/bin/tcsh

#=================================
# Shell script for conducting convolution in V4r4 Convolution Tool
#=================================

qsub pbs_conv.csh

echo " "
echo "... Batch job pbs_conv.csh has been submitted "
echo "    to compute adjoint gradient convolution with control."

echo " "
echo "    Estimated wallclock time:"
sed -n '3p' pbs_conv.csh
/bin/rm -f pbs_conv.csh

echo " " 
set dum = `tail -n 1 conv.dir_out`
echo '********************************************'
echo "    Results will be in" $dum
echo '********************************************'
echo " "

exit
