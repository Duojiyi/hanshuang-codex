# 把「提示词副本」里改好的提示词按原相对路径覆盖回项目
# 用法：在项目根执行  .\提示词副本\_覆盖回写.ps1
# 覆盖前原文件备份到  提示词副本\_覆盖前备份\<相同相对路径>

$ErrorActionPreference = 'Stop'

$copyRoot = $PSScriptRoot
$projRoot = Split-Path -Parent $copyRoot
$backup   = Join-Path $copyRoot '_覆盖前备份'

if (-not (Test-Path -LiteralPath (Join-Path $projRoot 'package.json'))) {
    throw "项目根定位失败：$projRoot 下没有 package.json"
}

$files = Get-ChildItem -LiteralPath $copyRoot -Recurse -File |
    Where-Object { $_.Name -notlike '_*' -and $_.FullName -notlike "*\_覆盖前备份\*" }

$done = 0
$skip = @()
foreach ($f in $files) {
    $rel = $f.FullName.Substring($copyRoot.Length + 1)
    $dst = Join-Path $projRoot $rel

    if (-not (Test-Path -LiteralPath $dst)) {
        $skip += $rel
        continue
    }

    $bak = Join-Path $backup $rel
    New-Item -ItemType Directory -Force -Path (Split-Path -Parent $bak) | Out-Null
    Copy-Item -LiteralPath $dst -Destination $bak -Force
    Copy-Item -LiteralPath $f.FullName -Destination $dst -Force
    $done++
}

Write-Host "已覆盖 $done 个提示词文件"
if ($skip.Count -gt 0) {
    Write-Host "跳过 $($skip.Count) 个（原位置不存在）："
    $skip | ForEach-Object { Write-Host "  $_" }
}
Write-Host "覆盖前的原文件备份在：$backup"
