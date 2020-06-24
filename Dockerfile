ARG HELM_VERSION
ARG KUBECTL_VERSION

FROM "registry.gitlab.com/gitlab-org/cluster-integration/helm-install-image/branches/add-builds-for-helm-3"

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
