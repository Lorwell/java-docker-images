# 运行时镜像
FROM ubuntu:22.04

RUN sed -i s@/archive.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list; \
    sed -i s@/security.ubuntu.com/@/mirrors.aliyun.com/@g /etc/apt/sources.list; \
    apt-get clean; \
    apt-get update;

# 安装常用命令
RUN apt-get install -y curl unzip zip wget tar less vim dos2unix tzdata locales

# 设置中国上海时区
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 安装中文字体
RUN apt-get install -y \
    language-pack-zh-hans \
    fonts-wqy-microhei \
    fonts-wqy-zenhei \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 设置中文环境变量
ENV LANG zh_CN.UTF-8
ENV LANGUAGE zh_CN:zh
ENV LC_ALL zh_CN.UTF-8