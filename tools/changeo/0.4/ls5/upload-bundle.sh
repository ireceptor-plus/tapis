#
SYSTEM=ls5
VER=0.4

# Copy all of the object files to the bundle directory
# and create a binaries.tgz
#
# For example:
# cd bundle

# Install pRESTO locally (used by Change-O, python 3):
# bash
# module purge
# module load gcc python3
# cd presto
# export PYTHONPATH=../lib/python3.7/site-packages:$PYTHONPATH
# python3 setup.py install --prefix=..

# Install AIRR-formats locally (used by Change-O, python 3):
# bash
# module unload python
# module load python3
# cd airr-standards/lang/python
# export PYTHONPATH=../../../lib/python3.7/site-packages:$PYTHONPATH
# python3 setup.py install --prefix=../../..

# Install Change-O locally (python 3):
# bash
# module unload python
# module load gcc python3
# cd changeo
# export PYTHONPATH=../lib/python3.7/site-packages:$PYTHONPATH
# python3 setup.py install --prefix=..
# exit

# tar zcvf binaries.tgz bin lib

# delete old working area in agave
files-delete /irplus/apps/changeo/$VER/$SYSTEM

# upload files
files-mkdir -N $VER /irplus/apps/changeo
files-mkdir -N $SYSTEM /irplus/apps/changeo/$VER
files-mkdir -N test /irplus/apps/changeo/$VER/$SYSTEM
files-upload -F bundle/binaries.tgz /irplus/apps/changeo/$VER/$SYSTEM
files-upload -F ../common/changeo_common.sh /irplus/apps/changeo/$VER/$SYSTEM
files-upload -F changeo.sh /irplus/apps/changeo/$VER/$SYSTEM
files-upload -F changeo.json /irplus/apps/changeo/$VER/$SYSTEM

files-upload -F test/test.sh /irplus/apps/changeo/$VER/$SYSTEM/test
files-upload -F test/test-clones.json /irplus/apps/changeo/$VER/$SYSTEM/test
files-upload -F ../common/test/SRR1383450_2.igblast.airr.tsv.gz /irplus/apps/changeo/$VER/$SYSTEM/test
