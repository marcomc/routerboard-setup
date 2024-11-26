# syntax=docker/dockerfile:1.2
FROM python:3.13-slim

# fix upstream signal
STOPSIGNAL SIGTERM

COPY requirements.pip.txt requirements.pip.txt
COPY ansible/requirements.ansible.yml requirements.ansible.yml

USER root

RUN --mount=type=cache,target=/var/cache/apt \
    --mount=type=cache,target=/var/lib/apt \
    --mount=type=cache,target=/root/.cache \
    apt update \
    && apt-get --no-install-recommends install -y git openssh-client \
    && id -u ansible || useradd --create-home ansible

USER ansible

ENV PATH="/home/ansible/.local/bin:${PATH}"

RUN mkdir $HOME/.ssh && chmod 700 $HOME/.ssh \
    && pip install --upgrade pip \
    && pip install -r requirements.pip.txt --pre\
    && ansible-galaxy install -r requirements.ansible.yml --force

CMD ["sleep", "infinity"]