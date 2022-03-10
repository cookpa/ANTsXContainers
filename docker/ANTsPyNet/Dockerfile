FROM python:3.8.12-buster as builder

COPY requirements.txt /opt

RUN apt-get update && \
    python3 -m venv /opt/venv && \
    . /opt/venv/bin/activate && \
    pip install wheel && \
    pip install --requirement /opt/requirements.txt && \
    pip install antspynet==0.1.5 && \
    wget -O /opt/antsPy-0.3.0.zip \
      https://github.com/ANTsX/ANTsPy/archive/refs/tags/v0.3.0.zip  && \
    unzip /opt/antsPy-0.3.0.zip -d /opt/ANTsPy

FROM python:3.8.12-slim

ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=1

# Make a user and add data to the expected location
RUN useradd --create-home antspyuser && \
    mkdir /home/antspyuser/.antspy

COPY --from=builder /opt/venv /opt/venv

COPY --from=builder --chown=antspyuser \
       /opt/ANTsPy/ANTsPy-0.3.0/data/* /home/antspyuser/.antspy/

WORKDIR /home/antspyuser
USER antspyuser

LABEL maintainer="Philip A Cook (https://github.com/cookpa)" \
      description="ANTsPyNet is part of the ANTsX ecosystem (https://github.com/ANTsX). \
ANTsX citation: https://pubmed.ncbi.nlm.nih.gov/33907199"
ENTRYPOINT ["python"]

