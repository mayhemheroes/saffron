# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang
RUN apt-get install -y cargo

## Add source code to the build stage.
ADD . /saffron
WORKDIR /saffron

## TODO: ADD YOUR BUILD INSTRUCTIONS HERE.
RUN cd saffron/fuzz
RUN cargo build

# Package Stage
FROM --platform=linux/amd64 ubuntu:20.04

## TODO: Change <Path in Builder Stage>
COPY --from=builder /saffron/saffron/fuzz/target/release/default /
