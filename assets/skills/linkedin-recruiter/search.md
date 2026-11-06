# Busca no LinkedIn Recruiter

Fontes: S1 (Boolean), S2 (filtros), S3 (busca padrão), S4 (página oficial de recursos), S5 (blog oficial sobre busca com IA), S6 (blog oficial sobre projetos), S11 (buscas salvas, ajuda oficial, via resumo de busca). Ver `SOURCES.md`.

## 1. Três jeitos de começar (Recruiter)

Pela barra de busca da página inicial (S3):
- **"Start a Recruiter search with filters"**: busca por filtros.
- **"Start a new AI search"**: descreva a pessoa ideal em linguagem natural ("analista de RH pleno em Curitiba, com experiência em recrutamento tech"). A IA preenche os filtros, e você continua a conversa para ajustar ("amplie para todo o Paraná", "só quem fala inglês") (S5).
- **String Boolean na caixa de texto da IA**: o Recruiter oferece a opção de rodar como busca Boolean (S5).

No **Recruiter Lite** (S3): digite um termo e escolha o cargo mais próximo, ou use "Start new Recruiter search", "Search by ideal candidate" ou "Advanced filters".

Outros recursos de IA documentados no blog oficial (S5, março de 2024; a disponibilidade depende do contrato e, para a versão avançada, do idioma em inglês, segundo o anúncio):
- pedir sugestões de filtros: principais cargos, empresas, competências ou locais relacionados;
- **"encontre alguém parecido com @Nome"**: busca a partir de um candidato modelo;
- criar um **Projeto** direto do texto descrito.

## 2. Boolean: o que o Recruiter aceita (S1)

| Operador | Uso | Efeito |
|---|---|---|
| `AND` (maiúsculas) | `analista AND recrutamento` | exige todos os termos (restringe) |
| `OR` (maiúsculas) | `"tech recruiter" OR "talent acquisition"` | qualquer um dos termos (amplia) |
| `NOT` (maiúsculas, antes do termo) | `recrutador NOT estágio` | exclui (restringe) |
| `( )` | `recrutador AND (tech OR tecnologia) NOT (estágio OR estagiário)` | agrupa |
| `" "` | `"business partner"` | frase exata (nos filtros Cargo, Empresas e Palavras-chave) |

**Não aceita (oficialmente):** `+` e `-` (use `AND` e `NOT`). O filtro **Projeto** não aceita Boolean; para excluir um projeto, digite o termo e clique no ícone de bloquear (S1).

**Ordem de precedência:** a ajuda não define. **Use sempre parênteses** para deixar a lógica explícita.

**Curinga `*`:** não aparece na ajuda oficial; guias de terceiros discordam. Não use; escreva as variações com `OR` (`recrutador OR recrutadora OR recruiter`).

**Stop words** ignoradas no filtro Palavras-chave (S1): and, or, the, of, at, by, to, for, with, in, they, have, from, not, but, after. Por isso `"after sales"` traz perfis só com "sales". Em português, prefira termos sem preposição ou use o filtro de Cargo.

**String longa demais:** a ajuda avisa que muitos elementos numa só string causam problemas; mova partes para os filtros próprios (Cargo, Competências, Modelo de trabalho) (S1).

## 3. Filtros

- Filtros com Boolean e com o seletor **Can have (OR) / Must have (AND) / Doesn't have (NOT)**: Cargos, Localização, Empresas, Competências e Avaliações, Escolas, Setores, Idiomas (S1, S2).
- No menu "Mais" de cada termo: **Atual ou anterior / Atual / Anterior / Anterior e não atual** e, só no Recruiter, **Open to work** (S1, S2).
- "Edit all preferences" e "Edit all priority" aplicam a escolha a todos os termos do filtro (S2).
- **"Hide previously viewed"** (busca avançada) esconde quem você já viu (S2).
- **Smart suggestions**: filtros recomendados que ampliam ou restringem em tempo real (S2).
- Contagens aproximadas: só no Recruiter (S2).
- O Recruiter tem **40+ filtros avançados**; o Lite, **20+**; a conta gratuita, 6 (S4). Combinações podem ser salvas como **filtros personalizados** (S4).

## 4. Receita de busca (boa prática oficial + método)

A ajuda recomenda conjuntos **amplos e inclusivos** de cargos e competências essenciais, em vez de listas longas de exclusões (S1). Passo a passo:

1. **Cargo** (Can have, OR): todas as variações reais do título, em português e inglês, com aspas.
2. **Competências essenciais** (2 a 4, Must have só no que é eliminatório).
3. **Localização** e modelo de trabalho.
4. **Exclusões mínimas** (Doesn't have): nível que não serve (estágio, júnior) ou cargos parecidos mas diferentes.
5. **Palavras-chave** só para o que nenhum filtro cobre (certificação, ferramenta específica).
6. Rode, leia 10 perfis, ajuste. Depois aplique Spotlights (`spotlights.md`).

Exemplo (Recruiter, vaga de Tech Recruiter):
- Cargos (Can have): `"tech recruiter" OR "technical recruiter" OR "recrutador tech" OR "talent acquisition"`
- Cargos (Doesn't have): `estágio OR estagiário OR intern`
- Competências (Must have): `Recrutamento técnico`
- Palavras-chave: `(Gupy OR Greenhouse OR Lever) AND ("hunting" OR "sourcing")`

## 5. Recommended Matches

Use **depois** da busca, para achar quem dificilmente apareceria nela. A IA aprende com suas ações (salvar, ocultar, enviar mensagem) e com cargo, local e competências da vaga (S4). Agir pelo menos uma vez a cada 24 horas mantém até **25 perfis novos por dia** (S6). Candidatos de Recommended Matches aceitam InMail até 35% mais do que os achados só pela busca (S9).

## 6. Buscas salvas e alertas

- Salve a busca e ative **"Receive alerts for this search"**: notificação diária ou semanal de quem passa a atender aos critérios (S6).
- Recruiter: buscas salvas ilimitadas; Recruiter Lite: até 10. Alertas avisam por e-mail e no sino do Recruiter (S11). Retome trabalhos em "Continue recent searches" (Recruiter) ou "Recent work" (Lite) (S3).

## 7. Quando a busca não traz ninguém

1. Tire `Must have` e deixe `Can have`.
2. Remova Palavras-chave e confie nos filtros.
3. Amplie local ou modelo de trabalho.
4. Troque frase exata por variações com `OR`.
5. Confira stop words e operadores em minúsculas (`and` vira palavra comum).
