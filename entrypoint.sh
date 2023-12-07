#!/bin/bash

SOOS_APP_VERSION=${GITHUB_ACTION_REF}
SOOS_INTEGRATION_NAME="GitHub"
SOOS_INTEGRATION_TYPE="Plugin"

SOOS_WORKING_DIRECTORY=${GITHUB_WORKSPACE}
SOOS_ROOT_CODE_PATH=${GITHUB_WORKSPACE}

SOOS_BRANCH_NAME=${SOOS_BRANCH_NAME:-${GITHUB_REF}}

PARAMS=(
    "--apiKey" "${SOOS_API_KEY}"
    "--apiURL" "${SOOS_API_URL}"
    "--appVersion" "${SOOS_APP_VERSION}"
    "--branchName" "${SOOS_BRANCH_NAME}"
    "--branchURI" "${SOOS_BRANCH_URI}"
    ${SOOS_BUILD_URI:+--buildURI ${SOOS_BUILD_URI}}
    ${SOOS_BUILD_VERSION:+--buildVersion ${SOOS_BUILD_VERSION}}
    "--clientId" "${SOOS_CLIENT_ID}"
    "--commitHash" "${GITHUB_SHA}"
    "--directoriesToExclude" "${SOOS_DIRECTORIES_TO_EXCLUDE}"
    "--filesToExclude" "${SOOS_FILES_TO_EXCLUDE}"
    "--integrationName" "${SOOS_INTEGRATION_NAME}"
    "--integrationType" "${SOOS_INTEGRATION_TYPE}"
    ${SOOS_LOG_LEVEL:+--logLevel ${SOOS_LOG_LEVEL}}
    "--onFailure" "${SOOS_ON_FAILURE}"
    "--operatingEnvironment" "${SOOS_OPERATING_ENVIRONMENT}"
    ${SOOS_OUTPUT_FORMAT:+--outputFormat ${SOOS_OUTPUT_FORMAT}}
    ${SOOS_PACKAGE_MANAGERS:+--packageManagers ${SOOS_PACKAGE_MANAGERS}}    
    "--projectName" "${SOOS_PROJECT_NAME}"
    "--sourceCodePath" "${GITHUB_WORKSPACE}"
    "--workingDirectory" "${GITHUB_WORKSPACE}"
)

[ "$SOOS_VERBOSE" == "true" ] && PARAMS+=("--verbose")

soos-sca "${PARAMS[@]}"