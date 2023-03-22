#!/bin/bash

# ----------------- Run script -----------------
# qsub -l 'procs=1,mem=32gb,walltime=48:00:00' -I
# cd /home/traaffneu/margal/code/multirat_se/script/
# ./RABIES_preprocess.sh 0200100 2
#   when typing command to run script, give inputs:
#       1. subject number of the rat e.g. 0200100
#       2. TR e.g. 2
    
#Load module for singularity
module load singularity
module load ANTs
module unload ANTs
module unload freesurfer
module unload fsl 

cd /project/4180000.19/multirat_stim/rabies/

#Provide path to templates and masks. 
template=/template/SIGMA_Rat_Anatomical_Imaging/SIGMA_Rat_Anatomical_InVivo_Template/SIGMA_InVivo_Brain_Template.nii
mask=/template/SIGMA_Rat_Anatomical_Imaging/SIGMA_Rat_Anatomical_InVivo_Template/SIGMA_InVivo_Brain_Mask.nii
wm=/template/SIGMA_Rat_Anatomical_Imaging/SIGMA_Rat_Anatomical_InVivo_Template/SIGMA_InVivo_WM_bin.nii.gz
csf=/template/SIGMA_Rat_Anatomical_Imaging/SIGMA_Rat_Anatomical_InVivo_Template/SIGMA_InVivo_CSF_bin.nii.gz 
atlas=/template/SIGMA_Rat_Brain_Atlases/SIGMA_Anatomical_Atlas/SIGMA_Anatomical_Brain_Atlas_rs.nii
roi=/groupshare/traaffneu/preclinimg/template/roi/

#Define input/output folders for subject sub-0101000 ses-1
subj_number=$1
TR=$2 
orig_folder=/project/4180000.19/multirat_stim/rabies/bids/sub-${subj_number}/ses-1
template_folder=/groupshare/traaffneu/preclinimg/templates/SIGMA_Wistar_Rat_Brain_TemplatesAndAtlases_Version1.1
bids_folder=/project/4180000.19/multirat_stim/rabies/bids/sub-${subj_number}_ses-1
preprocess_folder=/project/4180000.19/multirat_stim/rabies/preprocess/sub-${subj_number}_ses-1

#Clean and make directories
rm -rf $bids_folder
rm -rf $preprocess_folder
mkdir -p $bids_folder/sub-${subj_number}
mkdir -p $preprocess_folder

#copy orginal scans (from bids) into individualized subj directories 
cp -r /project/4180000.19/multirat_stim/bids/sub-${subj_number} $bids_folder

# the RABIES call with optional arguments
singularity run -B ${template_folder}:/template -B ${bids_folder}:/rabies_in:ro -B ${preprocess_folder}:/rabies_out /opt/rabies/0.4.7/rabies-0.4.7.simg -p MultiProc preprocess /rabies_in /rabies_out  \
--TR ${TR} \
--anat_template ${template} \
--brain_mask ${mask} \
--WM_mask ${wm} \
--CSF_mask ${csf} \
--vascular_mask ${csf} \
--labels ${atlas} \
# --anat_robust_inho_cor='apply'='true','masking'='true','brain_extraction'='true','template_registration'='SyN' \
# --bold_robust_inho_cor='apply'='true','masking'='true','brain_extraction'='true','template_registration'='SyN' \
# --commonspace_reg='masking'='false','brain_extraction'='true','template_registration'='SyN','fast_commonspace'='true' \
# --commonspace_resampling 0.3x0.3x0.3 \
# --anat_autobox \
# --bold_autobox \

#--anat_inho_cor='method'='N4_reg','otsu_thresh'='2','multiotsu'='false' \
#--bold_inho_cor='method'='N4_reg','otsu_thresh'='2','multiotsu'='false' \
