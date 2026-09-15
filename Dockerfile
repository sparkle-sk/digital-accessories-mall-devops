# 多阶段 Dockerfile：先把 Maven 构建，再丢进精简 JRE 跑
# 最终镜像只含 JRE + 你的 jar，不含 Maven，体积小、安全面小
# 注意：pom.xml 和 src 都在子目录 digital-accessories-server/ 下

# ==== 阶段 1：用 Maven 构建 ====
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /build

# 先只复制 pom 拉依赖（利用 Docker 缓存，pom 不变就不重装）
COPY digital-accessories-server/pom.xml .
RUN mvn -B dependency:go-offline

# 再复制源码打包（跳过测试，速度更快；测试在 CI 阶段单独跑）
COPY digital-accessories-server/src ./src
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