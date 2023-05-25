#!/bin/bash

# When missing dummy scan
# Select the timeseries without the frists containing drop of signal

module load afni
root_dir='/project/4180000.19/multirat_stim/test_3dresample'

input_dir=$root_dir'/input/'
output_dir=$root_dir'/output/'

cd $root_dir

for file in "$input_dir"/*; do

    filename=$(basename "$file")                                         # extracts the filename from the full path
    new_filename=$(echo "$filename" | sed 's/bold\.nii\.gz$//')          # remove the "bold.nii.gz"
    output_name="${new_filename}minus5sec_bold.nii.gz"                   # append "minus5sec_bold.nii.gz" to the new filename. Need to keep end as "bold.nii.gz" to input to rabies
    output_path="$output_dir/$output_name"

    command="3dresample -input $file'[5..$]' -prefix $output_path"       # resampling, select all timeseries after the 5 firsts
    eval "$command"
done