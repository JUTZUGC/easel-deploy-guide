#!/usr/bin/env bash
set -euo pipefail
# Easel 一键部署脚本（第三方指南）——按官方文档封装
# 官方文档：https://github.com/ZJU-REAL/Easel#-快速开始
# 更新日期：2026-10-26
# 类型：script
cd "$(dirname "${BASH_SOURCE[0]}")"

command -v git >/dev/null 2>&1 || { echo "需要先安装 Git"; exit 1; }
command -v python3 >/dev/null 2>&1 || command -v python >/dev/null 2>&1 || { echo "需要先安装 Python 3"; exit 1; }
command -v node >/dev/null 2>&1 || { echo "需要先安装 Node.js"; exit 1; }

mkdir -p .download
cd .download

git clone https://github.com/ZJU-REAL/Easel
cd Easel
bash setup.sh
nohup .venv/bin/easel web > easel-web.log 2>&1 &
echo "工作台已在后台启动，日志：easel-web.log"

echo ""
if command -v curl >/dev/null 2>&1; then
  echo "等待服务启动：http://127.0.0.1:7860"
  ready=0
  for _ in $(seq 1 30); do
    if curl -sS -o /dev/null "http://127.0.0.1:7860" 2>/dev/null; then ready=1; break; fi
    sleep 2
  done
  if [ "$ready" = "1" ]; then
    echo "服务已就绪"
  else
    echo "警告：60 秒内未探测到 http://127.0.0.1:7860，请手动打开确认或查看日志"
    exit 1
  fi
else
  echo "未检测到 curl，跳过启动探测；请手动访问 http://127.0.0.1:7860 确认"
fi
echo "部署完成：打开 http://127.0.0.1:7860，先到「设置 → 模型配置」填 API Key；发布前要在各平台完成登录"
echo "若结果异常或需要改配置，请参考官方文档：https://github.com/ZJU-REAL/Easel#-快速开始"
