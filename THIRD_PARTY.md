# Conteúdo de terceiros

Todos os itens abaixo são licenciados sob **MIT**. As licenças originais estão em `third_party/licenses/` (e em `assets/skills/awesome-design/LICENSE`).

| Skill(s) no kit | Repositório de origem | Commit copiado | Licença | Alterações |
|---|---|---|---|---|
| `awesome-design` (pasta `brands/`) | [VoltAgent/awesome-design-md](https://github.com/VoltAgent/awesome-design-md) | `fcc702849322` | MIT | Os arquivos `design-md/<marca>/DESIGN.md` foram copiados para `brands/<marca>.md`; o `INDEX.md` foi gerado a partir do README deles; o `SKILL.md` é novo. Os `DESIGN.md` são interpretações da comunidade, não material oficial das marcas. |
| `resume-screener`, `interview-scheduler`, `onboarding-guide`, `employee-support`, `engagement-analyzer` | [guia-matthieu/clawfu-skills](https://github.com/guia-matthieu/clawfu-skills) (`skills/hr-ops/`) | `4108f5c010cc` | MIT | Nenhuma (cópia dos `SKILL.md`). |
| `job-description-generator` (origem: `job-description`), `hr-workflows` (origem: `hr-automation`) | [claude-office-skills/skills](https://github.com/claude-office-skills/skills) | `9c4c7d5cd281` | MIT | Pastas renomeadas; cabeçalho (frontmatter) substituído por `name`/`description` em português, com os gatilhos de uso; corpo mantido. Referências a ferramentas MCP de escritório (`office-mcp`) no corpo não funcionam neste kit. |

As skills `cv-ats-fit`, `personal-cv`, `personal-job-interviews`, `grill-me` e `write-a-skill` são de autoria do mantenedor do kit e seguem a licença MIT do repositório. Foram generalizadas para uso por qualquer pessoa: nomes, caminhos e exemplos pessoais foram removidos, e a `write-a-skill` cria skills dentro da pasta `.claude/skills` do Cofre.

A `write-a-skill` cita como referência de estilo o repositório [mattpocock/skills](https://github.com/mattpocock/skills) (apenas menção e resumo de ideias; nenhum arquivo dele foi copiado).

## Como foi revisado

Antes de entrar no kit, cada skill de terceiros foi lida e varrida em busca de comandos de rede, execução de código, instruções para ignorar regras e credenciais. Nenhuma tem scripts. Uma skill candidata (`chro-advisor`, de alirezarezvani/claude-skills) foi descartada por depender de scripts Python que não existem no ambiente alvo.
