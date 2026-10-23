# lanix 第三方插件仓库

Dalamud（卫月）第三方插件源。填入地址即可订阅，**订阅后下载就能直接用**（AI 后端已打进安装包）。

## 订阅地址

```
https://raw.githubusercontent.com/lanix7/lanix-plugin-repo/main/pluginmaster.json
```

游戏里：

1. `/xlsettings` → **实验性** → **自定义插件仓库**
2. 粘贴上面的地址 → 点 **+** → 保存
3. `/xlplugins` → **所有插件** → 找到插件 → 安装

## 收录插件

| 插件 | 内部名 | 说明 |
|---|---|---|
| **九宫幻卡** | `JiuGongHuanKa` | 基于 I佬 自动锦标赛插件修改，修复窗口 + 全场景幻卡 |
| **多玛方城战** | `Duomafangchengzhan` | 本地 Mortal 神经网络驱动的多玛方城战打牌助手 |

## 安装包里已经包含什么

两个插件都把 AI 后端打进了 zip，安装后无需额外配置：

| 插件 | 包内后端 | 大小 |
|---|---|---|
| 九宫幻卡 | `TTC_Siren.exe` + `TTC_Siren_PYPY\` | ~156 MB |
| 多玛方城战 | `Mortal\`（含 venv、mortal.pth 模型） | ~340 MB |

插件会自动在**自己 DLL 所在目录**寻找后端并静默拉起（无控制台窗口），卸载插件时自动关闭后端。

## 仓库结构

```
pluginmaster.json        Dalamud 插件源清单（指向 Release 资源直链）
打包完整插件.ps1          把两个插件连后端一起打成 zip，输出到 _release\
生成pluginmaster.ps1     按 Release 标签重新生成 pluginmaster.json
README.md
```

完整安装包体积超过 GitHub 单文件 100 MB 限制，**不进 git**，放在 **Releases** 里。

## 发布流程（改完插件后）

```powershell
# 1. 重新编译两个插件，把新 DLL 复制到 D:\FF14CJ\本地插件\<插件名>\
# 2. 打包（产物在 _release\）
powershell -ExecutionPolicy Bypass -File .\打包完整插件.ps1

# 3. 去 GitHub 建一个 Release，标签如 v1.0.1
#    把 _release\ 里的两个 zip 作为附件上传

# 4. 改 生成pluginmaster.ps1 顶部的 $tag 为新标签，重新生成清单
powershell -ExecutionPolicy Bypass -File .\生成pluginmaster.ps1

# 5. 提交推送
git add -A
git commit -m "更新到 v1.0.1"
git push
```

> 如果 GitHub 用户名或仓库名不是 `lanix7/lanix-plugin-repo`，改 `生成pluginmaster.ps1` 顶部的 `$owner` / `$repoName` 再重新生成。
