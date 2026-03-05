FROM debian:12-slim AS builder

# 设置为阿里云的源，安装工具并清理（合并为一个RUN）
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list.d/debian.sources && \
    apt-get update && \
    apt-get install -y --no-install-recommends curl ca-certificates && \
    rm -rf /var/lib/apt/lists/*

# 安装JDK
ENV JAVA_URL=https://download.oracle.com/graalvm/25/latest \
    JAVA_HOME=/usr/java/jdk-25

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN set -eux; \
    ARCH="$(uname -m)" && \
    if [ "$ARCH" = "x86_64" ]; then \
        ARCH="x64"; \
    fi && \
    JAVA_PKG="$JAVA_URL"/graalvm-jdk-25_linux-"${ARCH}"_bin.tar.gz && \
    JAVA_SHA256=$(curl -s "$JAVA_PKG".sha256) && \
    curl --output /tmp/jdk.tgz "$JAVA_PKG" && \
    echo "$JAVA_SHA256 */tmp/jdk.tgz" | sha256sum -c && \
    mkdir -p "$JAVA_HOME" && \
    tar --extract --file /tmp/jdk.tgz --directory "$JAVA_HOME" --strip-components 1 && \
    rm /tmp/jdk.tgz


FROM debian:12-slim

# 合并所有运行时安装和配置为一个RUN，大幅减少层数和大小
RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list.d/debian.sources && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        curl \
        unzip \
        zip \
        wget \
        tar \
        less \
        vim \
        dos2unix \
        locales \
        fonts-wqy-microhei \
        fonts-wqy-zenhei \
    && \
    sed -i 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen zh_CN.UTF-8 && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# 设置中文环境变量
ENV LANG=zh_CN.UTF-8 \
    LANGUAGE=zh_CN:zh \
    LC_ALL=zh_CN.UTF-8 \
    JAVA_HOME=/usr/java/jdk-25 \
    PATH=/usr/java/jdk-25/bin:$PATH

COPY --from=builder /usr/java/jdk-25 /usr/java/jdk-25