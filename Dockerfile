# 多阶段 Dockerfile：先把 Maven 构建，再丢进精简 JRE 跑
# 最终镜像只含 JRE + 你的 jar，不含 Maven，体积小、安全面小
# 注意：pom.xml 和 src 都在子目录 digital-accessories-server/ 下

# ==== 阶段 1：用 Maven 构建 ====
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /build

# 先拷 settings.xml 配阿里云镜像（国内拉依赖快、CI 也不受影响）
COPY settings.xml /root/.m2/settings.xml

# 复制 pom 与源码（跳过测试，测试在 CI 阶段单独跑）
COPY digital-accessories-server/pom.xml .
COPY digital-accessories-server/src ./src

# 一条命令下载依赖 + 打包（与 CI 的 mvn 调用保持一致，少一道易翻车的 go-offline）
RUN mvn -B clean package -DskipTests

# ==== 阶段 2：用最小化 JRE 跑 ====
FROM eclipse-temurin:21-jre-jammy
WORKDIR /app

# 从构建阶段拷 jar 过来
COPY --from=build /build/target/*.jar app.jar

# 暴露后端端口
EXPOSE 8080

# JVM 容器化推荐参数：让 JVM 知道自己在容器里
ENV JAVA_OPTS="-XX:+UseG1GC -XX:MaxRAMPercentage=75.0"

# 启动
ENTRYPOINT ["sh", "-c", "java $JAVA_OPTS -jar app.jar"]