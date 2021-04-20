#
# Parse ChangeO summary output to JSON
#
# Because ChangeO does not seem to provide a way to save the summary output
# from a command, .e.g. DefineClones, we parse it here into a simple JSON format.
# It seems a waste to read the output files to calculate
# when the numbers are right there.
#
# Author: Scott Christley
# Date: Dec 5, 2020
#

from __future__ import print_function
import json
import argparse
import os
import sys

if (__name__=="__main__"):
    parser = argparse.ArgumentParser(description='Parse ChangeO summary output to JSON.')
    parser.add_argument('input_file', type=str, help='ChangeO file with stdout text')
    parser.add_argument('json_file', type=str, help='Output JSON file')
    args = parser.parse_args()

    if args:
        summary = {}
        summary['PROGRESS'] = []
        reader = open(args.input_file, 'r')
        line = reader.readline()
        while line:
            fields = line.split('>')
            if len(fields) == 2:
                if fields[0] == 'PROGRESS':
                    summary['PROGRESS'].append(fields[1].strip())
                else:
                    summary[fields[0].strip()] = fields[1].strip()
            line = reader.readline()

        with open(args.json_file, 'w') as json_file:
            json.dump(summary, json_file, indent=2)
