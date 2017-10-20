#!/usr/bin/env bash

set -e
set -o pipefail

if [[ $TRAVIS_EVENT_TYPE != "cron" ]]; then
  echo "gh-pages-reset: skipping because TRAVIS_EVENT_TYPE env. variable is not set to 'cron'"
  exit 1
fi

if [[ -z $GITHUB_TOKEN ]]; then
  echo "gh-pages-reset: skipping because GITHUB_TOKEN env. variable is not set"
  exit 1
fi

pushURL=https://$GITHUB_TOKEN@github.com/Slicer/preview.apidocs.slicer.org
git config --add remote.origin.pushURL $pushURL
echo "gh-pages-reset: added 'remote.origin.pushURL' with GITHUB_TOKEN"

SOURCE_BRANCH=gh-pages-reset
TARGET_BRANCH=gh-pages

git checkout master
git fetch origin $SOURCE_BRANCH
git branch -D $SOURCE_BRANCH > /dev/null 2>&1
git checkout -b $SOURCE_BRANCH origin/$SOURCE_BRANCH

git push origin $SOURCE_BRANCH:$TARGET_BRANCH --force > /dev/null 2>&1
push_exit_code=$?
if [[ ! $push_exit_code -eq 0 ]]; then
  echo "gh-pages-reset: skipping because command 'git push origin $SOURCE_BRANCH:$TARGET_BRANCH --force' failed"
  exit $push_exit_code
fi

echo "gh-pages-reset: $TARGET_BRANCH successfully reset"
