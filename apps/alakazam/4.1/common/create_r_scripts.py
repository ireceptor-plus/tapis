#
# Generate R scripts for Alakazam
#
# Author: Scott Christley
# Date: Sep 2, 2020
#

from __future__ import print_function
import json
import argparse

#
# main routine
#

parser = argparse.ArgumentParser(description='Generate R scripts.')
parser.add_argument('--gene', type=str, help='Output R script for Alakazam gene usage')
parser.add_argument('--clonal', type=str, help='Output R script for Alakazam clonal analysis')
parser.add_argument('--diversity', type=str, help='Output R script for Alakazam diversity analysis')
parser.add_argument('--lineage', type=str, help='Output R script for Alakazam lineage reconstruction')
parser.add_argument('--rearrangement_file', type=str, required=True, help='Rearrangment input file name')

args = parser.parse_args()
if (args):

    # gene usage R script, we just calculate all of them
    if (args.gene):
        with open(args.gene, 'w') as r_file:
            r_file.write('library(alakazam)\n')
            r_file.write('db <- readChangeoDb("/data/' + args.rearrangement_file + '")\n')

            # allele
            r_file.write("genes <- countGenes(db, gene='v_call', group='repertoire_id', mode='allele', copy='duplicate_count')\n")
            r_file.write("write.table(genes, row.names=F, sep='\\t', file='v_allele_usage.tsv')\n")
            r_file.write("genes <- countGenes(db, gene='d_call', group='repertoire_id', mode='allele', copy='duplicate_count')\n")
            r_file.write("write.table(genes, row.names=F, sep='\\t', file='d_allele_usage.tsv')\n")
            r_file.write("genes <- countGenes(db, gene='j_call', group='repertoire_id', mode='allele', copy='duplicate_count')\n")
            r_file.write("write.table(genes, row.names=F, sep='\\t', file='j_allele_usage.tsv')\n")
            # TODO: Alakazam throws an error and stops execution if no data in c_call field
            # We need to figure out to check for this
            #r_file.write("genes <- countGenes(db, gene='c_call', group='repertoire_id', mode='allele', copy='duplicate_count', fill=T)\n")
            #r_file.write("write.table(genes, row.names=F, sep='\\t', file='c_allele_usage.tsv')\n")

            # gene
            r_file.write("genes <- countGenes(db, gene='v_call', group='repertoire_id', mode='gene', copy='duplicate_count')\n")
            r_file.write("write.table(genes, row.names=F, sep='\\t', file='v_gene_usage.tsv')\n")
            r_file.write("genes <- countGenes(db, gene='d_call', group='repertoire_id', mode='gene', copy='duplicate_count')\n")
            r_file.write("write.table(genes, row.names=F, sep='\\t', file='d_gene_usage.tsv')\n")
            r_file.write("genes <- countGenes(db, gene='j_call', group='repertoire_id', mode='gene', copy='duplicate_count')\n")
            r_file.write("write.table(genes, row.names=F, sep='\\t', file='j_gene_usage.tsv')\n")
            #r_file.write("genes <- countGenes(db, gene='c_call', group='repertoire_id', mode='gene', copy='duplicate_count')\n")
            #r_file.write("write.table(genes, row.names=F, sep='\\t', file='c_gene_usage.tsv')\n")

            # family/subgroup
            r_file.write("genes <- countGenes(db, gene='v_call', group='repertoire_id', mode='family', copy='duplicate_count')\n")
            r_file.write("write.table(genes, row.names=F, sep='\\t', file='v_subgroup_usage.tsv')\n")
            r_file.write("genes <- countGenes(db, gene='d_call', group='repertoire_id', mode='family', copy='duplicate_count')\n")
            r_file.write("write.table(genes, row.names=F, sep='\\t', file='d_subgroup_usage.tsv')\n")
            r_file.write("genes <- countGenes(db, gene='j_call', group='repertoire_id', mode='family', copy='duplicate_count')\n")
            r_file.write("write.table(genes, row.names=F, sep='\\t', file='j_subgroup_usage.tsv')\n")
            #r_file.write("genes <- countGenes(db, gene='c_call', group='repertoire_id', mode='family', copy='duplicate_count')\n")
            #r_file.write("write.table(genes, row.names=F, sep='\\t', file='c_subgroup_usage.tsv')\n")

            r_file.write("q()\n")

    # clonal abundance R script
    if (args.clonal):
        pass

    # diversity curve R script
    if (args.diversity):
        pass

    # lineage reconstruction R script
    if (args.lineage):
        pass

else:
    # invalid arguments
    parser.print_help()

