#!/bin/bash

source functions.sh
source log-functions.sh
source str-functions.sh
source file-functions.sh
source aws-functions.sh

logInfoMessage "I'll remove all unwanted branches from the [$ORGANISATION] organization's git repository"

mkdir repo && cd repo

curl https://api.github.com/users/$ORGANISATION/repos | grep "clone_url" |sed 's/.*: //'| sed 's/.$//' | sed 's/"//g' > $FILE

sleep $SLEEP_DURATION

if [ -s $FILE ]; then
    for project_name in $(cat $FILE); do
            git init
            git remote add origin $project_name
            git pull origin
                
            echo "____ Start $project_name ____"


    default=$(git remote show origin | grep "HEAD branch" | sed 's/.*: //')

    for branch in $(git branch -r | grep -v $default | sed 's/^\s*//' | sed 's/origin\///'); do
            if [ -z "$(git log -1 --since='$RETENION_TIME' -s origin/$branch)" ]; then
                    echo -e `git show --format="%ci %cr %an" origin/$branch | head -n 1`
                    remote_branch=$(echo $branch | sed 's#origin/##' )

                    git push origin --delete $remote_branch
            fi
    done

    git remote remove origin

    echo "____ End $project_name ____"
    done
    logInfoMessage "Congratulations $ORGANISATION branches deleted successfully!!!"
    generateOutput $ACTIVITY_SUB_TASK_CODE true "Congratulations $ORGANISATION branches deleted successfully!!!"
else
  if [ "$VALIDATION_FAILURE_ACTION" == "FAILURE" ]
  then
    logErrorMessage "Provided Organisation is not found: $ORGANISATION"
    logErrorMessage "Failed to delete git branches for organisation [$ORGANISATION] please check!!!"
    generateOutput $ACTIVITY_SUB_TASK_CODE false "Failed to delete git branches for [$ORGANISATION] please check!!!"
    exit 1
  else
    logErrorMessage "Provided Organisation is not found: $ORGANISATION"
    logWarningMessage "Failed to delete git branches for organisation [$ORGANISATION] please check!!!"
    generateOutput $ACTIVITY_SUB_TASK_CODE true "Failed to delete git branches for organisation [$ORGANISATION] please check!!!"
  fi
fi 

