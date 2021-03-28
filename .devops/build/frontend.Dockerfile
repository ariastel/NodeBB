# STEP 1: Build binary files
FROM node:lts as builder

LABEL Description="RitoTalks: frontend application image" \
      Vendor="" \
      Version="0.1.0" \
      Maintainer=""

ARG GITHUB_TOKEN
ENV GITHUB_TOKEN $GITHUB_TOKEN

ARG NODE_ENV
ENV NODE_ENV $NODE_ENV

ENV NODEBB_USE_LOCAL_PLUGINS='true' \
    NODEBB_USE_LOCAL_THEME='true' \
    NODEBB_THEME_ID='@ariastel/nodebb-theme-ariastel'

ARG NODEBB_URL
ENV NODEBB_URL $NODEBB_URL
ARG NODEBB_PORT
ENV NODEBB_PORT $NODEBB_PORT
ARG NODEBB_SECRET
ENV NODEBB_SECRET $NODEBB_SECRET

RUN mkdir -p /opt/nodebb
WORKDIR /opt/nodebb

RUN echo "//npm.pkg.github.com/:_authToken=${GITHUB_TOKEN}" > ~/.npmrc && \
    echo "@ariastel:registry=https://npm.pkg.github.com/" >> ~/.npmrc

RUN apt-get update && apt-get install -y gettext-base

COPY . /opt/nodebb
COPY .devops/build/k8s.config.json.template .

RUN envsubst < /opt/nodebb/k8s.config.json.template > /opt/nodebb/config.json || \
    (echo "Unable to create nodebb config.json" && exit 1)

ENV NODE_ENV=production \
    daemon=false \
    silent=false

RUN npm install --only=prod && \
    npm cache clean --force

RUN node ./nodebb build --series

# STEP 2: create optimized Docker image
FROM nginx:alpine

# Copy compiled binary to package folder
COPY --from=builder /opt/nodebb/public /usr/share/nginx/html

# Copy nginx.conf
COPY --from=builder /opt/nodebb/.devops/configs/nginx.conf /etc/nginx/nginx.conf

# Expose port for app
EXPOSE 8080

# Set entrypoint for container
# ENTRYPOINT nginx
