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
    echo "germline_db=${germline_db}"
    echo "metadata_file=${metadata_file}"
    echo "airr_tsv_file=${airr_tsv_file}"
    echo ""
    echo "Application parameters:"
    echo "repertoire_id=${repertoire_id}"
    echo "file_type=${file_type}"
}

function run_statistics_workflow() {
    initProvenance

    # do not archive the input
    noArchive ${airr_tsv_file}
    noArchive ${singularity_image}
    noArchive ${repcalc_image}
    noArchive ${germline_db}

    # expand rearrangement file if its compressed
    expandfile $airr_tsv_file
    noArchive $file

    # Assuming airr.tsv extension
    fileBasename="${file%.*}" # file.airr.tsv -> file.airr
    fileBasename="${fileBasename%.*}" # file.airr -> file

    # Rearrangement counts
    if [[ "$file_type" == "rearrangement" ]] ; then
        singularity exec -e ${singularity_image} python3 count_statistics.py $file
    fi

    # Clonal abundance
    if [[ "$file_type" == "clone" ]] ; then
        singularity exec -e -B $PWD:/data ${singularity_image} /data/clonal_abundance.R -d $file -o $fileBasename
    fi

    # Gene Usage
    if [[ "$file_type" == "clone" ]] ; then
        singularity exec -e -B $PWD:/data ${singularity_image} /data/gene_usage.R -d $file -o $fileBasename
    fi
    if [[ "$file_type" == "rearrangement" ]] ; then
        $PYTHON repcalc_create_config.py --init gene_usage_template.json ${metadata_file} --rearrangementFile $file --repertoireID ${repertoire_id} --germline ${germline_db} gene_usage_config.json
        singularity exec -e ${repcalc_image} repcalc gene_usage_config.json

        # extract the productive rearrangements
        #parseName="${fileBasename}.airr_parse-select.tsv"
        #filteredFile="${fileBasename}.productive.airr.tsv"
        #noArchive $filteredFile
        #singularity exec -e ${singularity_image} ParseDb.py select -d ${file} -f productive -u T t TRUE True true 1
        #mv $parseName $filteredFile

        #singularity exec -e -B $PWD:/data ${singularity_image} /data/gene_usage.R -d $file -o $fileBasename
        #singularity exec -e -B $PWD:/data ${singularity_image} /data/gene_usage.R -d $filteredFile -o ${fileBasename}.productive
    fi

    # Amino Acid properties
    #singularity exec -e -B $PWD:/data ${singularity_image} /data/aa_properties.R -d $file

    # Junction length distribution
    $PYTHON repcalc_create_config.py --init junction_length_template.json ${metadata_file} --rearrangementFile $file --repertoireID ${repertoire_id} junction_length_config.json
    singularity exec -e ${repcalc_image} repcalc junction_length_config.json

    # Diversity curve
    if [[ "$file_type" == "clone" ]] ; then
        singularity exec -e -B $PWD:/data ${singularity_image} /data/diversity_curve.R -d $file -o $fileBasename
    fi
    
    # final report
    $PYTHON rearrangement_report.py ${repertoire_id} null null $file
}
