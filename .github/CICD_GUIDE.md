# GitHub Actions CI/CD 使用指南

## 📋 概述

本项目已配置完整的 CI/CD 流程，支持自动编译打包所有平台（Android、iOS、Web、Windows、macOS、Linux）。

## 🚀 快速开始

### 1. 推送代码自动触发

配置已经生效，当你推送代码到以下分支时会自动触发：

```bash
# 推送到 develop 分支（开发环境）
git push origin develop

# 推送到 main/master 分支（生产环境）
git push origin main
```

### 2. 手动触发构建

在 GitHub 网页端操作：
1. 进入项目的 **Actions** 标签
2. 选择左侧的 **Flutter CI/CD** 工作流
3. 点击右上角 **Run workflow** 按钮
4. 选择构建环境（dev/staging/production）
5. 点击 **Run workflow** 开始构建

## 📦 工作流说明

### 完整工作流（build.yml）

这是功能最完整的工作流，包含以下任务：

| 任务 | 说明 | 运行时机 |
|------|------|----------|
| **代码分析** | 运行 `flutter analyze` 和格式检查 | 每次推送和 PR |
| **单元测试** | 运行所有测试并生成覆盖率报告 | 每次推送和 PR |
| **Android 构建** | 构建 APK 和 AAB | 推送到主分支 |
| **iOS 构建** | 构建 iOS 应用（无签名） | 推送到主分支 |
| **Web 构建** | 构建 Web 应用 | 推送到主分支 |
| **Windows 构建** | 构建 Windows 桌面应用 | 推送到主分支 |
| **macOS 构建** | 构建 macOS 桌面应用 | 推送到主分支 |
| **Linux 构建** | 构建 Linux 桌面应用 | 推送到主分支 |
| **创建 Release** | 自动创建 GitHub Release | 推送到 main/master |

### 简化工作流（build-simple.yml）

用于快速验证的轻量级工作流：
- 只在推送到 `develop` 分支时触发
- 只构建 Android APK
- 执行时间约 10-15 分钟

## 🔧 环境配置

### 分支与环境映射

| 分支 | 环境 | 说明 |
|------|------|------|
| `develop` | dev | 开发环境，连接测试服务器 |
| `staging` | staging | 预发布环境 |
| `main`/`master` | production | 生产环境 |

### 自定义环境变量

在 `build.yml` 中可以修改：

```yaml
env:
  FLUTTER_VERSION: '3.24.5'  # Flutter 版本
  JAVA_VERSION: '17'         # Java 版本
```

## 📥 下载构建产物

### 方式一：从 Actions 下载

1. 进入 **Actions** 标签
2. 点击具体的工作流运行记录
3. 滚动到底部 **Artifacts** 区域
4. 下载需要的构建产物

### 方式二：从 Release 下载

当推送到 `main`/`master` 分支时，会自动创建 Release：

1. 进入项目的 **Releases** 页面
2. 找到对应版本的 Release
3. 下载附件中的安装包

## 🎯 构建产物说明

| 平台 | 产物 | 说明 |
|------|------|------|
| Android | `app-release.apk` | 直接安装的 APK 文件 |
| Android | `app-release.aab` | Google Play 上传用的 AAB 文件 |
| iOS | `ios-build/` | iOS 构建产物（需配置签名） |
| Web | `web-build/` | Web 应用静态文件 |
| Windows | `flutter_demo_windows.zip` | Windows 应用压缩包 |
| macOS | `flutter_demo_macos.zip` | macOS 应用压缩包 |
| Linux | `flutter_demo_linux.tar.gz` | Linux 应用压缩包 |

## ⏱️ 预计构建时间

| 任务 | 预计时间 |
|------|----------|
| 代码分析 | 2-3 分钟 |
| 测试 | 3-5 分钟 |
| Android 构建 | 10-15 分钟 |
| iOS 构建 | 15-20 分钟 |
| Web 构建 | 5-8 分钟 |
| Windows 构建 | 10-15 分钟 |
| macOS 构建 | 10-15 分钟 |
| Linux 构建 | 10-15 分钟 |

**总计（并行执行）：** 约 20-25 分钟完成所有平台构建

## 🔐 配置签名（可选）

### Android 签名

1. 生成密钥库文件：
```bash
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
```

2. 在 GitHub 仓库设置中添加 Secrets：
   - `KEYSTORE_FILE`：密钥库文件的 Base64 编码
   - `KEYSTORE_PASSWORD`：密钥库密码
   - `KEY_ALIAS`：密钥别名
   - `KEY_PASSWORD`：密钥密码

3. 在 `build.yml` 中添加签名步骤（参考注释）

### iOS 签名

需要配置：
- Apple Developer 证书
- Provisioning Profile
- 在 GitHub Secrets 中添加证书相关信息

## 🌐 部署到 GitHub Pages（可选）

如果想自动部署 Web 版本到 GitHub Pages：

1. 在项目设置中启用 GitHub Pages
2. 取消 `build.yml` 中 Web 部署部分的注释：

```yaml
# 可选：部署到 GitHub Pages
- name: 部署到 GitHub Pages
  uses: peaceiris/actions-gh-pages@v3
  if: github.ref == 'refs/heads/main'
  with:
    github_token: ${{ secrets.GITHUB_TOKEN }}
    publish_dir: ./build/web
```

## 🎨 自定义工作流

### 只构建特定平台

编辑 `build.yml`，注释掉不需要的构建任务：

```yaml
jobs:
  analyze: ...
  test: ...
  build-android: ...   # 保留
  # build-ios: ...     # 注释掉
  # build-web: ...     # 注释掉
  # build-windows: ... # 注释掉
  # build-macos: ...   # 注释掉
  # build-linux: ...   # 注释掉
```

### 修改触发条件

```yaml
on:
  push:
    branches: [ main, develop, feature/* ]  # 添加更多分支
    tags:
      - 'v*'  # 添加标签触发
  pull_request:
    branches: [ main ]
  schedule:
    - cron: '0 2 * * *'  # 每天凌晨 2 点自动构建
```

### 添加通知

构建完成后发送通知（Slack、邮件等）：

```yaml
- name: 发送 Slack 通知
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    text: '构建完成！'
  env:
    SLACK_WEBHOOK_URL: ${{ secrets.SLACK_WEBHOOK }}
```

## 🐛 常见问题

### 1. 构建失败怎么办？

- 查看 Actions 日志，找到报错信息
- 确认本地 `flutter build` 命令能正常执行
- 检查依赖版本是否正确
- 确认代码生成文件已提交或在 CI 中生成

### 2. 构建时间太长

- 使用 `build-simple.yml` 只构建需要的平台
- 启用缓存（已配置）
- 考虑使用 self-hosted runner

### 3. iOS 构建失败

- iOS 构建需要 macOS runner
- 默认配置是无签名构建，只能用于测试
- 正式发布需要配置证书和 Provisioning Profile

### 4. 如何查看测试覆盖率？

- 集成 Codecov（已配置）
- 在 Actions 日志中查看测试报告
- 配置 Codecov Token 以获得详细报告

## 📊 Badge 徽章

在 `README.md` 中添加构建状态徽章：

```markdown
![Flutter CI/CD](https://github.com/你的用户名/flutter_demo/workflows/Flutter%20CI%2FCD/badge.svg)
```

## 🔄 版本管理

### 自动版本号

在 `pubspec.yaml` 中更新版本：

```yaml
version: 1.0.0+1  # 版本号+构建号
```

推送到 `main` 分支时，会自动创建对应版本的 Release。

### 语义化版本

建议使用语义化版本号：
- `1.0.0` → `1.0.1`：补丁版本（bug 修复）
- `1.0.0` → `1.1.0`：次版本（新功能）
- `1.0.0` → `2.0.0`：主版本（破坏性更改）

## 💡 最佳实践

1. **分支策略**
   - `develop`：日常开发，频繁集成
   - `main`/`master`：稳定版本，定期发布

2. **代码质量**
   - 推送前运行 `flutter analyze`
   - 保持测试覆盖率 > 80%
   - 遵循项目代码规范

3. **构建优化**
   - 提交代码前本地构建测试
   - 避免频繁推送触发不必要的构建
   - 使用简化工作流进行快速验证

4. **安全性**
   - 不要在代码中硬编码密钥
   - 使用 GitHub Secrets 存储敏感信息
   - 定期更新依赖版本

## 📚 相关资源

- [GitHub Actions 官方文档](https://docs.github.com/en/actions)
- [Flutter CI/CD 最佳实践](https://docs.flutter.dev/deployment/cd)
- [Fastlane 自动化部署](https://fastlane.tools/)

## 🤝 需要帮助？

如果遇到问题：
1. 查看 Actions 日志
2. 参考本文档的常见问题
3. 在项目中创建 Issue
4. 联系项目维护者

---

**祝你的 CI/CD 流程顺畅！** 🎉

