# ✅ Checklist Pré-Deploy - Software

> Verificações antes de gravar firmware no foguete

[← Voltar para Boas Práticas de Software](./boas-praticas-software.md)

---

## 💻 Código e Compilação

- [ ] **Código compila sem warnings**
  - Zero warnings no compilador
  - Sem deprecated functions
- [ ] **Versão correta do firmware** identificada
  - `#define VERSION "v1.2.0"` no código
  - Comentário com data e autor
- [ ] **Constantes configuradas** para a missão
  - Altitudes de deploy corretas
  - Frequência LoRa correta (915 MHz)
  - Sample rate apropriado
- [ ] **Debug prints desabilitados** (ou reduzidos)
  - `Serial.println()` apenas para essencial
  - Não impacta performance

---

## 🐕 Watchdog

- [ ] **Watchdog habilitado** em modo de produção
  ```cpp
  #ifdef PRODUCTION_MODE
      esp_task_wdt_init(WDT_TIMEOUT, true);
  #endif
  ```
- [ ] **Timeout apropriado** (5-10s)
- [ ] **Reset em todas as trajetórias** de código
  - `wdt_reset()` no loop principal
  - Não há caminhos que esquecem de resetar

---

## 🧪 Testes

- [ ] **Testado em bancada** (mínimo 30 min rodando)
  - Sistema não reinicia
  - Sensores lendo corretamente
  - Telemetria transmitindo
- [ ] **Teste de vibração** realizado
  - 5-10 min com furadeira/subwoofer
  - Sistema continua funcional
- [ ] **Valores de sensores plausíveis**
  - Barômetro: ~101325 Pa
  - IMU: aceleração Z ≈ 9.8 m/s²
  - Temperatura: ~25°C
- [ ] **SD card gravando** dados
  - Arquivo criado com timestamp
  - Dados sendo escritos periodicamente
- [ ] **Telemetria validada**
  - Ground station recebendo pacotes
  - CRC verificando sem erros
  - Packet loss < 5%

---

## 🔧 Configuração

- [ ] **Arquivo `config.h` revisado**
  - Parâmetros de missão corretos
  - Pinos de hardware conferidos
  - Calibrações aplicadas
- [ ] **Bibliotecas atualizadas**
  - Versões compatíveis
  - Sem conflitos de dependências
- [ ] **Memória suficiente**
  - Flash: < 80% usado
  - RAM: < 70% usado
  - Heap não fragmentado

---

## 📊 Logging e Telemetria

- [ ] **Formato de dados documentado**
  - Estrutura do pacote definida
  - Ordem dos campos conhecida
- [ ] **Taxa de telemetria apropriada**
  - 10-100 Hz (não sobrecarrega rádio)
  - Sincronizado com sample rate
- [ ] **Logs têm timestamp**
  - Millis() ou RTC
  - Facilita análise pós-voo
- [ ] **Tratamento de erros implementado**
  - Sensor falha? Sistema continua
  - SD card cheia? Sobrescreve ou para?
  - Rádio offline? Sistema continua logando?

---

## 🚀 Lógica de Voo

- [ ] **Detecção de lançamento** testada
  - Aceleração > threshold (ex: 3G)
  - Não dispara com transporte/manuseio
- [ ] **Detecção de apogeu** validada
  - Altitude para de subir
  - Aceleração vertical ≈ 0
  - Múltiplos métodos (barômetro + IMU)
- [ ] **Deploy de recuperação** seguro
  - Drogue no apogeu
  - Main em altitude definida
  - Delays apropriados (não instantâneo)
  - Timeout de segurança (ex: 60s após lançamento)
- [ ] **Estados da máquina** bem definidos
  - IDLE → ARMED → LAUNCHED → COAST → APOGEE → DESCENT → LANDED
  - Transições claras e testadas

---

## 🔒 Segurança

- [ ] **Arming switch/comando** funcional
  - Sistema não arma sozinho
  - Visual/sonoro indica armado
- [ ] **Timeouts de segurança**
  - Deploy forçado após X segundos
  - Evita não-deploy por falha de detecção
- [ ] **Redundância** onde crítico
  - Dois barômetros? Sistema continua com um
  - Backup de detecção de apogeu
- [ ] **Sem hard-coded delays críticos**
  - `delay()` longo pode travar sistema
  - Use millis() para timing

---

## 📝 Documentação

- [ ] **Comentários em código crítico**
  - Algoritmos complexos explicados
  - Magic numbers justificados
- [ ] **CHANGELOG atualizado**
  - Mudanças desde última versão
  - Bugs corrigidos listados
- [ ] **README com instruções** de uso
  - Como compilar
  - Como configurar
  - Como testar
- [ ] **Pinout documentado**
  - Diagrama ou tabela
  - Correspondência com hardware

---

## 🔌 Hardware/Software Integration

- [ ] **Pinagem conferida** com hardware real
  - I2C: pinos corretos
  - SPI: pinos corretos
  - GPIOs: match com PCB
- [ ] **Pull-ups/pull-downs** corretos
  - I2C tem pull-ups (hardware ou software)
  - Botões com pull-up se necessário
- [ ] **Tensões compatíveis**
  - ESP32: 3.3V logic
  - Arduino: 5V logic (level shifters se necessário)

---

## 🎯 Code Review

- [ ] **Pelo menos 1 pessoa** revisou código
  - Não é quem escreveu
  - Entendeu a lógica
- [ ] **Sem código comentado** desnecessário
  - Remove código morto
  - Mantém só se há motivo documentado
- [ ] **Nomes de variáveis** claros
  - `altitude_m` melhor que `a`
  - `apogee_detected` melhor que `flag`
- [ ] **Funções curtas** (< 50 linhas idealmente)
  - Se muito longa, quebrar em subfunções
  - Uma responsabilidade por função

---

## 📦 Backup e Versionamento

- [ ] **Commit no Git** com tag de versão
  ```bash
  git tag -a v1.2.0 -m "Versão para COBRUF 2025"
  git push origin v1.2.0
  ```
- [ ] **Firmware binário salvo**
  - `.bin` ou `.hex` em local seguro
  - Nome descritivo: `flight_computer_v1.2.0_cobruf2025.bin`
- [ ] **Configuração salva**
  - Cópia do `config.h` usado
  - Parâmetros de calibração

---

## ⚠️ Critérios de GO/NO-GO

### ✅ GO (Gravar no foguete)
- Todos os testes passaram (30+ min em bancada)
- Código revisado por pelo menos 1 pessoa
- Watchdog habilitado e testado
- Telemetria funcional e validada
- Lógica de voo testada (simulação ou voo anterior)

### ❌ NO-GO (NÃO gravar)
- Warnings na compilação
- Reinicializações durante testes
- Sensores com leituras inconsistentes
- Telemetria com perda > 10%
- Lógica de voo não testada
- Código não revisado

---

## 🚨 Red Flags

Aborte se:
- ⛔ Sistema reinicia randomicamente
- ⛔ Memória se esgota (heap overflow)
- ⛔ Sensor crítico não detectado
- ⛔ SD card não grava
- ⛔ Telemetria não transmite

---

## 📋 Histórico de Deploy

| Data | Versão | Responsável | Missão | Status |
|------|--------|-------------|--------|--------|
| ____/____/____ | v____ | __________ | ____________ | ☐ Sucesso ☐ Falha |
| ____/____/____ | v____ | __________ | ____________ | ☐ Sucesso ☐ Falha |

**Após cada voo, documente problemas encontrados!**

---

## 💡 Dicas Finais

1. **Teste, teste, teste**: Não grave no foguete sem testar extensivamente
2. **Watchdog é seu amigo**: Pode salvar a missão de um travamento
3. **Logs são ouro**: Quanto mais dados, melhor a análise pós-voo
4. **Timeouts de segurança**: Deploy forçado > não-deploy
5. **Simplicidade > Complexidade**: Código simples tem menos bugs

---

**⏱️ Tempo estimado:** 15-20 minutos

**🎯 Objetivo:** Firmware confiável que sobrevive ao voo!

**🚀 Boa sorte no lançamento!**

