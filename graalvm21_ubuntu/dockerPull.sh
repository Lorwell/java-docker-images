# 用于构建时的镜像
docker build -t jre:graalvm21_ubuntu22.build -f build.dockerfile . || exit

# 用于运行时的镜像
docker build -t jre:graalvm21_ubuntu22.runtime -f runtime.dockerfile . || exit

# 上传
docker tag jre:graalvm21_ubuntu22.build docker-registry-panel.shacocloud.cc/jre:graalvm21_ubuntu22.build || exit
docker push docker-registry-panel.shacocloud.cc/jre:graalvm21_ubuntu22.build || exit

docker tag jre:graalvm21_ubuntu22.runtime docker-registry-panel.shacocloud.cc/jre:graalvm21_ubuntu22.runtime || exit
docker push docker-registry-panel.shacocloud.cc/jre:graalvm21_ubuntu22.runtime || exit

# 删除上传成功
docker rmi docker-registry-panel.shacocloud.cc/jre:graalvm21_ubuntu22.build || exit
docker rmi docker-registry-panel.shacocloud.cc/jre:graalvm21_ubuntu22.runtime || exit