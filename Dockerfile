FROM python:3.9-slim AS builder

RUN apt update

RUN apt install -y --no-install-recommends \
    gcc \
    libffi-dev \
    cargo \
    libssl-dev \
    libpython3-dev \
    build-essential

RUN pip install -U pip

COPY requirements.txt /requirements.txt

RUN pip install \
    --no-clean \
    -r /requirements.txt

FROM python:3.9-slim

COPY --from=builder /usr/local/lib/python3.9/site-packages /usr/local/lib/python3.9/site-packages
COPY --from=builder /usr/local/bin/ansible* /usr/local/bin
