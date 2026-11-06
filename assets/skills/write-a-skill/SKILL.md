---
name: write-a-skill
description: Cria e mantém skills deste Cofre (pasta `.claude/skills/`). Usar quando criar, estruturar, refatorar ou revisar uma skill; definir uma nova capacidade para o assistente; ou quando a pessoa disser "escreva uma skill", "crie uma skill", "nova skill", "atualiza a skill", "melhora essa skill", "transforma esse passo a passo em skill".
---

# write-a-skill

**Skills são primitivos precisos de propósito único que corrigem um modo de falha conhecido do agente — não mega-workflows. A menor skill que ainda direciona o comportamento corretamente para todos os seus casos de uso é a melhor skill.** Uma skill pode ser uma única frase imperativa. Estrutura, seção ou boilerplate que não carrega comportamento é atenção do agente desviada.

Quando uma instrução explícita do usuário contradisser algo aqui, prevalece a instrução do usuário.

## Assets — quando ler

| Se você vai… | Ler antes |
|---|---|
| Redigir ou revisar o texto de qualquer skill não trivial (técnicas, divisão em assets, dependências, scripts, skills de setup) | [`craft.md`](craft.md) — obrigatório |
| Entender o porquê de uma técnica ou justificar ao usuário uma skill menor/dividida | [`skill-writing-patterns.md`](skill-writing-patterns.md) |
| Incluir qualquer dado de caso real, conteúdo de terceiros, ou publicar/compartilhar a skill | [`security-and-privacy.md`](security-and-privacy.md) — obrigatório |

## Processo de criação

1. **Nomear a dor.** Qual modo de falha do agente esta skill corrige? ("o agente não fez o que eu queria", "é verboso demais", "o código não funciona", "vira bola de lama", ou um problema operacional concreto). A dor decide escopo e tom. Skills corrigem falhas e padronizam fluxos — não adicionam prosa informativa.
2. **Entender o domínio.** Definir o que a skill cobre e o que **não** cobre; listar os casos de uso reais (eles viram os gatilhos da `description`, com as frases literais do usuário); verificar se já existe skill similar — expandir a existente ou criar nova. Se for modificar skill existente: ler **todos** os arquivos da pasta antes de agir (`SKILL.md` + todos os assets + scripts).
3. **Decidir a estrutura.** O que fica no `SKILL.md` e o que vai para asset (tabela de decisão em [`craft.md`](craft.md)). Skills grandes viram **roteadoras**.
4. **Redigir** seguindo as seções abaixo e [`craft.md`](craft.md).
5. **Criar no lugar certo e registrar** — fluxo crítico abaixo.
6. **Revisar com o checklist** do fim deste arquivo.

## Explique a motivação (obrigatório em regras não óbvias)

Não basta listar o que fazer — o agente precisa entender **por que** a regra existe, senão volta ao atalho errado.

- No `SKILL.md` ou no asset relevante, inclua uma seção curta **Diagnóstico do modo de falha** (ou equivalente): o que o agente faz de errado hoje, com exemplos concretos do sintoma (ex.: "aceita o primeiro frame plausível em slide animado").
- Depois disso, sim: procedimento, critérios pass/fail, anti-padrões.
- Regras mecânicas óbvias (naming, paths) não precisam de parágrafo motivacional — só as que corrigem julgamento ou viés do modelo.
- Incidente real entra como motivação **generalizada**, nunca como replay das strings de uma sessão: a regra se define por critério comportamental verificável.

## Generalize por padrão

Mesmo quando o conteúdo é minerado de um projeto concreto, escreva a skill/asset em termos project-agnostic — vocabulário, entidades e citações de documento específicas do projeto-fonte viram exemplo ilustrativo entre parênteses, não premissa implícita. Só acople deliberadamente a um projeto quando o usuário pedir isso explicitamente (ex.: uma skill que É sobre aquele projeto). Teste antes de considerar pronto: um leitor sem contexto do projeto-fonte consegue aplicar cada item sem precisar substituir nomes de entidade mentalmente? Segredos, dados pessoais, contexto de cliente e conteúdo de terceiros seguem [`security-and-privacy.md`](security-and-privacy.md).

## Anatomia

Uma skill é uma pasta dentro de `.claude/skills/` do Cofre, com um `SKILL.md` e assets opcionais:

```
.claude/skills/<kebab-name>/
  SKILL.md
  <assets opcionais>
  scripts/          ← só se houver operação determinística
```

**Nomenclatura:**
- Pasta em `kebab-case` (letras minúsculas, números e hífens, sem acento), igual ao `name`.
- `SCREAMING-CASE.md` = contrato/formato de um artefato que a skill produz (ex.: `REPORT-FORMAT.md`); `lowercase.md` = guia de domínio (ex.: `tests.md`).
- Prefira nomes de arquivo sem acento e sem espaços, mesmo quando o **conteúdo** é em português.

## Frontmatter

```yaml
---
name: <kebab-name>          # igual ao nome da pasta
description: <o que faz>. Usar quando <gatilhos concretos + frases literais do usuário>.
---
```

### A description é a única coisa que o agente vê

Ela é exibida junto com as descrições de todas as outras skills e decide se esta carrega. É UX para o agente. Regras:
- Primeira frase = o que faz. Segunda = `Usar quando …` com gatilhos concretos.
- Inclua **frases literais que o usuário digita**, entre aspas (`"grill me"`, `"debug isso"`).
- Terceira pessoa, abaixo de ~1024 chars. Se ficar longa, o escopo está difuso.
- Específica o bastante para **distinguir esta skill das similares**.
- **Bom:** `Extrai texto e tabelas de PDFs, preenche formulários, mescla documentos. Usar quando trabalhar com PDFs ou quando o usuário mencionar formulários ou extração de documentos.`
- **Ruim:** `Ajuda com documentos.` (nada que a distinga de outras skills)

### `disable-model-invocation` é a exceção

A flag impede o modelo de auto-invocar a skill por inferência; ela só roda quando nomeada. Use apenas para skills que são um comando de voz do usuário (`zoom-out`, `grill-me`) ou uma operação perigosa/de setup/irreversível que nunca deve disparar automaticamente. Caso contrário, omita — a `description` bem escrita é o mecanismo de invocação, e a flag esconde a skill justamente quando o agente deveria reconhecê-la.

### `license` e `argument-hint` (opcionais)

- `license:` quando houver conteúdo de terceiros — dizendo qual asset vem de onde (ver [`security-and-privacy.md`](security-and-privacy.md)).
- `argument-hint:` quando a skill recebe um texto livre que muda a saída (ex.: `argument-hint: "O que a próxima sessão vai focar?"`); o corpo diz como tratar o argumento.

## Corpo

- Lead com o **princípio central** em uma linha, em negrito.
- Mantenha o `SKILL.md` abaixo de ~200 linhas. Uma skill imperativa de um parágrafo é válida — o limite é teto, não meta.
- Quando crescer, o `SKILL.md` vira um **router**: decide e aponta para assets; os assets carregam o detalhe. Ao apontar, diga **quando** ler o asset, em linguagem obrigatória. Referências descem **um nível**; nunca crie asset sem referenciá-lo.
- Seção de abertura do tipo "como ler esta skill" só em skill grande/multi-asset; em skill curta é boilerplate — omita.
- Crie assets **de forma lazy** — apenas quando houver conteúdo real.
- Técnicas (tags XML, pares Bom/Ruim, portões de decisão, escapes de falha, fases com checklist, durabilidade, composabilidade, dependências hard/soft, scripts, skills de setup): ver [`craft.md`](craft.md).

---

## ⚠️ CRÍTICO — Fluxo obrigatório ao criar uma nova skill

### Passo 1 — Achar a pasta de skills do Cofre

A sessão roda dentro da pasta do Cofre. Confirme com:

```powershell
Test-Path .\.claude\skills
```

Se a pasta não existir, crie (`New-Item -ItemType Directory -Force .\.claude\skills`). Se a sessão estiver aberta fora do Cofre, avise a pessoa e peça para abrir o atalho do Cofre antes de continuar: a skill precisa ficar na pasta do Cofre para ser carregada nas próximas sessões.

### Passo 2 — Criar a skill

Crie `.claude/skills/<kebab-name>/SKILL.md` (mais os assets) seguindo as seções acima. Se já existir uma skill com o mesmo nome, **leia todos os arquivos dela** e edite a existente; não crie versão paralela.

### Passo 3 — Registrar no índice do Cofre (se houver)

Se o `CLAUDE.md` do Cofre mantém um índice de skills, adicione uma linha compacta — `` | `<nome>` | <gatilho curto: quando abrir esta skill> | `` — perto de skills de domínio similar. O índice é roteador, não documentação: detalhes ficam no `SKILL.md`.

### Passo 4 — Ativar

Skills novas são lidas ao abrir uma sessão. Diga à pessoa para fechar o `claude` e abrir de novo pelo atalho do Cofre; depois ela testa com `/<nome-da-skill>` ou com uma frase dos gatilhos da `description`.

---

## Checklist

- [ ] Dor/modo de falha claro; regras não óbvias com **diagnóstico do modo de falha** antes do procedimento
- [ ] `name` = nome da pasta (kebab-case)
- [ ] `description`: o que faz + "Usar quando" + gatilhos entre aspas, < ~1024 chars, distingue das similares
- [ ] `disable-model-invocation` apenas se for comando de voz da pessoa ou setup perigoso
- [ ] `SKILL.md` mínimo, < ~200 linhas; assets referenciados dizendo *quando* ler, um nível só
- [ ] Exemplos concretos; anti-padrões nomeados como critério comportamental; dependências hard/soft classificadas
- [ ] Generalizada; sem segredo, dado pessoal, dado de candidato/colaborador ou contexto de cliente sem autorização; conteúdo de terceiros atribuído
- [ ] Criada em `.claude/skills/<nome>/` do Cofre; linha no índice do `CLAUDE.md`, se ele existir
- [ ] Pessoa avisada para reabrir o `claude` para carregar a skill

> Referência de craft: mattpocock/skills (github.com/mattpocock/skills) — estudo em [`skill-writing-patterns.md`](skill-writing-patterns.md).
