#!/bin/bash
    
#qsub -l 'procs=1,mem=24gb,walltime=12:00:00' -I 

#cd /home/traaffneu/margal/code/multirat_se/asset/
# ./fslorient.sh

base_dir='/project/4180000.19/multirat_stim/scratch/to_convert/test_marie/converted/export_sumiyoshi/fslorient/'

# Loop through subdirectories
for sub_dir in "$base_dir"sub-*/ses-*/func/; do
    cd "$sub_dir" || exit

    # Get the T2w file in the current subdirectory
    for t2w_file in *nii.gz; do 
        if [ -f "$t2w_file" ]; then
            output_dir="$sub_dir"
            mkdir -p "$output_dir"

            echo "Processing: $sub_dir$t2w_file"

            # Copy the T2w file into the output directory and rename it accordingly
            cp "$sub_dir$t2w_file" "$output_dir/tmp1_$t2w_file"                                 
            rm "$sub_dir$t2w_file"

            # Apply orientation correction
            #fslorient -deleteorient imagename "$output_dir/tmp1_$t2w_file"   
            fslorient -setqformcode 1 "$output_dir/tmp1_$t2w_file"                              # Reset the qform code  
            fslorient -setsform -1 0 0 0 0 0 1 0 0 1 0 0 0 0 0 1 "$output_dir/tmp1_$t2w_file"   # Correct the labelled of the orientation (Q form)
            fslorient -setqform -1 0 0 0 0 0 1 0 0 1 0 0 0 0 0 1 "$output_dir/tmp1_$t2w_file"
            fslreorient2std "$output_dir/tmp1_$t2w_file" "$output_dir/$t2w_file"
            #fslswapdim "$output_dir/tpm2_$t2w_file" -x y z "$output_dir/$t2w_file"        

            
            # Optionally remove temporary files if needed
            rm "$output_dir/tmp1_$t2w_file"
            #rm "$output_dir/tmp2_$t2w_file"
                
        echo "Done!"
        else
            echo "No T2w file found in: $sub_dir"
        fi
    done
done