# 📚 Boas Práticas de Git e GitHub

> Git não é Backup - É uma Máquina do Tempo Colaborativa

[← Voltar ao índice](./README.md)

---

## 🎯 Índice

1. [O que é Git vs Backup](#o-que-é-git-vs-backup)
2. [Por que isso importa para o Serra Rocketry?](#por-que-isso-importa-para-o-serra-rocketry)
3. [Conceitos Essenciais](#conceitos-essenciais)
4. [Fluxo de Trabalho: Fork → Pull Request](#fluxo-de-trabalho-fork--pull-request)
5. [Estratégia de Branches](#estratégia-de-branches)
6. [Commits Profissionais](#commits-profissionais)
7. [Comandos Git Essenciais](#comandos-git-essenciais)
8. [Recursos para Aprender](#recursos-para-aprender)

---

## O que é Git vs Backup

### Backup
- Salva uma **cópia** do estado atual dos arquivos
- Como uma "foto" única
- Se você perder o backup, perdeu tudo
- Não mostra O QUE mudou, QUEM mudou, ou POR QUÊ mudou

### Git (Versionamento)
- Salva **TODA a história** de mudanças
- Como um "filme" completo do projeto
- Você pode voltar para qualquer ponto da história
- Mostra exatamente o que mudou entre versões
- Registra quem fez, quando fez, e por quê
- Várias pessoas podem trabalhar simultaneamente sem conflitos

### Analogia

```
BACKUP:
📸 Estado do projeto hoje

GIT:
🎬 [Commit 1] → [Commit 2] → [Commit 3] → [Commit 4]
    |            |            |            |
    João        Maria        João         Pedro
    "Inicial"   "Add sensor" "Fix bug"    "Add telemetry"
```

Cada "commit" é como um ponto de salvamento em um jogo - você pode voltar para qualquer um!

---

## Por que isso importa para o Serra Rocketry?

### 🔍 Rastreabilidade
**Situação:** "Por que mudamos o sensor de pressão no projeto do ano passado?"

**Com Git:**
```bash
$ git log --grep="sensor pressão" --oneline
a3f2d1c Substitui BMP280 por BMP388 para maior precisão
```

**Detalhes do commit:**
```
commit a3f2d1c
Author: João Silva <joao@serrarocketry.com>
Date: 2024-03-15

Substitui BMP280 por BMP388 para maior precisão

O BMP388 possui resolução de 0.016 Pa vs 0.18 Pa do BMP280,
necessário para detectar apogeu com precisão de ±2m conforme
regulamento COBRUF 2024.

Referência: Issue #42
```

Você tem TODA a context do por quê a mudança foi feita!

### 🛡️ Segurança
**Situação:** Após uma mudança, o foguete não detecta mais o apogeu corretamente.

**Com Git:**
```bash
# Voltar para versão anterior
$ git checkout a3f2d1c

# Ou comparar o que mudou
$ git diff a3f2d1c HEAD
```

Você identifica EXATAMENTE qual linha de código causou o problema.

### 📊 Portfólio
Todas suas contribuições ficam registradas no seu perfil GitHub:
- Empresas podem ver seus commits, PRs, e issues
- Demonstra experiência com trabalho em equipe
- Mostra evolução técnica ao longo do tempo

### 🤝 Colaboração
**Sem Git:**
```
código_final.ino
código_final_v2.ino
código_final_v2_corrigido.ino
código_final_ESTE_SIM.ino
código_final_revisado_joao.ino  ← Qual usar???
```

**Com Git:**
- Todos trabalham no mesmo repositório
- Branches separados para cada funcionalidade
- Merge automático de mudanças compatíveis
- Conflitos são detectados e resolvidos de forma controlada

---

## Conceitos Essenciais

### 📦 Repositório (Repo)
A pasta do projeto com "superpoderes" de histórico.

```
meu-projeto/
├── .git/           ← Aqui está toda a "magia" do histórico
├── firmware/
├── docs/
└── README.md
```

### 📸 Commit
Uma "foto" do projeto em um momento específico, com descrição.

```bash
git commit -m "Adiciona leitura do sensor MPU6050"
```

**Boa prática:** Commits pequenos e frequentes > commit gigante no final

### 🌿 Branch
Uma linha temporal alternativa - como nos filmes de ficção científica!

```
main:           A → B → C → F
                      ↓
feature/sensor:       D → E
```

Você desenvolve em `feature/sensor` sem afetar a `main`.

### 🍴 Fork
Sua cópia **pessoal** do projeto onde você pode experimentar à vontade.

```
Serra-Rocketry/flight-computer (repositório oficial)
       ↓ [Fork]
seu-usuario/flight-computer (sua cópia)
```

**Vantagens:**
- Você nunca quebra o código principal
- Experimenta livremente
- Contribuições aparecem no SEU perfil

### 🔀 Pull Request (PR)
"Ei, fiz melhorias aqui, que tal adicionar ao projeto principal?"

É como dizer: "Revisei meu código, testei, e acho que está pronto para integrar!"

---

## Fluxo de Trabalho: Fork → Pull Request

### Por que Fork + Pull Request?
- ✅ **Segurança**: Você nunca quebra o código principal acidentalmente
- ✅ **Currículo**: Todas suas contribuições aparecem no SEU perfil GitHub
- ✅ **Revisão**: Alguém sempre revisa antes de integrar (4 olhos > 2 olhos)
- ✅ **Aprendizado**: Você aprende vendo o código dos outros e recebendo feedback

### ⚠️ Regra de Ouro
**NUNCA** faça commit direto na `main` do repositório principal da Serra Rocketry.  
Sempre use o fluxo: **Fork → Branch → Commit → Push → Pull Request**

---

### Passo a Passo Completo

#### 1️⃣ Fork - Crie sua cópia

1. Vá no repositório da Serra Rocketry que você quer contribuir
   - Exemplo: https://github.com/Serra-Rocketry/flight-computer
2. Clique em **"Fork"** (canto superior direito)
3. Agora você tem: `github.com/SEU-USUARIO/flight-computer`

#### 2️⃣ Clone - Baixe para seu computador

```bash
# Substitua SEU-USUARIO pelo seu username do GitHub
git clone https://github.com/SEU-USUARIO/flight-computer.git
cd flight-computer
```

#### 3️⃣ Configure o Remote Upstream (importante!)

```bash
# Adicione o repositório original como "upstream"
git remote add upstream https://github.com/Serra-Rocketry/flight-computer.git

# Verifique
git remote -v
# Deve mostrar:
# origin    https://github.com/SEU-USUARIO/flight-computer.git (seu fork)
# upstream  https://github.com/Serra-Rocketry/flight-computer.git (original)
```

Isso permite que você **sincronize** seu fork com o repositório original.

#### 4️⃣ Sincronize antes de começar (sempre!)

```bash
# Baixe mudanças do repositório original
git fetch upstream

# Atualize sua branch main
git checkout main
git merge upstream/main

# Envie para seu fork
git push origin main
```

**Por quê?** Garantir que você está trabalhando com a versão mais recente!

#### 5️⃣ Branch - Crie sua linha temporal

```bash
# Crie e mude para uma nova branch
git checkout -b feature/telemetria-lora

# Nomenclatura:
# feature/descricao  - para novas funcionalidades
# fix/descricao      - para correções de bugs
# docs/descricao     - para melhorias na documentação
```

#### 6️⃣ Trabalhe e Commite

```bash
# Após fazer mudanças nos arquivos

# Veja o que mudou
git status

# Adicione os arquivos modificados
git add firmware/telemetria.cpp
git add firmware/telemetria.h
# Ou adicione tudo:
git add .

# Faça o commit com mensagem descritiva
git commit -m "Adiciona transmissão LoRa com protocolo personalizado"
```

**Dica:** Faça commits pequenos e frequentes, não espere terminar tudo!

#### 7️⃣ Push - Envie para SEU fork no GitHub

```bash
git push origin feature/telemetria-lora
```

#### 8️⃣ Pull Request - Proponha a mudança

1. Vá no seu fork no GitHub (`github.com/SEU-USUARIO/flight-computer`)
2. GitHub mostrará um banner: **"Compare & Pull Request"** - clique nele
3. Preencha o template do PR:
   - **Título**: Claro e direto
   - **Descrição**: O QUE você fez e POR QUÊ
   - **Como testar**: Passos para validar sua mudança
4. Marque alguém para revisar: `@usuario-revisor`
5. Clique em **"Create Pull Request"**

---

### Exemplo de Boa Descrição de PR

```markdown
## 📝 O que foi feito
- Implementei transmissão de telemetria via LoRa
- Criei protocolo binário compacto (32 bytes/pacote)
- Adicionei CRC16 para validação de integridade

## 🎯 Por que é necessário
Para a competição COBRUF 2025 precisamos transmitir dados em 
tempo real para a estação base a uma distância de até 5km.

## 🧪 Como testar
1. Conecte módulo LoRa RFM95W no SPI padrão
2. Configure frequência 915MHz no `config.h`
3. Compile e grave o firmware
4. Execute ground station para receber dados
5. Verifique no Serial Monitor: "LoRa TX: OK"

## ⚠️ Breaking Changes
Nenhum - código retrocompatível com versão anterior

## 📚 Referências
- Issue #23 - Requisitos de telemetria
- Datasheet RFM95W
```

---

## Estratégia de Branches

### Estrutura de Branches Padrão

```
main
├── develop (desenvolvimento contínuo)
├── comp-2025 (competição COBRUF 2025)
├── comp-2026 (competição Spaceport America 2026)
├── feature/telemetria-lora
├── feature/recuperacao-gnss
└── fix/vazamento-memoria
```

### Quando usar cada Branch

#### `main` - Código de Produção
- Código **estável** e **testado**
- Versão que foi ou será usada em **lançamento real**
- **Protegida**: só recebe código via PR aprovado
- Sempre deve compilar sem erros

**Exemplo:** Código usado no lançamento do SR1500 em outubro/2024

#### `develop` - Desenvolvimento Contínuo
- Integração de novas funcionalidades
- Testes em **bancada** e **simulação**
- Preparação para próxima versão estável
- Pode ter bugs, mas deve compilar

**Workflow:**
```bash
git checkout develop
git checkout -b feature/minha-funcionalidade
# ... desenvolva ...
git push origin feature/minha-funcionalidade
# Abra PR para merge em develop (não main!)
```

#### `comp-YYYY` - Configurações de Competição
- Configurações **específicas** de cada competição
- Regulamentos mudam? Branch nova!
- Preserva exatamente o que foi usado em cada ano
- **Documentação obrigatória** das configurações

**Exemplo prático:**

```bash
# Criar branch para COBRUF 2025
git checkout develop
git checkout -b comp-2025

# Ajustar parâmetros específicos do regulamento
# - Apogeu alvo: 3048m (10000 ft)
# - Peso máximo: 5kg
# - Frequência telemetria: 915 MHz
# - Requisito de redundância dupla

git commit -m "Configura parâmetros para COBRUF 2025"
```

**Arquivo `README-COMP2025.md` obrigatório:**
```markdown
# Configuração COBRUF 2025

## Regulamento
- Apogeu: 3048m ± 10%
- Peso total: máx 5kg
- Recuperação: dual deploy obrigatório

## Configurações Alteradas
- `TARGET_ALTITUDE = 3048`
- `LORA_FREQ = 915.0`
- `REDUNDANCY_MODE = DUAL`

## Hardware Utilizado
- ESP32-S3
- MPU6050 + BMP388
- RFM95W LoRa
- GPS NEO-M9N

## Resultados
- Data: 15/março/2025
- Apogeu real: 3102m
- Status: ✅ Qualificado
```

#### `feature/*` - Novas Funcionalidades
- Criadas a partir de `develop`
- Uma funcionalidade por branch
- Nome descritivo

**Bons nomes:**
- ✅ `feature/telemetria-lora`
- ✅ `feature/filtro-kalman`
- ✅ `feature/recuperacao-dual-deploy`

**Maus nomes:**
- ❌ `feature/melhorias`
- ❌ `feature/teste`
- ❌ `feature/joao-mudancas`

#### `fix/*` - Correções de Bugs
- Criadas a partir de `develop` (ou `main` se bug crítico)
- Nome descreve o bug corrigido

**Exemplos:**
- `fix/vazamento-memoria-telemetria`
- `fix/leitura-incorreta-mpu6050`
- `fix/travamento-sd-card`

---

### Exemplo de Workflow Completo

```bash
# 1. Atualizar develop
git checkout develop
git pull upstream develop

# 2. Criar branch de funcionalidade
git checkout -b feature/gps-navigation

# 3. Desenvolver e commitar
git add .
git commit -m "Adiciona leitura de GPS NEO-M9N"
git commit -m "Implementa cálculo de velocidade via GPS"
git commit -m "Adiciona filtro de média móvel para coordenadas"

# 4. Push para seu fork
git push origin feature/gps-navigation

# 5. Abrir PR no GitHub: feature/gps-navigation → develop

# 6. Após aprovação e merge, deletar branch local
git checkout develop
git pull upstream develop
git branch -d feature/gps-navigation
```

---

## Commits Profissionais

### Anatomia de um Bom Commit

```bash
git commit -m "Título curto (máx 50 caracteres)

Descrição mais detalhada explicando o contexto:
- O que foi mudado
- Por que foi necessário
- Referências (issues, docs)

Closes #42"
```

### Exemplos de Mensagens

#### ❌ Ruins
```bash
git commit -m "ajustes"
git commit -m "correções"
git commit -m "testando"
git commit -m "asdfasdf"
```

**Problema:** Daqui 6 meses, ninguém (nem você!) saberá o que foi feito.

#### ✅ Boas
```bash
git commit -m "Corrige leitura do MPU6050 em alta frequência

O sensor retornava valores saturados quando sample rate > 100Hz.
Solução: adicionar delay de 10ms entre leituras conforme datasheet.

Referência: Issue #34"
```

```bash
git commit -m "Adiciona filtro Kalman para estimativa de altitude

Implementa EKF 1D para fusão de barômetro + acelerômetro.
Reduz ruído de ±5m para ±0.5m na estimativa de altitude.

Baseado em: 
- https://github.com/rlabbe/Kalman-and-Bayesian-Filters-in-Python
- Artigo: 'Sensor Fusion for Rocket Apogee Detection' (2019)"
```

### Convenções de Commit

Use prefixos para categorizar:

```bash
feat: Adiciona suporte para sensor BMP388
fix: Corrige vazamento de memória em loop de telemetria
docs: Atualiza pinagem do hardware no README
refactor: Reorganiza código de leitura de sensores
test: Adiciona testes unitários para cálculo de apogeu
chore: Atualiza biblioteca LoRa para v1.2.0
```

**Baseado em:** [Conventional Commits](https://www.conventionalcommits.org/pt-br/)

---

## Comandos Git Essenciais

### Status e Informação
```bash
# Ver estado atual
git status

# Ver histórico de commits
git log
git log --oneline --graph --all  # visualização compacta

# Ver mudanças não commitadas
git diff

# Ver mudanças em arquivo específico
git diff firmware/main.cpp
```

### Trabalhar com Mudanças
```bash
# Adicionar arquivos ao staging
git add arquivo.cpp
git add .  # adiciona tudo

# Remover do staging (sem perder mudanças)
git restore --staged arquivo.cpp

# Descartar mudanças locais (CUIDADO!)
git restore arquivo.cpp

# Commitar
git commit -m "Mensagem"

# Alterar último commit (antes de push)
git commit --amend
```

### Branches
```bash
# Listar branches
git branch
git branch -a  # incluindo remotos

# Criar branch
git branch nome-branch

# Mudar de branch
git checkout nome-branch

# Criar e mudar (atalho)
git checkout -b nome-branch

# Deletar branch
git branch -d nome-branch

# Renomear branch atual
git branch -m novo-nome
```

### Sincronização
```bash
# Baixar mudanças (sem aplicar)
git fetch upstream

# Baixar e aplicar mudanças
git pull upstream main

# Enviar mudanças
git push origin nome-branch

# Atualizar branch com mudanças de outra
git checkout feature/minha-branch
git merge develop
```

### Salvar Trabalho Temporariamente
```bash
# Guardar mudanças não commitadas
git stash

# Listar stashes
git stash list

# Recuperar último stash
git stash pop

# Recuperar stash específico
git stash apply stash@{0}
```

### Desfazer Coisas
```bash
# Desfazer último commit (mantém mudanças)
git reset HEAD~1

# Desfazer último commit (descarta mudanças) - CUIDADO!
git reset --hard HEAD~1

# Voltar para commit específico (criando novo commit)
git revert a3f2d1c
```

---

## Aliases Úteis

Adicione no seu `~/.bashrc` ou `~/.zshrc`:

```bash
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph --all'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gpl='git pull'
```

Uso:
```bash
ga                    # git add .
gc "Mensagem aqui"    # git commit -m "Mensagem aqui"
gp                    # git push
```

---

## Recursos para Aprender

### 🎮 Tutoriais Interativos
- [Learn Git Branching](https://learngitbranching.js.org/?locale=pt_BR) - Jogo visual para aprender Git
- [Git-it](https://github.com/jlord/git-it-electron) - Tutorial desktop interativo
- [GitHub Skills](https://skills.github.com/) - Cursos oficiais do GitHub

### 📖 Documentação
- [Pro Git Book](https://git-scm.com/book/pt-br/v2) - Livro completo em português (grátis)
- [Git Documentation](https://git-scm.com/doc) - Documentação oficial
- [GitHub Guides](https://guides.github.com/) - Guias rápidos

### 📺 Vídeos
- [Git e GitHub para Iniciantes - Willian Justen](https://www.youtube.com/watch?v=8mei6uVttho)
- [Curso Git - Bóson Treinamentos](https://www.youtube.com/playlist?list=PLucm8g_ezqNq0dOgug6paAkH0AQSJPlIe)

### 📄 Referências Rápidas
- [Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)
- [Interactive Git Cheatsheet](https://ndpsoftware.com/git-cheatsheet.html)

---

## Troubleshooting Comum

### "Conflict" no Pull Request

**O que aconteceu:** Alguém mudou as mesmas linhas que você em outro PR que já foi aprovado.

**Solução:**
```bash
# Atualizar sua branch com a main
git checkout main
git pull upstream main
git checkout sua-branch
git merge main

# Resolver conflitos manualmente nos arquivos
# Procure por:
<<<<<<< HEAD
seu código
=======
código da main
>>>>>>> main

# Após resolver:
git add .
git commit -m "Resolve conflitos com main"
git push origin sua-branch
```

### "Detached HEAD state"

**Solução:**
```bash
# Voltar para uma branch
git checkout main
```

### Commitei na branch errada

**Solução:**
```bash
# Salvar o commit
git log  # copie o hash do commit (ex: a3f2d1c)

# Voltar branch
git checkout branch-correta

# Aplicar o commit
git cherry-pick a3f2d1c
```

### Preciso desfazer um push

**⚠️ CUIDADO:** Só faça isso se ninguém mais puxou suas mudanças!

```bash
git reset --hard HEAD~1
git push --force origin sua-branch
```

---

[← Voltar ao índice](./README.md)

