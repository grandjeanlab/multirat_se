#conda create -n bruker python=3.7
#pip install git+https://github.com/brkraw/bruker 
#???? conda install -c hcc afni ???
#add to .bashrc --> PATH=$PATH:/groupshare/traaffneu/preclinimg/software/Bru2

# cd /home/traaffneu/margal/code/multirat_se/scripts/
# ./convert_bruker.sh


# ---- Init varaibles ----
module load afni
root_dir='/project/4180000.19/multirat_stim/to_convert/test_marie'

cd $root_dir/raw_hess/whisker_stim/data           #directory of data to be converted into bids format

output_dir=$root_dir'/export'                  #create the variable output_dir to be put in folder export  
mkdir -p $output_dir 

dataset_name='Hess02'                           #name dataset received 

ds_type=02 
ds_id=015                                       #because already 12 datasets aquired (see, /project/4180000.19/multirat_stim/bids/)
id=0    

# --- Convert to BIDS ---- 

ls . | while read line                    #line is a variable, while read all folders (=line) 
do                                        #start loop 
cd $root_dir/raw_hess/whisker_stim/data/$line         #go to directory of each line/folder

sub=$ds_type$ds_id'0'$id                  #define subject ID

ses='1'                                   #define session ID


output_sub_dir=$output_dir'/sub-'$sub'/ses-'$ses                                          #define directory for the outputs with subject and session ID
mkdir -p $output_sub_dir'/anat'                                                           #withing the directory output, create 2 directories: anat et func
mkdir -p $output_sub_dir'/func'

anat_name='sub-'$sub'_ses-'$ses'_T2w.nii.gz'                                               #define 2 variables to name file later, based on subject and session ID
func_name='sub-'$sub'_ses-'$ses'_run-1_bold.nii.gz'


Bru2 -a -z -o tmp anat/pdata/1                                                              #convert create tmp folder into anat/acqp directory -> convert
3dresample -inset tmp.nii.gz -prefix  $output_sub_dir'/anat/'$anat_name -orient LPI         #Change scan orientation, save into output directory 
rm tmp.nii.gz

Bru2 -z -a -o tmp func/pdata/1                                                           #convert data in folder 6 into BIDS format
3dresample -inset tmp.nii.gz -prefix  $output_sub_dir'/func/'$func_name -orient LPI        #Change scan orientation, save into output directory 
rm tmp.nii.gz                                                 

id=$((id + 1))                  #id number increases by 1

cd ..                           #go to previous directory
done                            #end of the loop
cd ../export                    
tree                            #display organisation of data
