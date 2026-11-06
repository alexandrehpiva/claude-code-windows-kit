# Funcoes auxiliares do instalador. Mantidas separadas de install.ps1 para poderem ser testadas.
# Arquivo em ASCII de proposito: o Windows PowerShell 5.1 le .ps1 sem BOM como ANSI.

function Write-Step([string]$Text) { Write-Host ""; Write-Host "== $Text" -ForegroundColor Cyan }
function Write-Info([string]$Text) { Write-Host "   $Text" }
function Write-Ok([string]$Text)   { Write-Host "   [ok] $Text" -ForegroundColor Green }
function Write-Warn2([string]$Text){ Write-Host "   [aviso] $Text" -ForegroundColor Yellow }
function Write-Err([string]$Text)  { Write-Host "   [erro] $Text" -ForegroundColor Red }

function Test-Command([string]$Name) {
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

function Update-SessionPath {
    # Recarrega o PATH (maquina + usuario) na sessao atual, para enxergar o que acabou de ser instalado.
    $machine = [Environment]::GetEnvironmentVariable('Path', 'Machine')
    $user    = [Environment]::GetEnvironmentVariable('Path', 'User')
    $env:Path = (@($machine, $user) | Where-Object { $_ }) -join ';'
}

function Add-UserPathEntry([string]$Dir) {
    # Acrescenta $Dir ao PATH do usuario (permanente) e da sessao, sem duplicar.
    $user = [Environment]::GetEnvironmentVariable('Path', 'User')
    $parts = @()
    if ($user) { $parts = $user.Split(';') | Where-Object { $_ } }
    $already = $parts | Where-Object { $_.TrimEnd('\') -ieq $Dir.TrimEnd('\') }
    if (-not $already) {
        $new = (@($parts) + $Dir) -join ';'
        [Environment]::SetEnvironmentVariable('Path', $new, 'User')
    }
    if (-not (($env:Path.Split(';')) | Where-Object { $_.TrimEnd('\') -ieq $Dir.TrimEnd('\') })) {
        $env:Path = "$env:Path;$Dir"
    }
}

function Get-NodeMajor {
    # Devolve o numero maior da versao do Node (ex.: 22) ou 0 se nao houver Node.
    if (-not (Test-Command 'node')) { return 0 }
    try {
        $v = (& node --version 2>$null | Out-String).Trim()
        if ($v -match '^v(\d+)\.') { return [int]$Matches[1] }
    } catch { }
    return 0
}

function ConvertTo-NormalizedApiUrl([string]$Url) {
    # Tira espacos, barra final e um eventual /v1 (o Claude Code acrescenta /v1/messages sozinho).
    if ([string]::IsNullOrWhiteSpace($Url)) { return '' }
    $u = $Url.Trim()
    if ($u -notmatch '^[a-zA-Z][a-zA-Z0-9+.-]*://') { $u = "https://$u" }
    $u = $u.TrimEnd('/')
    if ($u -match '/v1$') { $u = $u.Substring(0, $u.Length - 3) }
    return $u.TrimEnd('/')
}

function ConvertTo-Hashtable($Obj) {
    # Converte o resultado de ConvertFrom-Json (PSCustomObject) em hashtable aninhada editavel.
    if ($null -eq $Obj) { return $null }
    if ($Obj -is [System.Collections.IDictionary]) {
        $h = [ordered]@{}
        foreach ($k in $Obj.Keys) { $h[$k] = ConvertTo-Hashtable $Obj[$k] }
        return $h
    }
    if ($Obj -is [System.Management.Automation.PSCustomObject]) {
        $h = [ordered]@{}
        foreach ($p in $Obj.PSObject.Properties) { $h[$p.Name] = ConvertTo-Hashtable $p.Value }
        return $h
    }
    if ($Obj -is [System.Collections.IEnumerable] -and $Obj -isnot [string]) {
        $list = New-Object System.Collections.ArrayList
        foreach ($i in $Obj) { [void]$list.Add((ConvertTo-Hashtable $i)) }
        return ,$list.ToArray()
    }
    return $Obj
}

function Merge-ClaudeSettings {
    # Mescla as configuracoes do kit nas configuracoes existentes, sem apagar o resto.
    param(
        $Existing,                 # hashtable (ou $null)
        [hashtable]$EnvMap,        # variaveis para o bloco "env"
        [string]$DefaultMode       # ex.: bypassPermissions ('' = nao mexe)
    )
    $s = if ($null -eq $Existing) { [ordered]@{} } else { $Existing }
    if ($EnvMap -and $EnvMap.Count -gt 0) {
        if (-not ($s.Contains('env')) -or $null -eq $s['env']) { $s['env'] = [ordered]@{} }
        foreach ($k in $EnvMap.Keys) { $s['env'][$k] = $EnvMap[$k] }
    }
    if ($DefaultMode) {
        if (-not ($s.Contains('permissions')) -or $null -eq $s['permissions']) { $s['permissions'] = [ordered]@{} }
        $s['permissions']['defaultMode'] = $DefaultMode
    }
    return $s
}

function Write-JsonNoBom([string]$Path, $Object) {
    # JSON em UTF-8 SEM BOM: o Claude Code (Node) nao aceita BOM no settings.json.
    $json = $Object | ConvertTo-Json -Depth 20
    $enc = New-Object System.Text.UTF8Encoding($false)
    [System.IO.File]::WriteAllText($Path, $json, $enc)
}

function Get-SafeFolderName([string]$Name) {
    # Remove caracteres invalidos em nome de pasta do Windows e aspas simples (quebram o atalho).
    # Lista explicita (nao depende do sistema): invalidos do Windows + aspas simples, crase e cifrao.
    $invalid = [char[]]'\/:*?"<>|' + [char]"'" + [char]'`' + [char]'$' + [char[]](0..31)
    $clean = -join ($Name.ToCharArray() | Where-Object { $invalid -notcontains $_ })
    $clean = ($clean -replace '\s+', ' ').Trim().TrimEnd('.')
    return $clean
}

function Read-Secret([string]$Prompt) {
    # Le um segredo sem ecoar na tela. Nunca imprima o valor devolvido.
    $sec = Read-Host -Prompt $Prompt -AsSecureString
    $bstr = [Runtime.InteropServices.Marshal]::SecureStringToBSTR($sec)
    try { return [Runtime.InteropServices.Marshal]::PtrToStringBSTR($bstr) }
    finally { [Runtime.InteropServices.Marshal]::ZeroFreeBSTR($bstr) }
}

function Read-Choice([string]$Prompt, [string[]]$Valid, [string]$Default) {
    while ($true) {
        $r = Read-Host -Prompt "$Prompt [$Default]"
        if ([string]::IsNullOrWhiteSpace($r)) { return $Default }
        if ($Valid -contains $r.Trim()) { return $r.Trim() }
        Write-Warn2 "Opcao invalida. Use uma destas: $($Valid -join ', ')"
    }
}

function Read-YesNo([string]$Prompt, [bool]$Default) {
    $suffix = if ($Default) { 'S/n' } else { 's/N' }
    $r = Read-Host -Prompt "$Prompt ($suffix)"
    if ([string]::IsNullOrWhiteSpace($r)) { return $Default }
    return ($r.Trim().ToLower() -in @('s', 'sim', 'y', 'yes'))
}

function Test-ApiEndpoint {
    # Chama GET {url}/v1/models com a chave e devolve SOMENTE o codigo HTTP e (se vier) a lista de modelos.
    param([string]$BaseUrl, [string]$Key)
    $result = [ordered]@{ Status = 0; Models = @(); Error = '' }
    try {
        [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
        $resp = Invoke-WebRequest -Uri "$BaseUrl/v1/models" -Headers @{ Authorization = "Bearer $Key" } -UseBasicParsing -TimeoutSec 25
        $result.Status = [int]$resp.StatusCode
        try {
            $data = $resp.Content | ConvertFrom-Json
            if ($data.data) { $result.Models = @($data.data | ForEach-Object { $_.id } | Where-Object { $_ }) }
        } catch { }
    } catch {
        if ($_.Exception.Response) { $result.Status = [int]$_.Exception.Response.StatusCode }
        else { $result.Error = $_.Exception.Message }
    }
    return $result
}

function Get-ShortcutArguments([string]$VaultPath) {
    # Argumentos do atalho: abre o PowerShell, entra no Cofre e roda claude.
    # Aspas simples no comando; o caminho do Cofre nao tem aspas simples (Get-SafeFolderName remove).
    $cmd = '$env:Path += '';'' + $env:USERPROFILE + ''\.local\bin''; Set-Location -LiteralPath ''' + $VaultPath + '''; claude'
    return '-NoExit -NoProfile -Command "' + $cmd + '"'
}

function New-DesktopShortcut {
    param([string]$Name, [string]$VaultPath, [string]$IconPath)
    $desktop = [Environment]::GetFolderPath('Desktop')
    $lnk = Join-Path $desktop "$Name.lnk"
    $ps  = Join-Path $env:SystemRoot 'System32\WindowsPowerShell\v1.0\powershell.exe'
    $sh = New-Object -ComObject WScript.Shell
    $sc = $sh.CreateShortcut($lnk)
    $sc.TargetPath = $ps
    $sc.Arguments = Get-ShortcutArguments $VaultPath
    $sc.WorkingDirectory = $VaultPath
    $sc.Description = 'Abre o Claude Code na pasta do Cofre'
    if ($IconPath -and (Test-Path -LiteralPath $IconPath)) { $sc.IconLocation = "$IconPath,0" } else { $sc.IconLocation = "$ps,0" }
    $sc.Save()
    return $lnk
}
