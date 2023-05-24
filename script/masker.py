from nilearn.input_data import NiftiLabelsMasker

atlas='/project/4180000.19/SIGMA_Anatomical_Brain_Atlas_rs.nii'
mask='/project/4180000.19/SIGMA_InVivo_Brain_Mask.nii'

zstat='/project/4180000.19/multirat_stim/rabies_test/first_level_analysis/z_score/z_score_sub-0200601_ses-1.nii.gz'

residual='/project/4180000.19/multirat_stim/rabies_test/first_level_analysis/residuals/residuals_sub-0200601_ses-1.nii.gz'

masker = NiftiLabelsMasker(labels_img=atlas, mask_img=mask, standardize=True)
masker.fit_transform(zstat)

