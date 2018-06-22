#!/usr/bin/env bash

docker build \
    --build-arg PACKER_VERSION=$PACKER_VERSION  \
    --build-arg ANSIBLE_VERSION=$ANSIBLE_VERSION  \
    -t solutiondrive/docker-aws-packer-ansible:packer$PACKER_VERSION-ansible$ANSIBLE_VERSION-awscli$AWSCLI_VERSION-inspec$INSPEC_VERSION  \
    .

# Tag "latest"
if [ "$LATEST" = "1" ]; then
    docker tag \
        solutiondrive/docker-aws-packer-ansible:packer$PACKER_VERSION-ansible$ANSIBLE_VERSION-awscli$AWSCLI_VERSION-inspec$INSPEC_VERSION \
        solutiondrive/docker-aws-packer-ansible:latest
fi
