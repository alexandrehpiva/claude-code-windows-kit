# ats-mechanics — o que é fato vs. mito sobre ATS

Resumo de um estudo de referência sobre ATS (não incluído neste kit). Aqui só o que é operacionalmente acionável nesta skill.

## Por que workflow fixo, não julgamento livre

Um erro de avaliação de fit tem custo real (aprovar um "score" que não existe, ou sugerir keyword stuffing que faz o currículo soar gerado por IA). A literatura de referência (Anthropic "Building Effective Agents") recomenda workflow com etapas fixas e validação, não agente livre, exatamente para esse tipo de tarefa — daí o fluxo passo-a-passo do `SKILL.md`, não "avalie como achar melhor".

## Mitos a nunca repetir como fato

- **"75% dos currículos são rejeitados automaticamente"** — estatística de marketing de 2012 de empresa hoje extinta, sem base auditável. Não citar como fato.
- **"Recrutador olha 6-7 segundos"** — mede triagem humana (estudo comercial fraco), não mecânica de ATS.
- **"O robô rejeita currículo bonito"** — o estudo mais crível (HBS/Accenture 2021, "Hidden Workers") aponta a causa raiz de candidatos perdidos como **filtro de busca humano mal configurado**, não formatação exótica rejeitada por robô.

## Modos de falha de parsing com base técnica real (evitar de fato)

- Layout multi-coluna — ordem de leitura vira sopa fora de sequência.
- Tabelas usadas como layout (não como dado tabular).
- Caixas de texto — muitos extratores não leem conteúdo dentro delas.
- Cabeçalho/rodapé — contato ali pode ser ignorado por parser.
- PDF só-imagem (sem camada de texto extraível).
- Fonte com encoding customizado — texto extrai corrompido.
- Ícones/SmartArt no lugar de texto — não carrega conteúdo extraível.

Checklist de formatação segura (evidência técnica direta, verificar contra o HTML/PDF real):
- [ ] Coluna única
- [ ] Nomes de seção padrão ("Experiência", "Formação" — não título criativo)
- [ ] Contato no corpo do documento, não em cabeçalho/rodapé
- [ ] Bullets padrão, não ícone/símbolo customizado
- [ ] Siglas por extenso na primeira menção

## Keyword matching: é literal, não semântico — confirmado por teste real

Testes reais em ferramentas comerciais (Enhancv, AjustaCV, Teal HQ) confirmam: **matching de keyword é string literal na mesma língua, sem sinônimo, sem normalização cross-idioma, sem nem reordenação de palavras**. Achado mais extremo: "REST APIs" (currículo em inglês) não bateu com "APIs REST" (vaga em português) — mesmas duas palavras, ordem invertida, 0% de match reconhecido.

**Implicação prática para o gap analysis desta skill:**
- Ao apontar keyword ausente, citar o **termo literal exato da JD** — não assumir que um sinônimo ou tradução no currículo já "conta".
- Vaga em idioma diferente do currículo avaliado = risco real de match artificialmente baixo, mesmo com conteúdo real equivalente. Sinalizar isso explicitamente no relatório, não deixar implícito.
- Densidade de keyword: 2-3 repetições no máximo, sempre em contexto de frase — nunca lista solta/escondida (stuffing é penalizado por ranking moderno baseado em embedding **e** é notado por leitura humana).

## Por que não fabricar um "score de ATS"

- Nenhum ATS comercial relevante (Workday, iCIMS, Greenhouse, Gupy, **Sólides** — plataforma usada por muitas empresas brasileiras) documenta publicamente sua mecânica exata de parsing/ranking.
- Nenhum benchmark público e auditável de matching currículo-vaga existe hoje — datasets acadêmicos citados (AliYun, Intellipro, XING) são proprietários/restritos.
- Ferramentas comerciais de "score" (Jobscan e similares) não são auditáveis externamente — testes reais mostraram scores inconsistentes entre ferramentas para o mesmo par currículo-vaga (23% a 59% dependendo da ferramenta).
- Um número fabricado passa falsa sensação de precisão. O gap qualitativo (coberto/parcial/ausente, com fonte citada) é a saída honesta e é o que a arquitetura de referência do estudo (`04 — Arquitetura de agente de IA.md`) recomenda como saída real, não um score solto.

## O segundo filtro: humano, depois do ATS

Achado central do estudo (`02 — Otimização de currículo baseada em evidências.md`): currículo otimizado agressivamente pra ATS por IA está sendo cada vez mais **auto-rejeitado por recrutador humano** que reconhece o padrão de genericidade/keyword stuffing. Por isso o fluxo desta skill exige rodar também o checklist de "cheiro de IA" (`ai-smell-check.md` da skill `personal-cv`) — otimizar só pro filtro automático e ignorar o humano que lê depois é otimizar pro filtro errado.

## Vetor de risco a nunca introduzir

~1% dos currículos hoje têm instruções ocultas (texto branco-sobre-branco, fonte 0pt) direcionadas a manipular triagem por LLM — crescendo, e detectável. Esta skill **nunca** gera texto oculto/manipulativo no currículo, mesmo que o objetivo seja só "melhorar o score" — é limite ético, não só tático (mina credibilidade do candidato se descoberto).
