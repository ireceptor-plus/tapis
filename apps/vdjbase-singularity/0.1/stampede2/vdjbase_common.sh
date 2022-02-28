#
# VDJBase common functions
#
# This script relies upon global variables
# source vdjbase_common.sh
#
# required agave app input and parameters.

# the app
export APP_NAME=vdjbase-singularity

# bring in common functions
source ./common_functions.sh

# ----------------------------------------------------------------------------
# Analysis provenance
function initProvenance() {
    # nothing yet
    echo "initProvenance"
}

# ----------------------------------------------------------------------------
# Workflow functions

function print_versions() {
    echo "VERSIONS:"
    #singularity exec -e ${singularity_image} vdjbase-pipeline -v
    echo ""
}

function print_parameters() {
    echo "Input files:"
    echo "singularity_image=${singularity_image}"
    echo "rearrangement_file=${rearrangement_file}"
    echo ""
    echo "Application parameters:"
    echo "sample_name=${sample_name}"
}

function run_workflow() {
    # Do some provenance - mostly a placeholder for now.
    initProvenance
    echo "Run Workflow"

    # expand rearrangement file if its compressed
    expandfile $rearrangement_file
    noArchive $file

    # Run VDJBase pipeline on rearrangement file provided.
    singularity exec -e -B ${PWD}:/data ${singularity_image} vdjbase-pipeline -f /data/${file} -s ${sample_name} -t ${AGAVE_JOB_PROCESSORS_PER_NODE} -o /data

    echo "Done Workflow"
}
