#
# Tapis upload script
# Part of the iReceptor+ platform
#
# Author: Scott Christley
# Copyright (C) 2021-2022 The University of Texas Southwestern Medical Center
# Date: Jun 4, 2021
#

TOOL=mutations
SYSTEM=ls6
VER=0.1

# delete old app area in tapis
tapis files delete agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM

# create directory structure
tapis files mkdir agave://data.vdjserver.org/irplus/apps $TOOL
tapis files mkdir agave://data.vdjserver.org/irplus/apps/$TOOL $VER
tapis files mkdir agave://data.vdjserver.org/irplus/apps/$TOOL/$VER $SYSTEM
tapis files mkdir agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM test

# upload app assets
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM mutations.sh
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM mutations.json
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM ../../../../vdjserver/common/common_functions.sh
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM ../../../../vdjserver/common/parse_changeo.py
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM ../../../../vdjserver/common/repcalc_create_config.py
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM ../../../../vdjserver/common/get_repertoire_id_for_file.py
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM ../../../../vdjserver/common/mutational_analysis.R
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM ../../../../vdjserver/common/mutational_analysis.sh
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM ../../../../vdjserver/common/mutational_template.json
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM ../../../../vdjserver/common/create_germlines.sh
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM ../../../../vdjserver/common/germline_report.py
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM ../common/mutations_common.sh
tapis files list agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM

# upload test assets
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM/test test/test.sh
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM/test test/test-allele.json
tapis files upload agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM/test test/test-gene.json
tapis files list agave://data.vdjserver.org/irplus/apps/$TOOL/$VER/$SYSTEM/test

