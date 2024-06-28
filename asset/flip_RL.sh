#!/bin/bash

# cd /home/traaffneu/margal/code/multirat_se/asset
# ./flip_RL.sh


# Flip the scans in the x-axis 
#cd /project/4180000.19/multirat_stim/scratch/rabies_test/flip/
cd /project/4180000.19/multirat_stim/scratch/flip/

nifti_file="sub-0201003_ses-1_run-1_bold_combined.nii.gz"

fslhd $nifti_file

fslswapdim $nifti_file -x y z flipped/flipped_$nifti_file

fslhd $nifti_file
