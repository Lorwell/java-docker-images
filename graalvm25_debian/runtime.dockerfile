# 运行时镜像
FROM debian:12-slim

RUN sed -i 's/deb.debian.org/mirrors.aliyun.com/g' /etc/apt/sources.list.d/debian.sources; \
    apt-get clean; \
    apt-get update;

# 安装常用命令
RUN apt-get install -y curl unzip zip wget tar less vim dos2unix tzdata locales

# 设置中国上海时区
RUN ln -sf /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

# 安装中文字体
RUN apt-get install -y \
    fonts-wqy-microhei \
    fonts-wqy-zenhei \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# 配置中文locale
RUN sed -i 's/# zh_CN.UTF-8 UTF-8/zh_CN.UTF-8 UTF-8/' /etc/locale.gen && \
    locale-gen zh_CN.UTF-8

# 设置中文环境变量
ENV LANG=zh_CN.UTF-8
ENV LANGUAGE=zh_CN:zh
ENV LC_ALL=zh_CN.UTF-8