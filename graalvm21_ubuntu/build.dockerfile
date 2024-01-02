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

# 安装jdk
RUN mkdir "/jdk" && \
    wget https://download.oracle.com/graalvm/21/latest/graalvm-jdk-21_linux-x64_bin.tar.gz -O /jdk/graalvm-jdk-21.tar.gz

RUN tar -zvxf /jdk/graalvm-jdk-21.tar.gz -C /jdk; \
    mv -f /jdk/graalvm-jdk-21.0.1+12.1 /jdk/graalvm21

RUN echo "export JAVA_HOME=/jdk/graalvm21" >> /etc/profile; \
    echo "export PATH=/jdk/graalvm21/bin:$PATH" >> /etc/profile;

RUN bash -c "source /etc/profile && java -version"