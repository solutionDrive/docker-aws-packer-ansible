docker-packer-ansible
=====================

Docker container with:
- awscli
- packer
- ansible
- inspec

To build machine images in aws with packer and ansible checked by inspec

Example
-------

Usage with drone:

    pipeline:
      build:
        image: solutiondrive/docker-aws-packer-ansible
        target: base.json                                           # required for packer build
        ssh_key: "this is a private ssh key"                        # optional (content of private ssh key => should be added as secret)
        working_directory: /opt/dir                                 # optional
        aws_account_id: 123456789                                   # optional (default: use IAM Role)
        aws_role: role name                                         # optional
        aws_region: eu-central-1                                    # optional (default: eu-central-1)
        aws_session_id: sid                                         # optional (default: different CI variables)
        ansible_vaultpass_content: secret                           # optional
        ansible_vaultpass_filepath: path/to/vaultpass               # optional (default: vaultpass)
        ansible_run_galaxy_install: true                            # optional
        ansible_ansible_requirements_path: path/to/requirements.yml # optional (default: requirements.yml)
        packer_build_log_name: fancy-build.log                      # optional (default: build.log)
        on_error: cleanup                                           # optional (default: cleanup, valid values=ask|abort|cleanup)
      commands:
        - /bin/run.sh
        
Usage with gitlab:

    build:
      variables:
        PLUGIN_TARGET: "base.json"
        PLUGIN_SSH_KEY: "this is a private ssh key"                             # optional (content of private ssh key => should be added as secret)
        PLUGIN_WORKING_DIRECTORY: "${CI_PROJECT_DIR}"                           # optional
        PLUGIN_AWS_ACCOUNT_ID: "123456789"                                      # optional (default: use IAM Role)
        PLUGIN_AWS_ROLE: "Role Name"                                            # optional
        PLUGIN_AWS_REGION: "eu-central-1"                                       # optional (default: eu-central-1)
        PLUGIN_AWS_SESSION_ID: "SID"                                            # optional (default: different CI variables)
        PLUGIN_ANSIBLE_VAULTPASS_CONTENT: "secret"                              # optional
        PLUGIN_ANSIBLE_VAULTPASS_FILEPATH: "path/to/vaultpass"                  # optional (default: vaultpass)
        PLUGIN_ANSIBLE_RUN_GALAXY_INSTALL: "true"                               # optional
        PLUGIN_ANSIBLE_ANSIBLE_REQUIREMENTS_PATH: "path/to/requirements.yml"    # optional (default: requirements.yml)
        PLUGIN_PACKER_BUILD_LOG_NAME: "fancy-base.log"                          # optional (default: build.log)
        PLUGIN_ON_ERROR: "abort"                                                # optional (default: cleanup, valid values=ask|abort|cleanup)
      image: solutiondrive/docker-aws-packer-ansible
      stage: build
      script:
        - /bin/run.sh

If you want to use the container without drone, you have to inject the environment variables manually as:

    docker run -e PLUGIN_TARGET=target.json -e PLUGIN_AWS_ROLE=rolename   (...) /bin/run.sh
