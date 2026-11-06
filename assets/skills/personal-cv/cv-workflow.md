# cv-workflow — Artefatos e pipeline PDF

## Paths canônicos (Cofre)

| Artefato | Path |
|----------|------|
| PDF (upload) | `Pessoal/Carreira/Currículo — Nome Sobrenome (YYYY-MM).pdf` |
| HTML (editar) | `Pessoal/Carreira/Currículo — Nome Sobrenome (YYYY-MM).html` |
| Markdown espelho | `Pessoal/Carreira/Currículo — Nome Sobrenome (YYYY-MM).md` |
| Backup | `Currículo — Nome Sobrenome (YYYY-MM) — backup vN YYYY-MM-DD.pdf` / `.html` |

## Versionamento

- Tabela **Histórico de versões** no `.md` (v3.x com data + nota curta).
- Linha `Versão **vX.Y**` no topo do `.md`.
- Backup em marcos: aprovação do usuário, antes de mudança grande.

## Gerar PDF (macOS; no Windows veja abaixo)

```bash
"/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" \
  --headless=new --disable-gpu --no-pdf-header-footer \
  --print-to-pdf="/path/to/Currículo — Nome Sobrenome (YYYY-MM).pdf" \
  "file:///path/url-encoded/Currículo%20—%20Nome%20Sobrenome%20(YYYY-MM).html"
```

Verificar páginas: `mdls -name kMDItemNumberOfPages -raw` no PDF.

## Layout estável (referência v3.6.1)

- `@page margin: 7mm 9mm`
- `body` 9.5pt, line-height 1.36
- Resumo: **2 parágrafos** (`p.summary` + `p.summary` com margin-top 6px)
- Parágrafo 1: técnico; parágrafo 2: postura / soft skills / processo

## Commit (só quando pedido)

Incluir: `.html`, `.md`, `.pdf`, backups novos se relevante. Mensagem `docs(carreira): currículo vX.Y …`.

## Gerar PDF (Windows, PowerShell)

```powershell
& "C:\Program Files\Google\Chrome\Application\chrome.exe" --headless=new --disable-gpu --no-pdf-header-footer `
  --print-to-pdf="C:\caminho\Currículo — Nome Sobrenome (YYYY-MM).pdf" `
  "file:///C:/caminho/Curr%C3%ADculo%20%E2%80%94%20Nome%20Sobrenome%20(YYYY-MM).html"
```

Se o Chrome estiver em outra pasta (por exemplo `Program Files (x86)`), ajuste o caminho do executável.
