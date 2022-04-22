#!/usr/bin/env python

#
# This gets ANTsXNet data and pretrained networks
#
# Getting all the data ahead of time is optional, by default it is downloaded
# on demand and stored in ~/.keras/ANTsXNet . But for complete reproducibility,
# or for applications lacking Internet access, the data can be downloaded with
# this script.
#
# To use the data in a container, mount the data directory containing keras.json
# as $USER/.keras.
#
#
import antspynet
import os
import sys

if (len(sys.argv) == 1):
    usage = '''
  Usage: {} /path/to/ANTsXNetData

  Downloads ANTsXNet data and networks to the specified directory.

  The path MUST be absolute or it will be interpreted relative to
  the default ~/.keras
'''
    print(usage.format(sys.argv[0]))

    sys.exit(1)

# Base output dir, make ANTsXNet/ and keras.json under here
output_dir=sys.argv[1]

data_path = f"{output_dir}/ANTsXNet"

allData = list(antspynet.get_antsxnet_data('show'))
allData.remove('show')

for entry in allData:
  print(f"Downloading {entry}")
  antspynet.get_antsxnet_data(entry, antsxnet_cache_directory=data_path)

allNetworks = list(antspynet.get_pretrained_network('show'))
allNetworks.remove('sixTissueOctantBrainSegmentationWithPriors2')
allNetworks.remove('show')

for entry in allNetworks:
  print(f"Downloading {entry}")
  antspynet.get_pretrained_network(entry, antsxnet_cache_directory=data_path)

