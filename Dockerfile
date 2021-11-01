

#gcloud builds submit -t gcr.io/devops8687/angularapp:v1  --gcs-log-dir=gs://157582299266-cloudbuild-logs-cicd/ .
#kubectl run angular --image=gcr.io/devops8687/angularapp:v11 --port=80 
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

RUN mkdir -p /usr/share/nginx/html/emma-front
COPY nginx-config/nginx.conf /etc/nginx/nginx.conf

COPY --from=build-step /usr/src/app/dist/unicomerFront /usr/share/nginx/html/emma-front


#COPY distinto /usr/share/nginx/html