#
# Mutational analysis common functions
# Part of the iReceptor+ platform
#
# Author: Scott Christley
# Copyright (C) 2021-2022 The University of Texas Southwestern Medical Center
# Date: Jun 4, 2021
#
# This script relies upon global variables
# source mutations_common.sh
#

# required global variables:
# PYTHON
# AGAVE_JOB_ID
# and...
# The agave app input and parameters

# the app
export APP_NAME=mutations

# bring in common functions
source ./common_functions.sh

# ----------------------------------------------------------------------------
# Analysis provenance
function initProvenance() {
    # nothing yet
    echo "initProvenance"
}

# ----------------------------------------------------------------------------
# ChangeO workflow

function print_versions() {
    echo "VERSIONS:"
    singularity exec -e ${singularity_image} versions report
    singularity exec -e ${repcalc_image} repcalc --version
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
    echo "mutation_tool=${mutation_tool}"
}

function run_mutational_analysis() {
    initProvenance

    # launcher job files
    if [ -f joblist-germline ]; then
        echo "Warning: removing file 'joblist-germline'.  That filename is reserved." 1>&2
        rm joblist-germline
        touch joblist-germline
    fi
    noArchive "joblist-germline"

    if [ -f joblist-mutations ]; then
        echo "Warning: removing file 'joblist-mutations'.  That filename is reserved." 1>&2
        rm joblist-mutations
        touch joblist-mutations
    fi
    noArchive "joblist-mutations"

    if [ -f joblist-repcalc ]; then
        echo "Warning: removing file 'joblist-repcalc'.  That filename is reserved." 1>&2
        rm joblist-repcalc
        touch joblist-repcalc
    fi
    noArchive "joblist-repcalc"

    # for each file
    # decompress if necessary
    # generate commands to run
    fileList=($rearrangement_file)
    count=0
    while [ "x${fileList[count]}" != "x" ]
    do
        file=${fileList[count]}
        noArchive $file
        expandfile $file
        filename="${file##*/}"
        fileExtname="${file%.*}" # file.gene.clone.airr.tsv -> file.gene.clone.airr
        airrFilename="${fileExtname%.*}" # file.gene.clone.airr -> file.gene.clone
        baseFilename="${airrFilename%.*}" # file.gene.clone -> file.gene
        echo $baseFilename

        repertoire_id="${baseFilename%.*}" # strip the allele/gene
        echo $repertoire_id
        if [ "x${repertoire_id}" == "x" ]; then
            echo "Cannot determine repertoire_id for $file"
            export JOB_ERROR=1
            return 1
        fi

        # Mutational analysis with Alakazam/Shazam
        if [[ "$mutation_tool" == "alakazam" ]] ; then
            echo "singularity exec -e ${singularity_image} bash create_germlines.sh ${filename} ${airrFilename} ${VDJ_DB}" >> joblist-germline
            germFilename="${airrFilename}.germ.airr.tsv"

            echo "singularity exec -e ${singularity_image} Rscript mutational_analysis.R -d ${germFilename} -o ${baseFilename}" >> joblist-mutations
            echo "singularity exec -e ${repcalc_image} bash mutational_analysis.sh ${metadata_file} ${repertoire_id} ${baseFilename}" >> joblist-repcalc
        fi

        count=$(( $count + 1 ))
    done

    # check number of jobs to be run
    export LAUNCHER_JOB_FILE=joblist-germline
    numJobs=$(cat $LAUNCHER_JOB_FILE | wc -l)
    export LAUNCHER_PPN=$LAUNCHER_LOW_PPN
    if [ $numJobs -lt $LAUNCHER_PPN ]; then
        export LAUNCHER_PPN=$numJobs
    fi

    # run launcher
    $LAUNCHER_DIR/paramrun

    # generate germline report
    singularity exec -e ${singularity_image} python3 ./germline_report.py ${metadata_file}

    # check number of jobs to be run
    export LAUNCHER_JOB_FILE=joblist-mutations
    numJobs=$(cat $LAUNCHER_JOB_FILE | wc -l)
    export LAUNCHER_PPN=$LAUNCHER_LOW_PPN
    if [ $numJobs -lt $LAUNCHER_PPN ]; then
        export LAUNCHER_PPN=$numJobs
    fi

    # run launcher
    $LAUNCHER_DIR/paramrun

    # check number of jobs to be run
    export LAUNCHER_JOB_FILE=joblist-repcalc
    numJobs=$(cat $LAUNCHER_JOB_FILE | wc -l)
    export LAUNCHER_PPN=$LAUNCHER_LOW_PPN
    if [ $numJobs -lt $LAUNCHER_PPN ]; then
        export LAUNCHER_PPN=$numJobs
    fi

    # run launcher
    $LAUNCHER_DIR/paramrun
}
