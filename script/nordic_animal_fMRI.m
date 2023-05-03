input_dir = './func_img';
output_dir = './NORDIC_output';
files = dir(fullfile(input_dir, '*.nii.gz'));
ARG.kernel_size_gfactor=[10 1 10];
ARG.kernel_size_PCA=[5, 5, 5];
ARG.magnitude_only=1;
ARG.use_magn_for_gfactor=1;
ARG.gfactor_patch_overlap=2;

% Adds the path to be able to call NIFTI_NORDIC in the parent Dir
addpath("NORDIC_Raw/")

for i = 1:length(files)
    fn_magn_in = fullfile(input_dir, files(i).name);
    % Removing the extension as it will be added again in the NIFTI_NORDIC Script
    [~, baseFileNameNoGz, ~] = fileparts(files(i).name);        % Removes the GZ extension
    [~, baseFileNameNoExt, ~] = fileparts(baseFileNameNoGz);    % Removes the NII extension
    fn_out = fullfile(output_dir, baseFileNameNoExt);
    try
        NIFTI_NORDIC(fn_magn_in, "", fn_out, ARG);
    catch exception
        disp(getReport(exception))
        disp([fn_magn_in " : " size(niftiread(fn_magn_in))]);
    end
end

clear ARG fn_magn_in fn_out i files folder ans f
