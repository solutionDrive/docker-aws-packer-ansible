ARG PACKER_VERSION

FROM hashicorp/packer:${PACKER_VERSION}

ARG PACKER_VERSION
ARG ANSIBLE_VERSION
ARG AWSCLI_VERSION
ARG INSPEC_VERSION

RUN apk update && \
    apk upgrade && \
    apk --no-cache add python2 py-pip py-setuptools ca-certificates ruby ruby-rdoc ruby-irb openssh-client && \
    apk --no-cache add --virtual .sd-build-dependencies gcc libffi-dev openssl-dev build-base ruby-dev python2-dev linux-headers musl-dev && \
    pip install awscli==${AWSCLI_VERSION} && \
    gem install inspec -v ${INSPEC_VERSION} && \
    pip install ansible==${ANSIBLE_VERSION} && \
    apk --no-cache del .sd-build-dependencies

ADD keyscan.sh /bin/keyscan.sh
RUN chmod +x /bin/keyscan.sh && \
    sync && \
    /bin/keyscan.sh github.com nThbg6kXUpJWGl7E1IGOCspRomTxdCARLviKw6E5SY8 && \
    /bin/keyscan.sh bitbucket.org zzXQOXSRBEiUtuE8AikJYKwbHaxvSc0ojez9YXaGp1A

ADD run.sh /bin/run.sh

ENTRYPOINT ["/bin/bash", "/bin/run.sh"]
