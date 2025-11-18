# ✅ Checklist Pré-Voo - Hardware

> Verificação rápida de 5 minutos antes do lançamento

[← Voltar para Boas Práticas de Hardware](./boas-praticas-hardware.md)

---

## 🔋 Alimentação

- [ ] **Bateria carregada** (verificar tensão com multímetro)
- [ ] **Conector de bateria travado** (puxar levemente para confirmar)
- [ ] **LED de power aceso** (sistema ligado)

---

## 🔌 Conexões

- [ ] **Todos conectores travados/seguros** (verificar um por um)
- [ ] **Fios sem tensão excessiva** (deve haver folga)
- [ ] **Strain relief intacto** (hot glue nos conectores)
- [ ] **Sem fios desencapados expostos** (risco de curto)

---

## 🔩 Fixação Mecânica

- [ ] **PCB parafusada** (apertar parafusos com chave)
- [ ] **Módulos fixos** (puxar levemente cada módulo)
- [ ] **Bateria presa** com velcro + strap
- [ ] **Sensores firmemente fixados** (não devem se mover)

---

## ⚡ Soldas e Componentes

- [ ] **Inspeção visual de soldas críticas** (brilhantes e côncavas)
- [ ] **Componentes não apresentam movimento** (nada solto)
- [ ] **Sem sinais de trinca/rachadura na PCB**

---

## 💻 Funcional

- [ ] **Sistema boota corretamente** (mensagem de inicialização)
- [ ] **Todos sensores lendo** (valores plausíveis)
  - Barômetro: ~101325 Pa (nível do mar)
  - IMU: aceleração Z ≈ 9.8 m/s²
  - GPS: fix adquirido (se aplicável)
- [ ] **SD card gravando** (verificar arquivo criado)
- [ ] **Telemetria transmitindo** (recepção na base confirmada)
- [ ] **LEDs de status corretos**
  - Verde: Sistema OK
  - Azul: Sensores lendo
  - Amarelo: Transmitindo

---

## 🌍 Ambiente

- [ ] **Sistema protegido de poeira** (case/foam fechado)
- [ ] **Respiradouros para barômetro desobstruídos** (⚠️ CRÍTICO)
- [ ] **Antenas posicionadas corretamente** (não dobradas/obstruídas)

---

## 🔧 Teste de Continuidade (Opcional)

**Com multímetro, antes de ligar:**

1. **VCC para GND**: > 1MΩ (sem curto-circuito)
2. **Trilhas críticas**: < 1Ω (conexão sólida)
3. **Conectores**: contato firme

---

## ⚠️ Critérios de GO/NO-GO

### ✅ GO (Prosseguir com lançamento)
- Todos os itens críticos marcados
- Sistema funcional com telemetria
- Sem componentes soltos

### ❌ NO-GO (Abortar lançamento)
- Qualquer solda fria ou componente solto
- Sistema não boota ou sensores não leem
- Telemetria não transmite
- Sinais de curto-circuito

---

## 📋 Histórico de Verificação

| Data | Responsável | Status | Observações |
|------|-------------|--------|-------------|
| ____/____/____ | ____________ | ☐ GO ☐ NO-GO | |
| ____/____/____ | ____________ | ☐ GO ☐ NO-GO | |
| ____/____/____ | ____________ | ☐ GO ☐ NO-GO | |

---

**💡 Dica:** Imprima este checklist e leve para o campo!

**⏱️ Tempo estimado:** 5-10 minutos

**🚀 Boa sorte no lançamento!**

