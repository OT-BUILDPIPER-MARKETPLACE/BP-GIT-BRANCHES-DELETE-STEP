#!/bin/bash

source functions.sh
source log-functions.sh

case $REPO_TYPE in

  PRIVATE)
    ./private.sh
    ;;
  PUBLIC)
    ./public.sh
    ;;
  ALL)
    ./all.sh
    ;;
  *)
    logWarningMessage "Please mention the correct repository type !!!"
    logWarningMessage "usage: 
                       - ALL: For both (public and private) repository
                       - PUBLIC: For public repository 
                       - PRIVATE: For private repository"
    generateOutput ${ACTIVITY_SUB_TASK_CODE} true "Please mention the correct repository type!!!"
    ;;
esac

