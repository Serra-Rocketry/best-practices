# 🚀 Boas Práticas - Serra Rocketry

> Guia essencial para padronização e colaboração nos repositórios da equipe

## 📚 Seção 1: Git não é Backup - É uma Máquina do Tempo Colaborativa

### O que é Git vs Backup
- **Backup**: Salva uma cópia do estado atual dos arquivos
- **Git (Versionamento)**: Salva TODA a história de mudanças, quem fez, quando fez, e por quê
  - Você pode voltar para qualquer ponto da história
  - Você pode ver exatamente o que mudou entre versões
  - Várias pessoas podem trabalhar no mesmo projeto sem se atrapalharem

### Por que isso importa para o Serra Rocketry?
- **Rastreabilidade**: "Por que mudamos o sensor de pressão no ano passado?" - Git tem a resposta
- **Segurança**: Se algo quebrar, sabemos exatamente qual mudança causou o problema
- **Portfólio**: Suas contribuições ficam registradas PARA SEMPRE no seu perfil GitHub
- **Colaboração**: Todos podem trabalhar simultaneamente sem medo de estragar o trabalho do colega

### Conceitos Essenciais (com analogias)
- **Repositório**: A pasta do projeto com superpoderes de histórico
- **Commit**: Uma "foto" do projeto em um momento específico, com descrição
- **Branch**: Uma linha temporal alternativa (como nos filmes de ficção científica)
- **Fork**: Sua cópia pessoal do projeto onde você pode experimentar à vontade
- **Pull Request**: "Ei, fiz melhorias aqui, que tal adicionar ao projeto principal?"

📖 **Para aprender mais**: [Git in 15 minutes - Tutorial Interativo](https://try.github.io/)

---

## 🔄 Seção 2: Fluxo de Trabalho Serra Rocketry - Do Fork ao Pull Request

### Por que Fork + Pull Request?
- **Segurança**: Você nunca quebra o código principal acidentalmente
- **Currículo**: Todas suas contribuições aparecem no SEU perfil GitHub
- **Revisão**: Alguém sempre revisa antes de integrar (4 olhos > 2 olhos)
- **Aprendizado**: Você aprende vendo o código dos outros e recebendo feedback

### Passo a Passo Ilustrado

#### 1️⃣ **Fork - Crie sua cópia**
- Vá no repositório do Serra Rocketry
- Clique em "Fork" (canto superior direito)
- Agora você tem uma cópia no SEU GitHub: `github.com/SEU-USUARIO/nome-do-projeto`

#### 2️⃣ **Clone - Baixe para seu computador**
```bash
git clone https://github.com/SEU-USUARIO/nome-do-projeto.git
cd nome-do-projeto
```

#### 3️⃣ **Branch - Crie sua linha temporal**
```bash
git checkout -b feature/sensor-temperatura
# Nomeie com: feature/descricao ou fix/descricao
```

#### 4️⃣ **Trabalhe e Commite**
```bash
# Após fazer mudanças
git add .
git commit -m "Adiciona leitura do sensor DS18B20"
# Mensagem clara e em português
```

#### 5️⃣ **Push - Envie para SEU GitHub**
```bash
git push origin feature/sensor-temperatura
```

#### 6️⃣ **Pull Request - Proponha a mudança**
- GitHub mostrará um botão verde "Compare & Pull Request"
- Descreva O QUE você fez e POR QUE
- Marque alguém para revisar (@usuario)

### Exemplo de Boa Descrição de PR
```markdown
## O que foi feito
- Implementei leitura do sensor de temperatura DS18B20
- Adicionei filtro de média móvel para reduzir ruído

## Por que é necessário
Para a telemetria do foguete precisamos monitorar temperatura
da câmara de combustível em tempo real

## Como testar
1. Conecte o DS18B20 no pino D4
2. Execute o código
3. Verifique leitura no Serial Monitor
```

### ⚠️ Regra de Ouro
**NUNCA** faça commit direto na `main` do repositório principal. Sempre use o fluxo Fork → PR.

📖 **Para aprender mais**: 
- [GitHub Flow - Guia Visual](https://guides.github.com/introduction/flow/)
- [Primeiro Pull Request - Tutorial](https://www.firsttimersonly.com/)

---

## 🌳 Seção 3: Branches - Organizando as Competições

### Estrutura de Branches Padrão

```
main
├── develop (desenvolvimento contínuo)
├── comp-2025 (configuração específica para competição 2025)
├── comp-2026 (configuração específica para competição 2026)
└── feature/nome-da-feature (funcionalidades em desenvolvimento)
```

### Quando usar cada Branch

#### `main`
- Código estável e testado
- Versão que foi ou será usada em lançamento real
- **Protegida**: só recebe código via PR aprovado

#### `develop`
- Integração de novas funcionalidades
- Testes em bancada
- Preparação para próxima versão estável

#### `comp-YYYY`
- Configurações específicas de cada competição
- Regulamentos mudam? Branch nova!
- Preserva exatamente o que foi usado em cada ano
```bash
# Criar branch de competição
git checkout -b comp-2025
# Fazer ajustes específicos para regulamento 2025
```

#### `feature/*` ou `fix/*`
- Sempre criadas a partir de `develop`
- Uma funcionalidade por branch
- Nome descritivo: `feature/telemetria-lora`, `fix/vazamento-memoria`

### Exemplo Prático
```bash
# Preparando para competição 2025
git checkout develop
git checkout -b comp-2025

# Ajusta parâmetros para regulamento
# - Apogeu máximo: 3000m
# - Peso máximo: 5kg
# - Frequência telemetria: 915MHz

git commit -m "Ajusta parâmetros para regulamento COBRUF 2025"
```

### 📝 Importante
Cada branch de competição deve ter um `README-COMP.md` documentando:
- Regulamento específico daquele ano
- Configurações alteradas
- Resultados obtidos

📖 **Para aprender mais**: [Git Branching - Tutorial Interativo](https://learngitbranching.js.org/?locale=pt_BR)

---

## 📁 Seção 4: Organização de Repositórios

### Tipos de Repositório e Estrutura

#### Repositórios de Sistema Completo (Computador de Bordo, Satélite)
```
nome-do-projeto/
├── docs/                     # Documentação e diagramas
│   ├── hardware/            # Esquemáticos, PCB
│   ├── datasheets/          # PDFs dos componentes
│   └── images/              # Fotos e diagramas
├── firmware/                 # Código do microcontrolador
│   └── firmware.ino
├── software/                 # Interface, telemetria (se houver)
│   ├── ground-station/      # Software da base
│   └── data-analysis/       # Scripts de análise
├── hardware/                 # Arquivos de CAD, PCB
│   ├── pcb/                # Arquivos KiCAD/Eagle
│   └── 3d-models/          # STL para impressão
├── lib/                     # Bibliotecas customizadas
├── test/                    # Testes e validação
├── .gitignore
└── README.md
```

#### Repositórios de Código Puro (Analysis, Simulações)
```
nome-do-projeto/
├── src/                     # Código fonte
├── data/                    # Dados de entrada/exemplo
├── results/                 # Resultados das análises
├── notebooks/               # Jupyter notebooks (se Python)
├── requirements.txt         # Dependências Python
├── .gitignore
└── README.md
```

### O que NÃO versionar (.gitignore)
```gitignore
# Builds e compilados
*.hex
*.bin
.build/

# Arquivos pessoais do IDE
.vscode/
.idea/
*.code-workspace

# Dados grandes
*.csv
*.log
results/raw_data/

# Segredos
config.h
credentials.py
.env

# Mas SEMPRE inclua
# config.example.h
# credentials.example.py
```

### Arquivos Obrigatórios

#### README.md - Template Mínimo
```markdown
# Nome do Projeto

## O que é
Breve descrição (2-3 linhas)

## Como usar
1. Passo 1
2. Passo 2
3. Passo 3

## Hardware Necessário
- Lista de componentes
- Pinagem

## Dependências
- Biblioteca X
- Ferramenta Y

## Autores
- @usuario1 - Subsistema X
- @usuario2 - Subsistema Y
```

---

## 📂 Seção 5: Estruturação da Documentação - O que vai onde?

### README Principal - Apenas o Essencial

O `README.md` na raiz do projeto é a **vitrine** do projeto. Deve ser conciso e direcionar para documentos específicos.

#### Estrutura do README Principal

```markdown
# Nome do Projeto

![Status](https://img.shields.io/badge/status-em%20desenvolvimento-yellow)
![Versão](https://img.shields.io/badge/versão-1.0.0-blue)

## 📋 Sobre
Descrição breve (2-3 linhas) do que o projeto faz e seu objetivo.

## 🚀 Quick Start
1. Clone o repositório
2. Configure o hardware conforme esquemático
3. Carregue o firmware
4. Execute os testes

## 📁 Estrutura do Projeto
├── docs/           → Documentação detalhada
├── firmware/       → Código do microcontrolador  
├── hardware/       → Esquemáticos e PCBs
├── software/       → Interfaces e análises
└── test/          → Testes e validação

## 🔧 Pré-requisitos
- Hardware: ESP32 + MPU6050
- Software: PlatformIO ou Arduino IDE 2.0+
- Bibliotecas: Ver [requirements.txt](./requirements.txt)

## 📖 Documentação
- [Guia de Instalação Detalhado](./docs/INSTALACAO.md)
- [Esquemático e Montagem](./hardware/README.md)
- [API e Protocolos](./docs/API.md)
- [Troubleshooting](./docs/TROUBLESHOOTING.md)

## 🤝 Contribuindo
Ver [Boas Práticas Serra Rocketry](https://github.com/Serra-Rocketry/best-practices)

## 📊 Status do Projeto
- [x] Leitura de sensores
- [x] Transmissão LoRa
- [ ] Interface web
- [ ] Análise pós-voo

## ✨ Autores
- @fulano - Firmware e eletrônica
- @ciclano - Interface e telemetria
```

### Documentação Distribuída - Cada coisa em seu lugar

#### `/docs/` - Documentação Técnica Detalhada
```
docs/
├── INSTALACAO.md        # Passo a passo completo de setup
├── API.md               # Endpoints, protocolos, mensagens
├── TROUBLESHOOTING.md   # Problemas comuns e soluções
├── CALIBRACAO.md        # Procedimentos de calibração
├── TESTES.md            # Plano e resultados de testes
├── diagrams/            # Diagramas técnicos
│   ├── fluxograma.png
│   └── state_machine.svg
└── meetings/            # Atas de reuniões técnicas
    └── 2024-11-13.md
```

#### `/hardware/README.md` - Documentação de Hardware
```markdown
# Hardware - [Nome do Projeto]

## Lista de Componentes (BOM)
| Componente | Quantidade | Referência | Link |
|------------|------------|------------|------|
| ESP32 | 1 | U1 | [AliExpress](link) |
| MPU6050 | 1 | U2 | [Eletrogate](link) |

## Pinagem
| Pino ESP32 | Conexão | Descrição |
|------------|---------|-----------|
| GPIO 21 | MPU SDA | I2C Data |
| GPIO 22 | MPU SCL | I2C Clock |

## Consumo de Energia
- Operação: 150mA @ 3.3V
- Sleep: 10µA @ 3.3V
- Bateria recomendada: LiPo 1S 1000mAh (6h autonomia)

## Fotos da Montagem
![Montagem](./images/montagem_completa.jpg)

## Arquivos de Fabricação
- [Esquemático PDF](./schematic.pdf)
- [Gerbers para PCB](./gerbers/)
- [Modelo 3D do case](./3d_models/case.stl)
```

#### `/firmware/README.md` - Documentação do Código
```markdown
# Firmware - [Nome do Projeto]

## Arquitetura
O firmware segue arquitetura de máquina de estados:
- IDLE: Aguardando comando
- ARMED: Pronto para lançamento  
- FLIGHT: Coletando dados
- LANDED: Transmitindo dados salvos

## Configuração
Copie config.example.h para config.h e ajuste:
- LORA_FREQ: Frequência em MHz (915.0)
- SAMPLE_RATE: Taxa de amostragem em Hz (100)

## Fluxo de Dados
1. Sensores → DMA Buffer
2. Filtro Kalman
3. Pacote de telemetria
4. Transmissão LoRa (100Hz)

## Comandos Disponíveis
| Comando | Descrição | Exemplo |
|---------|-----------|---------|
| ARM | Arma o sistema | $ARM,1* |
| CAL | Calibra sensores | $CAL,MAG* |

Ver [API completa](../docs/API.md)
```

#### `/test/README.md` - Documentação de Testes
```markdown
# Plano de Testes

## Testes Unitários
- [ ] Leitura I2C
- [ ] Cálculo CRC
- [ ] Filtro Kalman

## Testes de Integração  
- [ ] Sensor + Transmissão
- [ ] Comando remoto + Ação

## Testes em Campo
| Data | Teste | Resultado | Log |
|------|-------|-----------|-----|
| 2024-11-10 | Alcance LoRa | 2.3km | [log](./logs/test_001.csv) |

## Como Executar
cd test/
python run_tests.py --all
```

### Arquivos Especiais na Raiz

#### `CHANGELOG.md`
```markdown
# Changelog

## [1.1.0] - 2024-11-13
### Adicionado
- Suporte para múltiplos sensores
### Corrigido
- Bug no cálculo de altitude

## [1.0.0] - 2024-10-01
### Inicial
- Primeira versão funcional
```

#### `LICENSE`
```
MIT License ou GPL v3 (discutir com a equipe)
```

#### `.gitignore`
```gitignore
# Builds
*.hex
*.bin
.pio/

# Configurações pessoais  
config.h
credentials.h

# Dados de teste grandes
*.csv
*.log
data/raw/

# IDEs
.vscode/
.idea/
```

### 📏 Regras de Ouro

1. **README principal**: Máximo 100 linhas
2. **Se passa de 1 tela**: Crie documento separado
3. **Documentação técnica**: Sempre em `/docs/`
4. **Configurações exemplo**: `config.example.h` versionado, `config.h` no gitignore
5. **Imagens**: Comprima antes de commitar (max 500KB)
6. **Logs e dados**: Nunca no repositório, use [Releases](https://docs.github.com/pt/repositories/releasing-projects-on-github) para datasets

---

## 📝 Seção 6: Documentação Mínima Obrigatória

### Em Todo Commit
```bash
# ❌ RUIM
git commit -m "ajustes"
git commit -m "correções"

# ✅ BOM
git commit -m "Corrige leitura do MPU6050 em alta frequência"
git commit -m "Adiciona filtro Kalman para estimativa de altitude"
```

### Em Todo Código
```cpp
// ❌ RUIM
int x = analogRead(A0) * 0.48828;

// ✅ BOM
// Conversão ADC para temperatura (10mV/°C, ADC 10-bit, Vref=5V)
const float ADC_TO_TEMP = (5.0 / 1024.0) * 100; 
int temperatura_celsius = analogRead(SENSOR_TEMP_PIN) * ADC_TO_TEMP;
```

### Em Todo PR
- **O quê**: Lista de mudanças
- **Por quê**: Motivação/problema resolvido
- **Como testar**: Passos para validar
- **Breaking changes**: Algo que pode quebrar código existente?

### Documentação de Hardware
Para cada PCB/montagem, inclua:
- Foto ou diagrama da montagem
- Lista de componentes (BOM)
- Pinagem utilizada
- Tensões de operação

---

## ⚡ Seção 7: Dicas Rápidas para Produtividade

### Comandos Git Mais Usados
```bash
# Ver status do que mudou
git status

# Ver histórico bonito
git log --oneline --graph

# Desfazer último commit (mantém mudanças)
git reset HEAD~1

# Atualizar seu fork com o original
git remote add upstream https://github.com/Serra-Rocketry/nome-projeto.git
git fetch upstream
git merge upstream/main

# Salvar trabalho temporariamente
git stash
# Recuperar trabalho salvo
git stash pop
```

### Aliases Úteis (.bashrc)
```bash
alias gs='git status'
alias ga='git add .'
alias gc='git commit -m'
alias gp='git push'
alias gl='git log --oneline --graph'
```

### VS Code - Extensões Essenciais
- **GitLens**: Vê quem mudou cada linha
- **Git Graph**: Visualiza branches
- **Arduino/PlatformIO**: Para desenvolvimento embedded

---

## 🎯 Seção 8: Checklist de Contribuição

Antes de fazer um PR, verifique:

- [ ] Código compila sem warnings
- [ ] Testei em hardware real (ou simulador)
- [ ] Adicionei comentários em partes complexas
- [ ] Atualizei README se necessário
- [ ] Commit messages são descritivas
- [ ] Não tem segredos/senhas no código
- [ ] Pedi revisão de pelo menos 1 pessoa

---

## 🚨 Seção 9: Quando Pedir Ajuda

### Está com problema? 
1. **Leia a mensagem de erro** (sim, toda ela)
2. **Google o erro** (alguém já passou por isso)
3. **Pergunte no grupo** com:
   - O que você tentou fazer
   - Mensagem de erro completa
   - Trecho de código relevante
   - O que já tentou resolver

### Canais de Comunicação
- Issues do GitHub: Para bugs e melhorias
- WhatsApp/Discord: Para dúvidas rápidas
- Reuniões: Para decisões de arquitetura

---

## 📚 Seção 10: Recursos para Aprender Mais

### Git e GitHub
- 🎮 [Learn Git Branching](https://learngitbranching.js.org/?locale=pt_BR) - Jogo interativo
- 📺 [Git e GitHub para Iniciantes](https://www.youtube.com/watch?v=8mei6uVttho) - Curso Grátis
- 📖 [Pro Git Book](https://git-scm.com/book/pt-br/v2) - Livro completo em PT-BR

### Boas Práticas de Código
- [Clean Code - Resumo](https://github.com/ryanmcdermott/clean-code-javascript) - Princípios aplicáveis a qualquer linguagem
- [The Twelve-Factor App](https://12factor.net/pt_br/) - Para projetos maiores

### Específico para Embedded
- [PlatformIO](https://platformio.org/) - Alternativa profissional ao Arduino IDE
- [Awesome Embedded](https://github.com/nhivp/Awesome-Embedded) - Lista curada de recursos

---

## 🤝 Contribuindo com Este Documento

Este documento é vivo! Encontrou algo confuso? Tem uma dica melhor? 
1. Faça um fork deste repositório
2. Edite o arquivo `BOAS_PRATICAS.md`
3. Faça um PR com suas melhorias

---
**Mantido por**: Equipe Serra Rocketry - IPRJ/UERJ
