# 用于构建时的镜像
docker build -t jre:11_ubuntu22 . || exit

# 上传
docker tag jre:11_ubuntu22 ccr.ccs.tencentyun.com/shaco_work/jre:11_ubuntu22 || exit
docker push ccr.ccs.tencentyun.com/shaco_work/jre:11_ubuntu22 || exit

# 删除上传成功
docker rmi ccr.ccs.tencentyun.com/shaco_work/jre:11_ubuntu22 || exit