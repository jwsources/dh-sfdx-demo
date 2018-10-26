#!/bin/bash

# Default values
BRANCH=$1
SFDX_CLI_EXEC=sfdx
TARGET_ORG='dhpack'
PACKAGE_NAME='packagedemo01'
RESULT=0

# Defining Salesforce CLI exec, depending if it's CI or local dev machine
if [ $CI ]; then
  echo "Script is running on CI"
  SFDX_CLI_EXEC=node_modules/sfdx-cli/bin/run
  TARGET_ORG="packagingorg"
fi

echo "Creating new Package version"
PACKAGE_VERSION="$($SFDX_CLI_EXEC force:package:version:create -p $PACKAGE_NAME -x -d force-app -w 20 --json)"
RESULT="$(echo $PACKAGE_VERSION | jq '.status')"
echo "Result is $RESULT"

if [ -z $RESULT ]; then
  exit 1
fi

if [ $RESULT -gt 0 ]; then
  echo $PACKAGE_VERSION
  exit 1
else
  sleep 240
fi

PACKAGE_VERSION="$(echo $PACKAGE_VERSION | jq '.result.SubscriberPackageVersionId' | tr -d '"')"

echo "Installing new Package version"
$SFDX_CLI_EXEC force:package:install --package $PACKAGE_VERSION -w 10 -u $TARGET_ORG -r
echo "Done"
sfdx force:org:open -p /lightning/page/home
