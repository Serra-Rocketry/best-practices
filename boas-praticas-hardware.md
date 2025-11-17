# ⚙️ Boas Práticas de Hardware

> Fungibilidade, Padronização e Intercambiabilidade para Projetos de Foguetemodelismo

[← Voltar ao índice](./README.md)

---

## 🎯 Índice

1. [O que é Fungibilidade?](#o-que-é-fungibilidade)
2. [Por que Fungibilidade Importa](#por-que-fungibilidade-importa)
3. [Padronização de Componentes](#padronização-de-componentes)
4. [Interfaces e Conectores](#interfaces-e-conectores)
5. [Modularidade em Hardware](#modularidade-em-hardware)
6. [Pin Compatibility](#pin-compatibility)
7. [Design for Testability](#design-for-testability)
8. [Documentação de Hardware](#documentação-de-hardware)
9. [Checklist de Design](#checklist-de-design)

---

## O que é Fungibilidade?

### 📖 Definição

> **Fungibilidade**: Propriedade de um item poder ser **substituído por outro equivalente** sem perda de funcionalidade.

**Analogia:** Pilhas AA
- Qualquer pilha AA funciona em qualquer dispositivo que aceite AA
- Você não precisa de uma "pilha específica do controle remoto X"
- Se uma pilha acabar, você troca por outra

---

### Em Hardware de Foguetes

Um sistema **fungível** permite:
- ✅ Substituir componentes facilmente
- ✅ Usar fornecedores alternativos
- ✅ Fazer upgrades sem redesenhar tudo
- ✅ Reparar rapidamente em campo
- ✅ Reaproveitar módulos em outros projetos

---

### Exemplo: Sensor de Pressão

#### ❌ **Design NÃO Fungível**

```
PCB com BMP280 soldado direto
├── BMP280 com defeito
└── Solução: Refazer PCB inteira ($$$ e tempo)
```

**Problemas:**
- BMP280 descontinuado? → Redesenhar PCB
- BMP280 com defeito? → Jogar PCB fora
- Quer testar BMP388? → Nova PCB
- Fornecedor sem estoque? → Projeto parado

#### ✅ **Design Fungível**

```
PCB com socket I2C padrão
├── Aceita BMP280
├── Aceita BMP388
├── Aceita BME680
└── Aceita qualquer sensor I2C de barômetro
```

**Vantagens:**
- Sensor com defeito? → Troca em 30 segundos
- BMP280 descontinuado? → Usa BMP388 sem mudar PCB
- Quer testar novo sensor? → Só plugar
- Fornecedor sem estoque? → Compra alternativa

---

## Por que Fungibilidade Importa

### 🚀 Cenário Real: Dia do Lançamento

**6h antes do lançamento:**
> "O sensor BMP280 queimou durante o transporte!"

#### ❌ **Com Hardware NÃO Fungível:**
```
1. Sensor soldado na PCB
2. Não tem BMP280 sobressalente específico
3. Não tem como trocar rapidamente
4. Lançamento cancelado ❌
```

#### ✅ **Com Hardware Fungível:**
```
1. Sensor plugável via conector padrão
2. Pega BMP388 do kit sobressalente (compatível)
3. Despluga BMP280, pluga BMP388
4. Recompila com #define SENSOR_BMP388
5. Lançamento em 15 minutos ✅
```

---

### 💰 Economia de Tempo e Dinheiro

| Situação | Não Fungível | Fungível |
|----------|--------------|----------|
| **Componente queima** | Refazer PCB ($100 + 2 semanas) | Trocar componente ($5 + 5min) |
| **Componente descontinuado** | Redesenhar sistema (meses) | Usar alternativa (horas) |
| **Fornecedor sem estoque** | Projeto parado | Comprar de outro fornecedor |
| **Upgrade** | Nova versão de hardware | Trocar módulo |
| **Teste de alternativas** | Múltiplas PCBs | Mesmo hardware |

---

### 🧪 Flexibilidade para Experimentação

Foguetemodelismo é **iterativo**:
- Testar diferentes sensores
- Comparar precisão
- Validar redundância
- Evolução entre competições

**Hardware fungível** permite experimentar **sem custo alto**.

---

## Padronização de Componentes

### 🔌 Use Interfaces Padrão de Mercado

#### ✅ **Padrões Recomendados**

##### Comunicação Digital
| Interface | Quando Usar | Vantagens |
|-----------|-------------|-----------|
| **I2C** | Sensores de baixa velocidade | 2 fios, múltiplos dispositivos |
| **SPI** | Sensores de alta velocidade | Rápido, confiável |
| **UART** | GPS, módulos RF | Universal, simples |
| **CAN Bus** | Sistemas críticos | Robusto, redundante |

##### Alimentação
| Padrão | Aplicação | Especificação |
|--------|-----------|---------------|
| **3.3V** | Microcontroladores modernos | ESP32, STM32, RP2040 |
| **5V** | Arduino clássico, periféricos | Compatibilidade |
| **VBat** | Bateria LiPo | 3.7-4.2V (1S), 7.4-8.4V (2S) |

---

### 📦 Componentes Intercambiáveis

#### Sensores de Pressão/Altitude (I2C)

```cpp
// Define qual sensor usar (config.h)
#define SENSOR_BMP280
//#define SENSOR_BMP388
//#define SENSOR_MS5611

// Código abstrato (main.cpp)
float altitude = barometer.readAltitude();
```

**Sensores intercambiáveis (mesma interface I2C):**
- BMP280 - Básico, barato
- BMP388 - Alta precisão
- MS5611 - Muito preciso
- DPS310 - Baixo consumo

**Todos usam I2C, endereços similares (0x76/0x77)**

---

#### IMUs (Inertial Measurement Unit)

```cpp
#define IMU_MPU6050
//#define IMU_MPU9250
//#define IMU_BNO055

float accel_z = imu.readAccelZ();
```

**IMUs intercambiáveis:**
- MPU6050 - 6 DOF (giroscópio + acelerômetro)
- MPU9250 - 9 DOF (+ magnetômetro)
- BNO055 - 9 DOF com fusão integrada
- ICM-20948 - 9 DOF, maior range

---

#### Módulos de Rádio

| Módulo | Frequência | Alcance | Interface |
|--------|------------|---------|-----------|
| RFM95W | 433/868/915 MHz | 2-15 km | SPI |
| HC-12 | 433 MHz | 1 km | UART |
| ESP32 WiFi | 2.4 GHz | 100m | Integrado |
| nRF24L01+ | 2.4 GHz | 100m | SPI |

**Uso modular:**
```cpp
// Abstração de comunicação
class Radio {
    virtual void send(uint8_t* data, size_t len);
    virtual bool receive(uint8_t* buffer);
};

class LoRaRadio : public Radio { /* ... */ };
class WiFiRadio : public Radio { /* ... */ };
```

---

### 🔋 Baterias Padronizadas

#### ❌ **Evite:**
- Baterias de dimensões customizadas
- Conectores proprietários
- Tensões não-padrão

#### ✅ **Prefira:**

| Tipo | Aplicação | Conector Padrão |
|------|-----------|-----------------|
| **LiPo 1S** (3.7V) | Sensores, telemetria | JST-PH 2.0 |
| **LiPo 2S** (7.4V) | Servos, sistemas de maior potência | XT30 |
| **LiPo 3S+** | Motores, alta potência | XT60, Deans |
| **18650** | Sistemas recarregáveis | Holder padrão |

**Vantagem:** Qualquer bateria LiPo 1S funciona, independente do fabricante

---

## Interfaces e Conectores

### 🔌 Padronização de Conectores

#### ✅ **Conectores Recomendados**

##### Baixa Corrente (Sinais, Sensores)
| Conector | Pinos | Corrente | Uso |
|----------|-------|----------|-----|
| **JST-XH** | 2-10 | 3A | Sensores, I2C, UART |
| **Dupont** | 1 | 1A | Prototipagem, jumpers |
| **Molex PicoBlade** | 2-15 | 1A | Compacto, confiável |

##### Média Corrente (Alimentação)
| Conector | Corrente | Uso |
|----------|----------|-----|
| **JST-RCY** | 5A | Alimentação geral |
| **XT30** | 15A | LiPo 2S |
| **Anderson Powerpole** | 45A | Modular, genderless |

##### Alta Corrente (Potência)
| Conector | Corrente | Uso |
|----------|----------|-----|
| **XT60** | 30A | LiPo 3S+ |
| **Deans** | 60A | Alta potência |
| **EC5** | 120A | Motores potentes |

---

### 🎨 Código de Cores

**Padronize cores de fios:**

| Cor | Função | Observação |
|-----|--------|------------|
| **Vermelho** | VCC/V+ | Positivo |
| **Preto** | GND | Terra/Negativo |
| **Branco** | Sinal 1 | TX, SDA, MOSI |
| **Amarelo** | Sinal 2 | RX, SCL, MISO |
| **Verde** | Sinal 3 | SCK, CS |
| **Azul** | Sinal 4 | Interrupt, Reset |

**Nunca use vermelho ou preto para sinais!**

---

### 📍 Pinout Padronizado

#### Exemplo: Conector I2C (JST-XH 4 pinos)

```
┌─────────────────┐
│ 🔴 VCC (3.3V)   │ ← Pino 1
│ ⚫ GND          │ ← Pino 2
│ ⚪ SDA          │ ← Pino 3
│ 🟡 SCL          │ ← Pino 4
└─────────────────┘
```

**Todos os sensores I2C da Serra Rocketry usam este padrão:**
- Plugou errado? Não encaixa (proteção mecânica)
- Qualquer sensor I2C se conecta em qualquer porta I2C
- Cabos intercambiáveis

---

## Modularidade em Hardware

### 🧩 Princípio: Módulos Independentes

Divida o sistema em **módulos funcionais** que podem ser:
- Testados separadamente
- Substituídos facilmente
- Reutilizados em outros projetos
- Desenvolvidos em paralelo

---

### Exemplo: Arquitetura Modular de Flight Computer

#### ❌ **Design Monolítico**

```
┌────────────────────────────────────┐
│                                    │
│  Uma PCB única com tudo soldado:  │
│  - ESP32                           │
│  - MPU6050 (soldado)              │
│  - BMP280 (soldado)               │
│  - RFM95W (soldado)               │
│  - SD Card                         │
│  - Servos de deploy               │
│  - Bateria (hardwired)            │
│                                    │
└────────────────────────────────────┘
```

**Problemas:**
- Sensor queima → PCB inteira inutilizada
- Quer testar outro GPS → Redesenhar tudo
- Reuso em outro projeto → Impossível
- Teste de módulos → Precisa do sistema completo

---

#### ✅ **Design Modular**

```
┌─────────────────┐     ┌──────────────┐
│  MAIN BOARD     │←────│ SENSOR BOARD │
│  - ESP32        │ I2C │ - MPU6050    │
│  - Power mgmt   │←────│ - BMP388     │
│  - SD Card      │     └──────────────┘
│                 │
│                 │     ┌──────────────┐
│                 │←────│  RADIO BOARD │
│                 │ SPI │ - RFM95W     │
│                 │←────│ - Antenna    │
│                 │     └──────────────┘
│                 │
│                 │     ┌──────────────┐
│                 │←────│ DEPLOY BOARD │
│                 │     │ - Servos     │
│                 │←────│ - Pyro chnls │
└─────────────────┘     └──────────────┘
         ↑
         │ Power
         │
┌────────┴─────────┐
│  BATTERY BOARD   │
│  - LiPo          │
│  - BMS           │
└──────────────────┘
```

**Vantagens:**
- ✅ Sensor queima → Troca sensor board
- ✅ Teste novo rádio → Troca radio board
- ✅ Reuso → Mesma main board em vários projetos
- ✅ Teste → Cada módulo testado isoladamente
- ✅ Desenvolvimento → Times diferentes em paralelo
- ✅ Redundância → Dois sensor boards

---

### Padrões de Modularidade

#### PC/104 (para CubeSats e projetos maiores)

```
Standard:
- 90mm x 96mm
- Stackable (empilhável)
- Conectores de 104 pinos
- Barramento padrão
```

**Vantagem:** Ecossistema enorme de módulos comerciais

#### Custom Stackable (para foguetes)

```
Dimensões:
- 50mm x 80mm (ajuste ao corpo do foguete)
- Conectores laterais ou empilháveis
- Barramento I2C + SPI + Power
```

---

### Interface Between Modules (IBM)

**Defina claramente a interface entre módulos:**

```cpp
// sensor_board_interface.h
class SensorBoard {
public:
    // Interface pública (contrato)
    virtual float getAltitude() = 0;
    virtual Vector3 getAcceleration() = 0;
    virtual bool isReady() = 0;
    
    // Implementação privada (pode mudar)
private:
    // Sensor específico (BMP280, BMP388, etc)
};
```

**Qualquer sensor board que implemente esta interface funciona!**

---

## Pin Compatibility

### 🔄 Microcontroladores Intercambiáveis

#### Família ESP32

```
ESP32 Original
  ↕ Pin compatible (mesmo footprint)
ESP32-S2
  ↕ Pin compatible
ESP32-S3
  ↕ Parcialmente compatible
ESP32-C3 (RISC-V)
```

**Design para compatibilidade:**
- Use pinos comuns a todas as variantes
- Evite pinos específicos de um modelo
- Documente alternativas

---

#### Exemplo: Pinout Compatível ESP32

```cpp
// Pinos compatíveis entre ESP32, ESP32-S2, ESP32-S3
#define I2C_SDA  21  // ✅ Todos têm GPIO21
#define I2C_SCL  22  // ✅ Todos têm GPIO22
#define SPI_SCK  18  // ✅ Todos têm GPIO18
#define SPI_MISO 19  // ✅ Todos têm GPIO19
#define SPI_MOSI 23  // ✅ Todos têm GPIO23

// Evite pinos específicos
// #define LED_PIN 2  // ❌ ESP32-C3 usa GPIO2 para boot
```

**Vantagem:** Pode usar ESP32-S3 (mais rápido) no lugar de ESP32 original sem redesenhar PCB

---

### 🔌 Footprints Compatíveis

#### Arduino Form Factor

```
Arduino Uno R3
  ↕ Pin compatible
Arduino Mega
  ↕ Superset (pinos a mais, não quebra compatibilidade)
Arduino-compatible boards
  ↕ (Muitas opções de fabricantes)
```

**Shields** (placas de expansão) funcionam em qualquer Arduino compatível.

---

### Adaptadores

Quando não há compatibilidade direta, use adaptadores:

```
ESP32 DevKit (30 pinos)
       ↕ Adapter board
Arduino Shield
```

**Faça PCBs de adaptação** para integrar componentes incompatíveis.

---

## Design for Testability (DFT)

### 🧪 Facilite Testes e Debug

#### Pontos de Teste (Test Points)

```
PCB:
    [Componente]
         ↓
    ● TP_VCC     ← Test point (pad exposto)
    ● TP_GND
    ● TP_SIGNAL
```

**O que testar:**
- Alimentação em cada módulo
- Sinais críticos (I2C, SPI, UART)
- Saídas de sensores
- Sinais de controle

**Como implementar:**
- Pads expostos na PCB (1-2mm)
- Identificados na silkscreen
- Acessíveis sem desmontar

---

#### LEDs de Status

```cpp
// LEDs informativos
#define LED_POWER   13  // Verde: Sistema ligado
#define LED_SENSOR  14  // Azul: Sensores OK
#define LED_RADIO   15  // Amarelo: Transmitindo
#define LED_ERROR   16  // Vermelho: Erro
```

**Estados visuais:**
- 🟢 Verde contínuo: Tudo OK
- 🔵 Azul piscando: Sensores lendo
- 🟡 Amarelo piscando: Transmitindo
- 🔴 Vermelho: Erro crítico

**Debug rápido sem Serial Monitor!**

---

#### Jumpers de Configuração

```
PCB:
┌────────────────┐
│  [JP1]  o-o    │ ← Jumper aberto: Sensor principal
│         o-o    │ ← Jumper fechado: Sensor redundante
└────────────────┘
```

**Casos de uso:**
- Selecionar sensor primário/backup
- Habilitar/desabilitar módulos
- Configurar endereços I2C
- Boot mode

---

#### Conectores de Debug

```
┌─────────────────────┐
│ UART Debug Header   │
│  1. TX              │
│  2. RX              │
│  3. GND             │
└─────────────────────┘

┌─────────────────────┐
│ SWD Debug (ARM)     │
│  1. SWDIO           │
│  2. SWCLK           │
│  3. GND             │
│  4. VCC (optional)  │
└─────────────────────┘
```

**Facilita:**
- Debugging com ST-Link, J-Link
- Gravação de firmware
- Monitoramento serial

---

### 🔌 Hot-Swappable (Troca a Quente)

**Quando possível, permita trocar módulos sem desligar:**

```cpp
// Detecta desconexão/reconexão de sensor
void loop() {
    if (!sensor.isConnected()) {
        Serial.println("Sensor desconectado, aguardando...");
        while (!sensor.reconnect()) {
            delay(1000);
        }
        Serial.println("Sensor reconectado!");
    }
    
    float data = sensor.read();
}
```

**Útil para:**
- Trocar sensor em campo
- Testes rápidos com diferentes sensores
- Redundância ativa

---

## Documentação de Hardware

### 📋 Bill of Materials (BOM)

```markdown
# Bill of Materials - Flight Computer v1.0

| Ref | Qty | Component | Value | Footprint | Supplier | Part # | Price |
|-----|-----|-----------|-------|-----------|----------|--------|-------|
| U1 | 1 | MCU | ESP32-S3 | WROOM | AliExpress | ESP32-S3-WROOM-1 | $3.50 |
| U2 | 1 | IMU | MPU6050 | GY-521 | Eletrogate | MPU6050 | $8.00 |
| U3 | 1 | Barometer | BMP388 | Breakout | Adafruit | BMP388 | $12.00 |
| J1 | 1 | Connector I2C | JST-XH-4P | THT | DigiKey | JST-XH-4P | $0.30 |
| ... | | | | | | | |

**Total:** $45.80
```

**Inclua:**
- Referência na PCB (U1, R1, C1...)
- Quantidade
- Descrição
- Valor/modelo
- Footprint (package)
- Fornecedor e part number
- Preço unitário

---

### 📐 Pinout Diagram

```
ESP32-S3 Pinout - Flight Computer v1.0

╔════════════════════════╗
║ ESP32-S3-WROOM-1       ║
╠════════════════════════╣
║ 3V3  ●────────→ VCC    ║
║ GND  ●────────→ GND    ║
║                        ║
║ GPIO 21 ●─────→ I2C SDA (MPU6050, BMP388) ║
║ GPIO 22 ●─────→ I2C SCL                    ║
║                        ║
║ GPIO 18 ●─────→ SPI SCK  (RFM95W)  ║
║ GPIO 19 ●─────→ SPI MISO            ║
║ GPIO 23 ●─────→ SPI MOSI            ║
║ GPIO 5  ●─────→ SPI CS              ║
║                        ║
║ GPIO 4  ●─────→ SD Card CS    ║
║ GPIO 16 ●─────→ Servo Drogue  ║
║ GPIO 17 ●─────→ Servo Main    ║
║                        ║
║ GPIO 13 ●─────→ LED Status    ║
╚════════════════════════╝

Notes:
- I2C: Pull-up resistors 4.7kΩ to 3.3V
- SPI: Max speed 10MHz for RFM95W
- Servos: 5V supply, logic level shifted
```

---

### 🔧 Assembly Instructions

```markdown
# Assembly Instructions - Flight Computer v1.0

## Tools Required
- Soldering iron (temperature controlled, 350°C)
- Solder (60/40 or lead-free)
- Flux
- Multimeter
- Tweezers

## Order of Assembly

### Step 1: SMD Components (smallest first)
1. Solder resistors (0805)
2. Solder capacitors (0805)
3. Solder ICs (if applicable)

### Step 2: Through-Hole Components
1. Solder pin headers
2. Solder connectors (JST-XH)
3. Solder ESP32 module

### Step 3: Testing
1. Visual inspection
2. Check shorts between VCC and GND (should be > 1MΩ)
3. Apply 3.3V, measure current (should be < 50mA idle)
4. Connect USB, verify ESP32 boots

### Step 4: Programming
1. Flash test firmware: `pio run -t upload`
2. Verify serial output: `pio device monitor`
3. Test each sensor individually

## Common Issues
- **No power**: Check reverse polarity, shorts
- **Sensor not detected**: Check I2C pullups, address
- **Sporadic resets**: Insufficient decoupling caps
```

---

### 📊 Schematic and PCB Files

**Organize no repositório:**

```
hardware/
├── schematic.pdf             ← Esquemático em PDF (fácil visualizar)
├── pcb_layout.pdf            ← Layout da PCB
├── bom.csv                   ← BOM em CSV (importável)
├── bom.md                    ← BOM em Markdown (legível)
├── pinout_diagram.png        ← Diagrama de pinagem
├── assembly_instructions.md  ← Instruções de montagem
├── kicad/                    ← Arquivos fonte (KiCAD)
│   ├── project.kicad_pro
│   ├── project.kicad_sch
│   └── project.kicad_pcb
├── gerbers/                  ← Arquivos para fabricação
│   └── project_gerbers.zip
└── 3d_models/                ← Modelos 3D
    ├── case.stl
    └── pcb_3d.step
```

---

### 📸 Photos and Diagrams

```markdown
# Hardware Documentation

## Assembled Board

![Top View](images/board_top.jpg)
*Top view - Main components labeled*

![Bottom View](images/board_bottom.jpg)
*Bottom view - Connector side*

## Connection Diagram

![System Diagram](images/system_diagram.svg)
*Complete system wiring diagram*

## Dimensions

![Mechanical Drawing](images/mechanical.png)
*PCB dimensions and mounting holes*
```

---

## Checklist de Design

### ✅ Antes de Finalizar o Design

#### Fungibilidade
- [ ] Componentes críticos são substituíveis?
- [ ] Uso sensores com interfaces padrão (I2C, SPI)?
- [ ] PCB aceita variações de componentes (footprints compatíveis)?
- [ ] Conectores são padrão de mercado?

#### Modularidade
- [ ] Sistema dividido em módulos funcionais?
- [ ] Módulos podem ser testados independentemente?
- [ ] Interfaces entre módulos estão bem definidas?
- [ ] Módulos podem ser reutilizados em outros projetos?

#### Testabilidade
- [ ] Test points em sinais críticos?
- [ ] LEDs de status para debugging?
- [ ] Conector de debug/UART acessível?
- [ ] Jumpers para configuração?

#### Documentação
- [ ] BOM completa com fornecedores?
- [ ] Esquemático em PDF legível?
- [ ] Pinout diagram claro?
- [ ] Assembly instructions escritas?
- [ ] Fotos da montagem?

#### Padronização
- [ ] Código de cores de fios consistente?
- [ ] Conectores rotulados na PCB?
- [ ] Tensões padrão (3.3V, 5V)?
- [ ] Protocolo de comunicação documentado?

---

## Exemplos da Serra Rocketry

### Caso: Flight Computer

**Sensores Fungíveis:**
```
I2C Bus:
├── Barometer (intercambiável)
│   ├── BMP280 (0x76)
│   ├── BMP388 (0x77)
│   └── MS5611 (0x77)
│
└── IMU (intercambiável)
    ├── MPU6050 (0x68)
    ├── MPU9250 (0x68)
    └── BNO055 (0x28)
```

**Código abstrato:**
```cpp
// Seleciona sensor em config.h
#define BARO_BMP388

// Código usa interface comum
float altitude = barometer.readAltitude();
// Funciona com BMP280, BMP388, ou MS5611
```

---

### Caso: Thrust Stand

**Módulos:**
```
Thrust Stand
├── Load Cell Module (HX711)
│   └── Intercambiável: 1kg, 5kg, 20kg
│
├── Display Module
│   └── Intercambiável: OLED, LCD, TFT
│
└── Data Logger Module
    └── Intercambiável: SD Card, WiFi, USB
```

**Vantagem:** Mesma base, diferentes configurações conforme motor testado.

---

### Caso: Ignitor

**Redundância:**
```
Ignitor Board
├── Channel 1 (Principal)
│   └── Relay 10A
│
└── Channel 2 (Backup)
    └── Relay 10A

Both channels independent:
- Separate power supply
- Separate control
- Separate status LED
```

**Se canal 1 falhar, canal 2 pronto para usar.**

---

## Recursos para Aprender Mais

### Hardware Design
- [Sparkfun Hardware Design Tutorials](https://learn.sparkfun.com/tutorials)
- [Adafruit Learning System](https://learn.adafruit.com/)
- [EEVblog](https://www.eevblog.com/) - Vídeos de eletrônica

### KiCAD
- [KiCAD Documentation](https://docs.kicad.org/)
- [Contextual Electronics - KiCAD Course](https://www.youtube.com/playlist?list=PLy2022BX6Eso532xqrUxDT1u2p4VVsg-q)

### PCB Design Best Practices
- [PCB Design Guide - Altium](https://resources.altium.com/pcb-design-blog)
- [Better PCBs in KiCAD](https://github.com/sethhillbrand/kicad_best_practices)

### Connectors and Standards
- [JST Connector Guide](https://www.mattmillman.com/info/crimpconnectors/)
- [PC/104 Standard](https://pc104.org/)

---

## Resumo: Princípios de Hardware Fungível

1. **🔄 Substitua, não descarte**
   - Componentes plugáveis vs soldados
   - Footprints compatíveis
   - Connectors padrão

2. **📏 Padronize interfaces**
   - I2C, SPI, UART
   - Conectores de mercado
   - Tensões padrão

3. **🧩 Modularize**
   - Sistemas divididos em módulos
   - Interfaces bem definidas
   - Testabilidade isolada

4. **🔌 Pin compatibility**
   - Microcontroladores intercambiáveis
   - Arduino form factor
   - Adaptadores quando necessário

5. **🧪 Design for testability**
   - Test points
   - LEDs de status
   - Debug connectors
   - Jumpers

6. **📖 Documente tudo**
   - BOM completa
   - Pinouts claros
   - Assembly instructions
   - Fotos e diagramas

---

**Resultado:** Hardware que **evolui** ao invés de ser **descartado**.

---

[← Voltar ao índice](./README.md)

