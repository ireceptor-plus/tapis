#
# wrapper script
# for Lonestar5
# 

# Configuration settings

# These get set by Tapis

# input files
singularity_image="${singularity_image}"
rearrangement_file="${rearrangement_file}"

# application parameters
single_flag=${single_flag}
optional_number="${optional_number}"
optional_enum="${optional_enum}"

# Agave info
AGAVE_JOB_ID=${AGAVE_JOB_ID}
AGAVE_JOB_NAME=${AGAVE_JOB_NAME}
AGAVE_LOG_NAME=${AGAVE_JOB_NAME}-${AGAVE_JOB_ID}

# ----------------------------------------------------------------------------
# modules
module load python3
module load tacc-singularity

# bring in common functions
source ./changeo_common.sh

# Start
printf "START at $(date)\n\n"

# If you want to tell Tapis that the job failed
export JOB_ERROR=0

# Run the workflow (from changeo-common.sh)
print_parameters
print_versions
run_workflow

# End
printf "DONE at $(date)\n\n"

# Handle AGAVE errors
if [[ $JOB_ERROR -eq 1 ]]; then
    ${AGAVE_JOB_CALLBACK_FAILURE}
fi
