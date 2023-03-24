# qsub -l 'procs=1,mem=32gb,walltime=48:00:00' -I
# cd /home/traaffneu/margal/code/multirat_se/script/
# python run_RABIES.py

import os
import pandas as pd
import numpy as np
import subprocess
from subprocess import call


# ---Init Variables ---

init_folder='/home/traaffneu/margal/code/multirat_se/script/'                                   # location of the codes
metadata_path='/home/traaffneu/margal/code/multirat_se/script/table/metadata_rabies.tsv'        # meta-data table

df = pd.read_csv(metadata_path, sep='\t')             # load the table
df = df.loc[(df['exclude'] != 'yes')]


#--- Function to submit job to HPC --- 

def queue_process(cmd):
    p1 = subprocess.Popen(["echo", f"${{PWD}}/{cmd}"], stdout=subprocess.PIPE)
    subprocess.call(["qsub", "-N", 's001', "-l", 'nodes=1:ppn=1,mem=128mb,walltime=00:10:00'], stdin=p1.stdout)        #subprocess.call(["./RABIES_preprocess.sh", subj_num, TR, correction_arg], shell=False) #run RABIES_preprocess, giving additional inputs: correction_args, specified in metadat_rabies, submit job to qsub


# --- Preprocess all datasets with RABIES --- 

for index in range(0, len(df)):

    rabies_preprocess = df.iloc[index]['rabies_prepro'] 
    subj_num=str(df.iloc[index]['rat.sub'])[:-2]                       #remove the 2 last characters ( if need zero at the begenning .zfill(9) )
    TR=str(df.iloc[index]['func.TR'])
    correction_arg = str(df.iloc[index]['rabies_cor'])
    
    print("rabies preprocess:", rabies_preprocess)
    print("subj_num:", subj_num)
    print("TR:", TR)
    
    if rabies_preprocess == '2' :
        queue_process(f'RABIES_preprocess.sh {subj_num} {TR} {correction_arg}')
        print("Corrected RABIES preprocess.")
        
    elif rabies_preprocess == '0' :
        subprocess.call(["./RABIES_preprocess.sh", subj_num, TR], shell=False)  #run RABIES_preprocess, giving inputs: subj_num, TR 
        print("Standard RABIES_preprocess. No correction needed.")
            
    else :                                                                  # if rabies_preprocess == 1 :
        print("Data have already been preprocessed. Go to next dataset")   
        continue                                                            # go to next iteration



# --- RABIES arguments for corrections ---
# rabies_anat_inho_args = "--anat_inho_cor=method=N4_reg,otsu_thresh=2,multiotsu=false --bold_inho_cor=method=N4_reg,otsu_thresh=2,multiotsu=false"
# rabies_autobox_args = "--anat_autobox --bold_autobox"
# rabies_commonspace_args = "--commonspace_reg=masking=false,brain_extraction=true,template_registration=SyN,fast_commonspace=true --commonspace_resampling 0.3x0.3x0.3"
