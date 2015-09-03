#!/bin/bash -e

function install_requirements() {
    pip install wheel==0.24.0
    pip install s3cmd==1.5.2
}

function download_wheels() {
    # NEED TO ADD SOFTLAYER AND VSPHERE HERE!
    pip wheel --wheel-dir packaging/source/wheels --requirement "https://raw.githubusercontent.com/codilime/cloudify-agent/snapshots-master/dev-requirements.txt"
    pip wheel --find-links packaging/source/wheels --wheel-dir packaging/source/wheels "https://github.com/codilime/cloudify-agent/archive/snapshots-master.zip"
}

function download_resources() {
    mkdir -p packaging/source/{pip,python,virtualenv}
    pushd packaging/source/pip
    curl -O https://dl.dropboxusercontent.com/u/407576/cfy-win-cli-package-resources/pip/get-pip.py
    curl -O https://dl.dropboxusercontent.com/u/407576/cfy-win-cli-package-resources/pip/pip-6.1.1-py2.py3-none-any.whl
    curl -O https://dl.dropboxusercontent.com/u/407576/cfy-win-cli-package-resources/pip/setuptools-15.2-py2.py3-none-any.whl
    popd
    pushd packaging/source/python
    curl -O https://dl.dropboxusercontent.com/u/407576/cfy-win-cli-package-resources/python/python.msi
    popd
    pushd packaging/source/virtualenv
    curl -O https://dl.dropboxusercontent.com/u/407576/cfy-win-cli-package-resources/virtualenv/virtualenv-12.1.1-py2.py3-none-any.whl
    popd
}

function upload_to_s3() {
    ###
    # This will upload both the artifact and md5 files to the relevant bucket.
    # Note that the bucket path is also appended the version.
    ###
    # no preserve is set to false only because preserving file attributes is not yet supported on Windows.
    python c:/Python27/Scripts/s3cmd put --force --acl-public --access_key=${AWS_ACCESS_KEY_ID} --secret_key=${AWS_ACCESS_KEY} \
        --no-preserve --progress --human-readable-sizes --check-md5 *.exe* s3://${AWS_S3_BUCKET_PATH}/
}


# VERSION/PRERELEASE/BUILD must be exported as they is being read as an env var by the install wizard
export VERSION="3.3.0"
export PRERELEASE="m4"
export BUILD="274"
CORE_TAG_NAME="3.3m4"
PLUGINS_TAG_NAME="1.3m4"

AWS_ACCESS_KEY_ID=$1
AWS_ACCESS_KEY=$2
AWS_S3_BUCKET_PATH="gigaspaces-repository-eu/org/cloudify3/${VERSION}/${PRERELEASE}-RELEASE"

echo "VERSION: ${VERSION}"
echo "PRERELEASE: ${PRERELEASE}"
echo "BUILD: ${BUILD}"
echo "CORE_TAG_NAME: ${CORE_TAG_NAME}"
echo "PLUGINS_TAG_NAME: ${PLUGINS_TAG_NAME}"
echo "AWS_ACCESS_KEY_ID: ${AWS_ACCESS_KEY_ID}"
echo "AWS_ACCESS_KEY: ${AWS_ACCESS_KEY}"
echo "AWS_S3_BUCKET_PATH: ${AWS_S3_BUCKET_PATH}"


install_requirements &&
download_wheels &&
download_resources &&
iscc packaging/create_install_wizard.iss &&
cd /home/Administrator/packaging/output/ && md5sum=$(md5sum -t *.exe) && echo $md5sum > ${md5sum##* }.md5 &&
[ -z ${AWS_ACCESS_KEY} ] || upload_to_s3
