# ⚙️ Boas Práticas de Hardware

> Fungibilidade, Padronização e Intercambiabilidade para Projetos de Foguetemodelismo

[← Voltar ao índice](../README.md)

---

## 📋 Checklists Rápidas (Para Uso no Campo)

**Acesso rápido para o dia do lançamento:**

- 🚀 **[Checklist Pré-Voo](./checklist-pre-voo.md)** - Verificação de 5 minutos antes do lançamento
- 🧰 **[Kit de Campo](./kit-campo.md)** - O que levar para reparos de emergência
- ✅ **[Checklist de Design](./checklist-design.md)** - Verificações antes de fabricar PCB

> 💡 **Dica:** Imprima os checklists e leve para o campo!

---

## 🎯 Índice

1. [O que é Fungibilidade?](#o-que-é-fungibilidade)
2. [Por que Fungibilidade Importa](#por-que-fungibilidade-importa)
3. [Padronização de Componentes](#padronização-de-componentes)
4. [Interfaces e Conectores](#interfaces-e-conectores)
5. [Modularidade em Hardware](#modularidade-em-hardware)
6. [Pin Compatibility](#pin-compatibility)
7. [Design for Testability](#design-for-testability)
8. [Resiliência e Robustez para Ambientes Hostis](#resiliência-e-robustez-para-ambientes-hostis)
9. [Documentação de Hardware](#documentação-de-hardware)
10. [Checklist de Design](#checklist-de-design)

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

## Resiliência e Robustez para Ambientes Hostis

### 🚀 O Desafio: Condições Extremas

Hardware de foguetemodelismo opera em condições **muito mais severas** que projetos convencionais:

#### Transporte para o Campo
- 🚗 Vibração em estradas ruins
- 📦 Impactos durante transporte
- 🌡️ Variação de temperatura
- 💧 Umidade e poeira

#### Durante o Lançamento
- 🚀 **Aceleração**: 10-30G (100-300 m/s²)
- 📳 **Vibração**: Motor sólido gera vibração intensa
- 🔥 **Temperatura**: -20°C a +60°C
- ⚡ **EMI**: Ignição gera interferência eletromagnética
- 💥 **Impacto**: Pouso pode ser violento

#### Após o Pouso
- 🌾 Ambiente externo (campo, mato)
- 💦 Possível contato com água
- ⏱️ Horas de exposição até recuperação

---

### ⚠️ Falhas Comuns em Campo

#### ❌ **Solda Fria**

**O que é:** Solda que parece conectada visualmente, mas tem má conexão elétrica.

**Sintomas:**
- Funciona na bancada
- Falha em campo (vibração rompe contato)
- Intermitência

**Causas:**
```
1. Temperatura baixa do ferro de solda
2. Tempo insuficiente de aquecimento
3. Movimento durante resfriamento
4. Oxidação dos terminais
```

**Como identificar:**

```
Solda BOA:          Solda FRIA:
   Brilhante           Fosca/opaca
   Côncava             Convexa/bolha
   Fluxo suave         Grumosa
   
   ╱╲                  ___
  /  \                (   )
 /____\              (_____)
  Pino                Pino
```

**Prevenção:**
- ✅ Ferro de solda a **350-370°C**
- ✅ Limpe ponta do ferro regularmente
- ✅ Use **flux** (pasta de solda)
- ✅ Aqueça pino E pad simultaneamente (3-5s)
- ✅ Deixe resfriar sem movimento
- ✅ **Inspeção visual**: brilhante e côncava

---

#### ❌ **Fios Rompidos por Fadiga**

**O que é:** Vibração causa ruptura de fios na raiz dos conectores.

**Pontos críticos:**
```
Conector ──┬─────── Fio
           │
           └─ ⚠️ Ponto de stress
              (fadiga rompe aqui)
```

**Prevenção: Strain Relief (Alívio de Tensão)**

```cpp
┌─────────────────────────────────────┐
│ ✅ BOM: Hot glue/heat shrink        │
│                                      │
│  Conector ═══╗                      │
│              ║ ← Hot glue           │
│              ║                       │
│              ╚════ Fio              │
│                                      │
│ Rigidifica transição                │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│ ❌ RUIM: Sem strain relief          │
│                                      │
│  Conector ─┐                        │
│            └───── Fio               │
│                                      │
│ Vibração rompe na raiz              │
└─────────────────────────────────────┘
```

**Técnicas:**
1. **Hot glue** (cola quente) na raiz do conector
2. **Heat shrink** (termo-retrátil) com cola interna
3. **Cable ties** (abraçadeiras) próximos ao conector
4. **Loop de folga** (não esticar fio até o limite)

---

#### ❌ **Componentes Soltos**

**O que é:** Componentes não fixados mecanicamente se soltam com vibração.

**Exemplos críticos:**
- PCBs sem parafusos/espaçadores
- Sensores presos apenas por fios
- Baterias soltas
- Conectores sem trava

**Solução:**

```
✅ PCB fixada:
┌─────────────────┐
│     [PCB]       │
│                 │
│  ●───────────●  │ ← Parafusos M3
│  │           │  │
│  │  Spacer   │  │ ← Espaçadores
│  │           │  │
└──●───────────●──┘

✅ Sensor fixado:
  [Sensor]
     ║
     ╚══ Hot glue na base
```

**Checklist de fixação:**
- [ ] PCB parafusada (mínimo 2 pontos)
- [ ] Sensores com fixação mecânica ou hot glue
- [ ] Bateria com velcro + strap
- [ ] Conectores com trava mecânica
- [ ] Módulos grandes com suporte adicional

---

### 🧪 Testes de Robustez

#### Teste de Vibração

**Objetivo:** Simular vibração do motor e transporte.

**Setup simples:**

```
Método 1: Furadeira
┌────────────────────────────┐
│  [Flight Computer]         │
│         │                  │
│         │ ← Fixado         │
│    ╔════╧════╗             │
│    ║ Furadeira║             │
│    ║ (sem broca)            │
│    ╚═════════╝             │
│  Vibra por 5 min           │
└────────────────────────────┘

Método 2: Alto-falante
[PCB] fixada sobre cone de subwoofer
Toca frequências 50-500 Hz
```

**Protocolo:**
1. Ligue o sistema
2. Inicie logging de dados
3. Aplique vibração por **5-10 minutos**
4. Verifique:
   - [ ] Sistema não reiniciou
   - [ ] Sem perda de dados
   - [ ] Sensores continuam lendo
   - [ ] LEDs indicam normalidade
5. **Inspeção visual pós-teste**:
   - [ ] Soldas intactas
   - [ ] Componentes fixos
   - [ ] Fios sem ruptura

---

#### Teste de Queda

**Objetivo:** Simular impacto de pouso.

**Protocolo:**

```bash
# Queda de 1-2 metros sobre grama/areia
# Com sistema ligado e logging

1. Embale no mesmo foam/proteção do foguete
2. Deixe cair de 1m (pouso suave)
3. Verifique funcionamento
4. Deixe cair de 2m (pouso duro)
5. Verifique funcionamento
```

**Aceitável:**
- ✅ Sistema reinicia mas continua funcional
- ✅ Dados salvos até momento do impacto

**Inaceitável:**
- ❌ Componente se solta
- ❌ Perda total de dados
- ❌ Não reinicia

---

#### Teste Térmico

**Objetivo:** Verificar operação em extremos de temperatura.

**Protocolo:**

```
Frio:
1. Coloque sistema em freezer (-10°C)
2. Deixe 30 min
3. Ligue e verifique funcionamento
4. Todos sensores devem ler corretamente

Calor:
1. Coloque ao sol direto (ou em carro fechado)
2. Deixe atingir ~50°C
3. Verifique funcionamento
4. Monitor para shutdown térmico
```

**Atenção:**
- Bateria LiPo: não carregar abaixo de 0°C
- SD card: pode falhar em temperaturas extremas

---

### 🛡️ Técnicas de Proteção

#### Conformal Coating (Revestimento Protetor)

**O que é:** Camada fina de resina protetora sobre PCB.

**Proteção contra:**
- 💧 Umidade
- 🌾 Poeira
- 🧂 Corrosão
- ⚡ Curto-circuito (parcial)

**Tipos:**

| Tipo | Aplicação | Proteção | Remoção |
|------|-----------|----------|---------|
| **Acrílico** | Pincel/spray | Boa | Fácil (acetona) |
| **Silicone** | Pincel | Muito boa | Difícil |
| **Poliuretano** | Spray | Excelente | Muito difícil |
| **Epoxy** | Pincel | Máxima | Impossível |

**Recomendação:** Acrílico para prototipagem, Silicone para produção.

**Como aplicar:**

```bash
1. Limpe PCB (álcool isopropílico)
2. Proteja conectores com fita (não recobrir)
3. Aplique camada fina (2-3 demãos)
4. Cure conforme instruções (geralmente 24h)
5. Teste continuidade/funcionamento
```

**⚠️ NÃO recobrir:**
- Conectores
- Botões
- LEDs (ou aplicar muito fino)
- Pontos de teste (se precisar acessar)
- Antenas

---

#### Hot Glue (Cola Quente) Estratégico

**Usos:**

1. **Strain relief** em conectores
```
  Conector
     ║
  ╔══╩══╗ ← Hot glue
  ║      ║
  ╚══════╝
     Fio
```

2. **Fixação de componentes grandes**
```
  [Módulo LoRa]
      ╱│╲
     ╱ │ ╲ ← Hot glue nas bordas
    ╱  │  ╲
  ────────────
     [PCB]
```

3. **Isolamento** de soldas expostas

**⚠️ Cuidados:**
- Não aplicar em componentes que aquecem (reguladores de tensão)
- Não em cristais (afeta frequência)
- Não em demasia (adiciona peso)

---

#### Cabo de Dados Blindado

**Quando usar:** Conexões críticas em ambiente com EMI.

```
Normal:              Blindado:
  ───────              ╔═══════╗
  ───────              ║───────║ ← Shield (malha)
                       ║───────║
                       ╚═══════╝
                           │
                          GND
```

**Aplicações:**
- Cabo do GPS (sensível a EMI)
- Comunicação entre placas
- Sensores analógicos precisos

---

### 🔍 Inspeção Pré-Lançamento

#### Checklist Visual (5 minutos antes)

```markdown
## Hardware Checklist - Pre-Flight

### Alimentação
- [ ] Bateria carregada (verificar tensão)
- [ ] Conector de bateria travado
- [ ] LED de power aceso

### Conexões
- [ ] Todos conectores travados/seguros
- [ ] Fios sem tensão excessiva
- [ ] Strain relief intacto (hot glue)
- [ ] Sem fios desencapados expostos

### Fixação Mecânica
- [ ] PCB parafusada (apertar parafusos)
- [ ] Módulos fixos (puxar levemente)
- [ ] Bateria presa com velcro/strap
- [ ] Sensores firmemente fixados

### Soldas e Componentes
- [ ] Inspeção visual de soldas críticas
- [ ] Componentes não apresentam movimento
- [ ] Sem sinais de trinca/rachadura na PCB

### Funcional
- [ ] Sistema boota corretamente
- [ ] Todos sensores lendo (valores plausíveis)
- [ ] SD card gravando (verificar arquivo)
- [ ] Telemetria transmitindo (recepção na base)
- [ ] LEDs de status corretos

### Ambiente
- [ ] Sistema protegido de poeira (case/foam)
- [ ] Respiradouros para barômetro desobstruídos
- [ ] Antenas posicionadas corretamente
```

---

#### Teste de Continuidade

**Com multímetro, antes de ligar:**

```bash
1. VCC para GND: > 1MΩ (sem curto)
2. Trilhas críticas: < 1Ω (conexão sólida)
3. Conectores: contato firme
```

---

### 📦 Transporte Seguro

#### Embalagem para Campo

```
┌─────────────────────────────────┐
│  [Case rígido/Tupperware]       │
│                                  │
│     ┌──────────────┐             │
│     │   [Foam]     │             │
│     │  ┌────────┐  │             │
│     │  │ PCB    │  │ ← Flight Computer
│     │  │        │  │             │
│     │  └────────┘  │             │
│     │              │             │
│     └──────────────┘             │
│                                  │
│  [Bateria separada]              │
│  [Ferramentas]                   │
│  [Componentes sobressalentes]    │
└─────────────────────────────────┘
```

**Princípios:**
- ✅ Case rígido (protege de impacto)
- ✅ Foam (amortece vibração)
- ✅ Bateria desconectada durante transporte
- ✅ Componentes não se movem dentro do case
- ✅ Kit de reparo junto (ferro de solda, fios, hot glue)

---

#### Kit de Emergência (Field Repair Kit)

```markdown
## Kit Mínimo de Campo

### Ferramentas
- [ ] Ferro de solda portátil (USB/bateria)
- [ ] Alicate de corte
- [ ] Chave Phillips pequena
- [ ] Multímetro

### Consumíveis
- [ ] Fios jumper variados
- [ ] Hot glue e pistola (ou supercola)
- [ ] Fita isolante
- [ ] Heat shrink (termo-retrátil)

### Componentes Sobressalentes
- [ ] Sensores (1 de cada tipo usado)
- [ ] Conectores sobressalentes
- [ ] Bateria extra (carregada)
- [ ] Fusíveis (se aplicável)
- [ ] Parafusos M3

### Documentação
- [ ] Pinout impresso
- [ ] Esquemático simplificado
- [ ] Procedimento de troubleshooting
```

---

### 🎯 Resumo: Robustez em Hardware

#### Princípios de Design

1. **🔩 Fixação Mecânica**
   - Tudo deve estar mecanicamente fixado
   - Não confie apenas em soldas para suporte

2. **⚡ Qualidade de Solda**
   - Inspeção visual rigorosa
   - Teste de continuidade
   - Brilhante e côncava = boa

3. **🔗 Strain Relief**
   - Hot glue em conectores
   - Loop de folga em fios
   - Cabos não devem estar esticados

4. **🛡️ Proteção**
   - Conformal coating em PCBs
   - Case/foam para transporte
   - Isolamento de pontos críticos

5. **🧪 Teste, Teste, Teste**
   - Vibração
   - Queda
   - Temperatura
   - Sempre antes do lançamento real

---

#### Mentalidade Correta

```
❌ "Funcionou na bancada, vai funcionar no foguete"

✅ "Funcionou na bancada sob vibração, queda, calor,
    e inspeção visual rigorosa - TALVEZ funcione no foguete"
```

**Lembre-se:**
- Foguete não é projeto de bancada
- Ambiente é hostil
- Não há "debug" durante o voo
- Cada componente solto pode causar falha catastrófica

**Invista tempo em robustez - vale cada minuto!**

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

#### Robustez e Resiliência
- [ ] Todas PCBs fixadas mecanicamente (parafusos)?
- [ ] Componentes grandes têm fixação adicional (hot glue)?
- [ ] Strain relief em todos conectores?
- [ ] Soldas inspecionadas visualmente (brilhantes e côncavas)?
- [ ] Teste de vibração realizado (5-10 min)?
- [ ] Teste de queda realizado (1-2m)?
- [ ] Conformal coating aplicado (se necessário)?
- [ ] Fios têm folga suficiente (não esticados)?
- [ ] Bateria tem fixação segura (velcro + strap)?
- [ ] Kit de reparo de campo preparado?

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

