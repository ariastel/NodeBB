# STEP 1: Build binary files
FROM node:lts as builder

LABEL Description="RitoTalks: frontend application image" \
      Vendor="" \
      Version="0.1.0" \
      Maintainer=""

ARG NODE_ENV
ENV NODE_ENV $NODE_ENV

RUN mkdir -p /opt/nodebb
WORKDIR /opt/nodebb

COPY . /opt/nodebb

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
