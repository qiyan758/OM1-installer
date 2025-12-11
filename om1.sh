#!/usr/bin/env bash
set -e

echo "======================================"
echo "       🚀 OM1 自动安装脚本 v3.0"
echo "======================================"

# -------------------------------
# 1) 安装 uv （并强制修复 PATH）
# -------------------------------
echo "[1/8] 检查 uv 是否存在..."
if ! command -v uv &>/dev/null; then
    echo "未检测到 uv，正在安装..."
    curl -LsSf https://astral.sh/uv/install.sh | sh

    # 写入 PATH
    echo 'export PATH=$HOME/.local/bin:$PATH' >> ~/.bashrc

    # 强制立即生效 PATH
    export PATH=$HOME/.local/bin:$PATH

    # 第三层保险：软链接到 /usr/local/bin（系统范围可用）
    if [ -f "$HOME/.local/bin/uv" ]; then
        ln -sf $HOME/.local/bin/uv /usr/local/bin/uv
        ln -sf $HOME/.local/bin/uvx /usr/local/bin/uvx
    fi

    echo "uv 安装成功（PATH 已强制修复）"
else
    echo "uv 已存在，跳过安装"
fi

# 再检查一次 uv
if ! command -v uv &>/dev/null; then
    echo "❌ uv 仍不可用，终止安装"
    exit 1
fi

# -------------------------------
# 2) 克隆仓库
# -------------------------------
echo
echo "[2/8] 克隆 OM1 仓库..."
if [ -d "$HOME/OM1" ]; then
    echo "检测到 OM1 目录已存在，跳过克隆"
else
    git clone https://github.com/OpenManus/OM1.git ~/OM1
fi

cd ~/OM1

# -------------------------------
echo "[3/8] 初始化子模块..."
git submodule update --init --recursive

# -------------------------------
echo
echo "[4/8] 创建 uv 虚拟环境..."
rm -rf .venv || true
uv venv   # 这里 uv 必须可用 → v3.0 保障了这一点

# -------------------------------
echo
echo "[5/8] 激活虚拟环境..."
source .venv/bin/activate

# -------------------------------
echo
echo "[6/8] 写入 .env..."
cat > .env <<EOF
OPENAI_API_KEY=PLEASE_INPUT_KEY
OPERATION_MODE=local
EOF

# -------------------------------
echo
echo "[7/8] 安装依赖..."
uv pip install -r requirements.txt

# -------------------------------
echo
echo "[8/8] 最终检测 uv 可用性..."
echo "uv 版本：$(uv --version)"

echo
echo "============================================================"
echo "  安装成功！你现在可以运行："
echo
echo "  cd ~/OM1"
echo "  source .venv/bin/activate"
echo "  uv run src/run.py conversation"
echo
echo "============================================================"
