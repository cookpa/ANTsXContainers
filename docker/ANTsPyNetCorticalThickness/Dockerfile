FROM cookpa/antspynet:latest

# Switch back to root from antspyuser in base layer
USER root

ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN mkdir /opt/dataCache /opt/bin

# Copy script
COPY do_antsxnet_thickness.py /opt/bin

# Copy data required by the cortical thickness pipeline
COPY ANTsXNetData /opt/dataCache/ANTsXNet

LABEL maintainer="Philip A Cook (https://github.com/cookpa)" \
      description="Cortical thickness script by Nick Tustison. \
ANTsPyNet is part of the ANTsX ecosystem (https://github.com/ANTsX). \
Citation: https://www.medrxiv.org/content/10.1101/2020.10.19.20215392v1 \
ANTs Citation: https://pubmed.ncbi.nlm.nih.gov/24879923"

# non-root user at run time
USER antspyuser
WORKDIR /home/antspyuser

ENTRYPOINT ["python", "/opt/bin/do_antsxnet_thickness.py"]
