#!/bin/bash

set -o errexit
set -o nounset

readonly AWS_PROFILE=$1
readonly AWS_BUCKET="s3://documentation.hioperator.com"
readonly BUILD_DIR="./build"

if [ -d "${BUILD_DIR}" ]; then
    rm -r "${BUILD_DIR}"
fi
# check if user has yarn
# if not use npm to build the documentation
if [ -z `which yarn` ]; then
    npm run build
fi
yarn run build
aws --profile "${AWS_PROFILE}" s3 sync "${BUILD_DIR}/." "${AWS_BUCKET}"
