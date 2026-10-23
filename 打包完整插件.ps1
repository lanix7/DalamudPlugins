# 打包「粘贴仓库地址即可下载使用」的插件包
# 只放运行必需的东西：源码 / 测试 / 日志 / 缓存 一律不进包
$ErrorActionPreference = 'Stop'
Add-Type -AssemblyName System.IO.Compression
Add-Type -AssemblyName System.IO.Compression.FileSystem

$repo    = "D:\FF14CJ\lanix第三方仓库"
$plugDir = "D:\FF14CJ\本地插件"
$outDir  = "$repo\_release"
New-Item -ItemType Directory -Force -Path $outDir | Out-Null

$skipDirs  = @('__pycache__', '.git', 'obj', 'bin', 'hands', 'tests')
$skipFiles = @('src.zip', 'test_flow.py', '进度.md', 'server.err.log', 'server.out.log',
               'recorder_state.json', 'packets.log')

function Should-Skip([string]$full) {
    foreach ($d in $skipDirs) {
        if ($full -like "*\$d\*") { return $true }
    }
    $name = Split-Path $full -Leaf
    if ($skipFiles -contains $name) { return $true }
    if ($name -like '*.pyc' -or $name -like '*.log' -or $name -like '*.bak' -or $name -like '*.md') { return $true }
    return $false
}

function Add-File($zip, $full, $entryName) {
    [System.IO.Compression.ZipFileExtensions]::CreateEntryFromFile(
        $zip, $full, $entryName, [System.IO.Compression.CompressionLevel]::Optimal) | Out-Null
}

function Add-Folder($zip, $root, $entryRoot) {
    $n = 0
    foreach ($f in Get-ChildItem $root -Recurse -File) {
        if (Should-Skip $f.FullName) { continue }
        $rel = $f.FullName.Substring($root.Length).TrimStart('\','/').Replace('\','/')
        Add-File $zip $f.FullName ("{0}/{1}" -f $entryRoot, $rel)
        $n++
    }
    Write-Output ("    {0}: {1} 个文件" -f $entryRoot, $n)
}

function New-Zip($path, $build) {
    if (Test-Path $path) { Remove-Item $path -Force }
    $zip = [System.IO.Compression.ZipFile]::Open($path, 'Create')
    try { & $build $zip } finally { $zip.Dispose() }
    $mb = [math]::Round((Get-Item $path).Length/1MB,1)
    Write-Output ("  完成: {0}  {1} MB" -f (Split-Path $path -Leaf), $mb)
}

Write-Output "[1/2] 九宫幻卡 ..."
$t1 = "$plugDir\九宫幻卡"
New-Zip "$outDir\JiuGongHuanKa.zip" {
    param($zip)
    foreach ($n in @("JiuGongHuanKa.dll","JiuGongHuanKa.json","JiuGongHuanKa.deps.json")) {
        $p = Join-Path $t1 $n
        if (Test-Path $p) { Add-File $zip $p $n }
    }
    foreach ($n in @("TTC_Siren.exe","TTC_Siren_PYPY.bat","导入说明.txt")) {
        $p = Join-Path $t1 $n
        if (Test-Path $p) { Add-File $zip $p $n }
    }
    Add-Folder $zip "$t1\TTC_Siren_PYPY" "TTC_Siren_PYPY"
}

Write-Output "[2/2] 多玛方城战 ..."
$t2 = "$plugDir\多玛方城战"
New-Zip "$outDir\Duomafangchengzhan.zip" {
    param($zip)
    foreach ($n in @("Duomafangchengzhan.dll","Duomafangchengzhan.json","Duomafangchengzhan.deps.json")) {
        $p = Join-Path $t2 $n
        if (Test-Path $p) { Add-File $zip $p $n }
    }
    Add-Folder $zip "$t2\Mortal" "Mortal"
}

Write-Output ""
Write-Output "=== 产物 ==="
Get-ChildItem $outDir -File | Select-Object Name, @{n='MB';e={[math]::Round($_.Length/1MB,1)}} | Format-Table -AutoSize
