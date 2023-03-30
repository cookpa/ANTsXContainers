FROM python:3.8.12-buster as builder

# ANTsPy just used to get the data directory from its source zip
ARG ANTSPY_DATA_VERSION=0.3.7

ENV VIRTUAL_ENV=/opt/venv

RUN apt-get update && \
    python3 -m venv ${VIRTUAL_ENV} && \
    . ${VIRTUAL_ENV}/bin/activate && \
    pip install wheel && \
    pip install git+https://github.com/ANTsX/ANTsPyNet.git && \
    wget -O /opt/antsPy-${ANTSPY_DATA_VERSION}.zip \
      https://github.com/ANTsX/ANTsPy/archive/refs/tags/v${ANTSPY_DATA_VERSION}.zip && \
    unzip /opt/antsPy-${ANTSPY_DATA_VERSION}.zip -d /opt/ANTsPy && \
    cp -r /opt/ANTsPy/ANTsPy-${ANTSPY_DATA_VERSION}/data /opt/antspydata

FROM python:3.8.12-slim-buster

# Define here to not cause cache miss above when installing same version with / without data
ARG INSTALL_ANTSXNET_DATA=0

ENV VIRTUAL_ENV=/opt/venv
ENV ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=1
ENV PATH="${VIRTUAL_ENV}/bin:$PATH"

COPY --from=builder ${VIRTUAL_ENV} ${VIRTUAL_ENV}

# Make a user and add data to the expected location
RUN useradd --create-home antspyuser && \
    mkdir /home/antspyuser/.antspy \
          /home/antspyuser/.keras

COPY keras.json /home/antspyuser/.keras/
COPY get_antsxnet_data.py /opt/

RUN echo "Install data option: ${install_antsxnet_data}"
RUN . ${VIRTUAL_ENV}/bin/activate && \
    /opt/get_antsxnet_data.py /home/antspyuser/.keras ${INSTALL_ANTSXNET_DATA}

COPY --from=builder --chown=antspyuser \
     /opt/antspydata/* /home/antspyuser/.antspy/

WORKDIR /home/antspyuser
USER antspyuser

LABEL maintainer="Philip A Cook (https://github.com/cookpa)" \
      description="ANTsPyNet is part of the ANTsX ecosystem (https://github.com/ANTsX). \
ANTsX citation: https://pubmed.ncbi.nlm.nih.gov/33907199"
ENTRYPOINT ["python"]

