#!/bin/bash

echo $GCLOUD_SERVICE_KEY > ${HOME}/gcloud-service-key.json
cat ${HOME}/gcloud-service-key.json
echo $GCLOUD_SERVICE_KEY
gcloud auth activate-service-account --key-file=${HOME}/gcloud-service-key.json
gcloud --quiet config set project ${GOOGLE_PROJECT_ID}