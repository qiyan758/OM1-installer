

## 🚀 OM1 一键安装脚本（Linux）

在 VPS 或本地 Linux 上执行以下命令即可开始安装：

```bash
wget -O om1.sh https://raw.githubusercontent.com/<你的GitHub用户名>/<仓库名>/main/om1.sh \
&& sed -i 's/\r$//' om1.sh \
&& chmod +x om1.sh \
&& ./om1.sh
```

脚本会自动提示你输入：

* ETH 地址
* API KEY
* 机器人 ID

并会 **每输入一项立即保存到 .env**。

---

## 📌 安装完成后运行对话功能：

```bash
uv run src/run.py conversation
```

---

## 🔍 音频硬件测试（可选）

```bash
python test_audio.py
```

---


