FROM python:3.8.5-buster as builder

# Use pip for a very fast install of the latest official release
#
# Default to install latest version
# For a specific version, use antspyx==<version> 
# to see available versions, run 'pip install antspyx=='
# RUN pip install antspyx

ARG antspy_version="HEAD"

ENV ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=1


RUN apt-get update && \
    apt-get install -y cmake && \
    mkdir /opt/src && \
    cd /opt/src && \
    git clone https://github.com/ANTsX/ANTsPy.git && \
    cd ANTsPy && \
    git checkout ${antspy_version} && \
    python setup.py install

from python:3.8.5-slim
COPY --from=builder /usr/local/lib/python3.8/site-packages/ants /usr/local/lib/python3.8/site-packages/ants

# Depdendencies
RUN pip install chart_studio matplotlib nibabel numpy pandas pillow plotly pyyaml sklearn scikit-image \
                statsmodels webcolors 

# Make a user and add data to the expected location
RUN useradd --create-home antspyuser && \
    mkdir /home/antspyuser/.antspy

COPY --from=builder /opt/src/ANTsPy/data/* /home/antspyuser/.antspy/
    
WORKDIR /home/antspyuser
USER antspyuser


CMD ["python"]
