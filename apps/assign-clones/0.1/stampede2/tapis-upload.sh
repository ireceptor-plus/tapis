#
TOOL=assign-clones
SYSTEM=stampede2
VER=0.1

# For locally compiled tools:
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
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM assign-clones.sh
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM assign-clones.json
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM ../../../../vdjserver/common/common_functions.sh
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM ../../../../vdjserver/common/parse_changeo.py
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM ../../../../vdjserver/common/changeo_clones.sh
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM ../../../../vdjserver/common/find_threshold.R
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM ../common/clones_common.sh
tapis files list agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM

# upload test assets
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM/test test/test.sh
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM/test test/test-clones.json
tapis files list agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM/test

