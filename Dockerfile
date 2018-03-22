FROM hashicorp/packer:1.2.1

RUN apk update && \
    apk upgrade && \
    apk add "ansible<2.4" py-pip py-setuptools ca-certificates && \
    pip install awscli && \
    rm -rf /var/cache/apk/*

ADD run.sh /bin/run.sh

ENTRYPOINT ["/bin/bash", "/bin/run.sh"]
