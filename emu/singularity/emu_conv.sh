#!/bin/bash -e

umask 022

#=================================
# Shell script for V4r4 Convolution Tool
# Script does all three steps of the Tool;
#    1) setup_conv.csh
#    2) conv.x
#    3) do_conv.csh
#=================================

singularity_image=SINGULARITY_IMAGE
emu_input_dir=EMU_INPUT_DIR

echo " "
echo "************************************"
echo "    EMU Convolution Tool (singularity) "
echo "************************************"

# Step 0: Check required EMU Input 
fdum=${emu_input_dir}/forcing/other/flux-forced/forcing_weekly
if [[ ! -d $fdum ]]; then 
    echo " "
    echo "ABORT: EMU Input for Convolution Tool not found;"
    echo $fdum
    echo "Run PUBLICDIR/emu_input_setup.sh"
    echo "to download forcing needed for the Convolution Tool." 
    exit 1
fi

# Step 1: Tool Setup & Specification 
echo " "
echo "**** Step 1 & 2: Setup & Specification"
echo ""

echo "Specify directory name of Adjoint Tool output or its equivalent "
echo "where the adjoint gradients to use in the convolution are. " 
echo "Files must have the same name and format as those of the "
echo "Adjoint Tool, in a directory named 'output' with its parent"
echo "directory having prefix 'emu_adj'; "
echo "  e.g., emu_adj_SOMETHING/output "
echo " " 
echo "Enter directory name with the adjoint gradients ... ?" 
read f_adxx

f_adxx=$(realpath "${f_adxx}")

echo " " 
echo "     Running conv.x"

/bin/rm -f my_commands.sh
echo '#!/bin/bash -e' > my_commands.sh && chmod +x my_commands.sh
echo 'cd /inside_out'               >> my_commands.sh
echo 'ln -sf ${emu_dir}/emu/exe/conv.x . ' >> my_commands.sh
echo "./conv.x ${emu_input_dir} ${f_adxx} /inside_alt "  >> my_commands.sh

singularity exec --bind ${emu_input_dir}:/emu_input_dir:ro --bind ${PWD}:/inside_out \
     --bind ${f_adxx}:/inside_alt:ro ${singularity_image} /inside_out/my_commands.sh

if [ -f "conv.dir_out" ] && [ -f "pbs_conv.sh" ]; then
    read dummy < "conv.dir_out"
    subdir=${dummy}/temp
    sed -i -e "s|SUBDIR|${subdir}|g" pbs_conv.sh
    rundir=${PWD}/${subdir}
    sed -i -e "s|YOURDIR|${rundir}|g" pbs_conv.sh
    cp -p pbs_conv.sh ${rundir}
else
    echo "File conv.dir_out and/or pbs_conv.sh do(es) not exist ... "
    exit 1
fi
# Step 3: Calculation 

echo " "                       
echo "**** Step 3: Calculation"
echo "     Running do_conv.x"
echo " "

#BATCH_COMMAND pbs_conv.sh

echo "... Running batch job pbs_conv.sh "
echo "    to compute the convolution." 

echo " "
echo "    Estimated wallclock time:"
sed -n '3p' pbs_conv.sh

echo " " 
dum=`sed -n '3p' conv.dir_out`
echo '********************************************'
echo "    Results will be in " ${dum}
echo '********************************************'
echo " "

BATCH_COMMAND pbs_conv.sh


