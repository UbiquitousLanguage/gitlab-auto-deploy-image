FROM alpine:3.9 AS base

FROM base AS build-base
RUN apk add --no-cache curl

FROM build-base AS kubectl
ARG KUBECTL_VERSION
ARG SOURCE=https://dl.k8s.io/v$KUBECTL_VERSION/kubernetes-client-linux-amd64.tar.gz
ARG TARGET=/kubernetes-client.tar.gz
RUN curl -fLSs "$SOURCE" -o "$TARGET"
RUN sha512sum "$TARGET"
RUN tar -xvf "$TARGET" -C /

FROM build-base AS helm
ARG HELM_VERSION
ARG SOURCE=https://storage.googleapis.com/kubernetes-helm/helm-v$HELM_VERSION-linux-amd64.tar.gz
ARG TARGET=/helm.tar.gz
RUN curl -fLSs "$SOURCE" -o "$TARGET"
RUN sha256sum "$TARGET"
RUN mkdir -p /helm
RUN tar -xvf "$TARGET" -C /helm

FROM build-base AS stage
WORKDIR /stage
ENV PATH=$PATH:/stage/usr/bin
COPY --from=kubectl /kubernetes/client/bin/kubectl ./usr/bin/
COPY --from=helm /helm/linux-amd64/helm ./usr/bin/

FROM base as ready
RUN apk add --no-cache ca-certificates git
COPY --from=stage /stage/ /

FROM ready

# https://github.com/sgerrand/alpine-pkg-glibc
ARG GLIBC_VERSION

COPY src/ build/

# Install Dependencies
RUN apk add --no-cache openssl curl tar gzip bash jq \
  && curl -sSL -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
  && curl -sSL -O https://github.com/sgerrand/alpine-pkg-glibc/releases/download/${GLIBC_VERSION}/glibc-${GLIBC_VERSION}.apk \
  && apk add glibc-${GLIBC_VERSION}.apk \
  && apk add ruby jq \
  && rm glibc-${GLIBC_VERSION}.apk \
  && curl -sL https://sentry.io/get-cli/ | bash

RUN ln -s /build/bin/* /usr/local/bin/

