# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    https://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

# Use the official lightweight Node.js 10 image.
# https://hub.docker.com/_/node

#gcloud builds submit -t gcr.io/ti-is-devenv-01/is-rendered:v1 --gcs-log-dir=gs://ti-is-devenv-01_cloudbuild_custom_logs_cicd/logs/ .
#gcloud builds submit -t gcr.io/ti-is-devenv-01/is-rendered:v3 --gcs-log-dir=gs://ti-is-devenv-01_cloudbuild_custom_logs_cicd/logs/ .

#gcloud builds submit -t gcr.io/devops8687/angularapp:v1 --gcs-log-dir=gs://ti-is-devenv-01_cloudbuild_custom_logs_cicd/logs/ .

#gcloud builds submit -t gcr.io/devops8687/angularapp:v1  --gcs-log-dir=gs://157582299266-cloudbuild-logs-cicd/ .
# FROM node:12-slim as build-step
FROM cypress/browsers:node14.17.0-chrome88-ff89 AS build-step
# # Create and change to the app directory.
WORKDIR /usr/src/app

# # Copy application dependency manifests to the container image.
# # A wildcard is used to ensure both package.json AND package-lock.json are copied.
# # Copying this separately prevents re-running npm install on every code change.
COPY package*.json ./

# # Install production dependencies.
RUN npm install 



# Copy local code to the container image.
COPY . ./

# RUN npm install @angular/cli 

RUN npm run build


FROM nginx:1.17.1-alpine

COPY --from=build-step /usr/src/app/dist /usr/share/nginx/html

#COPY distinto /usr/share/nginx/html