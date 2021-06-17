FROM python:3.9 AS cryptography-builder

# CRYPTOGRAPHY_DONT_BUILD_RUST is deprecated.
# This is a workaround for the known buildx issue:
# https://github.com/docker/buildx/issues/395
ENV CRYPTOGRAPHY_DONT_BUILD_RUST=1

RUN apt update \
    && apt install -y --no-install-recommends \
        gcc \
        libffi-dev \
        cargo \
    && pip wheel --wheel-dir=/tmp/wheelshome \
        cryptography

FROM python:3.9

COPY --from=cryptography-builder /tmp/wheelshome /tmp/wheelshome

RUN pip install --no-cache-dir --find-links=/tmp/wheelshome \
        ansible \
        ansible-lint \
    && rm -rf /tmp/*
