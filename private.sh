#!/bin/bash

source functions.sh
source log-functions.sh
source str-functions.sh
source file-functions.sh
source aws-functions.sh

logInfoMessage "I'll remove all unwanted branches from the [$ORGANISATION] organization's git repository"

$FILE="repos"

sleep $SLEEP_DURATION

mkdir repo && cd repo
git init

curl -u $ORGANISATION:$GIT_TOKEN https://api.github.com/user/repos?visibility=private | jq -r '.[].clone_url' | grep $ORGANISATION | sed 's,^https://,,g' > $FILE

if [ -s $FILE ]; then
    for project_name in $(cat $FILE); do

            git remote add origin https://$ORGANISATION:$GIT_TOKEN@$project_name
            git pull origin
                
            echo "____ Start https://$project_name ____"


    default=$(git remote show origin | grep "HEAD branch" | sed 's/.*: //')

    for branch in $(git branch -r | grep -v $default | sed 's/^\s*//' | sed 's/origin\///'); do
            
            LAST_COMMIT_DATE=$(git log -1 --since="$RETENTION_TIME" -s origin/$branch)
            if [ -z "$(echo $LAST_COMMIT_DATE)" ]; then
                    echo -e `git show --format="%ci %cr %an" origin/$branch | head -n 1`
                    remote_branch=$(echo $branch | sed 's#origin/##' )

                    git push origin --delete $remote_branch
            fi
    done

    git remote remove origin

    echo "____ End https://$project_name ____"

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

