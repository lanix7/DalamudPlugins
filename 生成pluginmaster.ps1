# 生成 pluginmaster.json（指向 GitHub Release 资源直链）
# 调试完插件、打完包、发完 Release 之后跑这个
$ErrorActionPreference = 'Stop'

# ============ 需要你确认的两项 ============
$owner = "lanix7"              # GitHub 用户名
$repoName = "lanix-plugin-repo" # GitHub 仓库名
$tag = "v1.0.0"                # Release 标签，必须和上传时填的一致
# =========================================

$repo    = "D:\FF14CJ\lanix第三方仓库"
$plugDir = "D:\FF14CJ\本地插件"
$base    = "https://github.com/$owner/$repoName/releases/download/$tag/"
$now     = [int][double]::Parse((Get-Date -UFormat %s))

$t1 = Get-Content "$plugDir\九宫幻卡\JiuGongHuanKa.json" -Raw -Encoding UTF8 | ConvertFrom-Json
$t2 = Get-Content "$plugDir\多玛方城战\Duomafangchengzhan.json" -Raw -Encoding UTF8 | ConvertFrom-Json

function New-Entry($m, $zip, $tags) {
    [ordered]@{
        Author              = $m.Author
        Name                = $m.Name
        Punchline           = $m.Punchline
        Description         = $m.Description
        InternalName        = $m.InternalName
        AssemblyVersion     = $m.AssemblyVersion
        TestingAssemblyVersion = $null
        RepoUrl             = ""
        ApplicableVersion   = "any"
        DalamudApiLevel     = 15
        Tags                = $tags
        IsHide              = $false
        IsTestingExclusive  = $false
        DownloadCount       = 0
        LastUpdate          = $now
        DownloadLinkInstall = "$base$zip"
        DownloadLinkUpdate  = "$base$zip"
        DownloadLinkTesting = "$base$zip"
        LoadRequiredState   = 0
        LoadSync            = $false
        CanUnloadAsync      = $false
        LoadPriority        = 0
        IconUrl             = ""
    }
}

$list = @(
    (New-Entry $t1 "JiuGongHuanKa.zip"       @("Triple Triad","Gold Saucer","Tournament","九宫幻卡")),
    (New-Entry $t2 "Duomafangchengzhan.zip"  @("Mahjong","Doman Mahjong","Mortal","多玛方城战"))
)

$json = ConvertTo-Json -InputObject $list -Depth 6
[System.IO.File]::WriteAllText("$repo\pluginmaster.json", $json, (New-Object System.Text.UTF8Encoding($false)))

Write-Output "已生成 pluginmaster.json"
Write-Output "订阅地址: https://raw.githubusercontent.com/$owner/$repoName/main/pluginmaster.json"
Write-Output "下载直链: $base"
