<#
.SYNOPSIS
    Tianracer Formula Mini 文档导出工具 (Marp to PDF)

.DESCRIPTION
    该脚本用于将 docs 文件夹下的 Markdown 文件导出为 PDF 格式。
    支持导出全部文档或指定单个文档。

.PARAMETER File
    指定要导出的文件名（例如：1.index.md）。如果不指定，则导出 docs 下的所有 .md 文件。

.EXAMPLE
    .\export_docs.ps1
    导出所有文档。

.EXAMPLE
    .\export_docs.ps1 -File "4.linux_ros_basic.md"
    仅导出指定的 Linux 基础教程。
#>

param (
    [string]$File
)

# 确保在项目根目录运行
$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
Set-Location $PSScriptRoot

$DocsPath = ".\docs"
$OutputPath = ".\export_pdf"

# 检查是否存在导出目录，不存在则创建
if (-not (Test-Path $OutputPath)) {
    New-Item -ItemType Directory -Path $OutputPath | Out-Null
    Write-Host "创建导出目录: $OutputPath" -ForegroundColor Gray
}

# 检查是否安装了 Marp CLI (通过 npx)
if (-not (Get-Command "npx" -ErrorAction SilentlyContinue)) {
    Write-Host "[错误] 未找到 Node.js/npx。请从 https://nodejs.org/ 安装 Node.js。" -ForegroundColor Red
    exit
}

function Export-MarpFile {
    param([string]$FilePath)
    $FileName = Split-Path -Leaf $FilePath
    $OutFile = Join-Path $OutputPath ($FileName.Replace(".md", ".pdf"))
    
    Write-Host "---"
    Write-Host "正在转换: $FileName" -ForegroundColor Cyan
    
    # 使用 npx 运行 marp-cli
    # --allow-local-files 允许加载本地图片
    npx @marp-team/marp-cli@latest $FilePath --pdf --allow-local-files -o $OutFile
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "成功导出至: $OutFile" -ForegroundColor Green
    } else {
        Write-Host "导出失败: $FileName" -ForegroundColor Red
    }
}

if ($File) {
    if ($File -notlike "*.md") { $File += ".md" }
    $TargetFile = Join-Path $DocsPath $File
    if (Test-Path $TargetFile) {
        Export-MarpFile -FilePath $TargetFile
    } else {
        Write-Host "[错误] 找不到指定文件: $TargetFile" -ForegroundColor Red
    }
} else {
    Write-Host "=== 开始全量导出 Tianracer 教学文档 ===" -ForegroundColor Yellow
    $MdFiles = Get-ChildItem -Path $DocsPath -Filter "*.md"
    $count = 0
    foreach ($MdFile in $MdFiles) {
        # 过滤掉备份文件或 README
        if ($MdFile.Name -like "*copy*" -or $MdFile.Name -like "README*") { continue }
        Export-MarpFile -FilePath $MdFile.FullName
        $count++
    }
    Write-Host "=== 任务统计: 已成功处理 $count 个文档 ===" -ForegroundColor Yellow
}

Write-Host "`n所有任务已结束。请在 $OutputPath 文件夹中查看结果。" -ForegroundColor Green
