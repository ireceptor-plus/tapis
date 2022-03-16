#
# Parse rearrangement statistics output files into JSON report
#
# VDJServer Analysis Portal
# VDJServer Tapis applications
# https://vdjserver.org
#
# Part of the iReceptor+ platform
#
# Copyright (C) 2021 The University of Texas Southwestern Medical Center
# Author: Scott Christley
# Date: Sep 28, 2021
#

from __future__ import print_function
import argparse
import os
import sys
import csv
import json

def junction_length(name, file):
    statistics = { "statistic_name": name, "total": 0, "data": [] }
    total = 0
    reader = csv.DictReader(open(file, 'r'), dialect='excel-tab')
    for row in reader:
        statistics['data'].append({"key": int(row['CDR3_LENGTH']), "count": int(float(row['CDR3_COUNT']))})
        total = total + int(float(row['CDR3_COUNT']))
    statistics['total'] = total
    return statistics

def gene_usage(segment, file):
    statistics = {}
    reader = csv.DictReader(open(file, 'r'), dialect='excel-tab')
    for row in reader:
        name = segment
        if row['level'] == 'allele':
            name = name + '_call'
        else:
            name = name + '_' + row['level']
        name = name + '_' + row['mode']
        if row['productive'] in ['T', 't', 'TRUE', 'True', 'true']:
            name = name + '_productive'
        stat = statistics.get(name)
        if stat is None:
            stat = { "statistic_name": name, "total": 0, "data": [] }
            statistics[name] = stat
        try:
            stat['data'].append({"key": row['gene'], "count": int(row['duplicate_count'])})
        except:
            stat['data'].append({"key": row['gene'], "count": float(row['duplicate_count'])})
    # generate totals
    for stat in statistics:
        total = 0
        for data in statistics[stat]['data']:
            total = total + data['count']
        statistics[stat]['total'] = total
    return statistics

if (__name__=="__main__"):
    parser = argparse.ArgumentParser(description='Generate statistics JSON report.')
    parser.add_argument('repertoire_id', type=str, help='Repertoire ID')
    parser.add_argument('data_processing_id', type=str, help='DataProcessing ID')
    parser.add_argument('sample_processing_id', type=str, help='SampleProcessing ID')
    parser.add_argument('rearrangement_file', type=str, help='Rearrangement AIRR TSV')
    args = parser.parse_args()

    if args:
        dp_id = args.data_processing_id
        if dp_id == 'None' or dp_id == 'null':
            dp_id = None
        sp_id = args.sample_processing_id
        if sp_id == 'None' or sp_id == 'null':
            sp_id = None
        result = { "repertoire": { "repertoire_id": args.repertoire_id, "data_processing_id": dp_id, "sample_processing_id": sp_id }}
        result['statistics'] = []

        # counts
        reader = csv.DictReader(open('count_statistics.csv', 'r'))
        for row in reader:
            if row['file'] == args.rearrangement_file:
                result['statistics'].append({ "statistic_name":"rearrangement_count", "total": row['total records'],
                    "data": [{ "key":"rearrangement_count", "count": row['total records'] }]})
                result['statistics'].append({ "statistic_name":"duplicate_count", "total": row['total dupcount'],
                    "data": [{ "key":"duplicate_count", "count": row['total dupcount'] }]})
                result['statistics'].append({ "statistic_name":"rearrangement_count_productive", "total": row['productive records'],
                    "data": [{ "key":"rearrangement_count_productive", "count": row['productive records'] }]})
                result['statistics'].append({ "statistic_name":"duplicate_count_productive", "total": row['productive dupcount'],
                    "data": [{ "key":"duplicate_count_productive", "count": row['productive dupcount'] }]})

        # junction length distribution
        result['statistics'].append(junction_length('junction_length', args.repertoire_id + '.junction_nt_length.tsv'))
        result['statistics'].append(junction_length('junction_aa_length', args.repertoire_id + '.junction_aa_length.tsv'))
        result['statistics'].append(junction_length('junction_length_productive', args.repertoire_id + '.productive.junction_nt_length.tsv'))
        result['statistics'].append(junction_length('junction_aa_length_productive', args.repertoire_id + '.productive.junction_aa_length.tsv'))

        # gene usage
        stats = gene_usage('v', args.repertoire_id + '.v_call.tsv')
        for s in stats:
            result['statistics'].append(stats[s])
        stats = gene_usage('d', args.repertoire_id + '.d_call.tsv')
        for s in stats:
            result['statistics'].append(stats[s])
        stats = gene_usage('j', args.repertoire_id + '.j_call.tsv')
        for s in stats:
            result['statistics'].append(stats[s])
        stats = gene_usage('c', args.repertoire_id + '.c_call.tsv')
        for s in stats:
            result['statistics'].append(stats[s])

        # save the json
        with open('rearrangement_statistics.json', 'w') as json_file:
            json.dump(result, json_file, indent=2)

