FROM ubuntu:18.04
RUN apt update 
RUN apt install curl -y && apt install git -y && apt install jq -y
COPY all.sh .
COPY public.sh .
COPY private.sh .
COPY build.sh .
RUN chmod +x all.sh private.sh public.sh build.sh
COPY BP-BASE-SHELL-STEPS .
ENV ACTIVITY_SUB_TASK_CODE BP-GIT-REPO-DELETE-BRANCHS-TASK
ENV SLEEP_DURATION 10s
ENV VALIDATION_FAILURE_ACTION WARNING
ENV REPO ""
ENV FILE ""
ENV ORGANISATION ""
ENV RETENTION_TIME ""
ENV GIT_TOKEN ""


ENTRYPOINT [ "./build.sh" ]
