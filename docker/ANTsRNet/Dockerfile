FROM cookpa/antsr:0.5.7.4

COPY installANTsRNet.R /opt

RUN apt-get update && \
    apt-get install -y \
      python3 \
      python3-pip \
      python3-venv && \
    python3 -m venv /opt/venv && \
    . /opt/venv/bin/activate && \
    R_REMOTES_NO_ERRORS_FROM_WARNINGS=true Rscript /opt/installANTsRNet.R

ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV R_DEFAULT_PACKAGES="datasets,utils,grDevices,graphics,stats,methods,ANTsR,ANTsRNet"

# Make a user, ANTsXNet data can be added or downloaded at run time to ~/.keras
RUN useradd --create-home antsrnetuser && \
    mkdir -p /home/antsrnetuser/.local/share/r-reticulate 

# This suppresses a miniconda installation prompt at run time
COPY miniconda.json /home/antsrnetuser/.local/share/r-reticulate

RUN chown -R antsrnetuser /home/antsrnetuser/.local && \
    chgrp -R antsrnetuser /home/antsrnetuser/.local

WORKDIR /home/antsrnetuser
USER antsrnetuser


CMD ["R"]
