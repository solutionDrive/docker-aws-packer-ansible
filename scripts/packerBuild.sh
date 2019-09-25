#!/bin/bash

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
