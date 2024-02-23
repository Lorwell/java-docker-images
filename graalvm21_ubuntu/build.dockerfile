FROM ubuntu:22.04 as builder

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

# 安装 graalvm 需要的依赖
RUN apt-get install -y build-essential libz-dev zlib1g-dev

# 设置编码
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8
ENV LANGUAGE en_US.utf8
ENV LC_ALL en_US.utf8

# 复制上个镜像的 jdk
ENV	JAVA_HOME=/usr/java/jdk-21
ENV	PATH $JAVA_HOME/bin:$PATH
COPY --from=builder $JAVA_HOME $JAVA_HOME