#Matlab for NORDIC denoising
#qsub -l 'procs=1,mem=24gb,walltime=48:00:00' -I

#conda activate MultiRatStim
#cd /home/traaffneu/margal/code/multirat_se/script/
# ./nordic_matlab.sh

module load matlab
matlab                                                                         #starts the MATLAB 

addpath('/groupshare/traaffneu/preclinimg/software/NORDIC_Raw');               #adds a directory called NORDIC_Raw to the MATLAB path

root_dir='/project/4180000.19/multirat_stim/nordic_test';                      #directory that contains the MRI scans to be preprocessed
anat_list=splitlines(ls(fullfile(root_dir,'/bids/*/*/anat/*.nii.gz')));        #lists all of the NIfTI files in /anat/ of each subdirectory /*/*/ within the BIDS directory. Splits the output of ls into a cell array of strings
anat_list(end)=[];                                                             #removes the last element
func_list=splitlines(ls(fullfile(root_dir,'/bids/*/*/func/*.nii.gz')));
func_list(end)=[];  

# %set kernal size, default [14 14 1]
# ARG.kernel_size_gfactor=[8 8 1];
# ARG.magnitude_only=1;
# Et ARG quand t’appelles la fonctione Nordic

for i = 1:length(anat_list)
[fpath, bpath] = fileparts(anat_list{i});                      #split the path of the current element in anat_list into: path (fpath), filename (bpath)
newfpath = strrep(fpath,'bids','bids_nordic');                 #replaces 'bids' in fpath with 'bids_nordic' and save it as newfpath
mkdir(newfpath);                                               #creates newfpath directory
copyfile(anat_list{i}, fullfile(newfpath,bpath))               #copies the current element in anat_list to the new directory specified in newfpath, keep the original filename used in bpath
end

for i = 1:length(func_list) 
[fpath, bpath] = fileparts(func_list{i});
newfpath = strrep(fpath,'bids','bids_nordic');
newffile = strrep(bpath,'nii.gz','nii');
mkdir(newfpath);
NIFTI_NORDIC(func_list{i},func_list{i}, 'tmp');                #convert the current functional file to Nordic format, saved as a temporary file "tmp.nii"
movefile('tmp.nii',fullfile(newfpath,newffile))                #moves the current file to the new directory 
end