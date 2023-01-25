#Python Nilearn Firsl Level Model 

"conda activate MultiRatStim" #Activates only if I run it directly from the terminal but not from runing the script (can't find why)
import pandas as pd
import numpy as np 
import nibabel as nib
import nilearn

from nilearn import plotting, image
from nilearn.glm.first_level import compute_regressor
from nilearn.glm.first_level import make_first_level_design_matrix
from nilearn.glm.first_level import FirstLevelModel

#Init variables
init_folder='/home/traaffneu/margal/code/multirat_se'
analysis_folder='/project/4180000.19/multirat_stim'

#Data path
subject_path = '/project/4180000.19/multirat_stim/rabies_test/preprocess/bold_datasink/commonspace_bold/_scan_info_subject_id0200200.session1_split_name_sub-0200200_ses-1_T2w/_run_1/sub-0200200_ses-1_run-1_bold_combined.nii.gz'
template_path ='/project/4180000.19/multirat_stim/rabies_test/preprocess/unbiased_template_datasink/'
rat_subj = 200200

# ------------------------------------- Events file - data frame -------------------------------------

metadata = pd.read_csv('/home/traaffneu/margal/Downloads/MultiRat_SE_metadata - multiRat_stim.tsv', sep='\t', header=0, index_col=3)
    # path might be changed 
    # sep='\t' -> because format .tsv has tab separar
    # header=0 -> because the first row contains the name of the columns
    # index_col=5 -> because the column 5 contains the ID of the rats
    #print(metadata.columns)

events = pd.DataFrame()
events = metadata.loc[:,['func.sensory.onset','func.sensory.duration']] #events for all animals
events = events.loc[rat_subj, :] #events for one animal

onset = events[['func.sensory.onset']] #define onset values
duration = events[['func.sensory.duration']] #define duration values

events['onset'] = list(map(float, onset.split(','))) #try to turn the objects into floats, UNSUCCESFULLY rrrrrr
events['duration'] = list(map(float, duration.split(',')))

print(onset)
print(duration)


# # -- Convert events of the rat to NumPy arrays --    
# onset = events[['func.sensory.onset']].to_numpy() 
# duration = events[['func.sensory.duration']].to_numpy() 

# print("Onset values", onset)
# print("Duration values", duration)

# # # ------------------------------------- Define parameters for design matrix -------------------------------------

# #Get TR
# func_img = nib.load(subject_path)
# header = func_img.header
#     #print(header) #print all parameters
#     #print(image.load_img(subject_path).shape) #print dimensions, number of slices, number of volumes 

# tr = 1.0
# n_scans = 325 #nb volumes
# frame_times = np.arange(n_scans) * tr  # corresponding frame times
# amplitude = np.array([1, 1, 1, 1, 1, 1], dtype=float) #6 events
# exp_condition = np.array((onset, duration, amplitude), dtype=float)
# hrf_model = 'spm'

# #Compute regressors 
# signal, name = nilearn.glm.first_level.compute_regressor(exp_condition, hrf_model, frame_times)





