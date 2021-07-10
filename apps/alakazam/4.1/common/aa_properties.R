#!/usr/bin/env Rscript

# Alakazam AA properties
#
# Author: Scott Christley
# Date: Sep 3, 2020
# 

# based upon this script for parsing args with optparse
# https://bitbucket.org/kleinstein/immcantation/src/master/pipelines/shazam-threshold.R

suppressPackageStartupMessages(library("optparse"))
suppressPackageStartupMessages(library("alakazam"))
suppressPackageStartupMessages(library("airr"))

# Define commmandline arguments
opt_list <- list(make_option(c("-d", "--db"), dest="DB",
                             help="Tabulated data file, in AIRR format (TSV)."),
                 make_option(c("-t", "--trim"), dest="TRIM", default=FALSE,
                             help=paste("Trim conserved residues.",
                                        "\n\t\tDefaults to FALSE.")),

# Parse arguments
opt <- parse_args(OptionParser(option_list=opt_list))

# Check input file
if (!("DB" %in% names(opt))) {
    stop("You must provide a database file with the -d option.")
}

# Read rearrangement data
db <- airr::read_rearrangement(opt$DB)

aa_db <- aminoAcidProperties(db, seq="junction_aa", label="junction")

airr::write_rearrangement(aa_db, 'aa_properties.airr.tsv')
