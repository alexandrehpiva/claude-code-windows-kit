# ai-smell-check — Avaliar "cheiro de IA" em texto

Recurso sob demanda: usar quando a pessoa usuária pedir para avaliar se um texto (currículo, bullet, resumo, post LinkedIn, e-mail, etc.) soa gerado por IA. Não é detector automatizado real — não existe métrica confiável pra isso em texto curto. É leitura de recrutador/editor experiente, procurando os tiques estilísticos que geração por LLM deixa.

**Regra:** só avaliar, nunca alterar o texto nesta etapa — reportar achados e esperar aprovação antes de editar (a menos que o usuário já peça a correção junto).

## O que procurar

- **Prosa (parágrafo corrido) virando fragmento sem verbo** — bullets podem ser fragmento (convenção de currículo/lista), prosa não. Ex.: "Portal B2B (Empresa) com LGPD." sem dizer o que foi feito ali.
- **Soft skill genérico sem fato/exemplo** — frases balanceadas e "seguras" que servem pra qualquer currículo de qualquer pessoa ("comprometido com prazos", "comunicação clara", "aberto a mudanças que façam sentido"). Se não dá pra defender em 30s numa entrevista com um exemplo concreto, é suspeito.
- **Repetição do mesmo fato sem sinal novo** — citar a mesma tech/conceito 2x em frases próximas sem motivo (ex.: "Lambda" na cláusula de LLM e de novo na lista AWS logo depois).
- **Fechamento em bordão curto** — frase final tipo "X e qualidade no dia a dia." que não acrescenta fato, só length e tom.
- **Tradução literal de jargão de IA/inglês** — verbo estranho em português por decalque ("oriento LLMs" em vez de "levei LLMs para produção").
- **Nome de marca solto sem ser o diferencial da frase** — "GPT" onde o termo genérico ("LLM") já bastaria e a marca não muda o sentido.
- **Parágrafos com estrutura excessivamente simétrica** — 3 frases de tamanho igual, mesma cadência, conectivos repetidos ("Além disso... Adicionalmente... Por fim...").

## O que NÃO marcar como problema

- Fragmento sem verbo em **bullet de lista** (convenção padrão de currículo, normal).
- Headline com separador curto (`·`, `|`) — formato de scan rápido, não é tique de IA.
- Termo técnico preciso e correto, mesmo que "bonito" — precisão não é sinal de IA.

## Formato do relatório

Por trecho encontrado: citar o trecho, risco (**Alto** / **Médio** / **Baixo**), motivo em 1 frase. Fechar com:
- **% geral estimado** do texto com esse padrão (estimativa qualitativa, não métrica exata — dizer isso explicitamente no relatório).
- Se o usuário pedir, sugestões de antes/depois ancoradas em fato real e citável (nunca inventar fato novo pra "consertar" o trecho).

## Aplicável a

Currículo (`.html`/`.md`), mas também qualquer texto avulso que a pessoa usuária colar ou apontar — bullet de LinkedIn, resposta de formulário ATS, e-mail, trecho de portfólio. Não limitado ao fluxo de revisão de currículo desta skill.
