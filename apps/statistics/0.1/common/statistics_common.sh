#
# Statistics common functions
#
# This script relies upon global variables
# source statistics_common.sh
#
# VDJServer Analysis Portal
# VDJServer Tapis applications
# https://vdjserver.org
#
# Part of the iReceptor+ platform
#
# Copyright (C) 2021 The University of Texas Southwestern Medical Center
# Author: Scott Christley
# Date: Aug 17, 2020
# 

# the app
export APP_NAME=statistics

# bring in common functions
source ./common_functions.sh

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
    singularity exec ${singularity_image} versions report
    singularity exec ${repcalc_image} repcalc --version
    echo -e "\nSTART at $(date)"
}

function print_parameters() {
    echo "Input files:"
    echo "singularity_image=${singularity_image}"
    echo "repcalc_image=${repcalc_image}"
    echo "metadata_file=${metadata_file}"
    echo "rearrangement_file=${rearrangement_file}"
    echo ""
    echo "Application parameters:"
    echo "gene_usage_flag=${gene_usage_flag}"
    echo "aa_properties_flag=${aa_properties_flag}"
    echo "aa_properties_trim=${aa_properties_trim}"
    echo "junction_length_flag=${junction_length_flag}"
}

function run_statistics_workflow() {
    initProvenance

    # expand rearrangement file if its compressed
    expandfile $rearrangement_file
    noArchive $file

    # Assuming airr.tsv extension
    fileBasename="${file%.*}" # file.airr.tsv -> file.airr
    fileBasename="${fileBasename%.*}" # file.airr -> file

    # extract the productive rearrangements
    parseName="${fileBasename}.airr_parse-select.tsv"
    filteredFile="${fileBasename}.productive.airr.tsv"
    singularity exec ${singularity_image} ParseDb.py select -d ${file} -f productive -u T
    mv $parseName $filteredFile

    # Rearrangement counts
    singularity exec ${singularity_image} python3 count_statistics.py $file

    # Gene Usage
    if [[ $gene_usage_flag -eq 1 ]]; then
        singularity exec -B $PWD:/data ${singularity_image} /data/gene_usage.R -d $file
    fi

    # Amino Acid properties
    if [[ $aa_properties_flag -eq 1 ]]; then
        # run it
        singularity exec -B $PWD:/data ${singularity_image} /data/aa_properties.R -d $file
    fi

    # Junction length distribution
    if [[ $junction_length_flag -eq 1 ]]; then
        # generate config
        $PYTHON repcalc_create_config.py --init junction_length_template.json ${metadata_file} --rearrangementFile $file junction_length_config.json
        # run it
        singularity exec ${repcalc_image} repcalc junction_length_config.json
    fi

    # Diversity curve
    #if [[ $gene_usage_flag -eq 1 ]]; then
        singularity exec -B $PWD:/data ${singularity_image} /data/diversity_curve.R -d $filteredFile
    #fi
}
