# 📁 Boas Práticas de Organização de Projetos

> Estrutura profissional que facilita colaboração e manutenção

[← Voltar ao índice](./README.md)

---

## 🎯 Índice

1. [Por que Organização Importa](#por-que-organização-importa)
2. [Estrutura de Repositórios](#estrutura-de-repositórios)
3. [O que Versionar e o que Ignorar](#o-que-versionar-e-o-que-ignorar)
4. [Documentação Distribuída](#documentação-distribuída)
5. [Arquivos Obrigatórios](#arquivos-obrigatórios)
6. [Regras de Ouro](#regras-de-ouro)

---

## Por que Organização Importa

### 😵 Projeto Desorganizado
```
foguete/
├── codigo.ino
├── codigo_v2.ino
├── teste.ino
├── biblioteca.h
├── esquematico.pdf
├── foto.jpg
├── dados_teste_15_11.csv
├── dados_teste_16_11.csv
└── README (incompleto)
```

**Problemas:**
- Onde está o código que realmente funciona?
- Qual esquemático é o atual?
- Como compilo isso?
- Quais bibliotecas preciso instalar?

### ✨ Projeto Organizado
```
flight-computer/
├── docs/              # Toda documentação técnica
├── firmware/          # Código do microcontrolador
├── hardware/          # Esquemáticos e PCB
├── software/          # Código de análise/interface
├── test/             # Testes e validação
├── .gitignore        # O que NÃO versionar
├── LICENSE           # Licença do projeto
├── README.md         # Visão geral
└── requirements.txt  # Dependências
```

**Vantagens:**
- ⚡ Novo membro encontra tudo rapidamente
- 📖 Documentação sempre no lugar certo
- 🔧 Fácil de compilar e testar
- 🤝 Outros projetos podem reutilizar partes

---

## Estrutura de Repositórios

### Tipo 1: Sistema Completo (Hardware + Firmware + Software)

**Exemplos:** `flight-computer`, `satellite`, `thrust-stand`

```
nome-do-projeto/
├── docs/                       # 📚 Documentação técnica
│   ├── hardware/              # Esquemáticos, PCB layouts
│   │   ├── schematic.pdf
│   │   ├── pcb_layout.pdf
│   │   └── bom.md            # Bill of Materials
│   ├── datasheets/            # PDFs dos componentes
│   │   ├── esp32-s3.pdf
│   │   └── mpu6050.pdf
│   ├── diagrams/              # Fluxogramas, diagramas
│   │   ├── state_machine.svg
│   │   └── data_flow.png
│   ├── INSTALACAO.md          # Guia de setup
│   ├── API.md                 # Protocolos e interfaces
│   ├── CALIBRACAO.md          # Procedimentos
│   └── TROUBLESHOOTING.md     # Problemas comuns
│
├── firmware/                   # 💾 Código do microcontrolador
│   ├── src/
│   │   ├── main.cpp
│   │   ├── sensors.cpp
│   │   └── telemetry.cpp
│   ├── include/
│   │   ├── sensors.h
│   │   └── telemetry.h
│   ├── lib/                   # Bibliotecas customizadas
│   │   └── custom_lib/
│   ├── platformio.ini         # Configuração PlatformIO
│   ├── config.example.h       # Template de configuração
│   └── README.md              # Instruções específicas
│
├── hardware/                   # ⚡ Arquivos de hardware
│   ├── kicad/                 # Projeto KiCAD
│   │   ├── projeto.kicad_pro
│   │   ├── projeto.kicad_sch
│   │   └── projeto.kicad_pcb
│   ├── gerbers/               # Arquivos para fabricação
│   ├── 3d_models/             # Modelos 3D (STL, STEP)
│   │   ├── case.stl
│   │   └── mount.stl
│   ├── images/                # Fotos da montagem
│   │   ├── montagem_top.jpg
│   │   └── montagem_bottom.jpg
│   └── README.md              # Pinagem, BOM, especificações
│
├── software/                   # 💻 Software de suporte
│   ├── ground-station/        # Interface da base
│   │   ├── main.py
│   │   └── requirements.txt
│   └── data-analysis/         # Scripts de análise
│       ├── plot_flight.py
│       └── analyze_telemetry.py
│
├── test/                       # 🧪 Testes e validação
│   ├── unit/                  # Testes unitários
│   ├── integration/           # Testes de integração
│   ├── field/                 # Logs de testes em campo
│   │   └── 2024-11-15_test.csv
│   └── README.md              # Plano de testes
│
├── .gitignore                 # Arquivos ignorados
├── LICENSE                    # MIT, GPL, etc
├── README.md                  # Visão geral do projeto
├── CHANGELOG.md               # Histórico de versões
└── requirements.txt           # Dependências Python (se houver)
```

---

### Tipo 2: Código Puro (Análise, Simulações)

**Exemplos:** `analysis`, `simulations`

```
nome-do-projeto/
├── src/                       # Código fonte
│   ├── main.py
│   ├── physics.py
│   └── visualization.py
│
├── data/                      # Dados de entrada
│   ├── raw/                   # Dados brutos (não versionar se grande)
│   ├── processed/             # Dados processados
│   └── README.md              # Descrição dos dados
│
├── notebooks/                 # Jupyter notebooks
│   ├── exploration.ipynb
│   └── analysis.ipynb
│
├── results/                   # Resultados (não versionar)
│   ├── figures/
│   └── reports/
│
├── tests/                     # Testes
│   └── test_physics.py
│
├── .gitignore
├── README.md
├── requirements.txt           # Dependências
└── setup.py                   # Instalação do pacote
```

---

### Tipo 3: Firmware Puro (Microcontrolador)

**Exemplo:** `ignitor`

```
ignitor/
├── src/
│   ├── main.cpp
│   ├── ignition.cpp
│   └── safety.cpp
│
├── include/
│   ├── ignition.h
│   └── safety.h
│
├── lib/                       # Bibliotecas locais
│
├── test/
│   └── test_ignition.cpp
│
├── docs/
│   ├── USER_MANUAL.md
│   ├── pinout.png
│   └── safety_procedures.md
│
├── platformio.ini             # ou Makefile
├── .gitignore
├── LICENSE
└── README.md
```

---

## O que Versionar e o que Ignorar

### ✅ SEMPRE Versionar

#### Código Fonte
```
✅ *.cpp, *.h, *.py, *.js
✅ *.ino (Arduino)
✅ Makefiles, platformio.ini
✅ Scripts de build
```

#### Documentação
```
✅ *.md (README, docs)
✅ Diagramas (*.svg, *.png pequenos)
✅ Esquemáticos (*.pdf)
```

#### Configurações de Exemplo
```
✅ config.example.h
✅ credentials.example.py
✅ .env.example
```

#### Hardware
```
✅ Arquivos KiCAD (*.kicad_*)
✅ Gerbers (arquivos pequenos)
✅ Modelos 3D (*.stl, *.step)
✅ BOM (bill of materials)
```

---

### ❌ NUNCA Versionar

#### Builds e Compilados
```
❌ *.hex, *.bin, *.elf
❌ *.o, *.obj
❌ .pio/, .build/
❌ __pycache__/
```

#### Arquivos Pessoais do IDE
```
❌ .vscode/
❌ .idea/
❌ *.code-workspace
❌ .DS_Store (macOS)
```

#### Dados Grandes
```
❌ *.csv (se > 1MB)
❌ *.log
❌ results/raw_data/
❌ *.bag (ROS)
```

#### Segredos e Configurações Pessoais
```
❌ config.h (versione config.example.h)
❌ credentials.py
❌ .env
❌ *.key, *.pem
❌ secrets/
```

#### Arquivos Temporários
```
❌ *.tmp, *.temp
❌ *.swp, *~
❌ .cache/
```

---

### Exemplo de `.gitignore` Completo

```gitignore
# ============================================
# Builds e Compilados
# ============================================
*.hex
*.bin
*.elf
*.o
*.obj
.pio/
.build/

# ============================================
# Python
# ============================================
__pycache__/
*.py[cod]
*$py.class
*.so
.Python
venv/
env/
ENV/
*.egg-info/
dist/
build/

# ============================================
# IDEs
# ============================================
.vscode/
.idea/
*.code-workspace
*.sublime-project
*.sublime-workspace

# ============================================
# Sistema Operacional
# ============================================
.DS_Store        # macOS
Thumbs.db        # Windows
*.swp            # Vim
*~               # Emacs

# ============================================
# Dados e Logs
# ============================================
*.csv
*.log
*.dat
data/raw/
results/
logs/

# Exceção: dados pequenos de exemplo
!data/example.csv

# ============================================
# Configurações Pessoais (use .example)
# ============================================
config.h
credentials.py
.env
secrets/
*.key
*.pem

# ============================================
# Documentação Gerada
# ============================================
docs/_build/
site/

# ============================================
# Testes
# ============================================
.coverage
htmlcov/
.pytest_cache/

# ============================================
# Hardware
# ============================================
*.bak           # Backups do KiCAD
*-cache.lib
*.kicad_pcb-bak
fp-info-cache
```

---

## Documentação Distribuída

### Princípio: Cada Coisa em Seu Lugar

**❌ Tudo no README:**
```markdown
# README.md (3000 linhas) 
- Descrição
- Instalação (500 linhas)
- API completa (1000 linhas)
- Troubleshooting (500 linhas)
- Hardware (800 linhas)
...
```

**✅ Distribuído:**
```markdown
# README.md (100 linhas)
- Descrição breve
- Quick start
- Links para docs específicas

# docs/INSTALACAO.md (200 linhas)
- Passo a passo detalhado

# docs/API.md (300 linhas)  
- Documentação completa da API

# hardware/README.md (150 linhas)
- BOM, pinagem, fotos
```

---

### README Principal - Template Mínimo

```markdown
# Nome do Projeto

![Status](https://img.shields.io/badge/status-em%20desenvolvimento-yellow)
![Versão](https://img.shields.io/badge/versão-1.0.0-blue)

## 📋 Sobre
Breve descrição (2-3 linhas) do que o projeto faz e seu objetivo.

**Exemplo:** Sistema de computador de bordo para foguetes de alta potência,
com telemetria LoRa, recuperação dual-deploy e logging em cartão SD.

## 🚀 Quick Start

```bash
# Clone o repositório
git clone https://github.com/Serra-Rocketry/flight-computer.git
cd flight-computer

# Configure o hardware
# Ver pinagem em: hardware/README.md

# Compile e grave
cd firmware
pio run -t upload

# Teste
pio device monitor
```

## 📁 Estrutura do Projeto

```
├── docs/           → Documentação detalhada
├── firmware/       → Código do microcontrolador  
├── hardware/       → Esquemáticos e PCBs
├── software/       → Ground station e análises
└── test/          → Testes e validação
```

## 🔧 Pré-requisitos

**Hardware:**
- ESP32-S3 DevKit
- MPU6050 (IMU)
- BMP388 (barômetro)
- RFM95W (LoRa 915MHz)

**Software:**
- PlatformIO Core 6.0+
- Python 3.8+ (para ground station)

**Bibliotecas:**
Ver [requirements.txt](./requirements.txt) e [platformio.ini](./firmware/platformio.ini)

## 📖 Documentação

- 📥 [Guia de Instalação Detalhado](./docs/INSTALACAO.md)
- ⚡ [Esquemático e Montagem](./hardware/README.md)
- 🔌 [API e Protocolos](./docs/API.md)
- 🔧 [Troubleshooting](./docs/TROUBLESHOOTING.md)
- ⚙️ [Calibração de Sensores](./docs/CALIBRACAO.md)

## 🤝 Contribuindo

Leia [Boas Práticas Serra Rocketry](https://github.com/Serra-Rocketry/best-practices)

**Workflow:**
1. Fork este repositório
2. Crie uma branch: `git checkout -b feature/sua-funcionalidade`
3. Commit: `git commit -m 'Adiciona funcionalidade X'`
4. Push: `git push origin feature/sua-funcionalidade`
5. Abra um Pull Request

## 📊 Status do Projeto

- [x] Leitura de sensores (IMU + Baro)
- [x] Detecção de apogeu
- [x] Transmissão LoRa
- [x] Dual deploy
- [ ] Interface web de configuração
- [ ] Análise pós-voo automatizada

## 🏆 Competições

- **COBRUF 2024** - 2º Lugar Categoria Avançado
- **COBRUF 2025** - Planejado

## ✨ Autores

- [@joao-silva](https://github.com/joao-silva) - Firmware e eletrônica
- [@maria-santos](https://github.com/maria-santos) - Ground station e análise
- [@pedro-costa](https://github.com/pedro-costa) - Hardware e integração

## 📄 Licença

Este projeto está sob a licença MIT - veja [LICENSE](LICENSE) para detalhes.

## 🙏 Agradecimentos

- Equipe Serra Rocketry - IPRJ/UERJ
- Biblioteca [MPU6050 do jrowberg](https://github.com/jrowberg/i2cdevlib)
- [PlatformIO](https://platformio.org/)
```

---

### `/docs/INSTALACAO.md` - Exemplo

```markdown
# 📥 Guia de Instalação

## Requisitos

### Hardware
- ESP32-S3 DevKit com USB-C
- Módulo MPU6050 (giroscópio + acelerômetro)
- Módulo BMP388 (barômetro)
- Módulo RFM95W LoRa 915MHz
- Protoboard ou PCB customizado
- Cabos jumper
- Fonte 3.3V (ou USB)

### Software
- Python 3.8 ou superior
- PlatformIO Core 6.0+
- Git

---

## Passo 1: Clonar o Repositório

```bash
git clone https://github.com/Serra-Rocketry/flight-computer.git
cd flight-computer
```

## Passo 2: Instalar PlatformIO

### Linux/macOS
```bash
python3 -m pip install platformio
```

### Windows
```powershell
python -m pip install platformio
```

Verifique a instalação:
```bash
pio --version
# Deve mostrar: PlatformIO Core, version X.X.X
```

## Passo 3: Montar o Hardware

### Pinagem ESP32-S3

| Pino ESP32 | Componente | Função | Observações |
|------------|------------|--------|-------------|
| GPIO 21 | MPU6050 SDA | I2C Data | Pull-up 4.7kΩ |
| GPIO 22 | MPU6050 SCL | I2C Clock | Pull-up 4.7kΩ |
| GPIO 21 | BMP388 SDA | I2C Data | Barramento compartilhado |
| GPIO 22 | BMP388 SCL | I2C Clock | Barramento compartilhado |
| GPIO 5 | RFM95W SCK | SPI Clock | |
| GPIO 18 | RFM95W MISO | SPI MISO | |
| GPIO 23 | RFM95W MOSI | SPI MOSI | |
| GPIO 15 | RFM95W CS | SPI Chip Select | |
| GPIO 14 | RFM95W RST | Reset | |
| GPIO 2 | RFM95W DIO0 | Interrupt | |

### Diagrama

Ver [hardware/pinout_diagram.png](../hardware/pinout_diagram.png)

### Fotos

![Montagem Top View](../hardware/images/montagem_top.jpg)
![Montagem Side View](../hardware/images/montagem_side.jpg)

## Passo 4: Configurar Firmware

```bash
cd firmware

# Copiar template de configuração
cp config.example.h config.h

# Editar configurações
nano config.h
```

**Configurações importantes em `config.h`:**

```cpp
// Frequência LoRa (MHz)
#define LORA_FREQ 915.0

// Taxa de amostragem (Hz)
#define SAMPLE_RATE 100

// Altitude de referência (m) - calibrar no local de lançamento
#define REF_ALTITUDE 0

// Altitudes para deploy (m acima de referência)
#define DROGUE_ALTITUDE 300  // Paraquedas drogue
#define MAIN_ALTITUDE 100    // Paraquedas principal
```

## Passo 5: Compilar e Gravar

```bash
# Listar portas disponíveis
pio device list

# Compilar
pio run

# Gravar no ESP32
pio run -t upload

# Monitorar serial
pio device monitor --baud 115200
```

**Saída esperada:**
```
[INFO] Flight Computer v1.0.0
[INFO] Inicializando sensores...
[OK] MPU6050 detectado
[OK] BMP388 detectado  
[OK] LoRa inicializado em 915.0 MHz
[INFO] Sistema pronto!
```

## Passo 6: Instalar Ground Station (Opcional)

```bash
cd ../software/ground-station

# Criar ambiente virtual
python3 -m venv venv
source venv/bin/activate  # Linux/macOS
# ou: venv\Scripts\activate  # Windows

# Instalar dependências
pip install -r requirements.txt

# Executar
python main.py
```

## Troubleshooting

Ver [TROUBLESHOOTING.md](./TROUBLESHOOTING.md)

## Próximos Passos

1. [Calibrar sensores](./CALIBRACAO.md)
2. [Executar testes em bancada](../test/README.md)
3. [Configurar telemetria](./API.md)
```

---

## Arquivos Obrigatórios

### `LICENSE`

Escolha uma licença apropriada:

**MIT** (permissiva - recomendada para projetos acadêmicos):
```
MIT License

Copyright (c) 2024 Serra Rocketry - IPRJ/UERJ

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:
...
```

**GPL v3** (copyleft - derivados devem ser open source):
- Use quando quiser garantir que modificações também sejam abertas
- Arquivo completo: https://www.gnu.org/licenses/gpl-3.0.txt

---

### `CHANGELOG.md`

Mantenha histórico de mudanças:

```markdown
# Changelog

Todas as mudanças notáveis neste projeto serão documentadas neste arquivo.

O formato é baseado em [Keep a Changelog](https://keepachangelog.com/pt-BR/1.0.0/),
e este projeto segue [Semantic Versioning](https://semver.org/lang/pt-BR/).

## [Unreleased]

### Planejado
- Interface web de configuração
- Suporte para múltiplos perfis de voo

## [1.1.0] - 2024-11-15

### Adicionado
- Suporte para sensor BMP388 (além do BMP280)
- Filtro Kalman para estimativa de altitude
- Modo de teste em bancada (sem detecção de lançamento)

### Modificado
- Taxa de amostragem aumentada de 50Hz para 100Hz
- Protocolo de telemetria compactado (32 bytes → 24 bytes)

### Corrigido
- Vazamento de memória no loop de telemetria
- Leitura incorreta do MPU6050 em alta frequência

## [1.0.0] - 2024-10-01

### Inicial
- Primeira versão estável
- Leitura de MPU6050 e BMP280
- Detecção de apogeu
- Dual deploy funcional
- Transmissão LoRa 915MHz
- Logging em cartão SD

[Unreleased]: https://github.com/Serra-Rocketry/flight-computer/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/Serra-Rocketry/flight-computer/compare/v1.0.0...v1.1.0
[1.0.0]: https://github.com/Serra-Rocketry/flight-computer/releases/tag/v1.0.0
```

---

### `requirements.txt` (para Python)

```txt
# Análise de dados
numpy==1.24.3
pandas==2.0.3
matplotlib==3.7.2

# Comunicação serial
pyserial==3.5

# Interface
PyQt6==6.5.2

# Opcional: análise avançada
scipy==1.11.1
```

Instalar:
```bash
pip install -r requirements.txt
```

---

### `platformio.ini` (para PlatformIO)

```ini
[env:esp32-s3-devkitc-1]
platform = espressif32
board = esp32-s3-devkitc-1
framework = arduino

; Velocidade de upload
upload_speed = 921600

; Velocidade do monitor serial
monitor_speed = 115200

; Bibliotecas
lib_deps = 
    adafruit/Adafruit MPU6050@^2.2.4
    adafruit/Adafruit BMP3XX Library@^2.1.2
    sandeepmistry/LoRa@^0.8.0
    arduino-libraries/SD@^1.2.4

; Flags de compilação
build_flags = 
    -D CORE_DEBUG_LEVEL=3
    -D BOARD_HAS_PSRAM
```

---

## Regras de Ouro

### 📏 Organização

1. **README principal**: Máximo 150 linhas
   - Se passar de 1 tela, crie documento separado

2. **Uma responsabilidade por diretório**
   - `docs/`: Apenas documentação
   - `firmware/`: Apenas código do microcontrolador
   - `hardware/`: Apenas arquivos de hardware

3. **Documentação técnica**: Sempre em `/docs/`
   - Não misture com código

4. **Arquivos de exemplo**: Sempre versionados
   - `config.example.h` ✅ (versiona)
   - `config.h` ❌ (no .gitignore)

### 📝 Nomenclatura

5. **Nomes descritivos**
   - ✅ `sensor_calibration.cpp`
   - ❌ `util.cpp`

6. **Lowercase com underscores** (snake_case) para arquivos
   - ✅ `flight_computer.cpp`
   - ❌ `FlightComputer.cpp`

7. **Markdown para documentação**
   - ✅ `README.md`, `INSTALACAO.md`
   - ❌ `readme.txt`, `instalacao.docx`

### 💾 Versionamento

8. **Imagens**: Comprima antes de commitar
   - Máximo 500KB por imagem
   - Use ferramentas como TinyPNG

9. **Dados grandes**: Nunca no repositório
   - Use [GitHub Releases](https://docs.github.com/pt/repositories/releasing-projects-on-github) para datasets
   - Ou links externos (Google Drive, Dropbox)

10. **Commits atômicos**: Uma mudança lógica por commit
    - ✅ Um commit por funcionalidade
    - ❌ Commit gigante com várias coisas não relacionadas

---

## Checklist: Novo Projeto

Antes de fazer o primeiro commit:

- [ ] README.md com descrição, quick start, e links
- [ ] LICENSE escolhida (MIT recomendada)
- [ ] .gitignore configurado
- [ ] Estrutura de diretórios criada
- [ ] Arquivo de dependências (requirements.txt ou platformio.ini)
- [ ] config.example.h (se houver configurações)
- [ ] docs/ com pelo menos INSTALACAO.md
- [ ] hardware/README.md com pinagem
- [ ] CHANGELOG.md iniciado

---

[← Voltar ao índice](./README.md)

