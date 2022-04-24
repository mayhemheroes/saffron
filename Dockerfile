# Build Stage
FROM --platform=linux/amd64 ubuntu:20.04 as builder

## Install build dependencies.
RUN apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y cmake clang
RUN apt-get install -y cargo curl

RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
RUN rustup -y default nightly

## Add source code to the build stage.
ADD . /saffron
WORKDIR /saffron/saffron/fuzz 

## TODO: ADD YOUR BUILD INSTRUCTIONS HERE.
RUN cargo +nightly rustc -- \
    -C passes='sancov-module' \
    -C llvm-args='-sanitizer-coverage-level=3' \
    -C llvm-args='-sanitizer-coverage-inline-8bit-counters' \
    -Z sanitizer=address

# Package Stage
FROM --platform=linux/amd64 ubuntu:20.04

## TODO: Change <Path in Builder Stage>
COPY --from=builder /saffron/saffron/fuzz/target/debug/default /
