# BP-GIT-BRANCHES-REMOVE-STEP

This step will help you delete unwanted git branches of the organisation/user.

## Setup
* Clone the code available at [BP-GIT-BRANCHES-REMOVE-STEP](https://github.com/OT-BUILDPIPER-MARKETPLACE/BP-GIT-BRANCHES-REMOVE-STEP.git)
* Build the docker image
```
git submodule init
git submodule update
docker build -t ot/git-branches-remove:0.1 .