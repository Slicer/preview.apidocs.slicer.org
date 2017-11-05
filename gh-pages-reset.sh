#!/usr/bin/env bash

set -e
set -o pipefail
set -x

UPDATE_MODE=$TRAVIS_EVENT_TYPE

SCRIPT_NAME=$(basename $0)

case $TRAVIS_EVENT_TYPE in
cron)
  UPDATE_MODE="reset"
  echo "$SCRIPT_NAME: executed from Travis Cron job [UPDATE_MODE defaults to $UPDATE_MODE]"
  ;;
reset)
  echo "$SCRIPT_NAME: executed from Travis API [UPDATE_MODE=$UPDATE_MODE]"
  ;;
merge)
  echo "$SCRIPT_NAME: executed from Travis API [UPDATE_MODE=$UPDATE_MODE]"
  ;;
*)
  echo "$SCRIPT_NAME: skipping because invalid TRAVIS_EVENT_TYPE value. Accepted values are 'cron', 'reset' or 'merge'"
  exit 1
  ;;
esac

if [[ -z $GITHUB_TOKEN ]]; then
  echo "$SCRIPT_NAME: skipping because GITHUB_TOKEN env. variable is not set"
  exit 1
fi

git config user.email "slicerbot@slicer.org"
git config user.name "Slicer Bot"

pushURL=https://$GITHUB_TOKEN@github.com/Slicer/preview.apidocs.slicer.org
git config --add remote.origin.pushURL $pushURL
echo "$SCRIPT_NAME: added 'remote.origin.pushURL' with GITHUB_TOKEN"

SOURCE_BRANCH=gh-pages-reset
TARGET_BRANCH=gh-pages

if [[ $UPDATE_MODE == "reset" ]]; then
  git checkout master
  git fetch origin $SOURCE_BRANCH
  git branch -D $SOURCE_BRANCH || true
  git checkout -b $SOURCE_BRANCH FETCH_HEAD

  git push origin $SOURCE_BRANCH:$TARGET_BRANCH --force
  push_exit_code=$?

elif [[ $UPDATE_MODE == "merge" ]]; then
  git checkout master
  git fetch origin +refs/heads/*:refs/remotes/origin/*
  git checkout -b $TARGET_BRANCH origin/$TARGET_BRANCH
  git merge origin/$SOURCE_BRANCH --log --no-ff

  git push origin $TARGET_BRANCH:$TARGET_BRANCH
  push_exit_code=$?
else
  echo "$SCRIPT_NAME: skipping because invalid UPDATE_MODE [$UPDATE_MODE]"
  exit 1
fi


if [[ ! $push_exit_code -eq 0 ]]; then
  echo "$SCRIPT_NAME: skipping because push command failed"
  exit $push_exit_code
fi

echo "$SCRIPT_NAME: $TARGET_BRANCH successfully $UPDATE_MODE"
