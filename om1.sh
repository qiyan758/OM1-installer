#!/usr/bin/env bash
set -e

echo "======================================"
echo "       🚀 OM1 自动安装脚本 v2.0"
echo "======================================"

# 1) 安装 uv（如无）
echo "[1/8] 检查 uv 是否存在..."
if ! command -v uv &>/dev/null; then
    echo "未检测到 uv，正在安装..."
    curl -LsSf https://astral.sh/uv/install.sh | sh
    echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc
    source ~/.bashrc
    echo "uv 安装成功"
else
    echo "uv 已存在，跳过安装"
fi

# 2) 克隆仓库
echo
echo "[2/8] 克隆 OM1 仓库..."
if [ -d "$HOME/OM1" ]; then
    echo "检测到 OM1 目录已存在，跳过克隆"
else
    git clone https://github.com/OpenManus/OM1.git ~/OM1
fi

# 3) 切换目录
cd ~/OM1

# 4) init submodules
echo
echo "[3/8] 初始化子模块..."
git submodule update --init --recursive

# 5) 创建虚拟环境
echo
echo "[4/8] 创建 uv 虚拟环境..."
if [ -d ".venv" ]; then
    echo "检测到已有虚拟环境，重新创建..."
    rm -rf .venv
fi
uv venv

# 6) 激活环境
echo
echo "[5/8] 激活虚拟环境..."
source .venv/bin/activate

# 7) 写入 .env
echo
echo "[6/8] 写入环境变量 (.env)..."
cat > .env <<EOF
OPENAI_API_KEY=PLEASE_INPUT_KEY
OPERATION_MODE=local
EOF

# 8) 初始化依赖
echo
echo "[7/8] 安装项目依赖..."
uv pip install -r requirements.txt

# 9) 最终检查 uv 是否可用
echo
echo "[8/8] 进行最终 uv PATH 检测..."

if command -v uv &>/dev/null; then
    echo "🎉 uv 检测通过：$(uv --version)"
else
    echo "⚠️ uv 在当前 shell 中不可见，添加路径中..."
    export PATH=$HOME/.local/bin:$PATH
fi

echo
echo "============================================================"
echo "  安装成功！你现在可以运行："
echo
echo "  cd ~/OM1"
echo "  source .venv/bin/activate"
echo "  uv run src/run.py conversation"
echo
echo "============================================================"
