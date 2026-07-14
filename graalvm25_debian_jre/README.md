## 基于 Debian 12 的 GraalVM 25 JAR 运行时镜像

镜像标签：

```text
docker.io/moailaozi/jre:graalvm25_debian12.jre
```

该镜像用于运行已经构建完成的 JVM/JAR 应用。它基于 Debian 12 slim，使用 Oracle GraalVM 25.0.3 通过 `jlink` 生成运行时，不包含 Maven、Gradle、native-image、编译工具链和常用交互工具。

### 包含内容

- GraalVM 25.0.3 jlink runtime
- CA 证书
- 时区数据库，默认 `Asia/Shanghai`
- `zh_CN.UTF-8` locale
- JVM 常用动态库依赖

镜像不预装中文字体。需要 PDF、报表、AWT/ImageIO 或中文图形渲染时，请在业务镜像中按需安装字体及相关系统库。

### 使用方式

```dockerfile
FROM docker.io/moailaozi/jre:graalvm25_debian12.jre

WORKDIR /app
COPY --chown=10001:10001 app.jar /app/app.jar

USER 10001:10001
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
```

也可以挂载 JAR 直接运行：

```shell
docker run --rm \
  -v "$PWD/app.jar:/app/app.jar:ro" \
  docker.io/moailaozi/jre:graalvm25_debian12.jre \
  java -jar /app/app.jar
```

### 模块策略

镜像使用 `java.se`、GraalVM JIT、JFR、JMX、Java Agent、Attach、JDWP、常用加密、DNS/JNDI、字符集、locale 和 ZIP 文件系统等运行模块构建。`javac`、`jlink`、`jdeps`、`javadoc`、`jpackage`、`jshell` 和 `native-image` 等开发工具不包含在最终镜像中。

该模块集合面向常见服务端 JAR，优先兼顾体积和兼容性，但不等同于针对单个业务 JAR 使用 `jdeps` 得到的最小 JRE。依赖特殊 JDK 模块的应用应先执行 `java --list-modules` 并完成集成测试。

基础镜像不设置默认 `ENTRYPOINT` 或 `CMD`，JAR 路径和 JVM 参数由业务镜像定义。
