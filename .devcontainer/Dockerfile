
FROM nvidia/cuda:12.4.1-cudnn-runtime-ubuntu22.04

# Set a non-root user to avoid permission issues in containers & HPC
ARG USERNAME=dev
ARG USER_UID=1000
ARG USER_GID=1000

ENV DEBIAN_FRONTEND=noninteractive \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1 \
    PYTHONDONTWRITEBYTECODE=1

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git curl ca-certificates build-essential cmake pkg-config \
    python3 python3-pip python3-venv python-is-python3\
    r-base r-base-dev \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /tmp/build
COPY requirements.txt /tmp/build/requirements.txt

RUN Rscript -e 'install.packages("remotes")'
RUN Rscript -e 'remotes::install_github("theislab/kBET")'
RUN python3 -m pip install --upgrade pip \
 && sed -e 's/\r$//' /tmp/build/requirements.txt \
    | grep -vE '^\s*#|^\s*$' \
    | xargs -r -I{} sh -lc 'pip install --no-cache-dir "{}" || echo "{}" >> /tmp/pip_failures.txt' \
 && if [ -s /tmp/pip_failures.txt ]; then \
      echo "[WARNING] The following packages failed to install:" && cat /tmp/pip_failures.txt; \
    fi

RUN groupadd --gid ${USER_GID} ${USERNAME} \
 && useradd -s /bin/bash --uid ${USER_UID} --gid ${USER_GID} -m ${USERNAME} \
 && mkdir -p /workspace /data /workspace/logs \
 && chown -R ${USERNAME}:${USER_GID} /workspace /data

USER ${USERNAME}
WORKDIR /workspace

ENV PATH="/home/${USERNAME}/.local/bin:${PATH}"
ENV DATA_ROOT=/data