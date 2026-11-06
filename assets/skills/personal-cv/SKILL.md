---
name: personal-cv
description: >-
  Itera, revisa e gera PDF do currículo da pessoa candidata no Cofre (HTML
  fonte, 1 página, backups versionados). Usar quando o usuário pedir "revisar
  currículo", "melhorar o CV", "iterar currículo", "gerar PDF do currículo",
  "backup do currículo", "aprovar currículo", "releia meu currículo", ou
  preparar upload para Sólides/ATS com o PDF em Pessoal/Carreira/. Também usar
  para avaliar "cheiro de IA" em qualquer texto de carreira — "isso parece
  escrito por IA", "soa gerado por IA", "avalia esse texto" — mesmo fora do
  fluxo de revisão de currículo.
---

# personal-cv

**Princípio:** currículo **multi-empresa**, **1 página**, bullets **defensáveis na entrevista** — iterar no chat até aprovação, depois backup + PDF + commit se pedido.

## Modo de falha que esta skill corrige

O agente resume o CV no chat sem editar os artefatos canônicos, inventa métricas ou jargão vazio, empurra PDF antes da aprovação, ou escreve frases que a pessoa não consegue exemplificar em 30s na entrevista.

## Antes de agir (sempre)

1. Seguir as instruções do `CLAUDE.md` do Cofre.
2. Ler `cv-workflow.md` — paths, PDF, backups, versionamento (**obrigatório**).
3. Ler HTML + `.md` espelho do currículo ativo (**obrigatório**).
4. Para **revisão profissional**: ler `cv-review-checklist.md` (**obrigatório**).
5. Cruzar com [[Portfólio técnico]] e skill `personal-job-interviews` quando a vaga importa — não duplicar narrativa contraditória.
6. Para **avaliação de "cheiro de IA"** (currículo ou qualquer texto de carreira avulso): ler `ai-smell-check.md` (**obrigatório**) — só reportar, não editar até aprovação.

## Escopo

| Faz | Não faz |
|-----|---------|
| Editar HTML + `.md` espelho; regerar PDF | CPF/telefone no PDF (só formulário) |
| Backups `backup vN YYYY-MM-DD` antes de marcos | Nomes internos de repositório |
| Revisão como recrutador TL + HM | Inventar métricas ou stack não usada |
| Soft skills no **2º parágrafo** do resumo | Bloco genérico "soft skills" que abre perguntas RAG/MCP sem evidência |
| Commit no cofre quando o usuário pedir | Push sem pedido |
| Avaliar "cheiro de IA" em texto sob demanda (`ai-smell-check.md`) | Editar o texto avaliado sem aprovação explícita |

## Fluxo rápido

1. Ler versão atual (HTML é fonte de layout; `.md` espelho + histórico de versões).
2. Propor ou aplicar mudanças; **confirmar 1 página** após cada PDF.
3. Na aprovação: backup snapshot → commit → entregar path do PDF.
4. Revisão profissional: veredito (aprovar / ajustes opcionais) com motivação, não lista de opções confusa.

## Escape de falha

- **2 páginas:** margens `@page` (último estável ~7mm×9mm), encurtar texto — não só reduzir fonte sem avisar.
- **Usuário negociando texto:** não editar HTML até fechar frase no chat.
- **Vaga específica:** variante opcional no chat ou nota no `.md`; não fork permanente `working/fixed` no cofre.
