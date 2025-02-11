#!/bin/bash

image=leantime/leantime:latest
# 因为是镜像名称转为版本号，所以需要将冒号转为下划线
target=leantime_latest

# 拉取镜像
docker pull "${image}" || exit

# 上传
docker tag ${image} ccr.ccs.tencentyun.com/shaco_work/library:${target} || exit
docker push ccr.ccs.tencentyun.com/shaco_work/library:${target} || exit

# 删除上传成功
docker rmi ccr.ccs.tencentyun.com/shaco_work/library:${target} || exit

echo "镜像地址：ccr.ccs.tencentyun.com/shaco_work/library:${target}"