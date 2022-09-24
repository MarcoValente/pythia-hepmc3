FROM rootproject/root:6.26.06-ubuntu22.04
USER root

WORKDIR /pythia

# Install useful apps
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
    && apt-get install -y \
    wget \
    python-pip \
    cmake \
    vim \
    git \
    gzip \
    rsync

# Download Pythia8
RUN wget https://pythia.org/download/pythia83/pythia8307.tgz
RUN tar -zxf pythia8307.tgz \
    && mv pythia8307/* . \
    && rm -r pythia8307.tgz pythia8307

# Download and install HepMC3 version 3.2.5
RUN git clone -b "3.2.5" https://gitlab.cern.ch/hepmc/HepMC3.git
RUN mkdir -p HepMC3/build && \
    cd HepMC3/build && \
    cmake -DHEPMC3_ENABLE_ROOTIO=OFF -DCMAKE_INSTALL_PREFIX=../../ ../ && \
    make && make install && \
    cd - && \
    rm -rf HepMC3

# Install Pythia8 with HepMC3
RUN ./configure --prefix=/usr/ \
                --with-hepmc3 \
                --with-hepmc3-bin=bin/ \
                --with-hepmc3-lib=lib/ \
                --with-hepmc3-include=include/ && \
    make && make install