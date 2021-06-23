#
TOOL=statistics
SYSTEM=stampede2
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
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM statistics.sh
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM statistics.json
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM ../../../../vdjserver/common/common_functions.sh
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM ../../../../vdjserver/common/repcalc_create_config.py
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM ../../../../vdjserver/common/junction_length_template.json
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM ../common/statistics_common.sh
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM ../common/gene_usage.R
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM ../common/aa_properties.R
tapis files list agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM

# upload test assets
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM/test test/test.sh
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM/test test/test-app.json
tapis files list agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM/test

