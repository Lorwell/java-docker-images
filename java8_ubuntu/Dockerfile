FROM ubuntu:22.04 as builder

# 设置为 阿里云的源
RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list; \
    sed -i s@/security.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list; \
    apt-get clean; \
    apt-get update;

# 安装常用命令
RUN apt-get install -y curl unzip zip wget tar less vim

# 安装jdk
# https://www.openlogic.com/openjdk-downloads?field_java_parent_version_target_id=416&field_operating_system_target_id=426&field_architecture_target_id=391&field_java_package_target_id=401
ENV JAVA_PKG=https://builds.openlogic.com/downloadJDK/openlogic-openjdk-jre/8u402-b06/openlogic-openjdk-jre-8u402-b06-linux-x64.tar.gz \
  JAVA_HOME=/usr/java/jdk-8

SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN set -eux; \
	curl --output /tmp/jdk.tgz "$JAVA_PKG" && \
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

# 设置编码
RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
	&& localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

ENV LANG en_US.utf8
ENV LANGUAGE en_US.utf8
ENV LC_ALL en_US.utf8

# 复制上个镜像的 jdk
ENV	JAVA_HOME=/usr/java/jdk-8
ENV	PATH $JAVA_HOME/bin:$PATH
COPY --from=builder $JAVA_HOME $JAVA_HOME