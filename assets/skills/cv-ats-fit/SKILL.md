---
name: cv-ats-fit
description: >-
  Avalia aderência do currículo da pessoa candidata a uma vaga específica — cobertura
  de requisitos (must-have vs. nice-to-have), keywords, formatação segura pra
  parsing de ATS, e legibilidade humana — sem fabricar score de ATS. Usar
  quando o usuário pedir "esse currículo bate com essa vaga", "avalia
  aderência à vaga", "isso passa no ATS", "compara meu currículo com a vaga",
  "score ATS", "gap analysis da vaga", ou pedir pra checar match antes de
  aplicar.
---

# cv-ats-fit

**Princípio:** reportar gap honesto (o que cobre, o que falta, o que pode ser reenquadrado com fato real) — nunca inventar um número de "score de ATS" como se fosse saída de um sistema real.

## Modo de falha que esta skill corrige

Pedido pra avaliar match com uma vaga, o agente ou (a) dá impressão vaga tipo "parece um bom fit" sem checar sistematicamente must-have vs. nice-to-have, ou (b) inventa um "score de 87% de compatibilidade" como se tivesse rodado um ATS real — um estudo de referência sobre ATS confirma que **nenhum simulador de score é auditável ou confiável**, nem os comerciais pagos — ou (c) empurra sugestões de keyword-stuffing que otimizam o score aparente mas soam "escritas por IA" pro recrutador humano que lê depois (achado do próprio estudo: currículo over-optimized é cada vez mais auto-rejeitado por humano reconhecendo o padrão).

## Antes de agir (sempre)

1. Seguir as instruções do `CLAUDE.md` do Cofre.
2. Ler `ats-mechanics.md` (**obrigatório**) — mecânica real de parsing/ranking, o que tem evidência e o que é mito.
3. Ler o currículo ativo (canônico ou variante da vaga) + `[[Portfólio técnico]]` como fonte de fatos aprovados — **nunca** avaliar fit contra fato que não está em nenhum dos dois.
4. Ler a JD da vaga (texto colado pelo usuário, ou `Vagas e entrevistas/…/Processo.md` se o dossiê já existir).
5. Se o dossiê da vaga (`personal-job-interviews`) já tem seção "Fit com a pessoa candidata", cruzar e não duplicar/contradizer — atualizar lá em vez de recriar em outro lugar.

## Fluxo (workflow fixo, não julgamento livre — ver motivação em `ats-mechanics.md`)

1. **Extrair requisitos da JD**: separar must-have de nice-to-have/diferencial (não tratar tudo como peso igual).
2. **Gap analysis contra fato grounded**: para cada requisito, marcar coberto / parcial / ausente, citando de onde vem a cobertura (bullet do currículo ou destaque do Portfólio técnico). Sem fonte = não marcar como coberto.
3. **Checklist de formatação segura**: rodar os itens de `ats-mechanics.md` (coluna única, nomes de seção padrão, contato no corpo, siglas por extenso etc.) contra o HTML/PDF real.
4. **Checklist de legibilidade humana**: reusar `ai-smell-check.md` da skill `personal-cv` — texto over-otimizado pra keyword não pode soar "gerado por IA" pro filtro humano seguinte.
5. **Relatório final** no formato de `MATCH-REPORT-FORMAT.md` — sem score numérico fabricado, com veredito qualitativo e lista priorizada de gaps.
6. Mudanças sugeridas ficam só no chat até aprovação — edição real do `.html`/`.md` segue o fluxo padrão da skill `personal-cv` (não editar direto daqui).

## Escopo

| Faz | Não faz |
|-----|---------|
| Gap analysis must-have vs. nice-to-have, com fonte citada | Inventar % de match / score de ATS simulado |
| Checklist de formatação segura pra parsing | Alegar saber a mecânica exata de um ATS específico não documentado publicamente (ex. Sólides) |
| Checklist de legibilidade humana (reusa `ai-smell-check.md`) | Editar o currículo diretamente — isso é escopo da `personal-cv` |
| Apontar keyword ausente citando o termo literal da JD | Sugerir keyword stuffing / lista de termos escondida |
| Registrar achado no dossiê da vaga se já existir | Recriar dossiê duplicado quando `personal-job-interviews` já cobre a vaga |

## Escape de falha

- **JD não colada nem em texto nem em dossiê**: pedir a JD antes de prosseguir — não avaliar fit contra vaga que não foi lida.
- **Vaga em outro idioma do currículo**: sinalizar explicitamente que matching literal cross-idioma falha mesmo em termos quase idênticos (ex. "REST APIs" vs. "APIs REST" — ver `ats-mechanics.md`) — não assumir que o ATS da empresa normaliza isso.
- **Usuário pede o score numérico mesmo assim**: explicar por que não é confiável (sem benchmark público auditável, ver `ats-mechanics.md`) e oferecer o gap qualitativo como alternativa real.
