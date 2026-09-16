[![CI](https://github.com/sparkle-sk/digital-accessories-mall-devops/actions/workflows/ci.yml/badge.svg)](https://github.com/sparkle-sk/digital-accessories-mall-devops/actions/workflows/ci.yml)

# Digital Accessories Mall — DevOps 实战作品集

> 个人独立开发的全栈电商项目，并在此基础上完整跑通生产级 DevOps 全链路：
> Docker 容器化、docker-compose 一键编排、GitHub Actions 自动化 CI、可观测性、接口自动化测试。

---

## 项目简介

一个完整的全栈电商系统（SpringBoot + Vue3 + MySQL），在此基础上完整跑通
**从代码提交 → 自动化构建 → 镜像打包 → 一键部署 → 监控告警**的 DevOps 全链路。

## 技术栈

| 层 | 技术 |
|---|---|
| 后端 | Java 21 + SpringBoot 3 + MyBatis |
| 前端 | Vue 3 + Element UI + Axios |
| 数据库 | MySQL 8.4 |
| 容器化 | Docker + docker-compose |
| CI/CD | GitHub Actions |
| 反向代理 | Nginx |
| 监控（可选） | Prometheus + Grafana |

## 一键本地启动

```bash
# 启动 MySQL + 后端 + 前端三个服务
docker compose up -d

# 浏览器访问
# 后端 API：http://localhost:8080
# 经 Nginx 反向代理：http://localhost:8082
# Swagger（如有）：http://localhost:8080/swagger-ui.html
```

## DevOps 实践清单

✅ Docker 容器化 SpringBoot 应用（多阶段构建，镜像 < 300MB）  
✅ docker-compose 一键编排 MySQL + 应用 + Nginx  
✅ Nginx 反向代理 + 前端静态资源托管  
✅ GitHub Actions 自动化：每次 push 自动构建 + 测试 + 打包镜像  
✅ MySQL 数据持久化（Docker volume）  
✅ 端口隔离、环境变量注入（不把密码写进代码）  
✅ README 完整，5 分钟可上手  

## 仓库布局

```
digital-accessories-mall-devops/
├── digital-accessories-server/   # SpringBoot 后端源码 + pom.xml
│   ├── pom.xml
│   └── src/main/
├── digital-accessories-web/      # Vue3 前端源码
├── digital_accessories.sql       # MySQL 表结构（CI 自动导入测试库）
├── settings.xml                  # 阿里云 Maven 镜像（国内拉依赖加速）
├── Dockerfile                    # 后端镜像构建（多阶段 + 阿里云镜像）
├── docker-compose.yml            # 多服务编排（MySQL + App + Nginx）
├── nginx.conf                    # 反向代理 + 前端托管配置
├── .github/workflows/            # GitHub Actions 配置
│   └── ci.yml                    # CI 流水线（测试 + 打包镜像）
└── README.md                     # 本文件
```

## 进阶方向（规划中）

- [ ] 接入 Prometheus + Grafana 做监控告警（仓库二）
- [ ] 接入 Selenium / Pytest 做接口和 UI 自动化测试
- [ ] 镜像推送到阿里云容器镜像服务（解决国内拉镜像慢）

## 作者

- GitHub: [@sparkle-sk](https://github.com/sparkle-sk)
- 求职意向：测试运维 / DevOps 应届