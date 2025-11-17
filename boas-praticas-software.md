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
7. [Watchdog: Proteção Contra Travamentos](#watchdog-proteção-contra-travamentos)
8. [Zen do Python: Filosofia de Código Limpo](#zen-do-python-filosofia-de-código-limpo)
9. [Abstração e Orientação a Objetos](#abstração-e-orientação-a-objetos)
10. [Casos Reais da Serra Rocketry](#casos-reais-da-serra-rocketry)

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

## Watchdog: Proteção Contra Travamentos

### 🐕 O que é um Watchdog?

Um **watchdog** (cão de guarda) é um mecanismo de segurança que **reinicia o sistema** se ele travar ou parar de responder.

**Analogia:** Como um cachorro que late se você não der sinal de vida a cada X minutos.

---

### Por que é Crítico em Foguetes?

Durante o voo, você **NÃO tem acesso físico** ao sistema:
- ❌ Não pode apertar o botão de reset
- ❌ Não pode desligar e religar
- ❌ Não pode conectar debugger

**Se o sistema travar = missão perdida**

---

### Como Funciona?

```cpp
┌──────────────────────────────────────┐
│  1. Sistema inicia                   │
│  2. Watchdog configurado (ex: 5s)    │
│  3. Loop principal:                  │
│     - Faz trabalho útil              │
│     - "Pet the dog" (reseta timer)   │
│     - Repete                         │
│                                      │
│  Se NÃO resetar em 5s:               │
│  → Watchdog REINICIA sistema         │
└──────────────────────────────────────┘
```

---

### Implementação ESP32

```cpp
#include <esp_task_wdt.h>

#define WDT_TIMEOUT 5  // 5 segundos

void setup() {
    Serial.begin(115200);
    
    // Configura watchdog de 5 segundos
    esp_task_wdt_init(WDT_TIMEOUT, true);
    esp_task_wdt_add(NULL);  // Adiciona task atual
    
    Serial.println("Watchdog ativo!");
}

void loop() {
    // ============ TRABALHO ÚTIL ============
    float altitude = readBarometer();
    float accel = readIMU();
    transmitTelemetry(altitude, accel);
    
    // ============ "PET THE DOG" ============
    esp_task_wdt_reset();  // ← Reseta timer do watchdog
    
    delay(100);  // 100ms < 5s (seguro)
}
```

**Se o código travar** (ex: loop infinito, deadlock):
1. Watchdog não é resetado
2. Após 5s, ESP32 reinicia automaticamente
3. Sistema volta a funcionar

---

### Arduino (AVR)

```cpp
#include <avr/wdt.h>

void setup() {
    Serial.begin(115200);
    
    // Ativa watchdog de 4 segundos
    wdt_enable(WDTO_4S);
    
    Serial.println("Watchdog ativo!");
}

void loop() {
    // Trabalho útil
    readSensors();
    logData();
    
    // Reseta watchdog
    wdt_reset();
    
    delay(100);
}
```

---

### ⚠️ Cuidados Importantes

#### 1. Timeout apropriado

```cpp
// ❌ Timeout muito curto
#define WDT_TIMEOUT 0.5  // 500ms
// Problema: operações lentas (SD card write) excedem timeout

// ✅ Timeout apropriado
#define WDT_TIMEOUT 5  // 5s
// Detecta travamentos reais, mas permite operações legítimas
```

#### 2. Reset em TODAS as trajetórias de código

```cpp
// ❌ ERRADO
void loop() {
    if (condition) {
        doWork();
        wdt_reset();  // ← Só reseta se condition = true
    }
    // Se condition sempre false, watchdog NÃO é resetado!
}

// ✅ CORRETO
void loop() {
    if (condition) {
        doWork();
    }
    
    wdt_reset();  // ← Sempre executado
}
```

#### 3. Operações bloqueantes

```cpp
// ❌ Operação pode exceder timeout
void loop() {
    String data = Serial.readStringUntil('\n');  // Pode bloquear!
    wdt_reset();
}

// ✅ Timeout ou reset dentro do bloqueio
void loop() {
    if (Serial.available()) {
        String data = Serial.readStringUntil('\n');
    }
    wdt_reset();
}
```

---

### Recuperação Após Reset

**Detecte que houve reset do watchdog:**

```cpp
#include <esp_system.h>

void setup() {
    Serial.begin(115200);
    
    // Verifica causa do último reset
    esp_reset_reason_t reason = esp_reset_reason();
    
    if (reason == ESP_RST_TASK_WDT || reason == ESP_RST_WDT) {
        Serial.println("⚠️ ATENÇÃO: Reset por watchdog!");
        // Salva flag em EEPROM/flash
        // Telemetria pode indicar problema
    }
    
    // Inicializa watchdog
    esp_task_wdt_init(WDT_TIMEOUT, true);
    esp_task_wdt_add(NULL);
}
```

**Telemetria com contador de resets:**

```cpp
uint8_t resetCount = 0;  // Salvar em EEPROM

void setup() {
    if (wasWatchdogReset()) {
        resetCount++;
        saveToEEPROM(resetCount);
    }
}

void sendTelemetry() {
    // Pacote inclui resetCount
    // Se resetCount > 0 durante voo = problema!
}
```

---

### Quando NÃO Usar Watchdog?

- ❌ Durante desenvolvimento/debug (dificulta debugging)
- ❌ Com sleep modes (pode resetar durante sleep)

**Solução:** Habilitar apenas em **modo de produção**

```cpp
#ifdef PRODUCTION_MODE
    esp_task_wdt_init(WDT_TIMEOUT, true);
#endif
```

---

## Zen do Python: Filosofia de Código Limpo

### 🧘 O Zen do Python

Execute no Python:
```python
import this
```

**Resultado:**
```
The Zen of Python, by Tim Peters

Beautiful is better than ugly.
Explicit is better than implicit.
Simple is better than complex.
Complex is better than complicated.
Flat is better than nested.
Sparse is better than dense.
Readability counts.
Special cases aren't special enough to break the rules.
Although practicality beats purity.
Errors should never pass silently.
Unless explicitly silenced.
In the face of ambiguity, refuse the temptation to guess.
There should be one-- and preferably only one --obvious way to do it.
Although that way may not be obvious at first unless you're Dutch.
Now is better than never.
Although never is often better than *right* now.
If the implementation is hard to explain, it's a bad idea.
If the implementation is easy to explain, it may be a good idea.
Namespaces are one honking great idea -- let's do more of those!
```

---

### 💡 Aplicando ao Foguetemodelismo

Vamos traduzir os princípios mais importantes para nosso contexto:

#### 1. **"Simple is better than complex"**

```python
# ❌ COMPLEXO (difícil de entender)
def calc(d):
    return ((d[0]-d[1])**2+(d[2]-d[3])**2)**0.5 if len(d)==4 else None

# ✅ SIMPLES (claro e direto)
def calculate_distance_2d(x1, y1, x2, y2):
    """Calcula distância euclidiana entre dois pontos 2D."""
    dx = x2 - x1
    dy = y2 - y1
    return math.sqrt(dx**2 + dy**2)
```

**Aplicação:** Código do foguete deve ser entendido rapidamente, mesmo às 3h da manhã antes do lançamento!

---

#### 2. **"Explicit is better than implicit"**

```python
# ❌ IMPLÍCITO (o que é 9.81?)
def calculate_altitude(pressure):
    return 44330 * (1 - (pressure / 101325) ** 0.1903)

# ✅ EXPLÍCITO (constantes nomeadas)
GRAVITY = 9.81  # m/s²
SEA_LEVEL_PRESSURE = 101325  # Pa
PRESSURE_EXPONENT = 0.1903

def calculate_altitude_from_pressure(pressure_pa):
    """
    Calcula altitude baseado na pressão atmosférica.
    
    Args:
        pressure_pa: Pressão em Pascals
    
    Returns:
        Altitude em metros acima do nível do mar
    """
    pressure_ratio = pressure_pa / SEA_LEVEL_PRESSURE
    return 44330 * (1 - pressure_ratio ** PRESSURE_EXPONENT)
```

---

#### 3. **"Readability counts"**

```python
# ❌ DIFÍCIL DE LER
a=[(x,y,z) for x,y,z in data if x>0 and z<100]
b=[math.sqrt(x**2+y**2+z**2) for x,y,z in a]

# ✅ LEGÍVEL
valid_accelerations = [
    (x, y, z) 
    for x, y, z in acceleration_data 
    if x > 0 and z < 100
]

magnitudes = [
    math.sqrt(x**2 + y**2 + z**2) 
    for x, y, z in valid_accelerations
]
```

**Dica:** Se precisa comentar linha por linha, o código não está claro o suficiente.

---

#### 4. **"Errors should never pass silently"**

```python
# ❌ ERRO SILENCIOSO
def read_sensor():
    try:
        return sensor.read()
    except:
        return 0  # ← Problema mascarado!

# ✅ ERRO TRATADO EXPLICITAMENTE
def read_sensor():
    """Lê sensor com tratamento de erro."""
    try:
        value = sensor.read()
        return value
    except SensorDisconnectedError as e:
        logger.error(f"Sensor desconectado: {e}")
        raise  # Propaga erro
    except SensorTimeoutError:
        logger.warning("Timeout no sensor, tentando novamente...")
        time.sleep(0.1)
        return sensor.read()  # Retry
```

**Aplicação:** Durante o voo, você PRECISA saber de erros! Log é crucial.

---

#### 5. **"If the implementation is hard to explain, it's a bad idea"**

```python
# ❌ DIFÍCIL DE EXPLICAR
def f(d):
    return sum([(d[i]-d[i-1])**2 for i in range(1,len(d))])**0.5

# Você consegue explicar o que isso faz em 10 segundos?

# ✅ FÁCIL DE EXPLICAR
def calculate_path_length(positions):
    """
    Calcula comprimento total do caminho percorrido.
    
    Soma das distâncias entre pontos consecutivos.
    """
    distances = []
    for i in range(1, len(positions)):
        previous = positions[i - 1]
        current = positions[i]
        distance = abs(current - previous)
        distances.append(distance)
    
    return sum(distances)
```

**Se você não consegue explicar facilmente = redesenhe!**

---

### 🎯 Resumo: Zen na Prática

| Princípio | Aplicação em Foguetes |
|-----------|----------------------|
| **Simples > Complexo** | Código deve funcionar sob pressão |
| **Explícito > Implícito** | Constantes físicas nomeadas |
| **Legibilidade** | Equipe deve entender rapidamente |
| **Erros visíveis** | Log de erros = debug pós-voo |
| **Fácil de explicar** | Revisão de código eficiente |

---

## Abstração e Orientação a Objetos

### 🎭 O Problema: Complexidade Crescente

**Cenário:** Sistema de telemetria do foguete

```python
# ❌ SEM ABSTRAÇÃO: Código cresce descontroladamente
import serial
import struct
import time

# Configuração do rádio LoRa
ser = serial.Serial('/dev/ttyUSB0', 9600)

# Enviar pacote
def send_data(altitude, accel_x, accel_y, accel_z):
    # Monta pacote manualmente
    packet = struct.pack('ffff', altitude, accel_x, accel_y, accel_z)
    crc = calculate_crc(packet)
    packet += struct.pack('H', crc)
    
    # Envia
    ser.write(b'\xAA\xBB')  # Header
    ser.write(packet)
    ser.write(b'\xCC\xDD')  # Footer
    time.sleep(0.01)

# Agora precisa adicionar GPS...
def send_data_with_gps(altitude, accel_x, accel_y, accel_z, lat, lon):
    # Copia e modifica tudo... 😰
    packet = struct.pack('ffffff', altitude, accel_x, accel_y, accel_z, lat, lon)
    # ... mais código duplicado
```

**Problemas:**
- Código duplicado
- Difícil de adicionar sensores
- Difícil de mudar protocolo
- Difícil de testar

---

### ✅ Solução: Orientação a Objetos

**OO não é sobre sintaxe - é sobre ORGANIZAÇÃO e ABSTRAÇÃO**

---

### 🎯 Para Que Serve Orientação a Objetos?

#### 1. **Esconder Complexidade** (Encapsulamento)

```python
# ✅ COM OO: Complexidade escondida
class LoRaRadio:
    """Abstração do rádio LoRa."""
    
    def __init__(self, port='/dev/ttyUSB0', baudrate=9600):
        self._serial = serial.Serial(port, baudrate)
        self._packet_id = 0
    
    def send_telemetry(self, data_dict):
        """
        Envia telemetria (você não precisa saber COMO).
        
        Args:
            data_dict: Dicionário com dados (ex: {'altitude': 1200})
        """
        packet = self._build_packet(data_dict)
        packet = self._add_crc(packet)
        self._transmit(packet)
        self._packet_id += 1
    
    def _build_packet(self, data_dict):
        """Monta pacote (privado, usuário não vê)."""
        # Complexidade escondida aqui
        pass
    
    def _add_crc(self, packet):
        """Adiciona CRC (privado)."""
        # Complexidade escondida aqui
        pass
    
    def _transmit(self, packet):
        """Transmite (privado)."""
        # Complexidade escondida aqui
        pass

# USO SIMPLES:
radio = LoRaRadio()
radio.send_telemetry({'altitude': 1200, 'accel_z': 15.3})
```

**Vantagem:** Usuário não precisa saber sobre struct.pack, CRC, headers, etc.

---

#### 2. **Trocar Implementações** (Polimorfismo)

```python
# Interface comum
class Radio:
    """Interface abstrata para rádios."""
    
    def send_telemetry(self, data_dict):
        raise NotImplementedError

class LoRaRadio(Radio):
    """Implementação LoRa."""
    def send_telemetry(self, data_dict):
        # Implementação específica LoRa
        pass

class WiFiRadio(Radio):
    """Implementação WiFi."""
    def send_telemetry(self, data_dict):
        # Implementação específica WiFi
        pass

# CÓDIGO QUE USA (não muda!):
def flight_computer(radio: Radio):
    """Computador de bordo funciona com QUALQUER rádio."""
    while True:
        altitude = read_barometer()
        radio.send_telemetry({'altitude': altitude})
        time.sleep(0.1)

# Usa LoRa em campo
flight_computer(LoRaRadio())

# Usa WiFi em bancada
flight_computer(WiFiRadio())
```

**Vantagem:** Mesmo código funciona com LoRa, WiFi, ou qualquer outro rádio!

---

#### 3. **Organizar Código Relacionado** (Coesão)

```python
# ❌ SEM OO: Funções espalhadas
def read_mpu6050(): pass
def calibrate_mpu6050(): pass
def filter_mpu6050_data(): pass
# ... 20 funções relacionadas a MPU6050 espalhadas

# ✅ COM OO: Tudo relacionado junto
class MPU6050:
    """Sensor IMU MPU6050."""
    
    def __init__(self, i2c_address=0x68):
        self.address = i2c_address
        self._calibration = None
    
    def read(self):
        """Lê aceleração e giroscópio."""
        pass
    
    def calibrate(self):
        """Calibra sensor."""
        pass
    
    def _apply_filter(self, data):
        """Filtro interno."""
        pass

# Tudo sobre MPU6050 está em UM lugar
sensor = MPU6050()
sensor.calibrate()
data = sensor.read()
```

---

#### 4. **Reutilizar Código** (Herança)

```python
# Classe base: sensor genérico
class Sensor:
    """Sensor genérico com funcionalidades comuns."""
    
    def __init__(self, name):
        self.name = name
        self._last_value = None
        self._timestamp = None
    
    def log_reading(self, value):
        """Salva leitura no log (comum a todos)."""
        self._last_value = value
        self._timestamp = time.time()
        logger.info(f"{self.name}: {value}")
    
    def get_last_value(self):
        """Retorna última leitura."""
        return self._last_value
    
    def read(self):
        """Método abstrato (cada sensor implementa)."""
        raise NotImplementedError

# Sensores específicos HERDAM funcionalidades comuns
class Barometer(Sensor):
    def __init__(self):
        super().__init__("Barometer")
        self._i2c = I2C(...)
    
    def read(self):
        pressure = self._i2c.read_pressure()
        self.log_reading(pressure)  # ← Herdado de Sensor
        return pressure

class IMU(Sensor):
    def __init__(self):
        super().__init__("IMU")
        self._i2c = I2C(...)
    
    def read(self):
        accel = self._i2c.read_accel()
        self.log_reading(accel)  # ← Herdado de Sensor
        return accel

# USO:
baro = Barometer()
imu = IMU()

baro.read()  # Automaticamente loga
imu.read()   # Automaticamente loga

# Última leitura disponível para ambos
print(baro.get_last_value())
print(imu.get_last_value())
```

**Vantagem:** Código de logging escrito UMA vez, usado por TODOS sensores.

---

### 🧠 Quando Usar OO vs Funções Simples?

#### ✅ Use OO quando:

1. **Há ESTADO persistente**
   ```python
   class FlightComputer:
       def __init__(self):
           self.state = "IDLE"  # ← Estado
           self.apogee = None
           self.launch_time = None
   ```

2. **Múltiplas operações relacionadas**
   ```python
   sensor = MPU6050()
   sensor.calibrate()
   sensor.start_sampling()
   data = sensor.read()
   sensor.stop_sampling()
   ```

3. **Diferentes implementações da mesma interface**
   ```python
   class Radio: pass
   class LoRaRadio(Radio): pass
   class WiFiRadio(Radio): pass
   ```

#### ❌ NÃO use OO quando:

1. **Função simples sem estado**
   ```python
   # Não precisa de classe
   def calculate_altitude(pressure):
       return 44330 * (1 - (pressure / 101325) ** 0.1903)
   ```

2. **Apenas um lugar no código**
   ```python
   # Se usado apenas uma vez, função simples basta
   def parse_gps_sentence(nmea_string):
       # ...
   ```

---

### 📚 Exemplo Completo: Sistema de Telemetria

```python
# ============ SENSOR (Abstração) ============
class Sensor:
    """Classe base para todos os sensores."""
    
    def read(self):
        raise NotImplementedError
    
    def calibrate(self):
        pass  # Opcional

# ============ SENSORES ESPECÍFICOS ============
class Barometer(Sensor):
    def __init__(self):
        self.bmp = BMP388()
    
    def read(self):
        return {'pressure': self.bmp.read_pressure()}

class IMU(Sensor):
    def __init__(self):
        self.mpu = MPU6050()
    
    def read(self):
        return {
            'accel_x': self.mpu.acceleration[0],
            'accel_y': self.mpu.acceleration[1],
            'accel_z': self.mpu.acceleration[2],
        }

# ============ RÁDIO (Abstração) ============
class Radio:
    def send(self, data):
        raise NotImplementedError

class LoRaRadio(Radio):
    def __init__(self):
        self.lora = RFM95W()
    
    def send(self, data):
        packet = json.dumps(data)
        self.lora.transmit(packet)

# ============ COMPUTADOR DE BORDO ============
class FlightComputer:
    """
    Computador de bordo - usa sensores e rádio de forma abstrata.
    """
    
    def __init__(self, sensors, radio):
        self.sensors = sensors  # Lista de sensores
        self.radio = radio
        self.running = False
    
    def start(self):
        """Inicia missão."""
        self.running = True
        
        # Calibra todos os sensores
        for sensor in self.sensors:
            sensor.calibrate()
        
        # Loop de telemetria
        while self.running:
            data = self._collect_data()
            self.radio.send(data)
            time.sleep(0.1)
    
    def _collect_data(self):
        """Coleta dados de todos os sensores."""
        telemetry = {'timestamp': time.time()}
        
        for sensor in self.sensors:
            sensor_data = sensor.read()
            telemetry.update(sensor_data)
        
        return telemetry
    
    def stop(self):
        """Para missão."""
        self.running = False

# ============ USO SIMPLES ============
# Setup
baro = Barometer()
imu = IMU()
radio = LoRaRadio()

# Cria flight computer com sensores e rádio
fc = FlightComputer(sensors=[baro, imu], radio=radio)

# Inicia missão
fc.start()
```

**Vantagens:**
- ✅ Adicionar GPS? Crie classe `GPS(Sensor)` e adicione na lista
- ✅ Trocar para WiFi? `radio = WiFiRadio()`
- ✅ Testar sem hardware? `radio = MockRadio()`
- ✅ Cada classe tem UMA responsabilidade clara

---

### 🎓 Para Que Serve OO? (Resumo Final)

| Objetivo | Como OO Ajuda | Exemplo |
|----------|---------------|---------|
| **Esconder complexidade** | Encapsulamento | LoRaRadio esconde detalhes de protocolo |
| **Código reutilizável** | Herança | `Sensor` base com funcionalidades comuns |
| **Trocar implementações** | Polimorfismo | `Radio` funciona com LoRa ou WiFi |
| **Organizar código** | Coesão | Tudo sobre MPU6050 em uma classe |
| **Facilitar testes** | Injeção de dependências | `MockRadio` para testes |

**OO não é obrigatório - mas quando bem usado, SIMPLIFICA código complexo.**

---

### 📖 Referências para Aprofundamento

#### Orientação a Objetos - Conceitos

1. **[Clean Code](https://www.amazon.com.br/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882)** - Robert C. Martin
   - Capítulos sobre classes e objetos
   - Como escrever código orientado a objetos limpo

2. **[Object-Oriented Programming in Python](https://realpython.com/python3-object-oriented-programming/)** - Real Python
   - Tutorial completo e prático
   - Exemplos claros

3. **[Design Patterns](https://refactoring.guru/design-patterns)** - Refactoring Guru
   - Padrões de design comuns
   - Quando e como usar cada um
   - Exemplos visuais

#### Python - Boas Práticas

4. **[The Hitchhiker's Guide to Python](https://docs.python-guide.org/)** - Kenneth Reitz
   - Melhores práticas Python
   - Estrutura de projetos
   - Código limpo

5. **[Fluent Python](https://www.oreilly.com/library/view/fluent-python-2nd/9781492056348/)** - Luciano Ramalho
   - Python idiomático
   - Uso avançado de OO em Python

#### Padrões de Projeto

6. **[Design Patterns: Elements of Reusable Object-Oriented Software](https://en.wikipedia.org/wiki/Design_Patterns)** - Gang of Four
   - Clássico sobre padrões de design
   - Fundamentos de arquitetura OO

#### Vídeos e Cursos

7. **[Python OOP Tutorial - Corey Schafer](https://www.youtube.com/watch?v=ZDa-Z5JzLYM&list=PL-osiE80TeTsqhIuOqKhwlXsIBIdSeYtc)** (YouTube)
   - Série completa sobre OOP em Python
   - Explicações claras com exemplos práticos

8. **[SOLID Principles](https://www.youtube.com/watch?v=pTB30aXS77U)** - Fireship (YouTube)
   - 5 princípios fundamentais de OO
   - Curto e direto (10 min)

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

