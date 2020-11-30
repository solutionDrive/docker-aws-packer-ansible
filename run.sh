#!/bin/bash

set -o pipefail

if [ -n "${PLUGIN_SSH_KEY}" ]; then
    echo "Adding SSH Key..."
    mkdir -p ~/.ssh/
    echo -e "$PLUGIN_SSH_KEY" > ~/.ssh/id_rsa
    chmod 0600 ~/.ssh/id_rsa
fi

PLUGIN_AWS_ACCOUNT_ID=${PLUGIN_AWS_ACCOUNT_ID:-'IAM Role'}

echo "AWS credentials:"
echo "Account ID: ${PLUGIN_AWS_ACCOUNT_ID}"

region=${PLUGIN_AWS_REGION:-'eu-central-1'}

if [ "${PLUGIN_AWS_ACCOUNT_ID}" != "IAM Role" ]; then
    #GENERATED_SESSION_ID="${CI_COMMIT_SHA:0:10}-${CI_BUILD_NUMBER}-${CI_JOB_ID}-${CI_CONCURRENT_ID}"
    #session_id=${PLUGIN_AWS_SESSION_ID:-"${GENERATED_SESSION_ID:0:64}"}

    if [ "${PLUGIN_AWS_ROLE}" = "" ]; then
        echo "Required attribute missing: aws_role"
        exit 1
    fi

    echo "Role: ${PLUGIN_AWS_ROLE}"
    echo "IAM Role Session ID: ${session_id}"
    echo "Region: ${region}"

    # @todo fix session role-session-name errors to not have problems with parallelity
    #iam_creds=$(aws sts assume-role --role-arn "arn:aws:iam::${PLUGIN_AWS_ACCOUNT_ID}:role/${PLUGIN_AWS_ROLE}" --role-session-name "docker-${session_id}" --region=${region} | python -m json.tool)
    iam_creds=$(aws sts assume-role --role-arn "arn:aws:iam::${PLUGIN_AWS_ACCOUNT_ID}:role/${PLUGIN_AWS_ROLE}" --region=${region} | python -m json.tool)
    export AWS_ACCESS_KEY_ID=$(echo "${iam_creds}" | grep AccessKeyId | tr -d '" ,' | cut -d ':' -f2)
    export AWS_SECRET_ACCESS_KEY=$(echo "${iam_creds}" | grep SecretAccessKey | tr -d '" ,' | cut -d ':' -f2)
    export AWS_SESSION_TOKEN=$(echo "${iam_creds}" | grep SessionToken | tr -d '" ,' | cut -d ':' -f2)
fi


echo "Packer build starting..."

if [ "${PLUGIN_TARGET}" = "" ]; then
    echo "Required attribute missing: target"
    exit 1
fi

echo "Build target: ${PLUGIN_TARGET}"

if [ -n "${PLUGIN_WORKING_DIRECTORY}" ]; then
    echo "Change to working directory: ${PLUGIN_WORKING_DIRECTORY}"
    cd ${PLUGIN_WORKING_DIRECTORY}
fi

if [ -n "${PLUGIN_ANSIBLE_VAULTPASS_CONTENT}" ]; then
    ANSIBLE_VAULTPASS_PATH=${PLUGIN_ANSIBLE_VAULTPASS_FILEPATH:-'vaultpass'}
    echo "Settings vaultpass content to '${ANSIBLE_VAULTPASS_PATH}'"
    echo $PLUGIN_ANSIBLE_VAULTPASS_CONTENT > "${ANSIBLE_VAULTPASS_PATH}"
fi

if [ -n "${PLUGIN_ANSIBLE_RUN_GALAXY_INSTALL}" ]; then
    ANSIBLE_REQUIREMENTS_PATH=${PLUGIN_ANSIBLE_ANSIBLE_REQUIREMENTS_PATH:-'requirements.yml'}
    echo "Running ansible-galaxy install"
    ansible-galaxy install -r "${ANSIBLE_REQUIREMENTS_PATH}" --ignore-errors
fi

PACKER_ON_ERROR_BEHAVIOR="-on-error="${PLUGIN_ON_ERROR:-'cleanup'}
PACKER_BUILD_LOG_NAME=${PLUGIN_PACKER_BUILD_LOG_NAME:-'build.log'}

packer build "${PACKER_ON_ERROR_BEHAVIOR}" "${PLUGIN_TARGET}" | tee ${PACKER_BUILD_LOG_NAME}
