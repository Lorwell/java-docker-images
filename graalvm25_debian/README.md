## 基于 Debian 12 的 GraalVM 25 版本的本地化镜像

### 构建时镜像

```dockerfile
FROM docker.io/moailaozi/jre:graalvm25_debian12.build as builder

# 复制项目所有代码
ADD . /build
WORKDIR /build

# 执行编译
RUN bash -c "source /etc/profile && chmod 755 -R /build && dos2unix /build/gradlew && /build/gradlew nativeCompile"
```

以上这个构建时模板的构建命令是基于 `gradle` 包管理器

* `dos2unix` 是将 `windows` 下的换行符转为 `unix` 的，以防止命令执行错误

*  `bash -c "source /etc/profile" ` 是为了使基础镜像的中的jdk配置可以生效
* `/build/gradlew nativeCompile` 是进行本地化构建

**该基础镜像包含的内容如下：**

* 使用 `debian:12-slim` 版本作为基础镜像
* 使用 `mirrors.aliyun.com` 作为镜像源
* 安装了一些基础命令 `curl unzip zip wget tar less vim dos2unix`
* 安装了 GraalVM 构建依赖 `build-essential libz-dev zlib1g-dev`
* 编码字符集统一为 `zh_CN.UTF-8`
* 预装中文字体支持

### 运行时镜像

```dockerfile
# 运行时镜像
FROM docker.io/moailaozi/jre:graalvm25_debian12.runtime

# 复制构建时镜像的构建结果
WORKDIR /workspace
COPY --from=builder "/build/server/build/native/nativeCompile/server" /workspace/app

EXPOSE 8080

CMD [ "sh", "-c", "/workspace/app -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8"]
```

以上这个运行时模板是接着构建时模板之后的，是一个多阶段打包的 `dockerfile`，[完整的文件](#完整的文件)

* `COPY --from=0 ` 复制第一个阶段中生成的文件

* `-Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8` 声明文件和字符编码，以防止出现文件名乱码或其他问题，这里可以参考我提的一个 [issue](https://github.com/spring-projects/spring-boot/issues/38936)

### 完整的文件

```dockerfile
FROM docker.io/moailaozi/jre:graalvm25_debian12.build as builder

# 复制项目所有代码
ADD . /build
WORKDIR /build

# 执行编译
RUN bash -c "source /etc/profile && dos2unix /build/gradlew && /build/gradlew nativeCompile"

# 运行时镜像
FROM docker.io/moailaozi/jre:graalvm25_debian12.runtime

# 复制构建时镜像的构建结果
WORKDIR /workspace
COPY --from=builder "/build/server/build/native/nativeCompile/server" /workspace/app

EXPOSE 8080

CMD [ "sh", "-c", "/workspace/app -Dfile.encoding=UTF-8 -Dsun.jnu.encoding=UTF-8"]
```

### 与 springboot 的 `bootBuildImage `构建的优缺点比较

| bootBuildImage                               | 基于 Debian 12 的运行时                                      |
| -------------------------------------------- | ------------------------------------------------------------ |
| 最终生成的运行时镜像小，大约75m              | 最终生成的运行时镜像较大，大约155m                           |
| 构建需要从 github 下载文件，国内网络是个问题 | 只要docker配置好国内镜像源，速度很快                         |
| 基于 `graalvm`的本地化可执行文件             | 基于 `graalvm`的本地化可执行文件                             |
| 运行时镜像无法进入命令行                     | 运行时镜像可以进入命令行，并且可以根据需求自定义安装需要的包 |
| 启动速度不到1s                               | 启动速度不到1s                                               |
| 运行时内存略少，因为几乎没有系统开销         | 运行时内存相对多一点，因为存在 Debian 系统开销              |

