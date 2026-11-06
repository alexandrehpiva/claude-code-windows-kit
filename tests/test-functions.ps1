# Testes das funcoes puras de lib/common.ps1. Rode: pwsh -File tests/test-functions.ps1
$ErrorActionPreference = 'Stop'
. (Join-Path $PSScriptRoot '..\lib\common.ps1')
$script:fail = 0
function Assert-Equal($Actual, $Expected, [string]$Name) {
    if ("$Actual" -ceq "$Expected") { Write-Host "ok   $Name" }
    else { Write-Host "FAIL $Name -> esperado '$Expected', veio '$Actual'"; $script:fail++ }
}

# URL
Assert-Equal (ConvertTo-NormalizedApiUrl 'https://x.exemplo.com/v1/') 'https://x.exemplo.com' 'url: tira /v1 e barra'
Assert-Equal (ConvertTo-NormalizedApiUrl 'x.exemplo.com') 'https://x.exemplo.com' 'url: acrescenta https'
Assert-Equal (ConvertTo-NormalizedApiUrl '  http://127.0.0.1:20128  ') 'http://127.0.0.1:20128' 'url: mantem http e porta'
Assert-Equal (ConvertTo-NormalizedApiUrl '') '' 'url: vazio'

# Nome de pasta
Assert-Equal (Get-SafeFolderName "Cofre Ana's:Dados?") 'Cofre AnasDados' 'pasta: remove invalidos e aspas'
Assert-Equal (Get-SafeFolderName '  Cofre   Ana. ') 'Cofre Ana' 'pasta: espacos e ponto final'

# Mesclagem de settings (preserva o que ja existe)
$orig = '{"theme":"dark","env":{"FOO":"1"},"permissions":{"allow":["Bash(ls)"],"deny":[]},"hooks":{"Stop":[{"x":1}]}}' | ConvertFrom-Json
$h = ConvertTo-Hashtable $orig
$m = Merge-ClaudeSettings -Existing $h -EnvMap @{ ANTHROPIC_BASE_URL = 'https://a.b'; ANTHROPIC_AUTH_TOKEN = 'SEGREDO' } -DefaultMode 'bypassPermissions'
$json = $m | ConvertTo-Json -Depth 20
$back = $json | ConvertFrom-Json
Assert-Equal $back.theme 'dark' 'merge: preserva chave solta'
Assert-Equal $back.env.FOO '1' 'merge: preserva env existente'
Assert-Equal $back.env.ANTHROPIC_BASE_URL 'https://a.b' 'merge: grava url'
Assert-Equal $back.permissions.defaultMode 'bypassPermissions' 'merge: modo'
Assert-Equal $back.permissions.allow[0] 'Bash(ls)' 'merge: preserva allow (array de 1 item)'
Assert-Equal ($back.permissions.allow -is [array]) 'True' 'merge: allow continua array'
Assert-Equal $back.hooks.Stop[0].x '1' 'merge: preserva hooks'

# Settings vazio
$m2 = Merge-ClaudeSettings -Existing $null -EnvMap @{} -DefaultMode 'bypassPermissions'
Assert-Equal $m2.permissions.defaultMode 'bypassPermissions' 'merge: arquivo inexistente'
$m3 = Merge-ClaudeSettings -Existing $null -EnvMap @{} -DefaultMode ''
Assert-Equal $m3.Count 0 'merge: sem nada a mudar'

# JSON sem BOM
$tmp = Join-Path ([IO.Path]::GetTempPath()) ("kit-test-" + [guid]::NewGuid().ToString('N') + '.json')
Write-JsonNoBom -Path $tmp -Object $m
$bytes = [IO.File]::ReadAllBytes($tmp)
Assert-Equal ($bytes[0] -eq 0xEF) 'False' 'json: sem BOM'
Remove-Item $tmp

# Argumentos do atalho
$a = Get-ShortcutArguments 'C:\Users\Ana\Documents\Cofre Ana'
Assert-Equal ($a.Contains("Set-Location -LiteralPath 'C:\Users\Ana\Documents\Cofre Ana'; claude")) 'True' 'atalho: entra no cofre e roda claude'
Assert-Equal ($a.StartsWith('-NoExit -NoProfile -Command "')) 'True' 'atalho: abre sem fechar'

if ($script:fail -gt 0) { Write-Host "$script:fail teste(s) falharam"; exit 1 }
Write-Host 'Todos os testes passaram'
