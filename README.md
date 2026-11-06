# claude-code-windows-kit

Instalador de um passo para colocar o **Claude Code** para funcionar em uma máquina **Windows**, com um **Cofre** (pasta de trabalho) já cheio de skills úteis para times de **Talent e RH**.

> Projeto da comunidade. Não é afiliado à Anthropic. "Claude" e "Claude Code" são marcas da Anthropic.

## O que o instalador faz

1. Confere o ambiente (Windows, PowerShell, internet, `winget`).
2. Instala o **Node.js LTS** (se faltar), pelo `winget`.
3. Instala o **Claude Code** com o instalador oficial (`https://claude.ai/install.ps1`) e põe `~\.local\bin` no PATH.
4. Pergunta o **endereço da API** (um gateway/túnel/proxy compatível com a API da Anthropic, ou nada para usar o login normal da conta) e a **chave** (digitada sem aparecer na tela). Testa o endereço, mostra a lista de modelos e deixa você escolher o modelo padrão de cada família.
5. Grava `~\.claude\settings.json` (com cópia de segurança do que já existia) e ativa o modo **`bypassPermissions`** por padrão (o Claude não pergunta antes de executar comandos e editar arquivos; veja [Segurança](#segurança)).
6. Instala e configura o **MCP do Playwright** (controle de navegador), em um destes modos:
   - **`extension`**: usa o seu Chrome já logado, pela extensão *Playwright MCP Bridge*;
   - **`profile`**: um Chrome próprio do Claude, com login salvo em `~\playwright-perfil` (bom para rotinas).
7. Cria o **Cofre** em Documentos (`Cofre <seu usuário>`, ou o nome que você escolher), com `CLAUDE.md`, pastas básicas e as **skills** em `.claude\skills`.
8. Cria um **atalho na Área de Trabalho** que abre o PowerShell já dentro do Cofre e roda `claude`.

Pode rodar de novo quando quiser: cada passo confere o que já existe, e skills que você editou são preservadas (a não ser que use `-Force`).

## Como usar

Requisitos: Windows 10/11, PowerShell 5.1 (já vem no Windows) e internet.

**1.** Baixe o kit (botão *Code → Download ZIP*) e extraia, ou clone:

```powershell
git clone https://github.com/alexandrehpiva/claude-code-windows-kit.git
cd claude-code-windows-kit
```

**2.** Se baixou o ZIP, desbloqueie os arquivos (o Windows marca downloads como não confiáveis):

```powershell
Get-ChildItem -Recurse | Unblock-File
```

**3.** Rode:

```powershell
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

No Git Bash ou no WSL, o `install.sh` chama o mesmo script pelo PowerShell do Windows (`./install.sh`). As perguntas podem não funcionar no terminal do Git Bash (mintty); se isso acontecer, use o PowerShell.

### Parâmetros opcionais

| Parâmetro | Efeito |
|---|---|
| `-ApiUrl https://meu-gateway.exemplo.com` | Já informa o endereço da API (sem `/v1`) |
| `-VaultName "Cofre Ana"` | Nome da pasta do Cofre |
| `-Browser extension\|profile\|none` | Modo do Playwright, sem perguntar |
| `-NoBypass` | **Não** ativa o modo sem permissões por padrão |
| `-SkipSkills` | Não copia as skills |
| `-Force` | Substitui skills que já existem no Cofre |

A chave pode vir da variável de ambiente `CLAUDE_KIT_API_KEY` (evita digitar). Ela nunca é impressa.

## Skills incluídas (`assets/skills`)

| Skill | Para quê | Origem |
|---|---|---|
| `job-description-generator` | Escrever e revisar descrição de vaga, com linguagem inclusiva | claude-office-skills (MIT), adaptada |
| `resume-screener` | Triar currículos contra os requisitos da vaga | clawfu-skills (MIT) |
| `interview-scheduler` | Montar o processo e o painel de entrevistas | clawfu-skills (MIT) |
| `onboarding-guide` | Planejar a integração de quem entra | clawfu-skills (MIT) |
| `employee-support` | FAQ e fluxos de dúvidas de colaboradores | clawfu-skills (MIT) |
| `engagement-analyzer` | Analisar pesquisa de engajamento | clawfu-skills (MIT) |
| `hr-workflows` | Fluxos de RH do recrutamento ao desligamento | claude-office-skills (MIT), adaptada |
| `cv-ats-fit` | Aderência de currículo a uma vaga (sem inventar "nota de ATS") | autoria do kit |
| `personal-cv` | Revisão de currículo e checagem de "cheiro de IA" no texto | autoria do kit |
| `personal-job-interviews` | Pesquisa da empresa e briefing de entrevista | autoria do kit |
| `grill-me` | Entrevista implacável sobre um plano até fechar a decisão | autoria do kit |
| `write-a-skill` | Cria skills novas dentro do Cofre | autoria do kit |
| `awesome-design` | Visual de ~84 marcas como referência de design (`DESIGN.md`) | VoltAgent/awesome-design-md (MIT) |

Detalhes de origem, versão copiada e alterações: [THIRD_PARTY.md](THIRD_PARTY.md).

As skills de terceiros estão em inglês (o Claude responde no idioma que você usar). As skills de RH são apoio à análise: **a decisão sobre pessoas é sempre humana**.

### Adicionar ou criar skills

- Para incluir no kit: crie uma pasta `assets/skills/<nome>/` com um `SKILL.md` e rode o instalador de novo.
- Para criar dentro do Cofre, converse com o Claude: *"crie uma skill para ..."* (a `write-a-skill` cuida do formato). Depois feche e abra o atalho.

## Segurança

- **Modo `bypassPermissions`.** Com ele ligado, o Claude executa comandos e altera arquivos **sem pedir confirmação**. Use em uma máquina/usuário dedicado ao trabalho, com a pasta do Cofre como área de trabalho. Para desligar, rode com `-NoBypass` ou apague `"defaultMode"` de `~\.claude\settings.json`. Na primeira abertura o Claude mostra um aviso de confirmação desse modo.
- **A chave da API fica em texto no `~\.claude\settings.json`.** O instalador restringe o arquivo ao seu usuário do Windows, mas qualquer processo rodando como você consegue lê-lo. Não commite, não envie e não compartilhe esse arquivo. Se a chave vazar, revogue-a no serviço que a emitiu.
- **Endereço público.** Se o seu gateway estiver exposto na internet (túnel), qualquer pessoa que descubra o endereço e tenha a chave usa o serviço. Prefira uma rede privada (VPN) quando possível.
- **Playwright em modo `extension`.** O Claude passa a controlar abas do seu Chrome com as suas sessões logadas. Libere só a aba necessária e evite o modo sem permissões nessa situação. Em modo `profile`, o login fica salvo em `~\playwright-perfil` (trate a pasta como credencial).
- **Instalador remoto.** O passo do Claude Code executa o script oficial baixado de `claude.ai`. Se preferir, instale manualmente seguindo a documentação oficial e rode o kit depois (ele detecta que já existe).
- **Dados de pessoas (LGPD).** Currículos e avaliações são dados pessoais. O `CLAUDE.md` do Cofre traz regras básicas (minimização, sem características protegidas, decisão final humana), mas revise com o seu time jurídico/DPO antes de usar com dados reais.
- **Skills de terceiros.** Foram lidas e revisadas antes de entrar no kit (sem scripts, sem comandos de rede), mas são conteúdo de terceiros: revise antes de confiar em um fluxo crítico.

## Solução de problemas

| Sintoma | O que fazer |
|---|---|
| `claude` "não é reconhecido" | Feche e abra um PowerShell novo (o PATH só atualiza ao abrir). Confira `dir $env:USERPROFILE\.local\bin` |
| `node`/`npx` "não é reconhecido" depois de instalar | Feche e abra um PowerShell novo e rode o instalador de novo |
| Execução de script bloqueada | Use `-ExecutionPolicy Bypass` e `Unblock-File` (passos 2 e 3 acima) |
| `winget` não existe | Instale o Node.js LTS em nodejs.org e rode de novo |
| `/mcp` mostra `CONNECTION_CLOSED` no playwright | Falta o Node.js, ou o cadastro precisa do `cmd /c` (o instalador já usa). Teste `npx -y @playwright/mcp@latest` à mão |
| API responde 401/403 | Chave inválida ou sem permissão: gere outra no serviço |
| Aba do Chrome não aparece no modo `extension` | Instale a extensão *Playwright MCP Bridge*, deixe o Chrome aberto e escolha a aba na página que a extensão abre |

## Desinstalar

```powershell
claude mcp remove playwright --scope user
Remove-Item "$env:USERPROFILE\.claude\settings.json"      # contém a chave
Remove-Item -Recurse "$env:USERPROFILE\playwright-perfil"  # se usou o modo profile
```

Depois apague o Cofre em Documentos e o atalho na Área de Trabalho. Para remover o Claude Code e o Node.js, use "Aplicativos instalados" do Windows (ou `winget uninstall OpenJS.NodeJS.LTS`).

## Status e testes

- A sintaxe dos scripts e as funções auxiliares (normalização do endereço, mesclagem do `settings.json`, nome de pasta, argumentos do atalho) têm testes automatizados: `pwsh -File tests/test-functions.ps1`.
- O fluxo completo reproduz passos que foram feitos e conferidos à mão numa máquina Windows (instalação do Node e do Claude Code, `settings.json`, MCP do Playwright em ambos os modos), mas **o `install.ps1` em si ainda não foi executado de ponta a ponta em uma máquina limpa**. Se algo falhar, abra uma issue com a mensagem exibida (sem a chave).

## Estrutura do repositório

```
install.ps1            instalador principal
install.sh             atalho para Git Bash/WSL (chama o install.ps1)
lib/common.ps1         funções auxiliares (testáveis)
assets/skills/         skills copiadas para o Cofre
assets/templates/      CLAUDE.md e LEIAME do Cofre
tests/                 testes das funções
third_party/licenses/  licenças dos conteúdos de terceiros
```

## Licença

MIT (veja [LICENSE](LICENSE)). Conteúdos de terceiros mantêm as licenças originais (veja [THIRD_PARTY.md](THIRD_PARTY.md)).
