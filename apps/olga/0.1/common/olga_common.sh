#
# Olga common functions
#
# This script relies upon global variables
# source olga_common.sh
#
# Author: Gema Rojas
# Date: Sept 4, 2020
# 

# required global variables:
# PYTHON
# AGAVE_JOB_ID
# and...
# The agave app input and parameters

# the app
export APP_NAME=olga

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
# Olga workflow

function print_versions() {
    echo "VERSIONS:"
    #echo "  $(DefineClones.py --version 2>&1)"
    #singularity exec ${singularity_image}
    echo -e "\nSTART at $(date)"
}

function print_parameters() {
    echo "Input files:"
    echo "singularity_image=${singularity_image}"
    echo "cdr3_file=${cdr3_file}"
    echo ""
    echo "Application parameters:"
    echo "single_flag=${single_flag}"
    echo "model=${model}"
}

function run_olga_workflow() {
    initProvenance

    #Run compute_pgen on the CDR3 sequences file provided
    singularity exec ${singulariry_image} /usr/local/bin/olga-compute_pgen --${model} -i ${cdr3_file} -o output.tsv
    
    #List output
    ls -l    
}
