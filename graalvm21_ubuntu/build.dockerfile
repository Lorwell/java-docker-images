FROM ubuntu:22.04 AS builder

# 设置为 阿里云的源
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list; \
    sed -i s@/security.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list; \
    apt-get clean; \
    apt-get update;

# 安装常用命令
RUN apt-get install -y curl unzip zip wget tar less vim

# 安装jdk
ENV JAVA_URL=https://download.oracle.com/graalvm/21/latest \
  JAVA_HOME=/usr/java/jdk-21

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN set -eux; \
	ARCH="$(uname -m)" && \
    if [ "$ARCH" = "x86_64" ]; \
        then ARCH="x64"; \
    fi && \
    JAVA_PKG="$JAVA_URL"/graalvm-jdk-21_linux-"${ARCH}"_bin.tar.gz ; \
	JAVA_SHA256=$(curl "$JAVA_PKG".sha256) ; \
	curl --output /tmp/jdk.tgz "$JAVA_PKG" && \
	echo "$JAVA_SHA256" */tmp/jdk.tgz | sha256sum -c; \
	mkdir -p "$JAVA_HOME"; \
	tar --extract --file /tmp/jdk.tgz --directory "$JAVA_HOME" --strip-components 1


FROM ubuntu:22.04

# 设置为 阿里云的源
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list; \
    sed -i s@/security.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list; \
    apt-get clean; \
    apt-get update;

# 安装常用命令
RUN apt-get install -y curl unzip zip wget tar less vim dos2unix

# 安装 前端构建工具
RUN apt-get install -y nodejs npm && npm install -g pnpm

# 安装 graalvm 需要的依赖
RUN apt-get install -y build-essential libz-dev zlib1g-dev

# 安装中文字体
RUN apt-get install -y \
    language-pack-zh-hans \
    fonts-wqy-microhei \
    fonts-wqy-zenhei \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 设置中文环境变量
ENV LANG=zh_CN.UTF-8
ENV LANGUAGE=zh_CN:zh
ENV LC_ALL=zh_CN.UTF-8

# 复制上个镜像的 jdk
ENV	JAVA_HOME=/usr/java/jdk-21
ENV	PATH=$JAVA_HOME/bin:$PATH
COPY --from=builder $JAVA_HOME $JAVA_HOME