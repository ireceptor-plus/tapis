#
# Assign clones common functions
#
# This script relies upon global variables
# source clones_common.sh
#
# VDJServer Analysis Portal
# VDJServer Tapis applications
# https://vdjserver.org
#
# Part of the iReceptor+ platform
#
# Copyright (C) 2021 The University of Texas Southwestern Medical Center
# Author: Scott Christley
# Date: Feb 19, 2020
# 

# required global variables:
# PYTHON
# AGAVE_JOB_ID
# and...
# The agave app input and parameters

# the app
export APP_NAME=assign-clones

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
    echo "clone_tool=${clone_tool}"
}

function run_assign_clones() {
    initProvenance

    # launcher job file
    if [ -f joblist ]; then
        echo "Warning: removing file 'joblist'.  That filename is reserved." 1>&2
        rm joblist
        touch joblist
    fi
    noArchive "joblist"

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
        filename="${file##*/}" # foo/bar/file.airr.tsv -> file.airr.tsv
        fileBasename="${file%%.*}" # file.airr.tsv -> file
        noArchive $fileOutname

        # Assign Clones
        if [[ "$clone_tool" == "changeo" ]] ; then
            #echo "export bash changeo_clones.sh ${filename}" >> joblist
            echo "singularity exec ${singularity_image} bash changeo_clones.sh ${file} ${fileBasename}" >> joblist
        fi

        count=$(( $count + 1 ))
    done

    # check number of jobs to be run
    numJobs=$(cat joblist | wc -l)
    export LAUNCHER_PPN=$LAUNCHER_LOW_PPN
    if [ $numJobs -lt $LAUNCHER_PPN ]; then
        export LAUNCHER_PPN=$numJobs
    fi

    # run launcher
    $LAUNCHER_DIR/paramrun
}
