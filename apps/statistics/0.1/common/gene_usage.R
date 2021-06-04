#!/usr/bin/env Rscript

# Alakazam gene usage
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
                             help="Tabulated data file, in AIRR format (TSV)."))

# Parse arguments
opt <- parse_args(OptionParser(option_list=opt_list))

# Check input file
if (!("DB" %in% names(opt))) {
    stop("You must provide a database file with the -d option.")
}

# Read rearrangement data
db <- airr::read_rearrangement(opt$DB)

# allele
genes <- countGenes(db, gene='v_call', group='repertoire_id', mode='allele', copy='duplicate_count')
write.table(genes, row.names=F, sep='\t', file='v_allele_usage.tsv')
genes <- countGenes(db, gene='d_call', group='repertoire_id', mode='allele', copy='duplicate_count')
write.table(genes, row.names=F, sep='\t', file='d_allele_usage.tsv')
genes <- countGenes(db, gene='j_call', group='repertoire_id', mode='allele', copy='duplicate_count')
write.table(genes, row.names=F, sep='\t', file='j_allele_usage.tsv')
# TODO: Alakazam throws an error and stops execution if no data in c_call field
# We need to figure out to check for this
#genes <- countGenes(db, gene='c_call', group='repertoire_id', mode='allele', copy='duplicate_count', fill=T)
#write.table(genes, row.names=F, sep='\t', file='c_allele_usage.tsv')

# gene
genes <- countGenes(db, gene='v_call', group='repertoire_id', mode='gene', copy='duplicate_count')
write.table(genes, row.names=F, sep='\t', file='v_gene_usage.tsv')
genes <- countGenes(db, gene='d_call', group='repertoire_id', mode='gene', copy='duplicate_count')
write.table(genes, row.names=F, sep='\t', file='d_gene_usage.tsv')
genes <- countGenes(db, gene='j_call', group='repertoire_id', mode='gene', copy='duplicate_count')
write.table(genes, row.names=F, sep='\t', file='j_gene_usage.tsv')
#genes <- countGenes(db, gene='c_call', group='repertoire_id', mode='gene', copy='duplicate_count')
#write.table(genes, row.names=F, sep='\t', file='c_gene_usage.tsv')

# family/subgroup
genes <- countGenes(db, gene='v_call', group='repertoire_id', mode='family', copy='duplicate_count')
write.table(genes, row.names=F, sep='\t', file='v_subgroup_usage.tsv')
genes <- countGenes(db, gene='d_call', group='repertoire_id', mode='family', copy='duplicate_count')
write.table(genes, row.names=F, sep='\t', file='d_subgroup_usage.tsv')
genes <- countGenes(db, gene='j_call', group='repertoire_id', mode='family', copy='duplicate_count')
write.table(genes, row.names=F, sep='\t', file='j_subgroup_usage.tsv')
