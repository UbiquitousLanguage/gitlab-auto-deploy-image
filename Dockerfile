FROM alpine:latest

ARG HELM_VERSION
ARG KUBERNETES_VERSION

COPY src/ build/

# Install Dependencies
RUN apk add -U openssl curl tar gzip bash ca-certificates git gettext \
  && curl -sSL -o /etc/apk/keys/sgerrand.rsa.pub https://alpine-pkgs.sgerrand.com/sgerrand.rsa.pub \
  && curl -sSL -O https://github.com/sgerrand/alpine-pkg-glibc/releases/download/2.28-r0/glibc-2.28-r0.apk \
  && apk add glibc-2.28-r0.apk \
  && rm glibc-2.28-r0.apk \
  && curl -sS "https://kubernetes-helm.storage.googleapis.com/helm-v${HELM_VERSION}-linux-amd64.tar.gz" | tar zx \
  && mv linux-amd64/helm /usr/bin/ \
  && mv linux-amd64/tiller /usr/bin/ \
  && curl -sSL -o /usr/bin/kubectl "https://storage.googleapis.com/kubernetes-release/release/v${KUBERNETES_VERSION}/bin/linux/amd64/kubectl" \
  && chmod +x /usr/bin/kubectl \
  && export INSTALL_DIR=/usr/bin \
  && curl -sL https://sentry.io/get-cli/ | bash

RUN ln -s /build/bin/* /usr/local/bin/
