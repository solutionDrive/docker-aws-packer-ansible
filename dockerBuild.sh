#!/usr/bin/env bash

set -e

docker build \
    --build-arg PACKER_VERSION=$PACKER_VERSION  \
    --build-arg AWSCLI_VERSION=$AWSCLI_VERSION \
    --build-arg INSPEC_VERSION=$INSPEC_VERSION \
    --build-arg ANSIBLE_VERSION=$ANSIBLE_VERSION \
    -t solutiondrive/docker-aws-packer-ansible:TEST-packer$PACKER_VERSION-ansible$ANSIBLE_VERSION-awscli$AWSCLI_VERSION-inspec$INSPEC_VERSION  \
    .

# Tag "latest"
#if [ "$LATEST" = "1" ]; then
#    docker tag \
#        solutiondrive/docker-aws-packer-ansible:packer$PACKER_VERSION-ansible$ANSIBLE_VERSION-awscli$AWSCLI_VERSION-inspec$INSPEC_VERSION \
#        solutiondrive/docker-aws-packer-ansible:latest
#fi
