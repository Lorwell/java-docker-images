# 用于构建时的镜像
docker build -t graalvm21:ubuntu22.build -f build.dockerfile . || exit

# 用于运行时的镜像
docker build -t graalvm21:ubuntu22.runtime -f runtime.dockerfile . || exit

# 上传
docker tag graalvm21:ubuntu22.build ccr.ccs.tencentyun.com/shaco_work/graalvm21:ubuntu22.build || exit
docker push ccr.ccs.tencentyun.com/shaco_work/graalvm21:ubuntu22.build || exit

docker tag graalvm21:ubuntu22.runtime ccr.ccs.tencentyun.com/shaco_work/graalvm21:ubuntu22.runtime || exit
docker push ccr.ccs.tencentyun.com/shaco_work/graalvm21:ubuntu22.runtime || exit

# 删除上传成功
docker rmi ccr.ccs.tencentyun.com/shaco_work/graalvm21:ubuntu22.build || exit
docker rmi ccr.ccs.tencentyun.com/shaco_work/graalvm21:ubuntu22.runtime || exit