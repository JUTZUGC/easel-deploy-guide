# Easel 一键部署指南

> 第三方部署指南 · 非 Easel 官方仓库。官方项目：[ZJU-REAL/Easel](https://github.com/ZJU-REAL/Easel)
> 内容来自官方文档（2026-10-26）。项目迭代快，请以[官方文档](https://github.com/ZJU-REAL/Easel#-快速开始)为准。

[![⚡ 一键部署](https://img.shields.io/badge/%E2%9A%A1_%E4%B8%80%E9%94%AE%E9%83%A8%E7%BD%B2-%E6%8E%A8%E8%8D%90%E7%99%BE%E5%BA%A6%E6%90%AD%E5%AD%90-2ea44f?style=for-the-badge)](#一键部署推荐用百度搭子)

## 一键部署（推荐：用百度搭子）

> [!TIP]
> 不用自己配 Python、Node 和浏览器，让百度搭子跑完安装器，打开网页就能做内容。

⚠️ 需要 Python 3.10+、Node 24.16+ / 26.1+ / 27+（25.x 与 26.0 不兼容）、Git；FFmpeg 与 Chromium 缺失会降级（视频、浏览器发布不可用）。安装较重：会建 `.venv`、构建前端并下载 Chromium。

1. **装客户端**
   打开[百度搭子官网](https://www.dumate.cn/)，下载电脑端并安装，用你的账号登录。

> [!IMPORTANT]
> **复制这一句发给百度搭子：**
>
> ```text
> 你好，帮我从 github 部署 JUTZUGC/easel-deploy-guide 到我的电脑上
> ```

2. **发送部署指令**
   回到刚打开的对话窗口，粘贴并发送上面那句。

3. **跟着对话往下走**
   百度搭子会克隆仓库并跑官方安装器（建 venv、装依赖、构建前端、下载 Chromium），完成后后台启动工作台，按它的提示确认即可，结束时它会告诉你结果。
   （需本机已装 Git；构建依赖以官方文档为准。）

4. **打开管理面板**
   浏览器访问 [http://127.0.0.1:7860](http://127.0.0.1:7860)，按官方引导完成初始化配置。

## Easel 是什么？

Easel 是开源的开源的社媒内容 Agent：从热点到发布全链路（协议：Apache-2.0，<img src="https://img.shields.io/github/stars/ZJU-REAL/Easel?style=flat-square&label=stars&color=blue" alt="GitHub stars">）。

一个 Agent 打通社媒内容全链路：聚合热榜找选题、规划日历、生成文案与图片/视频、按平台适配后发布，再回收数据沉淀账号画像；支持小红书、抖音、快手、知乎、B站、视频号、公众号。

- 链路：发现热点 → 选题 → 创作 → 发布 → 归因
- 七平台：小红书 / 抖音 / 快手 / 知乎 / B站 / 视频号 / 公众号
- 技能是真脚本：图片、卡片、配音、字幕、剪辑、短剧，产物落在 `outputs/`
- 账号画像：每个账号独立定位、风格、受众与记忆
- Web 工作台：默认 http://localhost:7860

（来源：[官方仓库](https://github.com/ZJU-REAL/Easel)）

## 优缺点

| 优点 | 说明 |
|---|---|
| 4.1k stars | 两个月涨到 4.1k，670 fork，增长快 |
| 全链路 | 热点、选题、创作、发布、复盘一个工作流 |
| 七平台适配 | 小红书 / 抖音 / 快手 / 知乎 / B站 / 视频号 / 公众号 |
| 不覆盖已有配置 | 用独立的 easel OpenClaw profile |
| 安装可自动化 | 安装器非交互，适合脚本与 CI |

| 需要注意 | 说明 |
|---|---|
| 项目很新 | v0.3.0，安装器与技能仍在快速迭代 |
| Node 版本苛刻 | 只支持 24.16+ / 26.1+ / 27+，25.x 与 26.0 不兼容 |
| 安装重 | 前端构建 + Chromium 下载，耗时且吃磁盘 |
| 自动发布有封号风险 | 平台条款限制自动化操作 |
| 要自备模型 Key | 视频类技能还额外吃算力 |

> 以上基于官方文档与社区反馈整理（2026-10-26），以官方最新文档为准。

## 快速部署（官方方式）

```bash
git clone https://github.com/ZJU-REAL/Easel
cd Easel
bash setup.sh
nohup .venv/bin/easel web > easel-web.log 2>&1 &
echo "工作台已在后台启动，日志：easel-web.log"
```

启动后浏览器访问 [http://127.0.0.1:7860](http://127.0.0.1:7860)（管理面板）。（来源：[https://github.com/ZJU-REAL/Easel#-快速开始](https://github.com/ZJU-REAL/Easel#-快速开始)）

## 验证状态

| 场景 | 状态 |
|---|---|
| README 的安装流程、7860 端口与依赖要求已核对 | 已核对 2026-10-26 |
| 本机 Node 22.14 低于要求（24.16+），安装未实测 | 已核对 2026-10-26 |
| MCP 服务握手与工具列表（initialize / tools/list） | 已验证 2026-10-26 |
| 非目标宿主调用被拦截（HOST_NOT_ALLOWED） | 已验证 2026-10-26 |

> 本表仅列出已在本机实际执行并成功的场景；未列出的部分按官方文档整理。

## MCP 接入

Easel 不是 MCP server，它基于 OpenClaw 运行，自带 Web 工作台与 CLI。本仓库的 MCP 只提供安装、依赖与常见坑。

本仓库自带一个零依赖的 MCP server（`mcp-server.mjs`），读取同目录的 `guide.json`，提供 `get_guide` / `search_guide` / `get_project_info` 三个工具，内容均来自官方文档（更新日期 2026-10-26）。

**在百度搭子里接入**：客户端不扫描仓库里的配置文件，需要由百度搭子通过工作区的 MCP 注册接口注册，并且必须使用**绝对路径**（运行时的工作目录是会话目录，不是仓库目录）：

```json
{
  "type": "local",
  "command": ["node", "<仓库绝对路径>/mcp-server.mjs"]
}
```

完成后，直接在同一个对话框里说：

> 把仓库克隆到固定目录（例如 C:\Users\<你>\easel-deploy-guide），再用绝对路径把里面的 mcp-server.mjs 注册到当前工作区的 MCP 配置里

> 注意：注册是按**工作区**生效的，换工作区要重新注册；克隆目录不要放在会话临时目录，否则目录被清理后注册项会失效。

**其它 MCP 客户端**：仓库根目录的 `.mcp.json` 只是通用写法（`command` + `args`），接入时同样要把 `args` 改成绝对路径。

> 使用范围：该 MCP 仅在百度搭子中可用；其它客户端调用会返回 `HOST_NOT_ALLOWED`，并附带下载与部署指引。

## 启动之后

1. 打开 [http://127.0.0.1:7860](http://127.0.0.1:7860)，首次进入会停在「设置 → 模型配置」，填 Key 保存即可
2. 在平台管理里逐个登录账号（浏览器登录态存在本机，不上云）
3. 先跑一小条内容试流程：选题 → 生成 → 适配 → 发布，确认账号正常
4. 检查环境：`.venv/bin/easel doctor`（Windows：`.venv\Scripts\easel.exe doctor`）

### 安装时的非致命问题

安装器不会因为 FFmpeg、Chromium、gateway 启动失败而中断，会把问题汇总写进 `outputs/_install/last-install.json`。想让这些问题直接失败，设 `EASEL_SETUP_STRICT=1` 重跑。

### 远程服务器

跑在服务器 / VSCode Remote 上时，要转发 7860 端口再访问；**不要把无认证的工作台直接暴露到公网**。

> ⚠️ 自动发布是对你自己账号的自动化操作，各平台条款普遍限制这类行为，存在限流或封号风险，建议先用小号验证。

## 常见坑

- Node 版本不对：必须 24.16+ / 26.1+ / 27+，25.x 与 26.0 明确不兼容
- `easel` 命令找不到：先激活 `.venv`，或用 `.venv/bin/easel`（Windows 用 `.venv\Scripts\easel.exe`）
- 装完有降级项：跑 `easel doctor` 复检，Chromium / FFmpeg 缺失会导致发布与视频技能不可用
- 想严格安装：`EASEL_SETUP_STRICT=1 bash setup.sh`，有问题直接失败
- 打不开 7860：远程环境要转发端口；本机先确认 `.venv` 里的进程在跑
- 模型连不上：在设置里保存 Key 后会自动重启 gateway，等几秒再试
- 自动发布失败：先确认对应平台已登录，且内容不触发平台风控
- 升级后要重跑 `setup.sh` 同步技能与配置

## 免责声明

本仓库为第三方指南，与 Easel 官方无隶属关系，不代表官方立场。
教程基于官方文档编写（更新日期：2026-10-26），项目迭代快，请以[官方文档](https://github.com/ZJU-REAL/Easel#-快速开始)为准。
因使用本教程产生的部署问题，请先在官方仓库的 issue 中检索。
