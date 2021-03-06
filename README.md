docker-packer-ansible
=====================

Docker container with packer and ansible to build machine images using packer and ansible


Example
-------

Usage with drone:

    pipeline:
      build:
        image: solutiondrive/docker-aws-packer-ansible
        target: base.json
        ssh_key: "this is a private ssh key"                    # optional (content of private ssh key => should be added as secret)
        working_directory: /opt/dir                             # optional
        aws_account_id: 123456789                               # optional (default: use IAM Role)
        aws_role: role name                                     # optional
        aws_region: eu-central-1                                # optional
        aws_session_id: sid                                     # optional
        ansible_vaultpass_content: secret                       # optional
        ansible_vaultpass_filepath: path/to/vaultpass           # optional (default: vaultpass)
        ansible_run_galaxy_install: true                        # optional
        ansible_ansible_requirements_path: path/to/requirements # optional (default: requirements)
        packer_build_log_name: fancy-build.log                  # optional (default: build.log)
        on_error                                                # optional (default: cleanup, valid values=ask|abort|cleanup) 


If you want to use the container without drone, you have to inject the environment variables manually as:

    docker run -e PLUGIN_TARGET=target.json -e PLUGIN_AWS_ROLE=rolename   (...)
