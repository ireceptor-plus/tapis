#
# Mutational analysis common functions
# Part of the iReceptor+ platform
#
# Author: Scott Christley
# Copyright (C) 2021 The University of Texas Southwestern Medical Center
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
# ChangeO workflow

function print_versions() {
    echo "VERSIONS:"
    singularity exec ${singularity_image} versions report
    echo -e "\nSTART at $(date)"
}

function print_parameters() {
    echo "Input files:"
    echo "singularity_image=${singularity_image}"
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
        fileExtname="${file%.*}" # file.clone.airr.tsv -> file.clone.airr
        airrFilename="${fileExtname%.*}" # file.clone.airr -> file.clone
        baseFilename="${airrFilename%.*}" # file.clone -> file
        echo $baseFilename

        # Mutational analysis with Alakazam/Shazam
        if [[ "$mutation_tool" == "alakazam" ]] ; then
            echo "singularity exec ${singularity_image} bash create_germlines.sh ${filename} ${baseFilename}" >> joblist-germline
            germFilename="${baseFilename}.germ.airr.tsv"

            echo "singularity exec ${singularity_image} bash mutational_analysis.sh ${germFilename} ${baseFilename}" >> joblist-mutations
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
    #singularity exec ${singularity_image} python3 ./germline_report.py ${metadata_file}

    # check number of jobs to be run
    export LAUNCHER_JOB_FILE=joblist-mutations
    numJobs=$(cat $LAUNCHER_JOB_FILE | wc -l)
    export LAUNCHER_PPN=$LAUNCHER_LOW_PPN
    if [ $numJobs -lt $LAUNCHER_PPN ]; then
        export LAUNCHER_PPN=$numJobs
    fi

    # run launcher
    $LAUNCHER_DIR/paramrun
}
