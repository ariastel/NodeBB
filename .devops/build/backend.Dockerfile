FROM node:lts

LABEL Description="RitoTalks: backend application image" \
      Vendor="" \
      Version="0.1.0" \
      Maintainer=""

ARG NODE_ENV
ENV NODE_ENV $NODE_ENV

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

RUN mkdir -p /opt/nodebb
WORKDIR /opt/nodebb

COPY install/package.json /opt/nodebb/package.json

RUN apt-get update && apt-get install -y gettext-base && \
    npm install --only=prod && \
    npm cache clean --force

COPY . /opt/nodebb
COPY .devops/build/k8s.config.json.template .
COPY .devops/build/k8s.start.sh ./start.sh

ENV NODE_ENV=production \
    daemon=false \
    silent=false

EXPOSE $NODEBB_PORT

CMD /opt/nodebb/start.sh
