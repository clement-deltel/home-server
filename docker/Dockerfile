# Use official Ubuntu image as a parent image
FROM ubuntu:22.04

LABEL org.opencontainers.image.authors="Clement Deltel <38040315+clement-deltel@users.noreply.github.com>"
LABEL org.opencontainers.image.title="home-server"
LABEL org.opencontainers.image.description=""

# Not persisted into the built image
ARG ID="1000"
ARG USER="ubuntu"
ARG TZ

# Persisted into the built image
ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=${TZ}

# Install dependencies
RUN apt update -y && apt install -y sudo tzdata

# Create group, user, and grant sudo permissions without password
RUN groupadd --gid ${ID} ${USER} && \
    useradd --create-home --gid ${ID} --home /home/${USER} --shell /bin/bash --uid ${ID} ${USER} &&\
    adduser ${USER} sudo && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers
WORKDIR /home/${USER}

USER ${USER}

ENTRYPOINT ["/bin/bash"]
