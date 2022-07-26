FROM cookpa/antsr:latest

ARG install_antsxnet_data=0

COPY installANTsRNet.R /opt

RUN apt-get update && \
    apt-get install -y \
      python3 \
      python3-pip \
      python3-venv && \
    python3 -m venv /opt/venv && \
    . /opt/venv/bin/activate && \
    R_REMOTES_NO_ERRORS_FROM_WARNINGS=true Rscript /opt/installANTsRNet.R ${install_antsxnet_data}

ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV R_DEFAULT_PACKAGES="datasets,utils,grDevices,graphics,stats,methods,ANTsR,ANTsRNet"

# Make a user, ANTsXNet data can be added or downloaded at run time to ~/.keras
RUN useradd --create-home antsrnetuser && \
    mkdir -p /home/antsrnetuser/.local/share/r-reticulate && \
    mkdir /home/antsrnetuser/.keras

# This suppresses a miniconda installation prompt at run time
COPY miniconda.json /home/antsrnetuser/.local/share/r-reticulate
COPY keras.json /home/antsrnetuser/.keras/
COPY getAntsXNetData.R /opt/

RUN echo "Install data option: ${install_antsxnet_data}"
RUN R_REMOTES_NO_ERRORS_FROM_WARNINGS=true Rscript \
    /opt/getAntsXNetData.R /home/antsrnetuser/.keras ${install_antsxnet_data}


RUN chown -R antsrnetuser /home/antsrnetuser/ && \
    chgrp -R antsrnetuser /home/antsrnetuser/

WORKDIR /home/antsrnetuser
USER antsrnetuser

LABEL maintainer="Philip A Cook (https://github.com/cookpa)" \
      description="ANTsRNet is part of the ANTsX ecosystem (https://github.com/ANTsX). \
Citation: https://www.medrxiv.org/content/10.1101/2020.10.19.20215392v1 \
ANTs Citation: https://pubmed.ncbi.nlm.nih.gov/24879923"

CMD ["R"]
