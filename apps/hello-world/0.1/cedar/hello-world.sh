#
# wrapper script
# for cedar.computecanada.ca
# 

# Configuration settings

# These get set by Tapis

# input files
# NONE

# application parameters
# NONE

# Agave info
AGAVE_JOB_ID=${AGAVE_JOB_ID}
AGAVE_JOB_NAME=${AGAVE_JOB_NAME}
AGAVE_LOG_NAME=${AGAVE_JOB_NAME}-${AGAVE_JOB_ID}

# Start
printf "START at $(date)\n\n"

# If you want to tell Tapis that the job failed
export JOB_ERROR=0

# Say Hello
echo "Hello World from Tapis"

echo "Sleeping for a couple of minutes so you can see me in the queue..."
sleep 120

# End
printf "DONE at $(date)\n\n"

if [[ $JOB_ERROR -eq 1 ]]; then
    ${AGAVE_JOB_CALLBACK_FAILURE}
fi
