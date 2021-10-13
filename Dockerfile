FROM node:16-alpine3.11

ENV export BINDLE_URL=http://localhost:8080/v1
ENV PATH=#{user-home-abs-path}/.cargo/bin:"$PATH"

RUN apk add --no-cache \
        ca-certificates \
        gcc \
        git \
        curl \
        bash \ 
        icu-libs \
        krb5-libs \
        libgcc \
        libintl \
        libssl1.1 \
        libstdc++ \
        zlib \
    && curl -sSL https://sh.rustup.rs | sh -s -- -y     



