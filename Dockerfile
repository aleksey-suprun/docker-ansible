FROM python:3.9-slim AS wheels-builder

RUN apt update \
    && apt install -y --no-install-recommends \
        gcc \
        libffi-dev \
        cargo \
        libssl-dev \
        libpython3-dev \
        build-essential \
    && pip install -U pip \
    && pip wheel --wheel-dir=/tmp/wheelshome \
        cryptography \
        bcrypt \
        pynacl

FROM python:3.9-slim

COPY --from=wheels-builder /tmp/wheelshome /tmp/wheelshome
COPY requirements.txt /requirements.txt

RUN pip install --no-cache-dir -U pip \
    && pip install \
        --no-cache-dir \
        --find-links=/tmp/wheelshome \
        -r /requirements.txt \
    && rm -rf /tmp/*
