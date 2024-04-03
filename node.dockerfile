# # Run commands below to build Node.
# docker build --tag "node:arm64v8-alpine-20.11.1" --file "./node.dockerfile" --build-arg "NODE_VERSION=20.11.1" --progress "plain" .
# docker create --name "node-arm64v8-alpine-20.11.1" node:arm64v8-alpine-20.11.1
# docker cp "node-arm64v8-alpine-20.11.1:/home/node-v20.11.1-linux-arm64-musl.tar.gz" ./

# # Building old Node versions requires Python 2.
# # Latest Alpine does not support Python 2.
# # Use Alpine 3.11 and Python 2 for old Node versions.
# docker build --tag "node:arm64v8-alpine-10.24.1" --file "./node.dockerfile" --build-arg "BASE_IMAGE=arm64v8/alpine:3.11" --build-arg "NODE_VERSION=10.24.1" --build-arg "PYTHON_VERSION=2" --progress "plain" .

ARG BASE_IMAGE=arm64v8/alpine
FROM $BASE_IMAGE

WORKDIR /home/

ARG NODE_VERSION=20.11.1
ARG PYTHON_VERSION=3

RUN apk update
RUN apk upgrade
RUN apk add libstdc++
RUN apk add --virtual .build-deps curl binutils-gold g++ gcc gnupg libgcc linux-headers make "python${PYTHON_VERSION}"
RUN curl -fsSL --compressed -o ./source.tar.gz "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}.tar.gz"
RUN tar -xzf ./source.tar.gz
RUN rm ./source.tar.gz
RUN cd ./source/ && ./configure && make -j4 V=
RUN apk del .build-deps
RUN cp ./source/out/Release/node ./node
RUN rm -rf ./source/
RUN tar -czf "./node-v${NODE_VERSION}-linux-arm64-musl.tar.gz" ./node

ENTRYPOINT /bin/sh
