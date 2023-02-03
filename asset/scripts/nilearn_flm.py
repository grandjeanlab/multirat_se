#Python Nilearn Firsl Level Model 
#Within MultiRatStim conda environment

#Imports
import pandas as pd
import numpy as np 
import nibabel as nib
import nilearn

from nilearn import plotting, image
from nilearn.glm.first_level import compute_regressor
from nilearn.glm.first_level import make_first_level_design_matrix
from nilearn.glm.first_level import FirstLevelModel
from nilearn.plotting import plot_design_matrix


#Init variables
init_folder='/home/traaffneu/margal/code/multirat_se'
analysis_folder='/project/4180000.19/multirat_stim'

#Data path
subject_path = '/project/4180000.19/multirat_stim/rabies_test/preprocess/bold_datasink/commonspace_bold/_scan_info_subject_id0200200.session1_split_name_sub-0200200_ses-1_T2w/_run_1/sub-0200200_ses-1_run-1_bold_combined.nii.gz'
template_path ='/project/4180000.19/multirat_stim/rabies_test/preprocess/unbiased_template_datasink/'
rat_subj = 200200

# ------------------------------------- Events file - data frame -------------------------------------
metadata = pd.read_csv('/project/4180000.19/multirat_stim/MultiRat_SE_metadata - multiRat_stim.tsv', sep='\t', header=0, index_col=3)
  # path might be changed 
    # sep='\t' -> because format .tsv has tab separar
    # header=0 -> because the first row contains the name of the columns
    # index_col=5 -> because the column 5 contains the ID of the rats
    
onset = np.matrix(metadata.loc[rat_subj,'func.sensory.onset']).A[0]
duration = np.matrix(metadata.loc[rat_subj,'func.sensory.duration']).A[0]
events = pd.DataFrame({'onset': onset,'duration': duration})

print(events)
print('onset: ', onset)
print('duration: ', duration)

# ------------------------------------- Design matrix -------------------------------------

#Get TR
func_img = nib.load(subject_path)
header = func_img.header
    #print(header) #print all parameters
    #print(image.load_img(subject_path).shape) #print dimensions, number of slices, number of volumes 

tr = 1.0
n_scans = 325 #nb volumes
frame_times = np.arange(n_scans) * tr  # corresponding frame times
amplitude = np.array([1, 1, 1, 1, 1, 1], dtype=object) #6 events
exp_condition = np.array((onset, duration, amplitude), dtype=object)
hrf_model = 'spm'

#Compute regressors 
signal, name = nilearn.glm.first_level.compute_regressor(exp_condition, hrf_model, frame_times)

#Compute design matrix
design_matrices = make_first_level_design_matrix(frame_times, events, drift_model='polynomial', drift_order=3, hrf_model=hrf_model)
design = make_first_level_design_matrix(
    frame_times, events, drift_model='polynomial', drift_order=3, hrf_model=hrf_model)

print(design)
plot_design_matrix(design)

#------------------------------------- Fitting a first-level model -------------------------------------

fmri_glm = FirstLevelModel()
fmri_glm = fmri_glm.fit(subject_path, design_matrices=design)

#Compute contrasts 
n_columns = design.shape[1]
contrast_val = np.hstack(([1], np.zeros(n_columns - 1)))
print('Contrasts: ', contrast_val)

summary_statistics= fmri_glm.compute_contrast(contrast_val, output_type='all')

plotting.plot_stat_map(summary_statistics['z_score'], bg_img = template_path, threshold = 1.9, title = 'My first contrast')



