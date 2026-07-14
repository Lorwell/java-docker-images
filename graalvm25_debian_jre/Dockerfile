FROM debian:12-slim AS jdk-builder

ARG TARGETARCH
ARG GRAALVM_VERSION=25.0.3
ARG GRAALVM_SHA256_AMD64=1b5296613c3d12521d594e1c99302df88d8e1f07d74ab7983dbf572000b92c7c
ARG GRAALVM_SHA256_ARM64=2c6e5ef63084c5f39c67cbf5c33d23c852df848d10cd50d76e667fff9c9cf2bc
ARG JAVA_MODULES=java.se,jdk.accessibility,jdk.attach,jdk.charsets,jdk.crypto.cryptoki,jdk.crypto.ec,jdk.dynalink,jdk.graal.compiler,jdk.graal.compiler.management,jdk.httpserver,jdk.incubator.vector,jdk.jdwp.agent,jdk.jfr,jdk.jsobject,jdk.localedata,jdk.management,jdk.management.agent,jdk.management.jfr,jdk.naming.dns,jdk.naming.rmi,jdk.net,jdk.nio.mapmode,jdk.sctp,jdk.security.auth,jdk.security.jgss,jdk.unsupported,jdk.unsupported.desktop,jdk.xml.dom,jdk.zipfs
ENV JAVA_HOME=/usr/java/jdk-25

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list.d/debian.sources && \
    apt-get -o Acquire::Retries=3 -o APT::Update::Error-Mode=any update && \
    apt-get install -y --no-install-recommends binutils ca-certificates curl tar && \
    rm -rf /var/lib/apt/lists/*

RUN set -eux; \
    case "$TARGETARCH" in \
        amd64) ORACLE_ARCH="x64"; JAVA_SHA256="$GRAALVM_SHA256_AMD64" ;; \
        arm64) ORACLE_ARCH="aarch64"; JAVA_SHA256="$GRAALVM_SHA256_ARM64" ;; \
        *) echo "Unsupported TARGETARCH: $TARGETARCH" >&2; exit 1 ;; \
    esac; \
    JAVA_PKG="https://download.oracle.com/graalvm/25/archive/graalvm-jdk-${GRAALVM_VERSION}_linux-${ORACLE_ARCH}_bin.tar.gz"; \
    curl --fail --show-error --location --retry 3 --output /tmp/jdk.tgz "$JAVA_PKG"; \
    printf '%s  %s\n' "$JAVA_SHA256" /tmp/jdk.tgz | sha256sum --check -; \
    mkdir -p "$JAVA_HOME"; \
    tar --extract --file /tmp/jdk.tgz --directory "$JAVA_HOME" --strip-components 1; \
    rm -f /tmp/jdk.tgz

RUN "$JAVA_HOME/bin/jlink" \
    --module-path "$JAVA_HOME/jmods" \
    --add-modules "$JAVA_MODULES" \
    --strip-debug \
    --no-header-files \
    --no-man-pages \
    --compress=zip-6 \
    --output /opt/java-runtime

FROM debian:12-slim

RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list.d/debian.sources && \
    apt-get -o Acquire::Retries=3 -o APT::Update::Error-Mode=any update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        ca-certificates \
        fontconfig \
        libasound2 \
        libstdc++6 \
        libx11-6 \
        libxext6 \
        libxi6 \
        libxrender1 \
        libxtst6 \
        locales \
        tzdata \
        zlib1g && \
    ln -snf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && \
    printf 'Asia/Shanghai\n' > /etc/timezone && \
    sed -i 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen zh_CN.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV JAVA_HOME=/usr/java/jre-25 \
    PATH=/usr/java/jre-25/bin:$PATH \
    LANG=zh_CN.UTF-8 \
    LANGUAGE=zh_CN:zh \
    LC_ALL=zh_CN.UTF-8

COPY --from=jdk-builder /opt/java-runtime/ $JAVA_HOME/
