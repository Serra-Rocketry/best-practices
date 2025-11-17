# 💻 Boas Práticas de Software

> Modularidade, Reutilização e Filosofia Unix aplicadas a Projetos de Foguetemodelismo

[← Voltar ao índice](./README.md)

---

## 🎯 Índice

1. [Filosofia Unix: One Tool, One Job](#filosofia-unix-one-tool-one-job)
2. [Modularidade e Separação de Responsabilidades](#modularidade-e-separação-de-responsabilidades)
3. [Quando Separar vs Quando Juntar](#quando-separar-vs-quando-juntar)
4. [Fork vs Novo Repositório vs Monorepo](#fork-vs-novo-repositório-vs-monorepo)
5. [Não Reinvente a Roda](#não-reinvente-a-roda)
6. [Gestão de Releases](#gestão-de-releases)
7. [Casos Reais da Serra Rocketry](#casos-reais-da-serra-rocketry)

---

## Filosofia Unix: One Tool, One Job

### 🎯 Princípio Fundamental

> "Faça uma coisa. Faça bem feito."
> — Filosofia Unix

Cada programa deve ter **UMA responsabilidade clara** e executá-la da melhor forma possível.

### Por que isso importa?

#### ✅ **Vantagens**
- **Simplicidade**: Código mais fácil de entender
- **Testabilidade**: Mais fácil de testar cada parte
- **Manutenibilidade**: Mudanças não quebram outros sistemas
- **Reutilização**: Componentes podem ser usados em outros projetos
- **Desenvolvimento paralelo**: Múltiplas pessoas trabalham sem conflitos

#### ❌ **Problemas de misturar responsabilidades**
- Código complexo e difícil de entender
- Mudanças em uma parte quebram outras
- Difícil de testar
- Impossível reutilizar partes isoladas
- Dependências desnecessárias

---

### Exemplo: ignitor e thrust-stand

#### ❌ **Abordagem ERRADA: Misturar**

```
ignitor-thrust-combo/         ← Projeto confuso
├── ignitor.cpp               ← Aciona ignitor
├── load_cell.cpp             ← Lê célula de carga
├── telemetry.cpp             ← Transmite dados
└── main.cpp                  ← Faz TUDO
```

**Problemas:**
1. **Ignitor nunca precisa de célula de carga** no foguete real
2. **Thrust stand nunca precisa de telemetria** no laboratório
3. Mudança no código de célula de carga pode quebrar ignitor
4. Não pode usar ignitor em outro projeto sem arrastar código de thrust stand
5. Dois desenvolvedores não podem trabalhar simultaneamente

**Cenário real:**
> "Preciso do ignitor para o recovery test, mas não compila porque alguém mudou o código da célula de carga que eu nem uso!"

---

#### ✅ **Abordagem CORRETA: Separar**

```
ignitor/                      ← Apenas aciona ignitores
├── src/
│   ├── main.cpp             ← Apenas lógica de ignição
│   ├── safety.cpp           ← Verificações de segurança
│   └── rf_receiver.cpp      ← Recebe comandos
└── README.md                ← "Sistema de ignição remota"

thrust-stand/                 ← Apenas mede empuxo
├── src/
│   ├── main.cpp             ← Apenas leitura de célula
│   ├── load_cell.cpp        ← Interface com HX711
│   └── calibration.cpp      ← Calibração
└── README.md                ← "Bancada de testes de motor"
```

**Vantagens:**
1. ✅ Cada projeto tem dependências mínimas
2. ✅ Ignitor pode ser usado em recovery test, launch pad, qualquer lugar
3. ✅ Thrust stand pode evoluir sem afetar ignitor
4. ✅ Equipes diferentes trabalham em paralelo
5. ✅ Fácil de reutilizar em outros foguetes

**Comunicação entre eles (quando necessário):**
- Via **protocolo padrão** (serial, API, arquivo)
- Não via código compartilhado

---

### Exemplo de Comunicação Modular

Se você REALMENTE precisa que thrust-stand controle ignitor:

```
thrust-stand/
└── src/
    └── main.cpp
        ↓ (comando serial)
        "IGNITE"
        ↓
ignitor/
└── src/
    └── main.cpp
        → Recebe comando
        → Aciona ignitor
```

**Interface serial simples:**
```cpp
// thrust-stand envia:
Serial.println("IGNITE");

// ignitor recebe e processa:
if (Serial.readStringUntil('\n') == "IGNITE") {
    fireIgnitor();
}
```

Projetos **desacoplados**, comunicação via **protocolo simples**.

---

## Modularidade e Separação de Responsabilidades

### 🧩 O que é Modularidade?

Dividir um sistema em **módulos independentes** que podem ser:
- Desenvolvidos separadamente
- Testados isoladamente
- Reutilizados em outros projetos
- Substituídos facilmente

### Níveis de Modularidade

#### 1️⃣ **Funções e Classes**
```cpp
// ❌ Tudo em uma função
void loop() {
    int raw = analogRead(A0);
    float voltage = raw * 5.0 / 1024.0;
    float temp = (voltage - 0.5) * 100.0;
    Serial.println(temp);
    // ... 200 linhas depois ...
}

// ✅ Modular
float readTemperature() {
    int raw = analogRead(TEMP_PIN);
    float voltage = adcToVoltage(raw);
    return voltageToTemperature(voltage);
}

void loop() {
    float temp = readTemperature();
    Serial.println(temp);
}
```

#### 2️⃣ **Arquivos**
```
❌ main.cpp (2000 linhas)

✅ 
├── main.cpp (100 linhas)
├── sensors.cpp (300 linhas)
├── telemetry.cpp (200 linhas)
└── recovery.cpp (150 linhas)
```

#### 3️⃣ **Bibliotecas**
```
❌ Copiar código entre projetos

✅ Criar biblioteca reutilizável
├── lib/
│   └── serra_sensors/
│       ├── MPU6050_wrapper.h
│       └── MPU6050_wrapper.cpp
```

Use em múltiplos projetos:
- flight-computer
- satellite
- thrust-stand (se precisar de IMU)

#### 4️⃣ **Repositórios** (foco desta seção)

---

## Quando Separar vs Quando Juntar

### 🤔 Critérios de Decisão

#### ✅ **SEPARAR em repositórios diferentes quando:**

1. **Diferentes casos de uso**
   - Exemplo: `ignitor` (usado em campo) vs `thrust-stand` (usado em lab)

2. **Diferentes ciclos de vida**
   - Exemplo: `flight-computer` (evolui rápido) vs `ground-station` (estável)

3. **Diferentes equipes/responsáveis**
   - Exemplo: time de firmware vs time de análise de dados

4. **Diferentes linguagens/tecnologias**
   - Exemplo: firmware (C++) vs análise (Python)

5. **Pode ser usado independentemente**
   - Exemplo: `recovery-webui` pode ser usado sem flight-computer

---

#### 🔗 **JUNTAR no mesmo repositório quando:**

1. **Alta interdependência**
   - Mudança em A sempre requer mudança em B
   
2. **Sempre usados juntos**
   - Não fazem sentido separados

3. **Compartilham muito código/configuração**
   - Protocolos, estruturas de dados, constantes

4. **Pequenos e relacionados**
   - Sobrecarga de manter repos separados > benefício

---

### Árvore de Decisão

```
┌─────────────────────────────────────┐
│ A e B são sempre usados juntos?     │
└─────────────┬───────────────────────┘
              │
        ┌─────┴─────┐
       SIM         NÃO
        │           │
        ↓           ↓
   ┌────────┐   ┌───────────────┐
   │ Juntar │   │ SEPARAR repos │
   └────────┘   └───────────────┘
        ↑
        │
   ┌────┴──────────────────────────────┐
   │ Mudanças em A sempre afetam B?     │
   └────────────────────────────────────┘
              │
        ┌─────┴─────┐
       SIM         NÃO → Considere separar
        │
        ↓
     Juntar
```

---

## Fork vs Novo Repositório vs Monorepo

### 🍴 Fork: Variações de um Projeto Base

**Quando usar:**
- Projetos **similares** com diferenças específicas
- Compartilham **maior parte do código**
- Beneficiam de **sincronização** com projeto original

#### Exemplo Real: satellite ← flight-computer

**flight-computer** (repositório original):
- Computador de bordo para foguetes
- Dual deploy
- Telemetria LoRa
- Detecção de apogeu

**satellite** (fork):
- Baseado no flight-computer
- **Diferenças**: 
  - Sem recuperação (órbita, não volta)
  - Missão estendida (dias vs minutos)
  - Sensores adicionais (câmera, GPS de alta precisão)
  - Comunicação via satélite (Iridium)

**Estrutura:**
```
Serra-Rocketry/flight-computer   (original)
       ↓ [Fork]
Serra-Rocketry/satellite         (variação)
```

**Workflow:**
```bash
# Criar fork
# Via interface do GitHub: Fork button

# Clone
git clone https://github.com/Serra-Rocketry/satellite.git
cd satellite

# Manter sincronizado com original
git remote add upstream https://github.com/Serra-Rocketry/flight-computer.git

# Puxar melhorias do flight-computer
git fetch upstream
git merge upstream/main

# Desenvolver features específicas de satélite
git checkout -b feature/iridium-comm
```

**Quando sincronizar:**
- Bug fix no flight-computer? → Merge para satellite
- Nova feature de telemetria? → Merge para satellite
- Feature específica de satélite? → Só no fork, não volta para original

---

### 🆕 Novo Repositório: Projetos Independentes

**Quando usar:**
- Projetos **fundamentalmente diferentes**
- Não compartilham código significativo
- Não precisam de sincronização

#### Exemplo Real: ignitor vs flight-computer

```
Serra-Rocketry/
├── ignitor/           ← Novo repo independente
│   └── Aciona ignitores remotamente
│
└── flight-computer/   ← Outro repo independente
    └── Computador de bordo
```

**Por que separados:**
- **Casos de uso diferentes**: Ignitor usado antes do lançamento, flight-computer durante
- **Hardware diferente**: Ignitor tem relés, flight-computer tem sensores
- **Código não relacionado**: Zero overlap
- **Equipes diferentes**: Podem ser mantidos por pessoas diferentes

**Comunicação (se necessária):**
- Via protocolo padronizado
- Não via código compartilhado

---

### 📦 Monorepo: Múltiplos Projetos, Um Repositório

**Quando usar:**
- Projetos **fortemente acoplados**
- Desenvolvidos pela **mesma equipe**
- Compartilham **muito código** (libs, configs, types)
- Mudanças frequentemente **atravessam** múltiplos componentes

#### Exemplo: Sistema de Telemetria Completo

```
telemetry-system/              ← Monorepo
├── firmware/                  ← Código do foguete
│   └── src/
│       └── telemetry_tx.cpp
│
├── ground-station/            ← Software da base
│   └── src/
│       └── telemetry_rx.py
│
├── shared/                    ← Código compartilhado
│   ├── protocol.h            ← Definição do protocolo
│   └── packet_definition.h
│
└── tools/                     ← Ferramentas
    └── packet_generator.py
```

**Vantagens:**
- Uma mudança no protocolo → atualiza firmware E ground station no mesmo commit
- Testes de integração no mesmo repo
- Versões sincronizadas

**Desvantagens:**
- Repo maior
- Clone mais lento
- Não ideal para projetos independentes

---

### 📊 Comparação: Fork vs Novo Repo vs Monorepo

| Critério | Fork | Novo Repo | Monorepo |
|----------|------|-----------|----------|
| **Compartilham código** | 70-90% | 0-10% | 50-70% |
| **Sincronização** | Frequente | Rara/nunca | Automática |
| **Independência** | Média | Alta | Baixa |
| **Complexidade gestão** | Média | Baixa | Alta |
| **Melhor para** | Variações | Projetos diferentes | Sistema integrado |

---

## Não Reinvente a Roda

### 📚 Use Bibliotecas Existentes

#### ❌ **Abordagem ERRADA**

```cpp
// Reimplementar protocolo I2C do zero
void i2c_init() {
    // 500 linhas de código
    // Bugs sutis
    // Meses de debugging
}

// Reimplementar filtro Kalman
float kalman_filter(float measurement) {
    // 200 linhas
    // Matemática complexa
    // Resultado incorreto
}
```

**Problemas:**
- ⏱️ Desperdiça tempo que poderia ser usado no problema real
- 🐛 Introduz bugs já resolvidos pela comunidade
- 📚 Sem documentação
- 🔧 Difícil de manter
- 🚀 Não agrega valor ao foguete

---

#### ✅ **Abordagem CORRETA**

```cpp
// Use biblioteca testada e mantida
#include <Wire.h>              // I2C nativo do Arduino
#include <Adafruit_MPU6050.h>  // Biblioteca Adafruit
#include <SimpleKalmanFilter.h> // Biblioteca Kalman

Adafruit_MPU6050 mpu;
SimpleKalmanFilter kalman(1, 1, 0.01);

void setup() {
    mpu.begin();  // Funciona imediatamente
}

void loop() {
    sensors_event_t a, g, temp;
    mpu.getEvent(&a, &g, &temp);
    
    float filtered = kalman.updateEstimate(a.acceleration.z);
}
```

**Vantagens:**
- ✅ Funciona imediatamente
- ✅ Testado por milhares de usuários
- ✅ Documentado
- ✅ Mantido pela comunidade
- ✅ Você foca no PROBLEMA do foguete

---

### Bibliotecas Recomendadas

#### Sensores
| Sensor | Biblioteca | Link |
|--------|-----------|------|
| MPU6050 | Adafruit MPU6050 | https://github.com/adafruit/Adafruit_MPU6050 |
| BMP280/388 | Adafruit BMP3XX | https://github.com/adafruit/Adafruit_BMP3XX |
| GPS | TinyGPS++ | https://github.com/mikalhart/TinyGPSPlus |
| SD Card | SD (Arduino) | Nativa |

#### Comunicação
| Protocolo | Biblioteca | Link |
|-----------|-----------|------|
| LoRa | RadioHead ou LoRa | https://github.com/sandeepmistry/arduino-LoRa |
| WiFi | WiFi (ESP32) | Nativa |
| Bluetooth | BluetoothSerial | Nativa |

#### Processamento
| Função | Biblioteca | Link |
|--------|-----------|------|
| Filtro Kalman | SimpleKalmanFilter | https://github.com/denyssene/SimpleKalmanFilter |
| PID | Arduino PID | https://github.com/br3ttb/Arduino-PID-Library |
| Média móvel | RunningAverage | https://github.com/RobTillaart/RunningAverage |

---

### Quando É OK Reimplementar?

✅ **Apenas quando:**
1. **Não existe biblioteca** para seu caso específico
2. **Biblioteca existente tem bug crítico** e maintainer não responde
3. **Requisitos muito específicos** (ex: latência ultra-baixa, tamanho mínimo)
4. **Aprendizado é o objetivo** (e você documenta isso)

❌ **NUNCA reimplemente:**
- Protocolos de comunicação (I2C, SPI, UART)
- Criptografia
- Drivers de sensores comuns
- Filtros matemáticos complexos

---

### Exemplo Real: MPU6050

#### ❌ Reimplementar driver
```cpp
// meu_mpu6050.cpp (600 linhas)
// Tempo: 2 semanas
// Bugs: vários
// Resultado: funciona "mais ou menos"
```

#### ✅ Usar biblioteca
```cpp
#include <Adafruit_MPU6050.h>
// Tempo: 5 minutos
// Bugs: zero (já resolvidos pela comunidade)
// Resultado: funciona perfeitamente
```

**Foco:** Use o tempo economizado para resolver o PROBLEMA REAL:
- Algoritmo de detecção de apogeu
- Estratégia de recuperação
- Análise de dados de voo

---

## Gestão de Releases

### 🏷️ O que é uma Release?

Uma **versão estável** do projeto, pronta para uso em produção.

**Analogia:** Lançamento de um produto:
- Desenvolvendo: obras na fábrica
- Release: produto pronto na prateleira

---

### Quando criar uma Release?

#### ✅ **Crie uma Release quando:**

1. **Antes de uma competição**
   ```
   v2024-cobruf
   - Código usado na COBRUF 2024
   - Configurações específicas do regulamento
   - Testado e validado
   ```

2. **Após mudanças significativas estáveis**
   ```
   v1.0.0 → v1.1.0
   - Nova funcionalidade testada
   - Bug fix importante
   ```

3. **Para marcar código de lançamento**
   ```
   v2024-launch-001
   - Exato código usado no lançamento de 15/mar/2024
   - Para análise futura e reprodutibilidade
   ```

---

### Versionamento Semântico

Use **Semantic Versioning** (SemVer): `MAJOR.MINOR.PATCH`

```
v1.2.3
│ │ │
│ │ └─ PATCH: Bug fixes (incrementa a cada correção)
│ └─── MINOR: New features (compatível com versão anterior)
└───── MAJOR: Breaking changes (incompatível com versão anterior)
```

**Exemplos:**
- `v1.0.0` → `v1.0.1`: Corrigiu bug, código compatível
- `v1.0.1` → `v1.1.0`: Adicionou telemetria WiFi, compatível
- `v1.1.0` → `v2.0.0`: Mudou formato de dados, **INCOMPATÍVEL**

**Competições:** Use tags descritivas
- `v2024-cobruf`
- `v2025-spaceport-america`
- `v2024-launch-sr1500`

---

### Como Criar uma Release

#### Via GitHub (Recomendado)

1. **Termine todas features da versão**
2. **Teste completamente**
3. **Atualize CHANGELOG.md**
   ```markdown
   ## [1.1.0] - 2024-11-15
   ### Added
   - WiFi telemetry
   ### Fixed
   - MPU6050 high frequency bug
   ```

4. **Crie tag e release no GitHub**
   ```bash
   # Via linha de comando
   git tag -a v1.1.0 -m "Release 1.1.0 - WiFi telemetry"
   git push origin v1.1.0
   ```

5. **No GitHub: Releases → Create new release**
   - Tag: `v1.1.0`
   - Title: `v1.1.0 - WiFi Telemetry`
   - Description: Copie do CHANGELOG
   - Anexe binários compilados (`.bin`, `.hex`)
   - Anexe datasets de teste (se pequenos)

---

### Exemplo de Release Notes

```markdown
# v1.1.0 - WiFi Telemetry (2024-11-15)

## 🎉 Novidades

- **WiFi Telemetry**: Transmissão de dados via WiFi para debugging em bancada
- **Web Interface**: Visualização de telemetria em tempo real via navegador
- **Dual Mode**: Automático switch entre LoRa (campo) e WiFi (bancada)

## 🐛 Correções

- Corrige leitura incorreta do MPU6050 em frequências > 100Hz (#42)
- Resolve vazamento de memória no loop de telemetria (#38)
- Ajusta timing de deploy para evitar falsos positivos (#45)

## 📦 Arquivos

- `flight_computer_v1.1.0.bin` - Firmware compilado para ESP32-S3
- `ground_station_v1.1.0.zip` - Software da estação base

## 🔧 Como Atualizar

```bash
# Flash via PlatformIO
pio run -t upload

# Ou via esptool
esptool.py write_flash 0x10000 flight_computer_v1.1.0.bin
```

## ⚠️ Breaking Changes

Nenhum - totalmente compatível com v1.0.x

## 📊 Testado em

- ✅ Bancada de testes - 20 horas
- ✅ Simulação de voo - 50 testes
- ✅ Lançamento teste - 3 voos

## 🙏 Agradecimentos

- @joao-silva - Implementação WiFi
- @maria-santos - Web interface
- @pedro-costa - Testes em campo
```

---

## Casos Reais da Serra Rocketry

### Caso 1: ignitor vs thrust-stand

#### ❌ Se fossem juntos (problema)

```
test-equipment/
├── ignitor.cpp
├── thrust_stand.cpp
└── shared_telemetry.cpp
```

**Problemas:**
- Ignitor para recovery test precisa compilar código de thrust stand
- Atualização na célula de carga pode quebrar ignitor
- Não pode usar ignitor em outros projetos facilmente

#### ✅ Separados (correto)

```
Serra-Rocketry/
├── ignitor/              ← Repositório independente
│   └── Apenas ignição remota
│
└── thrust-stand/         ← Repositório independente
    └── Apenas medição de empuxo
```

**Repositórios atuais:**
- https://github.com/Serra-Rocketry/ignitor
- https://github.com/Serra-Rocketry/thrust-stand

---

### Caso 2: flight-computer vs satellite

#### 🍴 satellite como Fork (correto)

**Razão:** Satellite **é essencialmente um flight-computer** com modificações:

**Código compartilhado (80%):**
- Leitura de sensores
- Estrutura de dados
- Telemetria básica
- Gerenciamento de energia

**Diferenças do satellite (20%):**
- Sem sistema de recuperação
- Comunicação via Iridium
- Missão de longa duração
- Sensores adicionais

**Workflow:**
```bash
# Satellite puxa melhorias do flight-computer
cd satellite
git fetch upstream
git merge upstream/main

# Bug fix de sensor? → Automaticamente no satellite
# Nova feature de telemetria? → Herda
# Feature específica de órbita? → Só no satellite
```

---

### Caso 3: analysis (Repositório Separado)

**analysis**: Scripts Python para análise de dados de voo

```
Serra-Rocketry/analysis/
├── notebooks/
│   ├── trajectory_analysis.ipynb
│   └── apogee_detection_validation.ipynb
├── src/
│   ├── flight_data_parser.py
│   └── visualization.py
└── data/
    └── example_flight.csv
```

**Por que separado:**
- ❌ Não compartilha código com flight-computer
- ❌ Linguagem diferente (Python vs C++)
- ❌ Usado depois do voo, não durante
- ❌ Time diferente (análise vs firmware)
- ✅ Pode analisar dados de QUALQUER foguete

**Comunicação:**
- Via **formato de dados padronizado** (CSV, JSON)
- Não via código compartilhado

---

### Caso 4: recovery-webui (Interface Web)

**recovery-webui**: Interface web para configurar sistema de recuperação

**Por que separado:**
- Tecnologia diferente (JavaScript vs C++)
- Pode ser usado com diferentes flight computers
- Desenvolvido por time de software web
- Ciclo de desenvolvimento independente

**Como se conecta:**
- Via **API REST** ou **WebSocket**
- Flight-computer expõe API
- WebUI consome API
- Desacoplamento total

---

### Caso 5: old-cdb (Código Legado)

**old-cdb**: Código antigo do SR1500

**Estratégia:**
1. **Manter** como referência histórica
2. **NÃO desenvolver** mais nele
3. **Extrair** código reutilizável para bibliotecas
4. **Documentar** lições aprendidas

```markdown
# old-cdb/README.md

⚠️ **Este repositório está arquivado**

Este era o código usado no SR1500 (2023-2024).

**Novo desenvolvimento:** Ver [flight-computer](../flight-computer)

**Útil para:**
- Referência de algoritmos de detecção de apogeu
- Análise de dados históricos
- Lições aprendidas

**Não usar para:**
- Novos projetos
- Competições futuras
```

---

## Resumo: Decision Tree

### Devo criar um repo novo ou usar existente?

```
┌─────────────────────────────────────┐
│ Projeto faz a MESMA coisa?          │
└────────┬────────────────────────────┘
         │
    ┌────┴────┐
   SIM      NÃO
    │         │
    ↓         ↓
┌─────────────────────┐  ┌──────────────────┐
│ Código 70%+ igual?  │  │ NOVO REPOSITÓRIO │
└────────┬────────────┘  └──────────────────┘
         │
    ┌────┴────┐
   SIM      NÃO
    │         │
    ↓         ↓
  FORK    ┌─────────────────────────┐
          │ Usados sempre juntos?   │
          └────────┬────────────────┘
                   │
              ┌────┴────┐
             SIM      NÃO
              │         │
              ↓         ↓
          MONOREPO   SEPARAR
```

---

## Checklist: Novo Projeto

Antes de criar código:

- [ ] Este projeto já existe na Serra Rocketry?
- [ ] Posso fazer fork de algo existente?
- [ ] Este projeto é realmente independente?
- [ ] Defini a responsabilidade ÚNICA do projeto?
- [ ] Verifiquei bibliotecas existentes para não reimplementar?
- [ ] Pensei em como vai se comunicar com outros sistemas?
- [ ] Documentei claramente o escopo e não-escopo?

---

## Recursos para Aprender Mais

### Filosofia Unix
- [The Art of Unix Programming](http://www.catb.org/~esr/writings/taoup/html/) - Eric S. Raymond
- [Unix Philosophy](https://en.wikipedia.org/wiki/Unix_philosophy) - Wikipedia

### Arquitetura de Software
- [Clean Code](https://www.amazon.com.br/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882) - Robert C. Martin
- [The Pragmatic Programmer](https://pragprog.com/titles/tpp20/) - Hunt & Thomas

### Monorepo vs Polyrepo
- [Monorepo vs Polyrepo](https://github.com/joelparkerhenderson/monorepo-vs-polyrepo)
- [Google's Monorepo Approach](https://cacm.acm.org/magazines/2016/7/204032-why-google-stores-billions-of-lines-of-code-in-a-single-repository/fulltext)

---

[← Voltar ao índice](./README.md)

