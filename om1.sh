#!/bin/bash
# ======================================
# OM1 Linux One-click Installer
# GitHub 版本（适用于 wget 一键运行）
# ======================================

if [ $# -ne 3 ]; then
    echo "用法: ./om1.sh ETH_ADDRESS OM_API_KEY URID"
    echo "示例: ./om1.sh 0x1234abcd xxxxx-mykey 9988"
    exit 1
fi

ETH_ADDRESS=$1
OM_API_KEY=$2
URID=$3

echo "========== OM1 安装开始 =========="

# ---- 系统依赖 ----
echo "[1/7] 安装系统依赖..."
sudo apt update
sudo apt install -y git ffmpeg portaudio19-dev python3-pip

# ---- Clone 项目 ----
echo "[2/7] 克隆 OM1 仓库..."
git clone https://github.com/OpenMind/OM1.git || true
cd OM1 || exit

# ---- Submodule ----
echo "[3/7] 初始化子模块..."
git submodule update --init

# ---- uv venv ----
echo "[4/7] 创建 uv 虚拟环境..."
uv venv

# ---- env 配置 ----
echo "[5/7] 生成 .env 文件..."
cat <<EOF > .env
ETH_ADDRESS="$ETH_ADDRESS"
OM_API_KEY="$OM_API_KEY"
URID="$URID"
EOF

echo ".env 内容："
cat .env

# ---- 加载 env ----
echo "[6/7] 加载环境变量..."
source .env

echo "[7/7] 安装完成！"

echo "======================================"
echo "运行对话功能："
echo "  uv run src/run.py conversation"
echo "======================================"
