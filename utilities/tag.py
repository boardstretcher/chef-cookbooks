#!/bin/python

import json
import sys

# ./tag.py <json file name> <tag to add>

jsonfile= sys.argv[1]
newtag= sys.argv[2]

with open(jsonfile) as f:
	data = json.load(f)

if newtag in data['normal']['tags']:
	print 'already exists'
else:
	data['normal']['tags'].append(newtag)

with open(jsonfile, 'w') as f:
	f.write(json.dumps(data, sort_keys=True, indent=4, separators=(',', ': ')))
