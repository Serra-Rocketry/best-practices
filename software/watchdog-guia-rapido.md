# 🐕 Watchdog - Guia Rápido de Implementação

> Proteção contra travamentos em sistemas embarcados

[← Voltar para Boas Práticas de Software](./boas-praticas-software.md)

---

## 🎯 O que é e Por Que Usar?

**Watchdog** = Temporizador que reinicia o sistema se ele travar.

**Analogia:** Cachorro que late se você não der sinal de vida a cada X minutos.

**Por quê?** Durante o voo, você NÃO pode apertar reset. Se travar = missão perdida.

---

## ⚡ Implementação Rápida

### ESP32

```cpp
#include <esp_task_wdt.h>

#define WDT_TIMEOUT 5  // 5 segundos

void setup() {
    Serial.begin(115200);
    
    // Configura watchdog
    esp_task_wdt_init(WDT_TIMEOUT, true);
    esp_task_wdt_add(NULL);
    
    Serial.println("Watchdog ativo!");
}

void loop() {
    // ========== SEU CÓDIGO AQUI ==========
    readSensors();
    processData();
    transmitTelemetry();
    
    // ========== RESET WATCHDOG ==========
    esp_task_wdt_reset();  // ← CRÍTICO!
    
    delay(100);
}
```

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
    // ========== SEU CÓDIGO AQUI ==========
    readSensors();
    processData();
    transmitTelemetry();
    
    // ========== RESET WATCHDOG ==========
    wdt_reset();  // ← CRÍTICO!
    
    delay(100);
}
```

---

## ⚠️ Regras de Ouro

### 1. **Timeout apropriado**

```cpp
// ❌ Muito curto
#define WDT_TIMEOUT 0.5  // 500ms
// Problema: operação lenta (SD write) pode exceder

// ✅ Apropriado
#define WDT_TIMEOUT 5  // 5s
// Detecta travamento real, permite operações legítimas
```

**Recomendação:** 5-10 segundos

---

### 2. **Reset em TODAS as trajetórias**

```cpp
// ❌ ERRADO
void loop() {
    if (condition) {
        doWork();
        wdt_reset();  // ← Só reseta se condition = true!
    }
    // Se condition sempre false, watchdog NÃO é resetado!
}

// ✅ CORRETO
void loop() {
    if (condition) {
        doWork();
    }
    
    wdt_reset();  // ← SEMPRE executado
}
```

---

### 3. **Cuidado com operações bloqueantes**

```cpp
// ❌ Pode bloquear por mais que timeout
void loop() {
    String data = Serial.readStringUntil('\n');  // Pode travar!
    wdt_reset();
}

// ✅ Verificar disponibilidade primeiro
void loop() {
    if (Serial.available()) {
        String data = Serial.readStringUntil('\n');
    }
    wdt_reset();
}
```

---

## 🔍 Detectar Resets do Watchdog

```cpp
#include <esp_system.h>

void setup() {
    Serial.begin(115200);
    
    // Verifica causa do último reset
    esp_reset_reason_t reason = esp_reset_reason();
    
    if (reason == ESP_RST_TASK_WDT || reason == ESP_RST_WDT) {
        Serial.println("⚠️ ATENÇÃO: Reset por watchdog!");
        // Salva flag, envia telemetria, etc
    }
    
    // Inicializa watchdog
    esp_task_wdt_init(WDT_TIMEOUT, true);
    esp_task_wdt_add(NULL);
}
```

---

## 📊 Telemetria com Contador de Resets

```cpp
#include <EEPROM.h>

uint8_t resetCount = 0;
#define EEPROM_RESET_ADDR 0

void setup() {
    EEPROM.begin(512);
    
    // Lê contador de resets
    resetCount = EEPROM.read(EEPROM_RESET_ADDR);
    
    // Se foi watchdog reset, incrementa
    if (wasWatchdogReset()) {
        resetCount++;
        EEPROM.write(EEPROM_RESET_ADDR, resetCount);
        EEPROM.commit();
    }
    
    Serial.printf("Reset count: %d\n", resetCount);
    
    // Inicializa watchdog
    esp_task_wdt_init(5, true);
    esp_task_wdt_add(NULL);
}

void sendTelemetry() {
    // Inclui resetCount no pacote
    // Se > 0 durante voo = problema!
    telemetry.resetCount = resetCount;
}
```

---

## 🚫 Quando NÃO Usar

- **Durante desenvolvimento/debug**
  - Dificulta debugging (sistema reinicia antes de ver erro)
  - Solução: Desabilite em modo debug
  
```cpp
#ifdef PRODUCTION_MODE
    esp_task_wdt_init(WDT_TIMEOUT, true);
    esp_task_wdt_add(NULL);
#endif
```

- **Com deep sleep**
  - Watchdog pode acordar sistema
  - Desabilite antes de entrar em sleep

---

## ✅ Checklist Rápido

Antes de habilitar watchdog em produção:

- [ ] Timeout definido (5-10s recomendado)
- [ ] `wdt_reset()` no loop principal
- [ ] `wdt_reset()` em TODAS as trajetórias de código
- [ ] Operações bloqueantes verificadas
- [ ] Detecção de reset implementada
- [ ] Contador de resets em telemetria
- [ ] Testado em bancada (30+ min)
- [ ] Sistema NÃO reinicia durante operação normal

---

## 🎯 Template Completo

```cpp
#include <esp_task_wdt.h>
#include <esp_system.h>
#include <EEPROM.h>

#define WDT_TIMEOUT 5
#define EEPROM_RESET_ADDR 0

uint8_t resetCount = 0;

void setup() {
    Serial.begin(115200);
    
    // 1. Lê contador de resets
    EEPROM.begin(512);
    resetCount = EEPROM.read(EEPROM_RESET_ADDR);
    
    // 2. Verifica causa do reset
    esp_reset_reason_t reason = esp_reset_reason();
    if (reason == ESP_RST_TASK_WDT || reason == ESP_RST_WDT) {
        Serial.println("⚠️ Watchdog reset detectado!");
        resetCount++;
        EEPROM.write(EEPROM_RESET_ADDR, resetCount);
        EEPROM.commit();
    }
    
    Serial.printf("Reset count: %d\n", resetCount);
    
    // 3. Inicializa watchdog (apenas em produção)
    #ifdef PRODUCTION_MODE
        esp_task_wdt_init(WDT_TIMEOUT, true);
        esp_task_wdt_add(NULL);
        Serial.println("Watchdog ATIVO");
    #else
        Serial.println("Watchdog DESABILITADO (modo debug)");
    #endif
    
    // 4. Inicializa seu sistema
    initSensors();
    initRadio();
}

void loop() {
    // Seu código aqui
    readSensors();
    processData();
    transmitTelemetry();
    
    // ========== RESET WATCHDOG (CRÍTICO!) ==========
    #ifdef PRODUCTION_MODE
        esp_task_wdt_reset();
    #endif
    
    delay(100);
}
```

---

## 📚 Referências

- [ESP32 Task Watchdog](https://docs.espressif.com/projects/esp-idf/en/latest/esp32/api-reference/system/wdts.html)
- [Arduino AVR Watchdog](https://www.arduino.cc/reference/en/libraries/watchdog/)
- [Adafruit Watchdog Guide](https://learn.adafruit.com/adafruit-metro-m0-express/using-the-watchdog-timer)

---

**💡 Lembre-se:**
- Watchdog é sua **última linha de defesa** contra travamentos
- Teste **extensivamente** antes de confiar
- Sempre monitore **contador de resets** na telemetria

**⏱️ Tempo de implementação:** 10-15 minutos

**🎯 Objetivo:** Sistema que se recupera de travamentos automaticamente!

