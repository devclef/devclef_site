# Multi-stage Dockerfile to build the Zola site and serve it with Nginx

# 1) Build stage: use official Zola image
FROM ghcr.io/getzola/zola:v0.21.0 AS build
WORKDIR /site
COPY . .
RUN ["zola", "build"]

# 2) Runtime stage: serve static files with nginx
FROM ghcr.io/static-web-server/static-web-server:2
WORKDIR /
COPY --from=build /site/public /public
