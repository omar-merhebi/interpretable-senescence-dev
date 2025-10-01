
FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04

# Set a non-root user to avoid permission issues in containers & HPC
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1000

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git curl ca-certificates build-essential cmake pkg-config \
    python3 python3-pip python3-venv python-is-python3\
    && rm -rf /var/lib/apt/lists/*

# Create user
RUN groupadd --gid ${USER_GID} ${USERNAME} \
 && useradd -s /bin/bash --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME}

# (Optional) CUDA toolkit headers if you compile kernels:
# RUN apt-get update && apt-get install -y cuda-toolkit-12-4 && rm -rf /var/lib/apt/lists/*

# Python deps example (adjust to your project)
# COPY requirements.txt /tmp/requirements.txt
# RUN pip3 install --no-cache-dir -r /tmp/requirements.txt

USER ${USERNAME}
WORKDIR /workspace
ENV PATH="/home/dev/.local/bin:${PATH}"
ENV DATA_ROOT=/data

RUN mkdir -p /workspace/logs
RUN python3 -m pip install upgrade pip
RUN cat /workspace/requirements.txt | xargs -n 1 pip install
RUN ln -s /data /workspace/