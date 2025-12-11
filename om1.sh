#!/bin/bash
# ======================================
# OM1 Linux One-click Installer
# 带交互输入版本
# ======================================

echo "========== OM1 一键安装脚本 =========="
echo "本脚本将自动完成安装，并生成 .env 配置文件"
echo "======================================="

# ---- 用户交互输入 ----
read -p "请输入 ETH 地址: " ETH_ADDRESS
read -p "请输入 OM_API_KEY: " OM_API_KEY
read -p "请输入 机器人 ID (URID): " URID

echo ""
echo "您输入的信息："
echo "ETH_ADDRESS: $ETH_ADDRESS"
echo "OM_API_KEY: $OM_API_KEY"
echo "URID: $URID"
echo ""

# ---- 系统依赖 ----
echo "[1/7] 安装系统依赖..."
sudo apt update
sudo apt install -y git ffmpeg portaudio19-dev python3-pip

# ---- 克隆仓库 ----
echo "[2/7] 克隆 OM1 仓库..."
git clone https://github.com/OpenMind/OM1.git || true
cd OM1 || exit

# ---- 初始化子模块 ----
echo "[3/7] 初始化子模块..."
git submodule update --init

# ---- 创建 uv 虚拟环境 ----
echo "[4/7] 创建 uv 虚拟环境..."
uv venv

# ---- 生成 .env 文件 ----
echo "[5/7] 生成 .env 文件..."
cat <<EOF > .env
ETH_ADDRESS="$ETH_ADDRESS"
OM_API_KEY="$OM_API_KEY"
URID="$URID"
EOF

echo ".env 内容如下："
cat .env

# ---- 加载环境变量 ----
echo "[6/7] 加载环境变量..."
source .env

echo "[7/7] 安装完成！"

echo "======================================"
echo "安装完成！你现在可以运行："
echo "  uv run src/run.py conversation"
echo "======================================"
