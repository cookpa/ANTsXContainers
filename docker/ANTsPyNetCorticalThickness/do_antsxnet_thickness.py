import ants
import antspynet
import argparse
import sys

import os.path
from os import path

import tensorflow as tf

# Script by Nick Tustison
# https://github.com/ntustison/PaperANTsX/blob/master/Data/Scripts/RunStudy/do_antsxnet_thickness.py

parser = argparse.ArgumentParser()
parser.add_argument("-a", "--anatomical-image", help="Input anatomical image (T1w)", type=str, required=True)
parser.add_argument("-o", "--output-prefix", help="Output prefix", type=str)
parser.add_argument("-t", "--threads", help="Number of threads in tensorflow operations. Use environment variable " \
                    "ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS to control threading in ANTs calls", type=int, default=1)
args = parser.parse_args()

# Internal variables for args
t1_file = args.anatomical_image
output_prefix = args.output_prefix
threads = args.threads

# Cache data location. Data is stored inside the container to avoid downloads at run time
# which can fail in isolated cluster environments
data_cache_dir = "/opt/dataCache/ANTsXNet"

tf.keras.backend.clear_session()
config = tf.compat.v1.ConfigProto(intra_op_parallelism_threads=threads,
                                  inter_op_parallelism_threads=threads)
session = tf.compat.v1.Session(config=config)
tf.compat.v1.keras.backend.set_session(session)

t1 = ants.image_read(t1_file)

print("Atropos and KellyKapowski")

kk_file = output_prefix + "CorticalThickness.nii.gz"
kk = None
if not path.exists(kk_file):
    print("    Atropos:  calculating\n")
    atropos = antspynet.deep_atropos(t1, do_preprocessing=True, 
                                     antsxnet_cache_directory=data_cache_dir, verbose=True)
    atropos_segmentation = atropos['segmentation_image']

    # Combine white matter and deep gray matter
    kk_segmentation = atropos_segmentation
    kk_segmentation[kk_segmentation == 4] = 3
    kk_white_matter = atropos['probability_images'][3] + atropos['probability_images'][4]
    print("    KellyKapowski:  calculating\n")
    kk = ants.kelly_kapowski(s=kk_segmentation, g=atropos['probability_images'][2],
                             w=kk_white_matter, its=45, r=0.025, m=1.5, t=10, x=0, verbose=1)
    ants.image_write(kk, kk_file)
else:
    print("    Reading\n")
    kk = ants.image_read(kk_file)

# If one wants cortical labels one can run the following lines

print("DKT\n")

dkt_file = output_prefix + "Dkt.nii.gz"
dkt = None
if not path.exists(dkt_file):
    print("    Calculating\n")
    dkt = antspynet.desikan_killiany_tourville_labeling(t1, do_preprocessing=True,
                                                        antsxnet_cache_directory=data_cache_dir, verbose=True)
    ants.image_write(dkt, dkt_file)
else:
    print("    Reading\n")
    dkt = ants.image_read(dkt_file)

print("DKT Prop\n")

dkt_prop_file = output_prefix + "DktPropagatedLabels.nii.gz"
if not path.exists(dkt_prop_file):
    print("    Calculating\n")
    dkt_mask = ants.threshold_image(dkt, 1000, 3000, 1, 0)
    dkt = dkt_mask * dkt
    ants_tmp = ants.threshold_image(kk, 0, 0, 0, 1)
    ants_dkt = ants.iMath(ants_tmp, "PropagateLabelsThroughMask", ants_tmp * dkt)
    ants.image_write(ants_dkt, output_prefix + "DktPropagatedLabels.nii.gz")
#
