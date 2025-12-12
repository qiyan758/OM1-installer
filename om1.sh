#!/bin/bash
# ======================================
# OM1 Linux One-click Installer
# 逐项输入即时保存版本
# ======================================

echo "========== OM1 一键安装脚本 =========="
echo "本脚本会在你输入后立即写入 .env"
echo "======================================="

# ---- 创建空 .env 文件 ----
rm -f .env
touch .env

# ---- 用户交互输入（逐项写入） ----
read -p "请输入 ETH 地址: " ETH_ADDRESS
echo "ETH_ADDRESS=\"$ETH_ADDRESS\"" >> .env
echo "已写入 ETH_ADDRESS 到 .env"

read -p "请输入 OM_API_KEY: " OM_API_KEY
echo "OM_API_KEY=\"$OM_API_KEY\"" >> .env
echo "已写入 OM_API_KEY 到 .env"

read -p "请输入 机器人 ID (URID): " URID
echo "URID=\"$URID\"" >> .env
echo "已写入 URID 到 .env"

echo ""
echo "当前 .env 文件内容："
cat .env
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

# ---- 移动 .env 到项目根目录 ----
echo "[5/7] 拷贝 .env 到项目目录..."
cp ../.env .

# ---- 加载环境 ----
echo "[6/7] 加载环境变量..."
source .env

# ---- 完成 ----
echo "[7/7] 安装完成！"

echo "======================================"
echo "你现在可以运行："
echo "  uv run src/run.py conversation"
echo "======================================"
