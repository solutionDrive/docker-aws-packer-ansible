ARG PACKER_VERSION=1.2.1
ARG ANSIBLE_VERSION=2.3.0.0

FROM hashicorp/packer:${PACKER_VERSION}

ARG PACKER_VERSION
ARG ANSIBLE_VERSION_CONSTRAINT

RUN apk update && \
    apk upgrade && \
    apk --no-cache add "ansible${ANSIBLE_VERSION}" py-pip py-setuptools ca-certificates ruby ruby-rdoc ruby-irb openssh-client && \
    apk --no-cache add --virtual .build-dependencies build-base ruby-dev && \
    pip install awscli && \
    gem install inspec && \
    apk --no-cache del .build-dependencies

ADD keyscan.sh /bin/keyscan.sh
RUN chmod +x /bin/keyscan.sh && \
    sync && \
    /bin/keyscan.sh github.com nThbg6kXUpJWGl7E1IGOCspRomTxdCARLviKw6E5SY8 && \
    /bin/keyscan.sh bitbucket.org zzXQOXSRBEiUtuE8AikJYKwbHaxvSc0ojez9YXaGp1A

ADD run.sh /bin/run.sh

ENTRYPOINT ["/bin/bash", "/bin/run.sh"]
