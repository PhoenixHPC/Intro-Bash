#!/bin/bash
set -e # Exit with non zero exit code if anything fails

# Get the deploy key by using Travis's stored variables to decrypt deploy_key.enc 
chmod 600 deploy_key
eval `ssh-agent -s`
ssh-add deploy_key

SOURCE_BRANCH="master"

# Configure git and clone the repo
git config --global user.email "$COMMIT_AUTHOR_EMAIL"
#git config user.email
git config --global user.name "travis-ci"
#git config user.name

SSH_REPO=${GH_REF/github.com\//git@github.com:}
echo $GH_REF
echo $SSH_REPO

git checkout master
echo "Change to master branch and show status"
git status
#git clone --quiet --branch=gh-pages https://${GH_REF} gh-pages > /dev/null 2>&1
git clone --branch=gh-pages $SSH_REPO gh-pages > /dev/null 2>&1
cd gh-pages
pwd 
ls -al
echo "New directory for gh-pages branch and show status" 
git status
#git clone --quiet --branch=gh-pages $SSH_REPO gh-pages > /dev/null 2>&1

#Using GH_TOKEN
#git clone --quiet --branch=gh-pages https://${GH_TOKEN}@${GH_REF} gh-pages > /dev/null 2>&1

# Only commit on changed commit 
#if git diff --quiet; then 
#   echo "No changes to the output on this push; exiting."
#   exit 0
#fi 

# Commit and Push the Changes
mkdir -p pdfs-latest 
rm -f pdfs-latest/*.pdf
cp -Rf ../*.pdf pdfs-latest/
cd pdfs-latest/ | ls -al | cd ..
git add -f . 
git commit -m "Lastest PDFs on successful travis build $TRAVIS_BUILD_NUMBER auto-pushed to gh-pages"
git status

# Auto push the Change
git push -fq  "${SSH_REPO}" ${TARGET_BRANCH} > /dev/null 2>&1

# Push using Deploy Key 
#git push -fq "https://${DEPLOY_KEY}@${GH_REF}" ${TARGET_BRANCH}  > /dev/null 2>&1
