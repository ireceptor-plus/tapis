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
# unpack local executables
#tar zxf binaries.tgz

# modules
module load python3
module load launcher/3.4
module load tacc-singularity

PYTHON=python3

export PATH="$PWD/bin:${PATH}"
export PYTHONPATH=$PWD/lib/python3.7/site-packages:$PYTHONPATH

# bring in common functions
source ./olga_common.sh

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
run_toy_workflow

# End
printf "DONE at $(date)\n\n"

# remove binaries before archiving 
rm -rf bin lib

if [[ $JOB_ERROR -eq 1 ]]; then
    ${AGAVE_JOB_CALLBACK_FAILURE}
fi
