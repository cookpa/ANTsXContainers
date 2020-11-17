FROM cookpa/antspynet:latest

COPY requirements.txt /opt

RUN apt-get update && \
    apt-get install -y cmake=3.13.4-1 && \
    python3 -m venv /opt/venv && \
    . /opt/venv/bin/activate && \
    pip install wheel && \
    pip install --use-feature=2020-resolver --requirement /opt/requirements.txt && \
    pip install --use-feature=2020-resolver git+https://github.com/ANTsX/ANTsPyNet.git@94eda8d3c609ae9b3b98d5b81dbc68dce9df8a14 && \
    git clone https://github.com/ANTsX/ANTsPy.git /opt/ANTsPy

FROM python:3.8.6-slim

COPY --from=builder /opt/venv /opt/venv

ENV VIRTUAL_ENV=/opt/venv
ENV PATH="$VIRTUAL_ENV/bin:$PATH"
ENV ITK_GLOBAL_DEFAULT_NUMBER_OF_THREADS=1

# Make a user and add data to the expected location
RUN useradd --create-home antspyuser && \
    mkdir /home/antspyuser/.antspy && \
    mkdir -p /home/antspyuser/.keras

COPY --from=builder /opt/ANTsPy/data/* /home/antspyuser/.antspy/

# copy data required by the cortical thickness pipeline
COPY ANTsXNetData /home/antspyuser/.keras/ANTsXNet

LABEL maintainer="Philip A Cook (https://github.com/cookpa)"     

WORKDIR /home/antspyuser
USER antspyuser

ENTRYPOINT ["python"]

