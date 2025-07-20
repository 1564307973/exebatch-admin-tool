# exebatch-admin-tool

<p align="center">
  <img src="https://img.shields.io/badge/Platform-Windows-blue?logo=windows" alt="platform"/>
  <img src="https://img.shields.io/badge/License-MIT-green" alt="license"/>
  <img src="https://img.shields.io/badge/Language-Batch%20%2F%20FOR-blueviolet" alt="batch"/>
  <img src="https://img.shields.io/badge/For-Legacy%20Software%20%7C%20IT%20Admin-orange" alt="for"/>
</p>

<p align="center">
  <!-- 微软终端 LOGO（ICO） -->
  <img src="https://raw.githubusercontent.com/microsoft/terminal/refs/heads/main/res/console.ico" alt="Microsoft Terminal Logo" width="96"/>
</p>

🛡️ 批量设置/清除 EXE 管理员权限脚本

## 项目简介

- 批量设置/清除 EXE 管理员权限
- 查询当前权限状态
- 自动排除系统关键目录，防止误操作
- 彩色菜单，操作直观

## 适用场景

- 旧版/行业软件批量设置管理员权限，解决兼容性或权限不足
- 批量恢复默认权限，便于环境还原和维护
- 适合 IT 管理员、软件维护人员、个人用户

## 使用方法

1. 将 `exe_compat_manager.bat` 放在需批量操作的目录（如 `D:\jlc-dfm`、`D:\Program Files\jlcCAM` 等）
2. 右键“以管理员身份运行”该脚本
3. 按菜单提示选择批量设置、清除或查询 EXE 管理员权限

> ⚠️ 建议仅在信任的业务软件目录下使用，勿在系统盘根目录、桌面等位置运行，避免误操作

## 功能特性

- 🛡️ 一键批量设置所有 EXE 以管理员身份运行
- ♻️ 一键批量清除所有 EXE 管理员权限
- 🔍 查询所有 EXE 当前权限状态
- 🚫 自动排除系统关键目录，防止误操作
- 🌈 彩色菜单与高亮提示，界面美观

## 许可证

[MIT License](./LICENSE)

## 贡献

欢迎 issue、PR 与建议！如有更好的批处理技巧、兼容性建议或美化想法，欢迎提交。

## 开源声明

- 遵循 MIT 许可证，欢迎自由传播、二次开发和开源使用。

---
