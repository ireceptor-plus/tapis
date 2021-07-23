#
# Tapis app template script for Stampede2
# Part of the iReceptor+ platform
#
# Author: Scott Christley
# Copyright (C) 2021 The University of Texas Southwestern Medical Center
# Date: July 22, 2021
#

# Configuration settings

# These get set by Tapis

# input files
singularity_image="${singularity_image}"
rearrangement_file="${rearrangement_file}"

# Application parameters
sample_name="${sample_name}"

# Agave info
AGAVE_JOB_ID=${AGAVE_JOB_ID}
AGAVE_JOB_NAME=${AGAVE_JOB_NAME}
AGAVE_LOG_NAME=${AGAVE_JOB_NAME}-${AGAVE_JOB_ID}
AGAVE_JOB_PROCESSORS_PER_NODE=${AGAVE_JOB_PROCESSORS_PER_NODE}
AGAVE_JOB_MEMORY_PER_NODE=${AGAVE_JOB_MEMORY_PER_NODE}

echo "Tapis Info"
echo "AGAVE_JOB_PROCESSORS_PER_NODE=${AGAVE_JOB_PROCESSORS_PER_NODE}"
echo ""

# ----------------------------------------------------------------------------
# modules
module load python3
module load launcher/3.4
module load tacc-singularity

PYTHON=python3

export PATH="$PWD/bin:${PATH}"
export PYTHONPATH=$PWD/lib/python3.7/site-packages:$PYTHONPATH

# bring in VDJBase workflow functions
source ./vdjbase_common.sh

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

# Run the workflow
print_parameters
print_versions
run_workflow

# End
printf "DONE at $(date)\n\n"
