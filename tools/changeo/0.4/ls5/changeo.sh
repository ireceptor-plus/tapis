#
# ChangeO wrapper script
# for Lonestar5
# 

# Configuration settings

# These get set by Agave

# input files
rearrangement_file="${rearrangement_file}"

# application parameters
define_clones=${define_clones}
define_clones_nproc="${define_clones_nproc}"
define_clones_mode="${define_clones_mode}"

# Agave info
AGAVE_JOB_ID=${AGAVE_JOB_ID}
AGAVE_JOB_NAME=${AGAVE_JOB_NAME}
AGAVE_LOG_NAME=${AGAVE_JOB_NAME}-${AGAVE_JOB_ID}

# ----------------------------------------------------------------------------
# unpack local executables
tar zxf binaries.tgz

# modules
module load python3
module load launcher/3.4

PYTHON=python3

export PATH="$PWD/bin:${PATH}"
export PYTHONPATH=$PWD/lib/python3.7/site-packages:$PYTHONPATH

# bring in common functions
source ./changeo_common.sh

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
run_changeo_workflow

# End
printf "DONE at $(date)\n\n"

# remove binaries before archiving 
rm -rf bin lib launcher

if [[ $JOB_ERROR -eq 1 ]]; then
    ${AGAVE_JOB_CALLBACK_FAILURE}
fi
