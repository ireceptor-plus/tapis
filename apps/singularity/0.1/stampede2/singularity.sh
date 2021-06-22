#
# wrapper script
# for Stampede2
# 
# Author: Scott Christley
# Copyright (C) 2021 The University of Texas Southwestern Medical Center
# Date: Jun 15, 2021

# Configuration settings

# These get set by Tapis

# input files

# application parameters
docker_image="${docker_image}"
singularity_image="${singularity_image}"

# Agave info
AGAVE_JOB_ID=${AGAVE_JOB_ID}
AGAVE_JOB_NAME=${AGAVE_JOB_NAME}
AGAVE_LOG_NAME=${AGAVE_JOB_NAME}-${AGAVE_JOB_ID}

# ----------------------------------------------------------------------------
# modules
module load tacc-singularity

# bring in common functions
source ./singularity_common.sh

# Start
printf "START at $(date)\n\n"

# If you want to tell Tapis that the job failed
export JOB_ERROR=0

print_parameters
print_versions
run_workflow

# End
printf "DONE at $(date)\n\n"

# remove binaries before archiving 
rm -rf bin lib

if [[ $JOB_ERROR -eq 1 ]]; then
    ${AGAVE_JOB_CALLBACK_FAILURE}
fi
