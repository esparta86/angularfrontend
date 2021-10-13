#!/bin/bash

echo $GCLOUD_SERVICE_KEY > gcloud-service-key.json

gcloud auth activate-service-account --key-file=gcloud-service-key.json
gcloud --quiet config set project ${GOOGLE_PROJECT_ID}