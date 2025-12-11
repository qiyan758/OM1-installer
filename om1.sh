#!/bin/bash
set -e  # 任何错误立即停止脚本，防止连续报错

echo -e "\n================== OM1 一键安装脚本（完美版） ==================\n"

# ---------- 步骤 0：准备 ----------
WORKDIR=$(pwd)
ENV_FILE="$WORKDIR/.env"

rm -f "$ENV_FILE"
touch "$ENV_FILE"

# ---------- 步骤 1：逐项输入并即时写入 .env ----------
read -p "请输入 ETH 地址: " ETH_ADDRESS
echo "ETH_ADDRESS=\"$ETH_ADDRESS\"" >> "$ENV_FILE"

read -p "请输入 OM_API_KEY: " OM_API_KEY
echo "OM_API_KEY=\"$OM_API_KEY\"" >> "$ENV_FILE"

read -p "请输入 机器人 ID (URID): " URID
echo "URID=\"$URID\"" >> "$ENV_FILE"

echo -e "\n.env 内容如下："
cat "$ENV_FILE"
echo ""

# ---------- 步骤 2：安装依赖 ----------
echo -e "\n[1/8] 安装系统依赖..."
sudo apt update
sudo apt install -y git ffmpeg portaudio19-dev curl python3-pip

# ---------- 步骤 3：安装 uv（如不存在） ----------
echo -e "\n[2/8] 检查 uv 是否存在..."

if ! command -v uv >/dev/null 2>&1; then
    echo "未检测到 uv，正在安装..."
    curl -LsSf https://astral.sh/uv/install.sh | sh

    # 自动添加 PATH（永久）
    echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
    export PATH="$HOME/.local/bin:$PATH"

    echo "uv 安装成功"
else
    echo "uv 已安装"
fi

# 再次确保 PATH 正确
export PATH="$HOME/.local/bin:$PATH"

# ---------- 步骤 4：克隆仓库 ----------
echo -e "\n[3/8] 克隆 OM1 仓库..."

if [ -d "OM1" ]; then
    echo "检测到 OM1 目录已存在，跳过克隆"
else
    git clone https://github.com/OpenMind/OM1.git
fi

cd OM1

# ---------- 步骤 5：初始化子模块 ----------
echo -e "\n[4/8] 初始化子模块..."
git submodule update --init

# ---------- 步骤 6：创建虚拟环境 ----------
echo -e "\n[5/8] 创建 uv 虚拟环境..."
uv venv

# 自动激活 venv（对当前脚本生效）
source .venv/bin/activate

# ---------- 步骤 7：写入 env ----------
echo -e "\n[6/8] 设置环境变量..."
cp "$ENV_FILE" .env
source .env

# ---------- 步骤 8：完成 ----------
echo -e "\n[7/8] 环境已准备完毕"
echo -e "[8/8] 一切顺利安装完成！ 🎉\n"

echo "============================================================"
echo "你现在可以直接运行："
echo ""
echo "  cd ~/OM1"
echo "  source .venv/bin/activate"
echo "  uv run src/run.py conversation"
echo ""
echo "============================================================"
