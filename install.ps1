<#
.SYNOPSIS
  Instala e configura o Claude Code no Windows, com Cofre de skills e atalho.

.DESCRIPTION
  Faz, nesta ordem: verifica o ambiente, instala o Node.js (se faltar), instala o Claude Code,
  configura endereco e chave da API (opcional) e o modo "sem pedir permissoes", instala e
  configura o MCP do Playwright, cria a pasta do Cofre em Documentos com as skills do kit e
  cria um atalho na Area de Trabalho que abre o Claude nessa pasta.

  Pode ser executado de novo sem problema: cada passo confere o que ja existe.

.PARAMETER ApiUrl
  Endereco base da API compativel com Anthropic (ex.: https://meu-gateway.exemplo.com).
  Sem este parametro, o script pergunta. Deixe vazio para usar o login normal do Claude.

.PARAMETER VaultName
  Nome da pasta do Cofre (padrao: "Cofre <seu usuario do Windows>").

.PARAMETER Browser
  extension | profile | none  - como o Playwright controla o navegador (padrao: pergunta).

.PARAMETER NoBypass
  Nao ativa o modo "sem pedir permissoes" por padrao.

.PARAMETER SkipSkills
  Nao copia as skills do kit para o Cofre.

.PARAMETER Force
  Substitui skills que ja existem no Cofre (sem isto, elas sao preservadas).

.EXAMPLE
  powershell -ExecutionPolicy Bypass -File .\install.ps1
#>
[CmdletBinding()]
param(
    [string]$ApiUrl,
    [string]$VaultName,
    [ValidateSet('extension', 'profile', 'none', '')]
    [string]$Browser = '',
    [switch]$NoBypass,
    [switch]$SkipSkills,
    [switch]$Force
)

$ErrorActionPreference = 'Stop'
$KitRoot = $PSScriptRoot
. (Join-Path $KitRoot 'lib\common.ps1')

$Summary = New-Object System.Collections.ArrayList
$Pending = New-Object System.Collections.ArrayList

Write-Host ""
Write-Host "Claude Code - instalador para Windows" -ForegroundColor White
Write-Host "Este script nao envia sua chave para lugar nenhum alem do endereco que voce informar."

# ---------------------------------------------------------------- 1. Ambiente
Write-Step '1/8 Verificando o ambiente'
if ($PSVersionTable.PSVersion.Major -lt 5) { Write-Err 'Precisa do PowerShell 5.1 ou superior.'; exit 1 }
if ([Environment]::OSVersion.Platform -ne 'Win32NT') { Write-Err 'Este instalador e para Windows.'; exit 1 }
Write-Ok "PowerShell $($PSVersionTable.PSVersion) em Windows"

if (-not (Test-Path (Join-Path $KitRoot 'assets\skills'))) {
    Write-Err 'Nao achei a pasta assets\skills ao lado do script. Extraia o kit inteiro antes de rodar.'
    exit 1
}
Write-Ok 'Arquivos do kit encontrados'

try {
    [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
    $null = Invoke-WebRequest -Uri 'https://claude.ai' -Method Head -UseBasicParsing -TimeoutSec 20
    Write-Ok 'Internet funcionando (claude.ai acessivel)'
} catch {
    Write-Warn2 'Nao consegui acessar https://claude.ai. Se houver proxy ou bloqueio na rede, a instalacao pode falhar.'
}

$hasWinget = Test-Command 'winget'
if ($hasWinget) { Write-Ok 'winget disponivel' } else { Write-Warn2 'winget nao encontrado (so e necessario se o Node.js faltar).' }

# ---------------------------------------------------------------- 2. Node.js
Write-Step '2/8 Node.js (necessario para o MCP do Playwright)'
$nodeMajor = Get-NodeMajor
if ($nodeMajor -ge 18) {
    Write-Ok "Node.js ja instalado (versao $((& node --version).Trim()))"
    [void]$Summary.Add('Node.js: ja existia')
} else {
    if (-not $hasWinget) {
        Write-Err 'Node.js ausente e o winget nao existe. Instale o Node.js LTS em https://nodejs.org e rode este script de novo.'
        exit 1
    }
    Write-Info 'Instalando Node.js LTS pelo winget (pode abrir um pedido de permissao do Windows)...'
    & winget install --id OpenJS.NodeJS.LTS -e --silent --accept-package-agreements --accept-source-agreements
    Update-SessionPath
    $nodeMajor = Get-NodeMajor
    if ($nodeMajor -lt 18) {
        Write-Err 'O Node.js foi instalado mas esta sessao ainda nao o enxerga. Feche o PowerShell, abra um novo e rode este script de novo.'
        exit 1
    }
    Write-Ok "Node.js instalado (versao $((& node --version).Trim()))"
    [void]$Summary.Add('Node.js: instalado agora')
}
if (-not (Test-Command 'npx')) { Write-Err 'O npx nao foi encontrado junto com o Node.js.'; exit 1 }

# ---------------------------------------------------------------- 3. Claude Code
Write-Step '3/8 Claude Code'
$localBin = Join-Path $env:USERPROFILE '.local\bin'
$claudeExe = Join-Path $localBin 'claude.exe'
if (-not (Test-Command 'claude') -and -not (Test-Path $claudeExe)) {
    Write-Info 'Instalando com o instalador oficial (https://claude.ai/install.ps1)...'
    try {
        Invoke-RestMethod -Uri 'https://claude.ai/install.ps1' | Invoke-Expression
    } catch {
        Write-Err "Falha ao instalar o Claude Code: $($_.Exception.Message)"
        Write-Info 'Tente manualmente: irm https://claude.ai/install.ps1 | iex'
        exit 1
    }
    [void]$Summary.Add('Claude Code: instalado agora')
} else {
    [void]$Summary.Add('Claude Code: ja existia')
}
if (Test-Path $localBin) { Add-UserPathEntry $localBin }
Update-SessionPath
if (Test-Path $localBin) { Add-UserPathEntry $localBin }
if (-not (Test-Command 'claude')) { Write-Err 'O comando claude nao foi encontrado apos a instalacao.'; exit 1 }
$claudeVersion = (& claude --version 2>&1 | Out-String).Trim()
Write-Ok "Claude Code: $claudeVersion"

# ---------------------------------------------------------------- 4. Configuracao (API + permissoes)
Write-Step '4/8 Endereco e chave da API, e permissoes'
$claudeDir = Join-Path $env:USERPROFILE '.claude'
New-Item -ItemType Directory -Force $claudeDir | Out-Null
$settingsPath = Join-Path $claudeDir 'settings.json'

$existing = $null
if (Test-Path $settingsPath) {
    $raw = Get-Content -LiteralPath $settingsPath -Raw -Encoding UTF8
    if (-not [string]::IsNullOrWhiteSpace($raw)) {
        try { $existing = ConvertTo-Hashtable ($raw | ConvertFrom-Json) }
        catch {
            Write-Err "O arquivo $settingsPath existe mas nao e um JSON valido. Corrija ou renomeie e rode de novo (nada foi alterado)."
            exit 1
        }
    }
    $stamp = Get-Date -Format 'yyyyMMdd-HHmmss'
    Copy-Item -LiteralPath $settingsPath -Destination "$settingsPath.bak-$stamp"
    Write-Info "Copia de seguranca: settings.json.bak-$stamp"
}
$currentUrl = ''
$currentKey = ''
if ($existing -and $existing.Contains('env') -and $existing['env']) {
    if ($existing['env'].Contains('ANTHROPIC_BASE_URL'))   { $currentUrl = [string]$existing['env']['ANTHROPIC_BASE_URL'] }
    if ($existing['env'].Contains('ANTHROPIC_AUTH_TOKEN')) { $currentKey = [string]$existing['env']['ANTHROPIC_AUTH_TOKEN'] }
}

$url = ConvertTo-NormalizedApiUrl $ApiUrl
if (-not $url) {
    Write-Info 'Informe o endereco da API (gateway/tunel/proxy compativel com Anthropic).'
    Write-Info 'Sem /v1 no fim. Deixe vazio para usar o login normal da sua conta Claude.'
    if ($currentUrl) { Write-Info "Atual: $currentUrl  (Enter mantem)" }
    $typed = Read-Host -Prompt 'Endereco da API'
    if ([string]::IsNullOrWhiteSpace($typed)) { $url = $currentUrl } else { $url = ConvertTo-NormalizedApiUrl $typed }
}

function Select-Model([string]$Label, [string[]]$Models) {
    $r = Read-Host -Prompt "Modelo para $Label (numero ou nome)"
    if ([string]::IsNullOrWhiteSpace($r)) { return '' }
    $r = $r.Trim()
    $n = 0
    if ([int]::TryParse($r, [ref]$n) -and $n -ge 1 -and $n -le $Models.Count) { return [string]$Models[$n - 1] }
    return $r
}

$envMap = @{}
if ($url) {
    $key = $env:CLAUDE_KIT_API_KEY
    if (-not $key) {
        $hint = if ($currentKey -and ($url -eq $currentUrl)) { ' (Enter mantem a chave atual)' } else { '' }
        $key = Read-Secret "Chave da API (nao aparece na tela)$hint"
        if ([string]::IsNullOrWhiteSpace($key) -and $currentKey -and ($url -eq $currentUrl)) { $key = $currentKey }
    }
    if ([string]::IsNullOrWhiteSpace($key)) { Write-Err 'Sem chave nao da para usar um endereco personalizado.'; exit 1 }

    Write-Info 'Testando o endereco e a chave (so mostro o codigo de resposta)...'
    $test = Test-ApiEndpoint -BaseUrl $url -Key $key
    if ($test.Status -eq 200) {
        Write-Ok "A API respondeu 200 em $url/v1/models ($($test.Models.Count) modelos listados)"
    } elseif ($test.Status -in 401, 403) {
        Write-Warn2 "A API respondeu $($test.Status): a chave parece invalida."
        if (-not (Read-YesNo 'Continuar mesmo assim' $false)) { Write-Info 'Cancelado. Nada foi gravado.'; exit 1 }
    } elseif ($test.Status -gt 0) {
        Write-Warn2 "A API respondeu $($test.Status) em /v1/models. Pode ser normal se o servico nao lista modelos."
    } else {
        Write-Warn2 "Nao consegui falar com $url ($($test.Error))."
        if (-not (Read-YesNo 'Continuar mesmo assim' $false)) { Write-Info 'Cancelado. Nada foi gravado.'; exit 1 }
    }

    $envMap['ANTHROPIC_BASE_URL']   = $url
    $envMap['ANTHROPIC_AUTH_TOKEN'] = $key
    $envMap['CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC'] = '1'

    # Modelos: o usuario escolhe da lista que a API devolveu (ou digita).
    Write-Info 'Modelos padrao (Enter pula e deixa o padrao do Claude Code).'
    $models = @($test.Models)
    if ($models.Count -gt 0) {
        $i = 1
        foreach ($m in $models) { Write-Host ("     {0,2}) {1}" -f $i, $m); $i++ }
    }
    $mSonnet = Select-Model 'SONNET (uso principal)' $models
    $mOpus   = Select-Model 'OPUS' $models
    $mHaiku  = Select-Model 'HAIKU (tarefas rapidas)' $models
    if ($mSonnet) { $envMap['ANTHROPIC_MODEL'] = $mSonnet; $envMap['ANTHROPIC_DEFAULT_SONNET_MODEL'] = $mSonnet }
    if ($mOpus)   { $envMap['ANTHROPIC_DEFAULT_OPUS_MODEL']  = $mOpus }
    if ($mHaiku)  { $envMap['ANTHROPIC_DEFAULT_HAIKU_MODEL'] = $mHaiku }
    [void]$Summary.Add("API: $url (chave gravada em settings.json)")
} else {
    Write-Info 'Sem endereco personalizado: no primeiro uso o Claude vai pedir login na conta.'
    [void]$Summary.Add('API: login normal da conta Claude')
}

$mode = ''
if (-not $NoBypass) { $mode = 'bypassPermissions' }
$settings = Merge-ClaudeSettings -Existing $existing -EnvMap $envMap -DefaultMode $mode
Write-JsonNoBom -Path $settingsPath -Object $settings
# Restringe o arquivo (tem a chave) ao usuario atual.
try {
    & icacls $settingsPath /inheritance:r /grant:r "$($env:USERNAME):(R,W)" | Out-Null
    Write-Ok 'settings.json gravado e restrito ao seu usuario'
} catch { Write-Warn2 'Nao consegui restringir as permissoes do settings.json.' }
if ($mode) {
    Write-Warn2 'Modo "sem pedir permissoes" ATIVADO por padrao: o Claude executa comandos e edita arquivos sem perguntar.'
    Write-Info 'Na primeira abertura ele mostra um aviso de confirmacao desse modo. Para desfazer, apague "defaultMode" em settings.json.'
    [void]$Summary.Add('Permissoes: bypassPermissions por padrao')
}

# ---------------------------------------------------------------- 5. Playwright MCP
Write-Step '5/8 MCP do Playwright (controle do navegador)'
if (-not $Browser) {
    Write-Host '     1) extension  - usa o SEU Chrome ja logado (precisa instalar uma extensao; voce escolhe a aba a cada sessao)'
    Write-Host '     2) profile    - abre um Chrome proprio do Claude com login salvo (ideal para rotinas; voce entra nos sites uma vez)'
    Write-Host '     3) none       - nao instalar agora'
    $c = Read-Choice 'Escolha' @('1', '2', '3') '2'
    $Browser = @{ '1' = 'extension'; '2' = 'profile'; '3' = 'none' }[$c]
}
if ($Browser -ne 'none') {
    $pkg = '@playwright/mcp@latest'
    Write-Info 'Baixando o pacote do Playwright MCP (primeira vez demora um pouco)...'
    & cmd /c "npx -y $pkg --version" 2>&1 | Out-Null
    if ($LASTEXITCODE -ne 0) { Write-Warn2 'Nao consegui baixar o pacote agora; o Claude tentara de novo ao conectar.' }

    $extraArgs = @()
    if ($Browser -eq 'extension') {
        $extraArgs = @('--extension')
    } else {
        $profileDir = Join-Path $env:USERPROFILE 'playwright-perfil'
        New-Item -ItemType Directory -Force $profileDir | Out-Null
        $chrome = @(
            "$env:ProgramFiles\Google\Chrome\Application\chrome.exe",
            "${env:ProgramFiles(x86)}\Google\Chrome\Application\chrome.exe",
            "$env:LocalAppData\Google\Chrome\Application\chrome.exe"
        ) | Where-Object { $_ -and (Test-Path $_) } | Select-Object -First 1
        $channel = if ($chrome) { 'chrome' } else { 'msedge' }
        if (-not $chrome) { Write-Warn2 'Chrome nao encontrado; vou usar o Microsoft Edge.' }
        $extraArgs = @('--browser', $channel, '--user-data-dir', $profileDir)
    }
    & claude mcp remove playwright --scope user 2>&1 | Out-Null
    $addArgs = @('mcp', 'add', '--scope', 'user', 'playwright', '--', 'cmd', '/c', 'npx', '-y', $pkg) + $extraArgs
    & claude @addArgs 2>&1 | Out-Null
    $claudeJson = Join-Path $env:USERPROFILE '.claude.json'
    if ((Test-Path $claudeJson) -and (Select-String -LiteralPath $claudeJson -Pattern '"playwright"' -Quiet)) {
        Write-Ok "MCP do Playwright cadastrado (modo $Browser)"
        [void]$Summary.Add("Playwright MCP: modo $Browser")
    } else {
        Write-Warn2 'Nao consegui confirmar o cadastro do Playwright. Rode "claude mcp list" depois para conferir.'
        [void]$Pending.Add('Conferir o MCP do Playwright com: claude mcp list')
    }
    if ($Browser -eq 'extension') {
        Write-Info 'Abrindo a pagina da extensao "Playwright MCP Bridge" na Chrome Web Store...'
        Start-Process 'https://chromewebstore.google.com/detail/mmlmfjhmonkocbjadbfplnigmagldckm'
        [void]$Pending.Add('Instalar a extensao Playwright MCP Bridge no Chrome (a pagina foi aberta) e deixar o Chrome aberto.')
    } else {
        [void]$Pending.Add('Na primeira vez, peca ao Claude para abrir o site desejado e faca o login VOCE MESMO na janela que abrir (nunca digite senha no chat).')
    }
}

# ---------------------------------------------------------------- 6. Cofre
Write-Step '6/8 Pasta do Cofre'
$docs = [Environment]::GetFolderPath('MyDocuments')
$defaultName = "Cofre $env:USERNAME"
if (-not $VaultName) {
    $typed = Read-Host -Prompt "Nome da pasta do Cofre [$defaultName]"
    $VaultName = if ([string]::IsNullOrWhiteSpace($typed)) { $defaultName } else { $typed }
}
$VaultName = Get-SafeFolderName $VaultName
if (-not $VaultName) { $VaultName = Get-SafeFolderName $defaultName }
$vault = Join-Path $docs $VaultName
New-Item -ItemType Directory -Force $vault | Out-Null
foreach ($sub in @('Vagas e entrevistas', 'Notas', '.claude\skills')) { New-Item -ItemType Directory -Force (Join-Path $vault $sub) | Out-Null }
Write-Ok "Cofre: $vault"

$utf8Bom = New-Object System.Text.UTF8Encoding($true)
$claudeMdTarget = Join-Path $vault 'CLAUDE.md'
if (-not (Test-Path $claudeMdTarget)) {
    $tpl = Get-Content -LiteralPath (Join-Path $KitRoot 'assets\templates\CLAUDE.md') -Raw -Encoding UTF8
    $tpl = $tpl.Replace('{{COFRE}}', $VaultName)
    [System.IO.File]::WriteAllText($claudeMdTarget, $tpl, $utf8Bom)
    Write-Ok 'CLAUDE.md criado (regras basicas do Cofre)'
} else { Write-Info 'CLAUDE.md ja existe: preservado' }
$readmeTarget = Join-Path $vault 'LEIAME.md'
if (-not (Test-Path $readmeTarget)) {
    $tpl = Get-Content -LiteralPath (Join-Path $KitRoot 'assets\templates\LEIAME-cofre.md') -Raw -Encoding UTF8
    [System.IO.File]::WriteAllText($readmeTarget, $tpl, $utf8Bom)
}
[void]$Summary.Add("Cofre: $vault")

# ---------------------------------------------------------------- 7. Skills
Write-Step '7/8 Skills'
if ($SkipSkills) {
    Write-Info 'Pulado (-SkipSkills).'
} else {
    $skillsSrc = Join-Path $KitRoot 'assets\skills'
    $skillsDst = Join-Path $vault '.claude\skills'
    $installed = 0; $kept = 0
    foreach ($d in (Get-ChildItem -LiteralPath $skillsSrc -Directory)) {
        $dst = Join-Path $skillsDst $d.Name
        if ((Test-Path $dst) -and -not $Force) { $kept++; continue }
        if (Test-Path $dst) { Remove-Item -LiteralPath $dst -Recurse -Force }
        Copy-Item -LiteralPath $d.FullName -Destination $dst -Recurse
        $installed++
    }
    Write-Ok "$installed skill(s) instalada(s) em .claude\skills do Cofre; $kept ja existiam e foram preservadas"
    if ($kept -gt 0) { Write-Info 'Use -Force para substituir as que ja existem pela versao do kit.' }
    [void]$Summary.Add("Skills: $installed instalada(s), $kept preservada(s)")
}

# ---------------------------------------------------------------- 8. Atalho
Write-Step '8/8 Atalho na Area de Trabalho'
$iconFile = if (Test-Path $claudeExe) { $claudeExe } else { $null }
try {
    $lnk = New-DesktopShortcut -Name "Claude - $VaultName" -VaultPath $vault -IconPath $iconFile
    Write-Ok "Atalho criado: $lnk"
    [void]$Summary.Add('Atalho: Area de Trabalho')
} catch {
    Write-Warn2 "Nao consegui criar o atalho: $($_.Exception.Message)"
    [void]$Pending.Add("Abra o PowerShell e rode: cd '$vault'; claude")
}

# ---------------------------------------------------------------- Resumo
Write-Host ""
Write-Host "================ Resumo ================" -ForegroundColor Green
foreach ($l in $Summary) { Write-Host "  - $l" }
if ($Pending.Count -gt 0) {
    Write-Host ""
    Write-Host 'Ainda falta (manual):' -ForegroundColor Yellow
    foreach ($p in $Pending) { Write-Host "  * $p" }
}
Write-Host ""
Write-Host 'Para comecar: abra o atalho criado na Area de Trabalho.' -ForegroundColor White
Write-Host 'Dentro do Claude, digite /mcp para ver o Playwright e /skills (ou /) para ver as skills.'
