#
# Tapis app template script for Stampede2
# Part of the iReceptor+ platform
#
# Author: Scott Christley
# Copyright (C) 2021 The University of Texas Southwestern Medical Center
# Date: Jun 22, 2021
#

# Configuration settings

# These get set by Tapis

# input files
singularity_image="${singularity_image}"
repcalc_image="${repcalc_image}"
germline_db="${germline_db}"
metadata_file="${metadata_file}"
airr_tsv_file="${airr_tsv_file}"

# application parameters
repertoire_id=${repertoire_id}
file_type=${file_type}

# Agave info
AGAVE_JOB_ID=${AGAVE_JOB_ID}
AGAVE_JOB_NAME=${AGAVE_JOB_NAME}
AGAVE_LOG_NAME=${AGAVE_JOB_NAME}-${AGAVE_JOB_ID}

# ----------------------------------------------------------------------------
# unpack local executables
#tar zxf binaries.tgz

#chmod +x gene_usage.R
#chmod +x aa_properties.R
chmod +x clonal_abundance.R
chmod +x diversity_curve.R

# modules
module load python3/3.7.0
module load launcher/3.4
module load tacc-singularity

PYTHON=python3

export PATH="$PWD/bin:${PATH}"
export PYTHONPATH=$PWD/lib/python3.7/site-packages:$PYTHONPATH

# bring in common functions
source ./statistics_common.sh

# ----------------------------------------------------------------------------
# Launcher to use multicores on node
export LAUNCHER_WORKDIR=$PWD
export LAUNCHER_LOW_PPN=1
export LAUNCHER_MID_PPN=8
export LAUNCHER_MAX_PPN=25
export LAUNCHER_PPN=1
export LAUNCHER_JOB_FILE=joblist
export LAUNCHER_SCHED=interleaved

# Start
printf "START at $(date)\n\n"

# If you want to tell Tapis that the job failed
export JOB_ERROR=0

print_parameters
print_versions
run_statistics_workflow

# End
printf "DONE at $(date)\n\n"

# remove binaries before archiving 
rm -rf bin lib

if [[ $JOB_ERROR -eq 1 ]]; then
    ${AGAVE_JOB_CALLBACK_FAILURE}
fi
