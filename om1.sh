#!/bin/bash
# ======================================
# OM1 Linux One-click Installer
# 自动安装 uv + 逐项输入即时写入
# ======================================

echo "========== OM1 一键安装脚本 =========="

# ---------- 创建 env 文件 ----------
rm -f .env
touch .env

# ---------- 用户输入(逐项写入) ----------
read -p "请输入 ETH 地址: " ETH_ADDRESS
echo "ETH_ADDRESS=\"$ETH_ADDRESS\"" >> .env
echo "已写入 ETH_ADDRESS"

read -p "请输入 OM_API_KEY: " OM_API_KEY
echo "OM_API_KEY=\"$OM_API_KEY\"" >> .env
echo "已写入 OM_API_KEY"

read -p "请输入 机器人 ID (URID): " URID
echo "URID=\"$URID\"" >> .env
echo "已写入 URID"

echo "当前 .env 内容如下:"
cat .env
echo ""

# ---------- 安装系统依赖 ----------
echo "[1/8] 安装系统依赖..."
sudo apt update
sudo apt install -y git ffmpeg portaudio19-dev curl python3-pip

# ---------- 检查 uv ----------
echo "[2/8] 检查 uv 是否已安装..."

if ! command -n uv &> /dev/null; then
    echo "未检测到 uv，正在安装..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    export PATH="$HOME/.local/bin:$PATH"
else
    echo "uv 已存在"
fi

# 再次确保 PATH 生效
export PATH="$HOME/.local/bin:$PATH"

# ---------- 克隆项目 ----------
echo "[3/8] 克隆 OM1 仓库..."
git clone https://github.com/OpenMind/OM1.git || true
cd OM1 || exit

# ---------- 初始化子模块 ----------
echo "[4/8] 初始化子模块..."
git submodule update --init

# ---------- 创建虚拟环境 ----------
echo "[5/8] 创建 uv 虚拟环境..."
uv venv

# ---------- 拷贝 env ----------
echo "[6/8] 拷贝 .env 到项目目录..."
cp ../.env .

# ---------- 加载环境 ----------
echo "[7/8] 加载环境变量..."
source .env

# ---------- 完成 ----------
echo "[8/8] 安装完成！"

echo "======================================"
echo "运行对话功能："
echo "  uv run src/run.py conversation"
echo "======================================"
