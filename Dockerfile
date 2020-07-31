# Build stage 1: Build Image
FROM node:12-alpine AS build
WORKDIR /usr/src/app/build
COPY . .

RUN echo "Installing BUILD dependencies and tools"
RUN apk add --update-cache \
    bash \
    bsd-compat-headers \
    build-base \
    ca-certificates \
    cyrus-sasl \
    cyrus-sasl-dev \
    cyrus-sasl-scram \
    g++ \
    libc-dev \
    lz4 \
    lz4-dev \
    make \
    musl \
    musl-dev \
    openssl \
    openssl-dev \
    py-pip \
    py-setuptools \
    python \
    python-dev \
    rapidjson \
    rapidjson-dev \
    zlib-dev

WORKDIR /usr/src/app/build
ARG NODE_AUTH_TOKEN
RUN echo "Building"
RUN npm install
RUN npm run build

# Build stage 2: runtime image
FROM node:12-alpine
WORKDIR /usr/src/app
RUN echo "Installing RUNTIME essentiel dependencies and tools"
RUN apk add --update-cache \
    ca-certificates \
    cyrus-sasl \
    cyrus-sasl-scram \
    lz4 \
    lz4-dev \
    musl \
    musl-dev \
    openssl \
    rapidjson 
RUN echo "Installing additional packages - these are not required and may pose security risk"
RUN apk update && apk upgrade
RUN apk add \
    tcpdump \
    bash \
    net-tools
# IF you need to copy custom CA certs, do that here. It may be needed for the SASL stage.
# Some distroseems like it cannot be instructed to ignore cert validity.
# RUN mkdir -p /etc/ssl/certs
# COPY <customca>.cert /usr/local/share/ca-certificates/custom-ca-cert.crt
# RUN update-ca-certificates --fresh
RUN rm -rf /var/cache/apk/*
RUN echo "Building runtime image"
# copy dependencies
RUN echo "Copying build output"
COPY --from=build /usr/src/app/build/package.json ./
COPY --from=build /usr/src/app/build/package-lock.json ./
COPY --from=build /usr/src/app/build/dist ./dist
COPY --from=build /usr/src/app/build/node_modules ./node_modules

WORKDIR /usr/src/app
ENV PORT 80
ENV NODE_ENV=production
ENV LOG=error,warn,log
EXPOSE 80
CMD [ "npm", "run", "start:prod" ]