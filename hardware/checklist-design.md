# ✅ Checklist de Design de Hardware

> Verificações antes de finalizar o design e fabricar PCB

[← Voltar para Boas Práticas de Hardware](./boas-praticas-hardware.md)

---

## 🔄 Fungibilidade

Componentes devem ser facilmente substituíveis:

- [ ] **Componentes críticos são substituíveis?**
  - Sensores em sockets ou conectores (não soldados direto)
  - Microcontrolador pode ser trocado sem refazer PCB
- [ ] **Uso sensores com interfaces padrão** (I2C, SPI)?
  - Evite interfaces proprietárias
  - Prefira protocolos amplamente suportados
- [ ] **PCB aceita variações de componentes** (footprints compatíveis)?
  - Exemplo: BMP280 e BMP388 no mesmo footprint
  - Pinos alternativos marcados na PCB
- [ ] **Conectores são padrão de mercado?**
  - JST-XH para sinais
  - XT30/XT60 para potência
  - Não use conectores customizados

---

## 🧩 Modularidade

Sistema dividido em módulos independentes:

- [ ] **Sistema dividido em módulos funcionais?**
  - Sensor board, power board, telemetry board
  - Cada módulo tem responsabilidade clara
- [ ] **Módulos podem ser testados independentemente?**
  - Não precisa do sistema completo para testar um módulo
  - Interfaces bem definidas entre módulos
- [ ] **Interfaces entre módulos estão bem definidas?**
  - Pinagem documentada
  - Protocolos especificados
  - Tensões padronizadas (3.3V, 5V)
- [ ] **Módulos podem ser reutilizados em outros projetos?**
  - Não são específicos demais para um projeto
  - Design genérico e flexível

---

## 🧪 Testabilidade

Facilite testes e debugging:

- [ ] **Test points em sinais críticos?**
  - VCC, GND em cada módulo
  - Sinais I2C, SPI, UART
  - Saídas de sensores
  - Pads de 1-2mm acessíveis
- [ ] **LEDs de status para debugging?**
  - Power (verde)
  - Sensor OK (azul)
  - Transmitindo (amarelo)
  - Erro (vermelho)
- [ ] **Conector de debug/UART acessível?**
  - TX, RX, GND expostos
  - SWD/JTAG para ARM (se aplicável)
  - Não precisa desmontar para acessar
- [ ] **Jumpers para configuração?**
  - Selecionar modo de operação
  - Habilitar/desabilitar módulos
  - Boot mode / programação

---

## 🚀 Robustez e Resiliência

Hardware para ambientes hostis:

- [ ] **Todas PCBs fixadas mecanicamente** (parafusos)?
  - Mínimo 2 furos de fixação M3
  - Espaçadores para evitar curto com case
- [ ] **Componentes grandes têm fixação adicional** (hot glue)?
  - Módulos LoRa, GPS
  - Conectores JST
  - Capacitores eletrolíticos grandes
- [ ] **Strain relief em todos conectores?**
  - Hot glue na raiz do conector
  - Heat shrink com cola interna
  - Cabos não esticados
- [ ] **Soldas inspecionadas visualmente** (brilhantes e côncavas)?
  - Inspeção com lupa/microscópio
  - Sem soldas frias (opacas, granuladas)
  - Conexões sólidas
- [ ] **Teste de vibração realizado** (5-10 min)?
  - Furadeira ou subwoofer
  - Sistema ligado durante teste
  - Sem reinicializações ou falhas
- [ ] **Teste de queda realizado** (1-2m)?
  - Sobre grama/areia (simulando pouso)
  - Sistema protegido com foam
  - Componentes não se soltam
- [ ] **Conformal coating aplicado** (se necessário)?
  - Acrílico ou silicone
  - Protege contra umidade e poeira
  - Não aplicado em conectores/botões
- [ ] **Fios têm folga suficiente** (não esticados)?
  - Loop de folga perto de conectores
  - Margem para movimento
  - Não sob tensão mecânica
- [ ] **Bateria tem fixação segura** (velcro + strap)?
  - Não pode se soltar durante voo
  - Testado com vibração
- [ ] **Kit de reparo de campo preparado?**
  - Componentes sobressalentes
  - Ferramentas essenciais
  - Documentação impressa

---

## 📖 Documentação

Facilite uso e manutenção:

- [ ] **BOM completa com fornecedores?**
  - Part numbers específicos
  - Links para compra
  - Preços atualizados
  - Quantidade necessária
- [ ] **Esquemático em PDF legível?**
  - Resolução alta
  - Referências legíveis (R1, C1, U1)
  - Valores claramente marcados
- [ ] **Pinout diagram claro?**
  - Diagrama visual colorido
  - Tabela com descrição de cada pino
  - Tensões e correntes especificadas
- [ ] **Assembly instructions escritas?**
  - Passo a passo com fotos
  - Ordem de montagem
  - Testes intermediários
  - Troubleshooting comum
- [ ] **Fotos da montagem?**
  - Vista superior e inferior
  - Close-up de áreas críticas
  - Comparação com esquemático

---

## 📏 Padronização

Use padrões consistentes:

- [ ] **Código de cores de fios consistente?**
  - Vermelho: VCC
  - Preto: GND
  - Branco/Amarelo: Sinais
  - Nunca vermelho/preto para sinais
- [ ] **Conectores rotulados na PCB?**
  - Silkscreen com identificação
  - J1, J2, J3...
  - Função descrita (I2C, UART, POWER)
- [ ] **Tensões padrão** (3.3V, 5V)?
  - Evite tensões customizadas
  - Compatível com componentes comerciais
  - Reguladores com margem térmica
- [ ] **Protocolo de comunicação documentado?**
  - Formato de pacotes
  - Baudrate/frequência
  - CRC ou checksum

---

## ⚡ Elétrico

Verificações elétricas críticas:

- [ ] **Capacitores de desacoplamento** em todos os CIs?
  - 100nF próximo a cada pino VCC
  - 10µF adicional por módulo
  - Colocação próxima (< 5mm)
- [ ] **Pull-ups em linhas I2C?** (4.7kΩ ou 2.2kΩ)
- [ ] **Proteção contra inversão de polaridade?**
  - Diodo em série ou P-MOSFET
  - Evita destruir sistema
- [ ] **Fusível ou PTC** em alimentação principal?
- [ ] **Indicação de polaridade clara** em conectores?
  - Setas, +/- na silkscreen
  - Conector impedindo conexão errada
- [ ] **Vias térmicas** em reguladores de tensão?
- [ ] **Trilhas de potência** dimensionadas corretamente?
  - Largura adequada para corrente
  - Calculadora: https://www.4pcb.com/trace-width-calculator.html

---

## 🔌 Mecânico

Aspectos físicos do design:

- [ ] **PCB cabe no case/compartimento** do foguete?
  - Margem de 2-3mm para folga
  - Furos de fixação alinhados
- [ ] **Altura de componentes** considerada?
  - Componentes altos (capacitores) não batem no case
  - Clearance adequado
- [ ] **Acesso aos conectores** quando montado?
  - USB, power, debug acessíveis
  - Não precisa desmontar para conectar
- [ ] **Orientação correta de antenas?**
  - Não apontando para metal
  - Espaço livre ao redor
- [ ] **Montagem/desmontagem fácil?**
  - Parafusos acessíveis
  - Não precisa remover tudo para acessar um componente

---

## 🎯 Revisão Final

Antes de enviar para fabricação:

- [ ] **Design Review** com pelo menos 2 pessoas
- [ ] **DRC (Design Rule Check)** passou sem erros no KiCad/Eagle
- [ ] **ERC (Electrical Rule Check)** passou sem erros
- [ ] **Todos os componentes** têm footprints corretos
- [ ] **Simulação** de circuitos críticos (se aplicável)
- [ ] **Checklist de gerber** revisado:
  - Camadas corretas (Top, Bottom, Silkscreen, etc)
  - Drill files incluídos
  - Border/outline definido
- [ ] **Versão da PCB** marcada na silkscreen (v1.0, v1.1...)

---

## 💰 Custo

Mantenha projeto viável:

- [ ] **BOM total** dentro do orçamento?
- [ ] **Possível adquirir todos componentes** localmente ou via importação?
- [ ] **Componentes críticos** não estão descontinuados?
- [ ] **Fabricação da PCB** cotada e viável?

---

## 📊 Matriz de Decisão

| Aspecto | Prioridade | Status | Notas |
|---------|------------|--------|-------|
| Fungibilidade | Alta | ☐ OK | |
| Testabilidade | Alta | ☐ OK | |
| Robustez | **Crítica** | ☐ OK | |
| Documentação | Média | ☐ OK | |
| Custo | Variável | ☐ OK | |

---

## 🚦 Critério de Aprovação

### ✅ Aprovar para Fabricação
- Todos os itens **críticos** marcados
- Robustez verificada (vibração, queda)
- Documentação completa
- Design review aprovado

### ⚠️ Revisar
- Algum item crítico pendente
- Dúvidas sobre robustez
- Componentes difíceis de adquirir

### ❌ Reprovar
- Múltiplos itens críticos pendentes
- Falhou em testes de robustez
- Custo inviável

---

## 📝 Histórico de Versões

| Versão | Data | Responsável | Mudanças | Aprovado? |
|--------|------|-------------|----------|-----------|
| v1.0 | ____/____ | _________ | Inicial | ☐ |
| v1.1 | ____/____ | _________ | _______ | ☐ |

---

**💡 Dica:** Use este checklist ANTES de fabricar PCB. Economiza tempo e dinheiro!

**⏱️ Tempo de revisão:** 30-60 minutos

**🎯 Objetivo:** Hardware que funciona na primeira tentativa!

