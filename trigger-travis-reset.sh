#!/usr/bin/env bash

set -e
set -o pipefail

if [[ -z $GITHUB_TOKEN ]]; then
  echo "travis-trigger-reset: skipping because GITHUB_TOKEN env. variable is not set"
  exit 1
fi

# Login to TravisCI
travis-cli login --org --no-interactive --github-token $GITHUB_TOKEN

# Get a Travis token
TRAVIS_TOKEN=$(echo $(travis-cli token --org --no-interactive) | tr -d '[:space:]')

body='{
  "request": {
    "config": {
      "env": {"TRAVIS_EVENT_TYPE": "cron"
      }
    }
  }
}'

TRAVIS_REPO="Slicer%2Fpreview.apidocs.slicer.org"

curl -s -X POST \
   -H "Content-Type: application/json" \
   -H "Accept: application/json" \
   -H "Travis-API-Version: 3" \
   -H "Authorization: token ${TRAVIS_TOKEN}" \
   -d "$body" \
   "https://api.travis-ci.org/repo/${TRAVIS_REPO}/requests"
