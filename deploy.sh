#!/bin/bash

set -o errexit

readonly AWS_PROFILE=$1
readonly AWS_BUCKET="s3://documentation.hioperator.com"
readonly BUILD_DIR="./build"

usage() {
cat << EOF
usage for $0
===================

./deploy.sh "AWS PROFILE GOES HERE"
EOF
    exit 1
}

main() {
    if [ "$1" -lt 1 ]; then
        usage
    fi
    # check if build dir exists
    if [ -d "${BUILD_DIR}" ]; then
        # remove if it does
        echo "removing old build dir..."
        rm -r "${BUILD_DIR}"
    fi
    # check if user has yarn
    if [ -z `which yarn` ]; then
        # if not use npm to build the documentation
        npm run build
    fi
    yarn run build
    aws --profile "${AWS_PROFILE}" s3 sync "${BUILD_DIR}/." "${AWS_BUCKET}"
    exit 0
}
main $#