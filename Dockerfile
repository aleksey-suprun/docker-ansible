FROM python:3.8-slim AS cryptography-builder

# CRYPTOGRAPHY_DONT_BUILD_RUST is deprecated.
# This is a workaround for the known buildx issue:
# https://github.com/docker/buildx/issues/395
ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1

RUN apt update \
    && apt install -y --no-install-recommends \
        gcc \
        libffi-dev \
        cargo \
        libssl-dev \
    && pip wheel --wheel-dir=/tmp/wheelshome \
        cryptography

FROM python:3.8-slim

ARG ANSIBLE_VERSION=4.2.0

COPY --from=cryptography-builder /tmp/wheelshome /tmp/wheelshome
COPY requirements.txt /requirements.txt

RUN pip install --no-cache-dir --find-links=/tmp/wheelshome -r /requirements.txt \
        ansible==${ANSIBLE_VERSION} \
    && rm -rf /tmp/*
