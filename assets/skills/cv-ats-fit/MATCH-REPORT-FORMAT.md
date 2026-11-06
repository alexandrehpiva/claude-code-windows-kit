# MATCH-REPORT-FORMAT — contrato de saída do relatório de aderência

Formato obrigatório do relatório final desta skill. Sem score numérico fabricado (ver motivo em `ats-mechanics.md`).

```markdown
## Aderência — {Cargo} ({Empresa})

### Cobertura de requisitos

**Must-have (obrigatórios da JD):**
| Requisito (termo literal da JD) | Status | Fonte |
|---|---|---|
| {termo exato} | Coberto / Parcial / Ausente | {bullet do currículo ou destaque do Portfólio técnico — nunca vazio se "Coberto"} |

**Nice-to-have / diferenciais:**
| Requisito | Status | Fonte |
|---|---|---|

### Formatação segura (parsing)

- [x]/[ ] por item do checklist de `ats-mechanics.md`, com nota curta só nos itens que falharem.

### Legibilidade humana (cheiro de IA)

Resultado do checklist `ai-smell-check.md` aplicado ao currículo/variante avaliada — trechos de risco, se houver, com antes/depois só se solicitado.

### Risco de idioma (se aplicável)

Sinalizar explicitamente se JD e currículo estão em idiomas diferentes — matching literal cross-idioma falha mesmo em termos quase idênticos (ver `ats-mechanics.md`).

### Veredito

1-2 frases diretas: aplicar como está / aplicar com ajustes pontuais (listar prioridade) / gap grande demais nos must-have (listar quais). Sem menção a score percentual.

### Gaps — roteiro de honestidade

Para cada requisito "Ausente" que importa: reconhecer o gap → ponte pra experiência adjacente real, se houver → não inventar fato pra fechar o gap.
```

## Regras de preenchimento

- **"Coberto" sem fonte citada é erro de preenchimento** — se não há bullet/destaque real, o status é "Ausente" ou "Parcial", nunca "Coberto" por inferência.
- Termo da coluna "Requisito" é **o termo literal da JD**, não uma paráfrase — é o que será checado contra keyword matching real.
- Se o dossiê da vaga (`Vagas e entrevistas/…/Processo.md`) já existe, oferecer registrar esse relatório lá (seção "Fit com a pessoa candidata") em vez de deixar só no chat — mas só escrever no arquivo com aprovação do usuário.
