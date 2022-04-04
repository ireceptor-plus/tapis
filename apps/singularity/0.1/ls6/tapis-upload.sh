#
TOOL=singularity
SYSTEM=ls6
VER=0.1

# Copy all of the object files to the bundle directory
# and create a binaries.tgz
#
# For example:
# cd bundle

# tar zcvf binaries.tgz bin lib

# delete old working area in tapis
tapis files delete agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM

# create directory structure
tapis files mkdir agave://data.vdjserver.org/irplus/apps $TOOL
tapis files mkdir agave://data.vdjserver.org/irplus/apps/$TOOL $VER
tapis files mkdir agave://data.vdjserver.org/irplus/apps/$TOOL/$VER $SYSTEM
tapis files mkdir agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM test

# upload app assets
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM singularity.sh
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM singularity.json
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM ../common/singularity_common.sh
tapis files list agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM

# upload test assets
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM/test test/test.sh
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM/test test/test-sonar.json
tapis files list agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM/test
