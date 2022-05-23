#!/bin/bash

SOOS_CLIENT_ID=$1
SOOS_API_KEY=$2
SOOS_BASE_URI=$3
SOOS_PROJECT_NAME=$4
SOOS_MODE=$5
SOOS_ON_FAILURE=$6
SOOS_DIRECTORIES_TO_EXCLUDE=$7
SOOS_FILES_TO_EXCLUDE=$8
SOOS_ANALYSIS_RESULT_MAX_WAIT=$9
SOOS_ANALYSIS_RESULT_POLLING_INTERVAL=${10}
SOOS_DEBUG_PRINT_VARIABLES=${11}

SOOS_BRANCH_URI=${12}
SOOS_BUILD_VERSION=${13}
SOOS_BUILD_URI=${14}
SOOS_OPERATING_ENVIRONMENT=${15}

SOOS_COMMIT_HASH=${GITHUB_SHA}
SOOS_BRANCH_NAME=${GITHUB_REF}
SOOS_INTEGRATION_NAME="Github Action"
SOOS_GENERATE_SARIF_REPORT=${16}
SOOS_GITHUB_PAT=${17}

SOOS_WORKING_DIRECTORY=${GITHUB_WORKSPACE}
SOOS_ROOT_CODE_PATH=${GITHUB_WORKSPACE}

echo 'Starting entrypoint.sh'

if $SOOS_DEBUG_PRINT_VARIABLES ; then
  echo "BEGIN DEBUG :: EXPLICIT ENV/VAR *****************************"
  echo "GITHUB_WORKSPACE: ${GITHUB_WORKSPACE}"
  echo "SOOS_MODE: ${SOOS_MODE}"
  echo "SOOS_ON_FAILURE: ${SOOS_ON_FAILURE}"
  echo "SOOS_DIRECTORIES_TO_EXCLUDE: ${SOOS_DIRECTORIES_TO_EXCLUDE}"
  echo "SOOS_FILES_TO_EXCLUDE: ${SOOS_FILES_TO_EXCLUDE}"
  echo "SOOS_WORKING_DIRECTORY: ${SOOS_WORKING_DIRECTORY}"
  echo "SOOS_ANALYSIS_RESULT_MAX_WAIT: ${SOOS_ANALYSIS_RESULT_MAX_WAIT}"
  echo "SOOS_ANALYSIS_RESULT_POLLING_INTERVAL: ${SOOS_ANALYSIS_RESULT_POLLING_INTERVAL}"
  echo "SOOS_ROOT_CODE_PATH: ${SOOS_ROOT_CODE_PATH}"
  
  echo "SOOS_COMMIT_HASH: ${SOOS_COMMIT_HASH}"
  echo "SOOS_BRANCH_NAME: ${SOOS_BRANCH_NAME}"
  echo "SOOS_BRANCH_URI: ${SOOS_BRANCH_URI}"
  echo "SOOS_BUILD_VERSION: ${SOOS_BUILD_VERSION}"
  echo "SOOS_BUILD_URI: ${SOOS_BUILD_URI}"
  echo "SOOS_OPERATING_ENVIRONMENT: ${SOOS_OPERATING_ENVIRONMENT}"
  echo "SOOS_INTEGRATION_NAME: ${SOOS_INTEGRATION_NAME}"
  echo "SOOS_GENERATE_SARIF_REPORT: ${SOOS_GENERATE_SARIF_REPORT}"
  echo "SOOS_GITHUB_PAT: ${SOOS_GITHUB_PAT}"

  echo "END DEBUG :: EXPLICIT ENV/VAR *****************************"

  # DEBUG PRINT ALL ENV
  echo "BEGIN DEBUG :: ECHO ALL ENV/VAR *****************************"
  env
  echo "END DEBUG :: ECHO ALL ENV/VAR *****************************"
fi


# RESET HOME FOLDER
HOME=${GITHUB_WORKSPACE}

# Start off within the workspace
cd ${GITHUB_WORKSPACE}

# Create virtual environment to install requirements
virtualenv -p python .

# Create SOOS Working directory beneath the user's checkout-root folder
mkdir -p ${GITHUB_WORKSPACE}/soos/workspace

source bin/activate

# Get SOOS CLI
cd ${GITHUB_WORKSPACE}/soos/workspace
curl -s https://api.github.com/repos/soos-io/soos-ci-analysis-python/releases/latest | grep "browser_download_url" | cut -d '"' -f 4 | xargs -n 1 curl -LO
sha256sum -c soos.sha256
sha256sum -c requirements.sha256

# Install SOOS Requirements
pip3 install -r requirements.txt

cd ${GITHUB_WORKSPACE}

# Execute SOOS CLI
echo "About to execute soos.py with commit hash ${SOOS_COMMIT_HASH}"

PARAMS=""

if [ "${SOOS_GENERATE_SARIF_REPORT}" = 'true' ]
  then
    PARAMS="-sarif=True -gpat=${SOOS_GITHUB_PAT}"
fi


python3 soos/workspace/soos.py -m="${SOOS_MODE}" -of=${SOOS_ON_FAILURE} -dte="${SOOS_DIRECTORIES_TO_EXCLUDE}" -fte="${SOOS_FILES_TO_EXCLUDE}" -wd="${SOOS_WORKING_DIRECTORY}" -armw="${SOOS_ANALYSIS_RESULT_MAX_WAIT}" -arpi="${SOOS_ANALYSIS_RESULT_POLLING_INTERVAL}" -buri="${SOOS_BASE_URI}" -scp="${SOOS_ROOT_CODE_PATH}" -pn="${SOOS_PROJECT_NAME}" -ch="${SOOS_COMMIT_HASH}" -bn="${SOOS_BRANCH_NAME}" -bruri="${SOOS_BRANCH_URI}" -bldver="${SOOS_BUILD_VERSION}" -blduri="${SOOS_BUILD_URI}" -oe="${SOOS_OPERATING_ENVIRONMENT}" -akey="${SOOS_API_KEY}" -cid="${SOOS_CLIENT_ID}" -intn="${SOOS_INTEGRATION_NAME}" ${PARAMS}
