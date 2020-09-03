#
# Toy common functions
#
# This script relies upon global variables
# source toy_common.sh
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
# Toy workflow

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
    echo "single_flag=${single_flag}"
    echo "optional_number=${optional_number}"
    echo "optional_enum=${optional_enum}"
}

function run_toy_workflow() {
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
        filename="${file##*/}"
        fileBasename="${file%.*}" # file.airr.tsv -> file.airr
        fileOutname=${fileBasename}.clones.tsv
        noArchive $fileOutname

        #ARGS="--format airr --act set --model ham --sym min --norm len --dist 0.165"
        #if [ -n "$define_clones_mode" ]; then
        #    ARGS="$ARGS --mode $define_clones_mode"
        #fi
        #if [ -n "$define_clones_nproc" ]; then
        #    ARGS="$ARGS --nproc $define_clones_nproc"
        #fi

        # Define Clones
        #if [[ $define_clones -eq 1 ]]; then
        #    echo "DefineClones.py -d ${filename} -o ${fileOutname} $ARGS" >> joblist
        #fi

        count=$(( $count + 1 ))
    done

    # check number of jobs to be run
    numJobs=$(cat joblist | wc -l)
    export LAUNCHER_PPN=$LAUNCHER_LOW_PPN
    if [ $numJobs -lt $LAUNCHER_PPN ]; then
        export LAUNCHER_PPN=$numJobs
    fi

    # run launcher
    #$LAUNCHER_DIR/paramrun

    ls -l
    
}
