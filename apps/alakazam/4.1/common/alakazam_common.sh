#
# Alakazam common functions
#
# This script relies upon global variables
# source alakazam_common.sh
#
# Author: Scott Christley
# Date: Aug 17, 2020
# 

# required global variables:
# PYTHON
# AGAVE_JOB_ID
# and...
# The agave app input and parameters

# the app
export APP_NAME=alakazam

# ----------------------------------------------------------------------------
function expandfile () {
    fileBasename="${1%.*}" # file.txt.gz -> file.txt
    fileExtension="${1##*.}" # file.txt.gz -> gz

    if [ ! -f $1 ]; then
        echo "Could not find input file $1" 1>&2
        exit 1
    fi

    if [ "$fileExtension" == "gz" ]; then
        gunzip $1
        export file=$fileBasename
        # don't archive the intermediate file
    elif [ "$fileExtension" == "bz2" ]; then
        bunzip2 $1
        export file=$fileBasename
    elif [ "$fileExtension" == "zip" ]; then
        unzip -o $1
        export file=$fileBasename
    else
        export file=$1
    fi
}

# prevent Agave from archiving the file
function noArchive() {
    echo $1 >> .agave.archive
}

# ----------------------------------------------------------------------------
# Analysis provenance
function initProvenance() {
    # nothing yet
    echo "initProvenance"
}

# ----------------------------------------------------------------------------
# Workflow

function print_versions() {
    echo "VERSIONS:"
    #echo "  $(DefineClones.py --version 2>&1)"
    singularity exec ${singularity_image} versions report
    echo -e "\nSTART at $(date)"
}

function print_parameters() {
    echo "Input files:"
    echo "singularity_image=${singularity_image}"
    echo "rearrangement_file=${rearrangement_file}"
    echo ""
    echo "Application parameters:"
    echo "gene_usage_flag=${gene_usage_flag}"
    echo "aa_properties_flag=${aa_properties_flag}"
    echo "aa_properties_trim=${aa_properties_trim}"
}

function run_alakazam_workflow() {
    initProvenance

    # expand rearrangement file if its compressed
    expandfile $rearrangement_file
    noArchive $file

    # Gene Usage
    if [[ $gene_usage_flag -eq 1 ]]; then
        singularity exec -B $PWD:/data ${singularity_image} /data/gene_usage.R -d $file
    fi

    # Amino Acid properties
    if [[ $aa_properties_flag -eq 1 ]]; then
        # run it
        singularity exec -B $PWD:/data ${singularity_image} /data/aa_properties.R -d $file
    fi

}
