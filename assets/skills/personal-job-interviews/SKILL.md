---
name: personal-job-interviews
description: >-
  Pesquisa vagas e empresas, monta briefings de entrevista e persiste dossiês no
  Cofre em Pessoal/Carreira/Vagas e entrevistas/ (por empresa e por
  data). Usar quando o usuário pedir para "estudar a vaga", "preparar entrevista",
  "briefing de entrevista", "pesquisar a empresa", "me ajuda na entrevista",
  "dossiê da vaga", "vagas e entrevistas", ou aprofundar uma oportunidade além
  do resumo do LinkedIn.
---

# personal-job-interviews

**Princípio:** o agente pesquisa com evidência (links + data), monta briefing acionável e **grava no dossiê do cofre** antes de encerrar — sem inventar métricas nem vazar conteúdo privado em destinos externos.

## Modo de falha que esta skill corrige

O agente deixa pesquisa de vaga só no chat, mistura com inbox LinkedIn, inventa fatos da empresa, ou não prepara perguntas/pitch concretos para a entrevista.

## Antes de agir (sempre)

1. Seguir as instruções do `CLAUDE.md` do Cofre.
2. Ler `vault-structure.md` — paths, templates e regra LinkedIn vs dossiê (**obrigatório**).
3. Se for **pesquisar / briefar entrevista**: ler `interview-briefing.md` e, na entrega no chat, `BRIEFING.md` (**obrigatório**).
4. Se for **gravar ou atualizar** no cofre: ler `persistence.md` (**obrigatório**).
5. Seguir a estrutura de pastas do Cofre ao classificar notas.

## Escopo

| Faz | Não faz |
|-----|---------|
| Estudar empresa, founders, funding, produto, stack, processo seletivo | Publicar no LinkedIn / enviar mensagem sem o OK explícito do usuário |
| Briefing para screening, cultural, técnico, founders, case | Assumir que screening = entrevista técnica |
| Fit honesto vs perfil da pessoa candidata (`Pessoal/Carreira/`, `Pessoal/LinkedIn/Perfil.md`) | Fabricar experiência que a pessoa não tem |
| Persistir dossiê completo no cofre | Guardar salário/pacote em chat-log |

## Fluxo rápido

1. Identificar **empresa + cargo + próximo evento** (data/pessoa/tipo).
2. Criar/atualizar pasta do processo (ver `vault-structure.md`).
3. Pesquisar com fontes citadas; métricas de terceiros = atribuídas + data.
4. Entregar briefing no chat conforme `BRIEFING.md`.
5. Persistir (`persistence.md`) + espelhar resumo em `Pessoal/LinkedIn/Oportunidades.md` se veio do LinkedIn + agenda se houver data.

## Escape de falha

- **Sem link da vaga:** pedir URL/JD ou usar só o pitch do recrutador, marcando lacunas.
- **Fontes conflitantes:** mostrar tabela fato/fonte/data; não “média” inventada.
- **Usuário sem tempo:** só Índice + 5 bullets + 3 perguntas; completar dossiê na próxima iteração.
