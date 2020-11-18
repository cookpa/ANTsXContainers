FROM cookpa/antspynet:latest

# Switch back to root from antspyuser in base layer
USER root

ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

RUN mkdir -p /home/antspyuser/.keras

# Copy script
COPY do_antsxnet_thickness.py /opt

# Copy data required by the cortical thickness pipeline
COPY ANTsXNetData /home/antspyuser/.keras/ANTsXNet

LABEL maintainer="Philip A Cook (https://github.com/cookpa)" \
      description="Cortical thickness script by Nick Tustison. \
                   ANTsPyNet is part of the ANTsX ecosystem (https://github.com/ANTsX). \
                   Citation: https://www.medrxiv.org/content/10.1101/2020.10.19.20215392v1"     

RUN chown -R antspyuser /home/antspyuser/.keras && \
    chgrp -R antspyuser /home/antspyuser/.keras

# non-root user at run time
USER antspyuser
WORKDIR /home/antspyuser

ENTRYPOINT ["python", "/opt/do_antsxnet_thickness.py"]
