#!/bin/bash

echo grep -F SNAPSHOT gradle.properties: `grep -F SNAPSHOT gradle.properties` 
echo "TRAVIS_REPO_SLUG: $TRAVIS_REPO_SLUG" 
echo "TRAVIS_PULL_REQUEST: $TRAVIS_PULL_REQUEST"
echo "TRAVIS_BRANCH: $TRAVIS_BRANCH"

# no SNAPSHOT versions, only relase tags/branches, no forks, no pull requests
if ! grep -Fq SNAPSHOT gradle.properties && [[ "$TRAVIS_BRANCH" =~ [0-9]+\.[0-9]+\.[0-9]+ ]] && [ "$TRAVIS_REPO_SLUG" == "axe-felix/travis-publish-tags" ] && [ "$TRAVIS_PULL_REQUEST" == "false" ]; then
  gradle publish  
  cp -R build/repo $HOME/repo
  cd $HOME
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "travis-ci"
  # pssh! don't tell the secret!
  git clone --quiet https://${GH_TOKEN}@github.com/axe-felix/travis-test-mvn-repo > /dev/null
  cd travis-test-mvn-repo
  cp -R $HOME/repo .
  git add .
  git commit -m 'release'
  git push -fq origin master > /dev/null  
fi