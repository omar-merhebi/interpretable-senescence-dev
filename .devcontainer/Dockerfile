
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

USER ${USERNAME}
WORKDIR /workspace
ENV PATH="/home/dev/.local/bin:${PATH}"
ENV DATA_ROOT=/data

COPY requirements.txt /tmp/requirements.txt
RUN mkdir -p /workspace/logs
RUN python3 -m pip install --upgrade pip
RUN sed -e 's/\r$//' /tmp/requirements.txt \
    | grep -vE '^\s*#|^\s*$' \
    | xargs -r -I{} sh -lc 'pip install --no-cache-dir "{}" || echo "{}" >> /tmp/pip_failures.txt' \
    && if [ -s /tmp/pip_failures.txt ]; then \
        echo "[WARNING] The following packages failed to install:" && cat /tmp/pip_failures.txt; \
    fi