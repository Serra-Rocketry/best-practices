# 🧰 Kit de Reparo de Campo

> Ferramentas e componentes essenciais para levar ao local de lançamento

[← Voltar para Boas Práticas de Hardware](./boas-praticas-hardware.md)

---

## 🔧 Ferramentas

- [ ] **Ferro de solda portátil** (USB/bateria recarregável)
  - Exemplo: TS100, Pinecil
  - Incluir estanho e pasta de solda (flux)
- [ ] **Alicate de corte** (para cortar fios)
- [ ] **Alicate de bico** (para manipular componentes pequenos)
- [ ] **Chave Phillips pequena** (M3)
- [ ] **Chave de fenda** pequena
- [ ] **Multímetro** (para testes elétricos)
- [ ] **Pinça** (para componentes SMD)
- [ ] **Estilete** ou canivete

---

## 🔌 Consumíveis

- [ ] **Fios jumper variados** (macho-macho, macho-fêmea)
  - Vários comprimentos: 10cm, 20cm, 50cm
- [ ] **Hot glue e pistola** (ou supercola/epoxy)
  - Para fixação de emergência e strain relief
- [ ] **Fita isolante** (isolamento rápido)
- [ ] **Heat shrink** (termo-retrátil) de vários diâmetros
  - Incluir isqueiro ou mini maçarico
- [ ] **Velcro adesivo** (fixação de baterias)
- [ ] **Cable ties** (abraçadeiras de nylon)
- [ ] **Dupont pins** (para reparar conectores)

---

## 🔩 Componentes Sobressalentes

### Sensores
- [ ] **Barômetro** (1x do modelo usado)
  - BMP280, BMP388, MS5611, etc
- [ ] **IMU** (1x do modelo usado)
  - MPU6050, MPU9250, BNO055, etc
- [ ] **GPS** (se aplicável)

### Conectores e Cabos
- [ ] **Conectores JST-XH** (2-4 pinos)
  - 2-3 unidades de cada tipo usado
- [ ] **Cabo USB** (para programação de emergência)
- [ ] **Adaptador USB-Serial** (se necessário)

### Eletrônicos
- [ ] **Bateria extra** (carregada e identificada)
- [ ] **Fusíveis** (se aplicável)
- [ ] **Resistores pull-up** 4.7kΩ (para I2C)
- [ ] **Capacitores de desacoplamento** 100nF
- [ ] **Parafusos M3** (vários comprimentos)
- [ ] **Espaçadores M3** (nylon ou metal)

### Microcontrolador
- [ ] **ESP32/Arduino sobressalente** (já programado com firmware)
  - ⚠️ **CRÍTICO:** Grave o firmware antes de sair

---

## 📄 Documentação

- [ ] **Pinout impresso** (diagrama de conexões)
- [ ] **Esquemático simplificado** (versão legível)
- [ ] **Procedimento de troubleshooting** (este documento)
- [ ] **Checklist pré-voo** impresso
- [ ] **Lista de contatos** (telefones da equipe)

---

## 🔋 Energia

- [ ] **Powerbank** USB (para ferro de solda e carregamento)
  - Mínimo 10.000 mAh
- [ ] **Carregador de bateria LiPo** (se aplicável)
- [ ] **Extensão elétrica** (se houver energia no local)
- [ ] **Pilhas AA/AAA** (para equipamentos auxiliares)

---

## 🧪 Testes

- [ ] **Furadeira sem fio** (teste de vibração de emergência)
- [ ] **Laptop com software de ground station**
- [ ] **Módulo rádio sobressalente** (para testes de telemetria)

---

## 🏥 Primeiros Socorros (Hardware)

- [ ] **Álcool isopropílico** (limpeza de PCB)
- [ ] **Cotonetes** (aplicar álcool)
- [ ] **Pano antiestático** (limpar componentes)
- [ ] **Fita adesiva dupla face** (fixações temporárias)
- [ ] **WD-40** ou similar (liberar conectores travados)

---

## 📦 Organização

### Case Recomendado
- **Maleta rígida** (tipo maleta de ferramentas)
- **Compartimentos** organizados por categoria
- **À prova d'água** (proteção contra chuva)
- **Espuma** interna (proteção de componentes)

### Etiquetagem
- Cole etiquetas em cada compartimento
- Use cores para categorias:
  - 🟢 Verde: Ferramentas
  - 🔵 Azul: Componentes eletrônicos
  - 🟡 Amarelo: Consumíveis
  - 🔴 Vermelho: Documentação

---

## 🚨 Troubleshooting Rápido

### Sistema não liga
1. Verificar tensão da bateria
2. Verificar fusíveis
3. Testar continuidade VCC/GND
4. Trocar bateria

### Sensor não detectado
1. Verificar conexão física (puxar conector)
2. Verificar alimentação do sensor (3.3V)
3. Adicionar resistores pull-up I2C (4.7kΩ)
4. Trocar sensor

### Telemetria não transmite
1. Verificar antena (não dobrada)
2. Verificar ground station recebendo
3. Testar módulo rádio com outro ESP32
4. Trocar módulo rádio

### Solda fria detectada
1. Reaquecer com ferro de solda
2. Adicionar flux
3. Se necessário, cortar e ressoldar
4. Aplicar hot glue após reparo

---

## 📝 Checklist de Preparação do Kit

**1 semana antes:**
- [ ] Verificar se todos os itens estão presentes
- [ ] Testar ferro de solda (funciona?)
- [ ] Carregar powerbank
- [ ] Imprimir documentação atualizada

**1 dia antes:**
- [ ] Carregar bateria sobressalente
- [ ] Gravar firmware em ESP32 sobressalente
- [ ] Testar multímetro (trocar pilha se necessário)
- [ ] Verificar se pistola de hot glue tem bastões

**No dia:**
- [ ] Levar kit completo
- [ ] Incluir laptop com software
- [ ] Levar extensão elétrica
- [ ] Incluir água e lanche (para você! 😊)

---

## 💡 Dicas de Campo

1. **Organize antes de sair**: Não procure componente na hora do aperto
2. **Etiquete tudo**: "Bateria principal", "Bateria sobressalente"
3. **Teste o kit**: Simule um reparo ANTES de ir ao campo
4. **Compartilhe**: Combine com a equipe quem leva o quê
5. **Case visível**: Use cor chamativa (amarelo, laranja) para não perder

---

## 📊 Histórico de Uso

| Data | Item Usado | Motivo | Repor? |
|------|------------|--------|--------|
| ____/____/____ | _____________ | _____________ | ☐ Sim |
| ____/____/____ | _____________ | _____________ | ☐ Sim |
| ____/____/____ | _____________ | _____________ | ☐ Sim |

**Após cada uso, marque o que precisa repor!**

---

## 🎯 Regra de Ouro

> **"Se você vai precisar, Murphy garante que vai faltar."**

Melhor levar e não usar, do que precisar e não ter!

---

**💡 Sugestão:** Faça uma foto do kit completo para referência!

**📦 Peso típico:** 2-5 kg (maleta completa)

**💰 Investimento:** R$ 200-500 (kit inicial)

