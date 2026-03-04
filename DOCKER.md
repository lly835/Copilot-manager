# Docker 支持

本项目支持通过 Docker 进行构建和开发。

## 系统要求

- Docker 20.10+
- Docker Buildx (用于多平台构建)
- 至少 4GB 可用内存
- 至少 10GB 磁盘空间（用于构建）

## 快速开始

### 1. 构建生产镜像

```bash
# 克隆项目
git clone https://github.com/king157419/Copilot-manager.git
cd Copilot-manager

# 构建镜像
docker build -t copilot-manager:latest .
```

### 2. 运行镜像

```bash
# 交互式运行（查看帮助）
docker run --rm copilot-manager:latest

# 后台运行（如果构建成功）
docker run -d --name copilot-manager \
  -p 8045:8045 \
  -p 1420:1420 \
  copilot-manager:latest
```

### 3. 使用 Docker Compose

```bash
# 开发模式
docker-compose --profile dev up

# 仅构建
docker-compose --profile build up
```

## Docker Compose 配置说明

### 开发模式 (dev profile)

```bash
docker-compose --profile dev up
```

- 监听端口：
  - `1420`: 前端开发服务器
  - `8045`: API 反代服务
- 挂载当前目录到容器内 `/app`
- 支持热重载开发

### 生产构建 (build profile)

```bash
docker-compose --profile build up
```

## 手动构建步骤

如果你想分步构建：

### Step 1: 构建前端

```bash
# 安装依赖
npm ci --legacy-peer-deps

# 构建前端
npm run build
```

### Step 2: 构建 Rust 后端

```bash
cd src-tauri
cargo build --release
```

### Step 3: 运行

```bash
# 找到构建产物
./src-tauri/target/release/antigravity-tools
```

## 多平台构建

如需构建多平台镜像（ARM64/AMD64）：

```bash
# 启用 buildx
docker buildx create --name mybuilder
docker buildx use mybuilder

# 构建并推送
docker buildx build \
  --platform linux/amd64,linux/arm64 \
  -t copilot-manager:latest \
  --push .
```

## 注意事项

1. **GUI 限制**: 这是一个 Tauri 桌面应用，Docker 构建主要用于生成二进制文件。完整的 GUI 功能需要在本地桌面环境中运行（需要 X11/Wayland）。

2. **构建时间**: 首次构建可能需要 15-30 分钟（取决于网络和硬件）。

3. **依赖**: Docker 镜像已包含所有运行时依赖，无需额外安装。

4. **端口**: 默认暴露以下端口：
   - `8045`: API 反代服务
   - `1420`: 前端开发服务器

## 故障排除

### 构建失败

如果遇到构建问题，尝试：

```bash
# 清理缓存
docker builder prune

# 重新构建（不带缓存）
docker build --no-cache -t copilot-manager:latest .
```

### 内存不足

如果构建时内存不足，可以增加 Docker 内存限制：

```json
{
  "memory": "8GB"
}
```

### Rust 依赖下载慢

可以换用国内镜像源，在 Dockerfile 中添加：

```dockerfile
ENV RUSTUP_DIST_SERVER=https://mirrors.ustc.edu.cn/rust-static
ENV RUSTUP_UPDATE_ROOT=https://mirrors.ustc.edu.cn/rust-static/rustup
```

## 贡献

欢迎提交 Issue 和 Pull Request 来改进 Docker 支持！
