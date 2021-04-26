#
TOOL=toy
SYSTEM=ls5
#VER=0.1
VER=schristley

# Copy all of the object files to the bundle directory
# and create a binaries.tgz
#
# For example:
# cd bundle

# tar zcvf binaries.tgz bin lib

# delete old working area in tapis
tapis files delete agave:///irplus/apps/$TOOL/$VER/$SYSTEM

# create directory structure
tapis files mkdir agave:///irplus/apps $TOOL
tapis files mkdir agave:///irplus/apps/$TOOL $VER
tapis files mkdir agave:///irplus/apps/$TOOL/$VER $SYSTEM
tapis files mkdir agave:///irplus/apps/$TOOL/$VER/$SYSTEM test

# upload app assets
tapis files upload agave:///irplus/apps/$TOOL/$VER/$SYSTEM toy.sh
tapis files upload agave:///irplus/apps/$TOOL/$VER/$SYSTEM toy.json
tapis files upload agave:///irplus/apps/$TOOL/$VER/$SYSTEM ../common/toy_common.sh
tapis files list agave:///irplus/apps/$TOOL/$VER/$SYSTEM

# upload test assets
tapis files upload agave:///irplus/apps/$TOOL/$VER/$SYSTEM/test test/test.sh
tapis files upload agave:///irplus/apps/$TOOL/$VER/$SYSTEM/test ../common/test/IGH_SRR1383450.airr.tsv.gz
tapis files list agave:///irplus/apps/$TOOL/$VER/$SYSTEM/test

#files-upload -F test/test.sh /irplus/apps/$TOOL/$VER/$SYSTEM/test
#files-upload -F test/test-clones.json /irplus/apps/$TOOL/$VER/$SYSTEM/test
#files-upload -F ../common/test/SRR1383450_2.igblast.airr.tsv.gz /irplus/apps/$TOOL/$VER/$SYSTEM/test
