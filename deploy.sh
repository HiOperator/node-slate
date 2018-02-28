#!/bin/bash

set -o errexit
set -o nounset

readonly AWS_PROFILE=$1
readonly AWS_BUCKET="s3://documentation.hioperator.com"
# check if user has yarn
# if not use npm to build the documentation
if [ -z `which yarn` ]; do
    npm run build
fi
yarn run build
cd ./build
aws --profile "${AWS_PROFILE}" s3 sync "${AWS_BUCKET}"