FROM python:3.11.10-bookworm AS builder

# Pull data from this version, but install latest
# development antspy
ARG ANTSPY_DATA_VERSION=0.5.4

ENV VIRTUAL_ENV=/opt/venv

RUN apt-get update && \
    python3 -m venv ${VIRTUAL_ENV} && \
    . ${VIRTUAL_ENV}/bin/activate && \
    pip install wheel && \
    pip install antspyx && \
    pip install git+https://github.com/ANTsX/ANTsPyNet.git && \
    wget -O /opt/antsPy-${ANTSPY_DATA_VERSION}.zip \
      https://github.com/ANTsX/ANTsPy/archive/refs/tags/v${ANTSPY_DATA_VERSION}.zip && \
    unzip /opt/antsPy-${ANTSPY_DATA_VERSION}.zip -d /opt/ANTsPy && \
    cp -r /opt/ANTsPy/ANTsPy-${ANTSPY_DATA_VERSION}/data /opt/antspydata && \
    chmod 0755 /opt/antspydata && \
    chmod 0644 /opt/antspydata*


FROM python:3.11.10-slim-bookworm

RUN apt-get update && \
    apt-get install -y \
      libpng16-16 \
      procps && \
    rm -rf /var/lib/apt/lists/*

ENV VIRTUAL_ENV=/opt/venv
ENV ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=1
ENV PATH="${VIRTUAL_ENV}/bin:$PATH"

COPY --from=builder ${VIRTUAL_ENV} ${VIRTUAL_ENV}

# Make a user and add data to the expected location for antspy
# Also set up .keras directory for antspynet data and models
# Note .keras is owned by root and not writeable by the user
#
# This is to prevent users spinning up multiple instances of the
# container and downloading the same data to a non-persistent location
#
RUN useradd --create-home antspyuser && \
    mkdir /home/antspyuser/.antspy \
          /home/antspyuser/.keras && \
    chown antspyuser /home/antspyuser/.antspy

COPY get_antsxnet_data.py /opt/bin/

COPY --from=builder --chown=antspyuser \
     /opt/antspydata/* /home/antspyuser/.antspy/

WORKDIR /home/antspyuser
USER antspyuser

LABEL maintainer="Philip A Cook (https://github.com/cookpa)" \
      description="ANTsPyNet is part of the ANTsX ecosystem (https://github.com/ANTsX). \
ANTsX citation: https://pubmed.ncbi.nlm.nih.gov/33907199"
ENTRYPOINT ["python"]

