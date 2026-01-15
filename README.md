---
marp: true
theme: TsinghuaPPT
paginate: true
---

<!-- backgroundImage: url("../images/title.png") -->

# 🏎️ Tianracer Formula Mini 开源指南

**方寸之间，自有天地。**
Powered by [Tianbot](https://www.tianbot.com/)

---

## 📖 项目简介

**Tianracer Formula Mini** 是一款专为自动驾驶算法验证设计的微缩竞技平台。它参考了国际 **F1TENTH** 的工程逻辑，旨在为国内开发者提供一个精密、纯粹的物理验证环境。

### 核心理念
- **拒绝“纯仿真”**：在真实的摩擦力、惯性与传感器噪声中打磨算法。
- **拥抱工程约束**：在有限的硬件资源（RDK X5）下追求极致的代码效率。
- **从赛道到实车**：完美衔接微缩赛车与全尺寸自动驾驶实车的开发逻辑。

---

## 🛠️ 技术规格

| 类别 | 规格参数 |
| :--- | :--- |
| **计算平台** | RDK X5 (8 核 ARM, 10TOPS 算力) |
| **操作系统** | Ubuntu 22.04 + ROS1 Noetic / ROS2 Humble |
| **传感器** | 1080p USB 相机 + dToF 激光雷达 + IMU (卡尔曼滤波) |
| **底盘结构** | 阿克曼式转向 + 独立悬挂 + 四驱系统 |
| **最高速度** | 4.0 m/s |

---


## 🚀 快速启动

### 1. 物理连接
通过 USB-C 线缆连接电脑与小车（USB2 接口），确认系统识别为 NDIS 网络设备。

### 2. SSH 登录
```bash
# 默认内网 IP
ssh sunrise@192.168.128.10
# 默认密码: sunrise
```

### 3. 指令驱动
```bash
# 启动底盘心脏
roslaunch tianracer_core tianracer_core.launch
```

---

## 🖊️ 编写与预览 (Marp Ecosystem)

本项目文档基于 **Marp** 规范编写，建议在 **Visual Studio Code** 中安装 **[Marp for VS Code](https://marketplace.visualstudio.com/items?itemName=marp-team.marp-vscode)** 插件。

### 如何高效工作？
1. **安装插件**：在插件市场搜索并安装 `Marp for VS Code`。
2. **实时预览**：点击编辑器右上角的 **Marp 图标** (或按 `Ctrl + Shift + V`)，即可实时看到幻灯片效果。
3. **导出 PDF**：除了插件自带的导出功能，我们推荐使用下文提到的 `export_docs` 脚本进行批量导出。

> ⚠️ **重要提示**：为避免 Windows 环境下的中文乱码，编写时请务必确保文件编码为 **UTF-8 with BOM** (utf-8-sig) 格式。

---

## 🤝 贡献指南

我们非常欢迎社区开发者的参与！你可以通过以下方式协助我们：
- 🌟 在 GitHub 上为本项目点击 **Star**。
- 🐛 提交 [Issue](https://github.com/tianbot/tianracer/issues) 反馈 Bug 或建议。
- 📝 提交 [Pull Request](https://github.com/tianbot/tianracer/pulls) 改进文档或核心算法。
- 💬 在社区分享你的创新应用场景。

---

## 📄 文档导出 (Marp to PDF)

为了方便教学演示与分发，项目提供了一键式的 PDF 导出脚本（支持一键导出 `docs/` 下所有教程）：

### 如何使用 (Windows/PowerShell)
1. **导出全量文档**：
   ```powershell
   .\export_docs.ps1
   ```
2. **导出单个指定文档**：
   ```powershell
   .\export_docs.ps1 -File "4.linux_ros_basic.md"
   ```

### 如何使用 (Linux/Ubuntu Bash)
1. **导出全量文档**：
   ```bash
   ./export_docs.sh
   ```
2. **导出单个指定文档**：
   ```bash
   ./export_docs.sh 4.linux_ros_basic.md
   ```

> 💡 **小助手提示**：
> - 脚本会自动调用 `npx @marp-team/marp-cli`，只需你的电脑安装了 [Node.js](https://nodejs.org/) 即可运行。
> - 导出的 PDF 文件将统一保存在根目录的 `export_pdf/` 文件夹中。
> - 运行脚本前，请确保在项目根目录下操作。

---

## ⚖️ 开源协议

本项目采用 **Creative Commons Attribution Share Alike 4.0 International** (CC BY-SA 4.0) 协议授权。

你可以自由地：
- **分享** — 在任何媒介上以任何形式拷贝、发行本作品。
- **演绎** — 修改、转换或以本作品为基础进行创作。

只要遵守许可协议条款，许可人就不能撤回这些自由。

---

<!-- _footer: © 2026 Tianbot Team. 方寸之间，自有天地。 -->

# 🏁 开始你的自动驾驶之旅吧！

---
![bg opacity:.1](../images/thanks.png)
