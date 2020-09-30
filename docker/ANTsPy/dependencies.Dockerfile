FROM python:3.8.5-buster as builder

# This doesn't actually b

ARG antspy_version="HEAD"

RUN apt-get update && \
    apt-get install -y cmake && \
    mkdir -p /opt/src /opt/config && \
    cd /opt/src && \
    git clone https://github.com/ANTsX/ANTsPy.git && \
    cd ANTsPy && \
    git checkout ${antspy_version} && \
    pip install pip-tools==5.3.1 && \
    pip-compile --output-file /opt/config/antsPyRequirements.txt && \
    git log | head -n 1 > /opt/config/antsPyVersion.txt

CMD ["python"]

