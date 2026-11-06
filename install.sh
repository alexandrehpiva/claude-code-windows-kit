#!/usr/bin/env bash
# Atalho para quem esta no Git Bash ou no WSL: chama o install.ps1 pelo PowerShell do Windows.
# A forma recomendada continua sendo rodar o install.ps1 direto no PowerShell (veja o README).
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*) WINPATH="$(cygpath -w "$DIR/install.ps1")" ;;
  Linux)
    if grep -qi microsoft /proc/version 2>/dev/null && command -v wslpath >/dev/null 2>&1; then
      WINPATH="$(wslpath -w "$DIR/install.ps1")"
    else
      echo "Este kit instala o Claude Code no Windows. Rode no Windows (PowerShell, Git Bash ou WSL)." >&2; exit 1
    fi ;;
  *) echo "Este kit instala o Claude Code no Windows. Rode no Windows (PowerShell, Git Bash ou WSL)." >&2; exit 1 ;;
esac

PS="$(command -v powershell.exe || true)"
[ -n "$PS" ] || { echo "powershell.exe nao encontrado no PATH." >&2; exit 1; }

# No Git Bash (mintty) as perguntas interativas podem nao funcionar; se acontecer, use o PowerShell.
exec "$PS" -NoProfile -ExecutionPolicy Bypass -File "$WINPATH" "$@"
