#!/bin/bash

SOOS_BASE_URI=$1
SOOS_PROJECT_NAME=$2
SOOS_MODE=$3
SOOS_ON_FAILURE=$4
SOOS_DIRECTORIES_TO_EXCLUDE=$5
SOOS_FILES_TO_EXCLUDE=$6
SOOS_ANALYSIS_RESULT_MAX_WAIT=$7
SOOS_ANALYSIS_RESULT_POLLING_INTERVAL=$8
SOOS_DEBUG_PRINT_VARIABLES=$9

SOOS_BRANCH_URI=${10}
SOOS_BUILD_VERSION=${11}
SOOS_BUILD_URI=${12}
SOOS_OPERATING_ENVIRONMENT=${13}

SOOS_COMMIT_HASH=${GITHUB_SHA}
SOOS_BRANCH_NAME=${GITHUB_REF}
SOOS_INTEGRATION_NAME="GitHubAction"

SOOS_WORKING_DIRECTORY=${GITHUB_WORKSPACE}
SOOS_ROOT_CODE_PATH=${GITHUB_WORKSPACE}

# export SOOS_ROOT_CODE_PATH=${GITHUB_WORKSPACE}
# export SOOS_API_BASE_URI=${SOOS_BASE_URI}
# export SOOS_PROJECT_NAME=${SOOS_PROJECT_NAME}

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
pip install -r requirements.txt

cd ${GITHUB_WORKSPACE}

# Execute SOOS CLI
echo "About to execute soos.py with commit hash ${SOOS_COMMIT_HASH}"

python soos/workspace/soos.py -m="${SOOS_MODE}" -of="${SOOS_ON_FAILURE}" -dte="${SOOS_DIRECTORIES_TO_EXCLUDE}" -fte="${SOOS_FILES_TO_EXCLUDE}" -wd="${SOOS_WORKING_DIRECTORY}" -armw="${SOOS_ANALYSIS_RESULT_MAX_WAIT}" -arpi="${SOOS_ANALYSIS_RESULT_POLLING_INTERVAL}" -buri="${SOOS_BASE_URI}" -scp="${SOOS_ROOT_CODE_PATH}" -pn="${SOOS_PROJECT_NAME}" -ch="${SOOS_COMMIT_HASH}" -bn="${SOOS_BRANCH_NAME}" -bruri="${SOOS_BRANCH_URI}" -bldver="${SOOS_BUILD_VERSION}" -blduri="${SOOS_BUILD_URI}" -oe="${SOOS_OPERATING_ENVIRONMENT}" -intn="${SOOS_INTEGRATION_NAME}"
