#!/usr/bin/env bash

if [ -z "$KUBEVIRTCI_PATH" ]; then
    KUBEVIRTCI_PATH="$(
        cd "$(dirname "$BASH_SOURCE[0]")/../"
        echo "$(pwd)/"
    )"
fi


if [ -z "$KUBEVIRTCI_CONFIG_PATH" ]; then
    KUBEVIRTCI_CONFIG_PATH="$(
        cd "$(dirname "$BASH_SOURCE[0]")/../../"
        echo "$(pwd)/_ci-configs"
    )"
fi


KUBEVIRTCI_CLUSTER_PATH=${KUBEVIRTCI_CLUSTER_PATH:-${KUBEVIRTCI_PATH}/cluster}
KUBEVIRT_PROVIDER=${KUBEVIRT_PROVIDER:-k8s-1.19}
KUBEVIRT_NUM_NODES=${KUBEVIRT_NUM_NODES:-1}
KUBEVIRT_MEMORY_SIZE=${KUBEVIRT_MEMORY_SIZE:-5120M}
KUBEVIRT_NUM_SECONDARY_NICS=${KUBEVIRT_NUM_SECONDARY_NICS:-0}
KUBEVIRT_DEPLOY_ISTIO=${KUBEVIRT_DEPLOY_ISTIO:-false}
KUBEVIRT_VERSION=${KUBEVIRT_VERSION:-v0.44.0}
CDI_VERSION=${CDI_VERSION:-v1.37.1}
KUBEVIRT_DEPLOYMENT_TIMEOUT=${KUBEVIRT_DEPLOYMENT_TIMEOUT:-480}

# If on a developer setup, expose ocp on 8443, so that the openshift web console can be used (the port is important because of auth redirects)
# http and https ports are accessed by testing framework and should not be randomized
if [ -z "${JOB_NAME}" ]; then
    KUBEVIRT_PROVIDER_EXTRA_ARGS="${KUBEVIRT_PROVIDER_EXTRA_ARGS} --ocp-port 8443"
fi

#If run on jenkins, let us create isolated environments based on the job and
# the executor number
provider_prefix=${JOB_NAME:-${KUBEVIRT_PROVIDER}}${EXECUTOR_NUMBER}
job_prefix=${JOB_NAME:-kubevirt}${EXECUTOR_NUMBER}

mkdir -p $KUBEVIRTCI_CONFIG_PATH/$KUBEVIRT_PROVIDER
KUBEVIRTCI_TAG=2103240101-142f745
