#!/bin/bash

PLUGIN_AWS_ACCOUNT_ID=${PLUGIN_AWS_ACCOUNT_ID:-'IAM Role'}

echo "AWS credentials:"
echo "Account ID: ${PLUGIN_AWS_ACCOUNT_ID}"

region=${PLUGIN_AWS_REGION:-'eu-central-1'}

if [ "${PLUGIN_AWS_ACCOUNT_ID}" != "IAM Role" ]; then
    session_id=${PLUGIN_AWS_SESSION_ID:-"${DRONE_COMMIT_SHA:0:10}-${DRONE_BUILD_NUMBER}"}

    if [ "${PLUGIN_AWS_ROLE}" = "" ]; then
        echo "Required attribute missing: aws_role"
        exit 1
    fi

    echo "Role: ${PLUGIN_AWS_ROLE}"
    echo "IAM Role Session ID: ${session_id}"
    echo "Region: ${region}"

    iam_creds=$(aws sts assume-role --role-arn "arn:aws:iam::${PLUGIN_AWS_ACCOUNT_ID}:role/${PLUGIN_AWS_ROLE}" --role-session-name "docker-${session_id}" --region=${region} | python -m json.tool)
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

if [ -n "${PLUGIN_VAULTPASS_CONTENT}" ]; then
    VAULTPASS_PATH=${PLUGIN_VAULTPASS_FILEPATH:-'vaultpass'}
    echo "Settings vaultpass content to '${VAULTPASS_PATH}'"
    echo $PLUGIN_VAULTPASS_CONTENT > "${VAULTPASS_PATH}"
fi

if [ -n "${PLUGIN_RUN_ANSIBLE_GALAXY_INSTALL" ]; then
    REQUIREMENTS_PATH=${PLUGIN_REQUIREMENTS_PATH:-'requirements.yml'}
    echo "Running ansible-galaxy install"
    ansible-galaxy -r "${REQUIREMENTS_PATH}"
fi

packer build "${PLUGIN_TARGET}"
