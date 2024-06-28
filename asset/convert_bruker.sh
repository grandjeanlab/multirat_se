#!/bin/bash

#conda create -n bruker2nifti python=3.7

#pip install git+https://github.com/BrkRaw/brkraw.git
#add to .bashrc --> PATH=$PATH:/groupshare/traaffneu/preclinimg/software/Bru2

#qsub -l 'procs=1,mem=24gb,walltime=12:00:00' -I 
#cd /home/traaffneu/margal/code/multirat_se/asset
# ./convert_bruker.sh


# ---- Init varaibles ----
module load afni
root_dir='/project/4180000.19/multirat_stim/scratch/to_convert/test_marie'

cd $root_dir/raw_ciobanu/visstimforJo/rat12/                       #directory of data to be converted into bids format

output_dir=$root_dir'/export'                  #create the variable output_dir to be put in folder export  
mkdir -p $output_dir 

dataset_name='Ciobanu'                           #name dataset received 

ds_type=02 
ds_id=016                                      #because already 12 datasets aquired (see, /project/4180000.19/multirat_stim/bids/)
id=7  

# --- Convert to BIDS ---- 

# ls . | while read line                    #line is a variable, while read all folders (=line) 
# do                                        #start loop 
# cd $root_dir/raw_champalimaud/ExtraISIs/NSH-08914/$line              #go to directory of each line/folder

sub=$ds_type$ds_id'0'$id                  #define subject ID

ses='1'                                   #define session ID

output_sub_dir=$output_dir'/sub-'$sub'/ses-'$ses                                          #define directory for the outputs with subject and session ID
mkdir -p $output_sub_dir'/anat'                                                           #withing the directory output, create 2 directories: anat et func
mkdir -p $output_sub_dir'/func'

anat_name='sub-'$sub'_ses-'$ses'_T2w.nii.gz'                                               #define 2 variables to name file later, based on subject and session ID
func_name='sub-'$sub'_ses-'$ses'_run-1_bold.nii.gz'

#anat
Bru2 -z -a -o tmp '4/pdata/1/'                                                             #convert create tmp folder into anat/acqp directory -> convert
3dresample -inset sub-0202000_ses-1_T2w.nii -prefix /project/4180000.19/multirat_stim/scratch/to_convert/test_marie/converted/export_champalimaud/sub-0202000/ses-1/anat/test_sub-0202000_ses-1_T2w.nii -orient LPI
                                            


Bru2 -z -a -o tmp '4/pdata/1/'                                                             #convert create tmp folder into anat/acqp directory -> convert
3dresample -inset tmp.nii.gz -prefix  $output_sub_dir'/anat/'$anat_name -orient LPI         #change scan orientation, save into output directory 
#3dTcat -prefix $output_sub_dir'/anat/sub-'$sub'_ses-'$ses'_T2w_3D.nii.gz' $output_sub_dir'/anat/'$anat_name'[0]' 
rm tmp.nii.gz

# #func
# func_name='sub-020160'$id'_ses-1_run-1_bold.nii.gz'
# Bru2 -z -a -o tmp '14/pdata/1/'                                                                 #convert data in folder 6 into BIDS format
# 3dresample -inset tmp.nii.gz -prefix  $output_sub_dir'/func/'$func_name -orient LPI        #Change scan orientation, save into output directory 
# rm tmp.nii.gz

# func_name='sub-020170'$id'_ses-1_run-1_bold.nii.gz'
# Bru2 -z -a -o tmp '92/pdata/1/'                                                                 #convert data in folder 6 into BIDS format
# 3dresample -inset tmp.nii.gz -prefix  $output_sub_dir'/func/'$func_name -orient LPI        #Change scan orientation, save into output directory 
# rm tmp.nii.gz


# ---- 
# # anat   
#cp $root_dir'/raw_sumiyoshi/data/'$line'/anat/'$line'_anat.nii' $output_sub_dir'/anat/'tmp_$anat_name         # copy the anat file into the output directory and rename it accordingly
#fslorient fslswapdim $nifti_file -x y z $output_sub_dir'/anat/'tmp_$anat_name                                 # flip signal on the x axis,  Right -
# fslreorient2std $output_sub_dir'/anat/'tmp_$anat_name  $output_sub_dir'/anat/'$anat_name 
# rm $output_sub_dir'/anat/'tmp_$anat_name

# # func
# cp $root_dir'/raw_sumiyoshi/data/'$line'/func/'$line'_func.nii' $output_sub_dir'/func/'tmp_$func_name         # copy the anat file into the output directory and rename it accordingly
# fslorient -setsform 1 0 0 0 0 0 1 0 0 1 0 0 0 0 0 1  $output_sub_dir'/func/'tmp_$func_name                    # correct the labelled of the orientation, in this case to get posterior to anterior and superior to inferior
# fslorient -setqform 1 0 0 0 0 0 1 0 0 1 0 0 0 0 0 1 $output_sub_dir'/func/'tmp_$func_name                     # correct the labelled of the orientation, in this case to get posterior to anterior and superior to inferior
# fslreorient2std $output_sub_dir'/func/'tmp_$func_name  $output_sub_dir'/func/'$func_name                      #Change scan orientation to match stadard one
# rm $output_sub_dir'/func/'tmp_$func_name



id=$((id + 1))                  #id number increases by 1

cd ..                           #go to previous directory
done                            #end of the loop
cd ../export                    
tree                            #display organisation of data


