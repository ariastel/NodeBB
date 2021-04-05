FROM 792522745996.dkr.ecr.eu-central-1.amazonaws.com/ecr-node:latest

LABEL Description="RitoTalks: backend application image" \
      Vendor="AriastelDev" \
      Version="1.1.0" \
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

ARG MONGO_HOST
ENV MONGO_HOST $MONGO_HOST
ARG MONGO_PORT
ENV MONGO_PORT $MONGO_PORT
ARG MONGO_USER
ENV MONGO_USER $MONGO_USER
ARG MONGO_PASS
ENV MONGO_PASS $MONGO_PASS
ARG MONGO_DATABASE
ENV MONGO_DATABASE $MONGO_DATABASE

ARG REDIS_HOST
ENV REDIS_HOST $REDIS_HOST
ARG REDIS_PORT
ENV REDIS_PORT $REDIS_PORT
ARG REDIS_DATABASE
ENV REDIS_DATABASE $REDIS_DATABASE

RUN mkdir -p /opt/nodebb
WORKDIR /opt/nodebb

RUN echo "//npm.pkg.github.com/:_authToken=${GITHUB_TOKEN}" > ~/.npmrc && \
    echo "@ariastel:registry=https://npm.pkg.github.com/" >> ~/.npmrc

RUN apt-get update && apt-get install -y gettext-base

COPY . /opt/nodebb
COPY .devops/build/k8s.config.json.template .
COPY .devops/build/k8s.start.sh ./start.sh

RUN envsubst < /opt/nodebb/k8s.config.json.template > /opt/nodebb/config.json || \
    (echo "Unable to create nodebb config.json" && exit 1)

ENV NODE_ENV=production \
    daemon=false \
    silent=false

RUN npm install --only=prod && \
    npm cache clean --force

RUN node ./nodebb build --series

EXPOSE $NODEBB_PORT

CMD bash
