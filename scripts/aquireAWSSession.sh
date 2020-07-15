#!/bin/bash

set -eo pipefail

PLUGIN_AWS_ACCOUNT_ID=${PLUGIN_AWS_ACCOUNT_ID:-'IAM Role'}

echo "AWS credentials:"
echo "Account ID: ${PLUGIN_AWS_ACCOUNT_ID}"

region=${PLUGIN_AWS_REGION:-'eu-central-1'}

if [ "${PLUGIN_AWS_ACCOUNT_ID}" != "IAM Role" ]; then
    GENERATED_SESSION_ID="${CI_COMMIT_SHA:0:10}-${CI_BUILD_NUMBER}-${CI_JOB_ID}-${CI_CONCURRENT_ID}"
    session_id=${PLUGIN_AWS_SESSION_ID:-"${GENERATED_SESSION_ID:0:64}"}

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

    mkdir -p ~/.aws
    echo "[default]" > ~/.aws/credentials
    echo "aws_access_key_id = $AWS_ACCESS_KEY_ID" >> ~/.aws/credentials
    echo "aws_secret_access_key = $AWS_SECRET_ACCESS_KEY" >> ~/.aws/credentials
    echo "aws_session_token = $AWS_SESSION_TOKEN" >> ~/.aws/credentials
fi
