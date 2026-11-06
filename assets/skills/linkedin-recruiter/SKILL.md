---
name: linkedin-recruiter
description: >-
  Apoia quem recruta: monta e refina buscas no LinkedIn Recruiter e no
  Recruiter Lite (Boolean, filtros, Spotlights, busca com IA), escreve InMails
  que respeitam a regra de taxa de resposta, organiza projetos e pipeline, lê
  relatórios do Talent Insights e avalia currículos e perfis do ponto de vista
  do recrutador. Versão "do outro lado" da skill personal-cv. Usar quando a
  pessoa disser "monte a busca no LinkedIn Recruiter", "string Boolean para
  essa vaga", "quais filtros usar", "escreva um InMail", "minha taxa de
  resposta caiu", "como organizar o projeto/pipeline", "o que é Spotlight",
  "relatório de talent pool", "avalie este perfil/currículo para a vaga".
---

# linkedin-recruiter

**Princípio:** toda orientação sobre o LinkedIn Recruiter vem da documentação oficial (em `SOURCES.md`, com data de consulta). O que vier de fonte de terceiros é dito como tal, e recurso que não está documentado não é prometido.

## Diagnóstico do modo de falha

Sem esta skill o assistente tende a:
- inventar sintaxe que o Recruiter não aceita (curinga `*`, `+`/`-`, Boolean no filtro de Projeto) ou ignorar as *stop words* que somem da busca ("after sales" vira "sales");
- citar taxas de resposta e "benchmarks" de blogs como se fossem do LinkedIn;
- escrever InMail longo e genérico, enviado em massa, que derruba a taxa de resposta do assento e bloqueia o envio em massa;
- tratar o plano Lite como se tivesse os recursos do Recruiter (Spotlights, Open to work, buscas salvas ilimitadas);
- avaliar pessoas por características protegidas ou decidir no lugar do recrutador.

## Antes de agir

1. Pergunte (se não souber) **qual plano** a pessoa usa: Recruiter (Corporate), Recruiter Lite ou RPS/RPS+. Muitos recursos mudam por plano.
2. Pegue a **descrição da vaga** (ou o rascunho). Sem ela, monte primeiro o perfil com a pessoa: cargo, senioridade, local/modelo de trabalho, requisitos obrigatórios e desejáveis.
3. Leia o asset da tarefa (tabela abaixo) antes de responder.

## Roteamento

| Tarefa | Ler antes |
|---|---|
| Montar ou corrigir busca, Boolean, filtros, busca com IA, buscas salvas e alertas | [`search.md`](search.md) |
| Escolher Spotlights (Open to work, Active talent, etc.) | [`spotlights.md`](spotlights.md) |
| Escrever InMail, campanha, entender a regra dos 13% | [`inmail.md`](inmail.md) |
| Organizar projeto, etapas do pipeline, notas, tags, colaboração | [`projects-pipeline.md`](projects-pipeline.md) |
| Relatório de talent pool, mercado, concorrência por talento | [`insights.md`](insights.md) |
| Avaliar currículo ou perfil contra a vaga (lado do recrutador) | [`candidate-review.md`](candidate-review.md) |
| Conferir de onde veio uma informação | [`SOURCES.md`](SOURCES.md) |

## Regras

- **Não automatize o LinkedIn.** Não sugira robôs, extensões de raspagem ou envio automatizado: violam os termos de uso e podem restringir a conta. Use os recursos do próprio Recruiter (buscas salvas, alertas, projetos, Recommended Matches).
- **Interface muda.** Nomes de menus podem ter mudado desde a data em `SOURCES.md`. Se a pessoa não achar um botão, peça um print em vez de insistir.
- **Dados de candidatos (LGPD).** Use só o necessário para a vaga; não copie perfis inteiros para fora do Recruiter sem necessidade; não registre dados sensíveis.
- **Decisão humana.** A skill organiza evidências; quem decide avançar ou recusar é o recrutador ou o gestor da vaga.
- **Sem características protegidas.** Nunca filtre, pontue ou comente idade, gênero, raça, religião, orientação sexual, deficiência, estado civil, gravidez ou nacionalidade. Se o pedido envolver isso, explique o motivo e ofereça critério ligado ao trabalho.

## Saída esperada

Entregue o que a pessoa vai colar ou executar, pronto para uso: a string Boolean por campo (Cargo, Empresas, Palavras-chave), os filtros e Spotlights recomendados com o porquê, o texto do InMail com contagem de caracteres, ou o quadro de avaliação do candidato. Diga sempre qual plano o conselho exige.
