#!/bin/bash

# Source configuration
CUR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)"
source "${CUR_DIR}/go_build_config.sh"

# Where community-operators sources are located
CO_PATH=~/dev/community-operators/operators/clickhouse/

# Ask to prepare copy of required files
echo "Please ensure new clickhouse folder in operatorhub repo is available :"
echo "${CO_PATH}"
read -n 1 -r -s -p $'Press enter to continue...\n'

if [[ ! -d "${CO_PATH}" ]]; then
    echo "No ${CO_PATH} available! Abort."
    exit 1
fi

if [[ -z "${PREVIOUS_VERSION}" ]]; then
    echo "PREVIOUS_VERSION is empty"
    echo "Trying to figure out PREVIOUS_VERSION from releases"
    PREVIOUS_VERSION=$(cat "${SRC_ROOT}/releases" | head -n1)
    echo "Found the following PREVIOUS_VERSION=$PREVIOUS_VERSION"
else
    echo "PREVIOUS_VERSION=${PREVIOUS_VERSION}"
    echo "PREVIOUS_VERSION explicitly specified, continue"
fi

if [[ -z "${PREVIOUS_VERSION}" ]]; then
    echo "Please specify PREVIOUS_VERSION earlier published on operatorhub, like"
    echo "PREVIOUS_VERSION=0.18.1"
    exit 1
else
    echo "Going to use"
    echo "PREVIOUS_VERSION=${PREVIOUS_VERSION}"
fi

echo "Please, verify correctness of specified previous version"
read -n 1 -r -s -p $'Press enter to continue...\n'

PREVIOUS_VERSION="${PREVIOUS_VERSION}" ${SRC_ROOT}/deploy/builder/operatorhub.sh

cp -r "${SRC_ROOT}/deploy/operatorhub/${VERSION}" "${CO_PATH}"
cp -r "${SRC_ROOT}/deploy/operatorhub/clickhouse.package.yaml" "${CO_PATH}"

echo "DONE"

# git remote add upstream https://github.com/k8s-operatorhub/community-operators
# git pull --rebase upstream main
# git rebase --skip  (if the conflicts are not true, skip the patches)
# git push --force-with-lease origin main