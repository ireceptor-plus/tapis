#
# Tapis app template script
# Part of the iReceptor+ platform
#
# Author: Scott Christley
# Copyright (C) 2021 The University of Texas Southwestern Medical Center
# Date: Jun 4, 2021
#

# Configuration settings

# These get set by Tapis/Agave

# input files
singularity_image="${singularity_image}"
repcalc_image="${repcalc_image}"
metadata_file="${metadata_file}"
rearrangement_file="${rearrangement_file}"

# application parameters
mutation_tool=${mutation_tool}

# Agave info
AGAVE_JOB_ID=${AGAVE_JOB_ID}
AGAVE_JOB_NAME=${AGAVE_JOB_NAME}
AGAVE_LOG_NAME=${AGAVE_JOB_NAME}-${AGAVE_JOB_ID}

# ----------------------------------------------------------------------------
# unpack local executables
#tar zxf binaries.tgz

# modules
module load python3
module load launcher/3.10
module load tacc-singularity

PYTHON=python3
export VDJ_DB=${WORK}'/../common/igblast-db/db.2019.01.23/germline/human/ReferenceDirectorySet/IG_VDJ.fna'

#export PATH="$PWD/bin:${PATH}"
#export PYTHONPATH=$PWD/lib/python3.7/site-packages:$PYTHONPATH

# bring in common functions
source ./mutations_common.sh

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

export JOB_ERROR=0

print_parameters
print_versions
run_mutational_analysis

# End
printf "DONE at $(date)\n\n"

# remove binaries before archiving 
#rm -rf bin lib launcher

if [[ $JOB_ERROR -eq 1 ]]; then
    ${AGAVE_JOB_CALLBACK_FAILURE}
fi
