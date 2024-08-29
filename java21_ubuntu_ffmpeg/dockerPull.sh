# 用于构建时的镜像
docker build -t jre:21_ubuntu22_ffmpeg . || exit

# 上传
docker tag jre:21_ubuntu22_ffmpeg ccr.ccs.tencentyun.com/shaco_work/jre:21_ubuntu22_ffmpeg || exit
docker push ccr.ccs.tencentyun.com/shaco_work/jre:21_ubuntu22_ffmpeg || exit

# 删除上传成功
docker rmi ccr.ccs.tencentyun.com/shaco_work/jre:21_ubuntu22_ffmpeg || exit