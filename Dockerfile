ARG HELM_VERSION
ARG KUBECTL_VERSION

FROM alpine:3.9

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
  && curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl \
  && mv ./kubectl /usr/bin/kubectl \
  && chmod +x /usr/bin/kubectl \
  && curl -L https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3 | bash \
  && curl -sL https://sentry.io/get-cli/ | bash

RUN ln -s /build/bin/* /usr/local/bin/
