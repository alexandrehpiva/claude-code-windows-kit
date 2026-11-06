# Estrutura no cofre — vagas e entrevistas

> Leia antes de criar ou mover qualquer nota de vaga/entrevista.

## Raiz

`Pessoal/Carreira/Vagas e entrevistas/`

| Path | Papel |
|------|--------|
| `Índice.md` | MOC: ativas, por mês, arquivo |
| `_templates/` | `empresa.md`, `processo.md`, `briefing-entrevista.md` |
| `empresas/{Empresa}/` | Dossiê por empresa |
| `empresas/{Empresa}/Empresa.md` | Fatos estáveis da empresa |
| `empresas/{Empresa}/YYYY-MM — {cargo curto}/` | Um processo seletivo |
| `por-data/YYYY-MM/Índice.md` | Vista mensal (só links + datas) |

## O que **não** misturar

| Pasta | Uso |
|-------|-----|
| `Pessoal/Carreira/Entrevistas/` | Roteiros quando a pessoa **entrevistava** (legado) |
| `Pessoal/Carreira/Vagas e entrevistas/` | Busca de emprego **como candidato** |
| `Pessoal/LinkedIn/Oportunidades.md` | **Resumo** operacional (1 bloco por vaga) — detalhe fica no dossiê |
| `Trabalho/{Empresa}/` | Só **depois** de fechar a vaga (template empregador) |

## Naming

- Empresa: nome comercial curto (`Empresa Exemplo`).
- Processo: `YYYY-MM — Senior Software Engineer Python` (mês do início do processo).
- Briefing: `Briefing — YYYY-MM-DD {tipo} {pessoa}.md` (ex.: `screening Maria Silva`).

## Arquivos mínimos de um processo novo

1. `empresas/{Empresa}/Índice.md` (se a empresa for nova)
2. `empresas/{Empresa}/Empresa.md`
3. `…/YYYY-MM — {cargo}/Processo.md`
4. Se houver entrevista marcada: `Briefing — …md` + linha em `por-data/YYYY-MM/Índice.md` + linha em `Índice.md` (Ativas)
5. Opcional: `Fontes.md` quando houver muitas URLs

Copiar de `_templates/` e preencher — não inventar estrutura paralela.
