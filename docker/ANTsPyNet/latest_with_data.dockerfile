FROM cookpa/antspynet:latest AS builder

COPY get_antsxnet_data.py /opt/bin/

# Unlock cache dir
USER root
RUN chown antspyuser /home/antspyuser/.keras && \
    chown antspyuser /home/antspyuser/.antspy

USER antspyuser

RUN . ${VIRTUAL_ENV}/bin/activate && \
    chmod 0755 /home/antspyuser/.keras && \
    /opt/bin/get_antsxnet_data.py /home/antspyuser/.keras 1 && \
    find /home/antspyuser/.keras -type d -exec chmod 0755 {} + && \
    find /home/antspyuser/.keras -type f -exec chmod 0644 {} +

WORKDIR /home/antspyuser

LABEL maintainer="Philip A Cook (https://github.com/cookpa)" \
      description="ANTsPyNet is part of the ANTsX ecosystem (https://github.com/ANTsX). \
ANTsX citation: https://pubmed.ncbi.nlm.nih.gov/33907199"
ENTRYPOINT ["python"]

