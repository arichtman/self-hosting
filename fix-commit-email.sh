#!/bin/bash

pip install git-filter-repo

echo "<${SECRET_GIT_USERNAME}> ${SECRET_GIT_FULL_NAME} <${SECRET_OLD_EMAIL}>" > mailmap

git filter-repo --mailmap mailmap --force
git remote add origin https://github.com/arichtman/self-hosting.git
git push --set-upstream origin HEAD --force
git push --set-upstream origin master --force

