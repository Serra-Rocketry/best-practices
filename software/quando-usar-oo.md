# 🎯 Quando Usar Orientação a Objetos - Guia de Decisão

> Escolha entre OO, funções ou procedural

[← Voltar para Boas Práticas de Software](./boas-praticas-software.md)

---

## 🤔 A Pergunta Fundamental

**"Devo usar classes ou funções simples?"**

Este guia ajuda você a decidir.

---

## ✅ Use Orientação a Objetos (Classes) Quando:

### 1. **Há ESTADO persistente**

```python
# ✅ BOM USO DE OO
class FlightComputer:
    def __init__(self):
        self.state = "IDLE"  # ← Estado persistente
        self.apogee_altitude = None
        self.launch_time = None
        self.data_log = []
    
    def update_state(self, sensor_data):
        if self.state == "IDLE" and sensor_data['accel'] > 30:
            self.state = "LAUNCHED"
            self.launch_time = time.time()
        # ... mais lógica de estados
```

**Por quê?** Estado entre chamadas é naturalmente representado em classes.

---

### 2. **Múltiplas operações relacionadas**

```python
# ✅ BOM USO DE OO
class MPU6050:
    def __init__(self, i2c_address=0x68):
        self.address = i2c_address
        self._calibration = None
    
    def calibrate(self):
        """Calibra sensor (operação 1)."""
        pass
    
    def start_sampling(self, rate_hz):
        """Inicia amostragem (operação 2)."""
        pass
    
    def read(self):
        """Lê dados (operação 3)."""
        pass
    
    def stop_sampling(self):
        """Para amostragem (operação 4)."""
        pass

# USO:
sensor = MPU6050()
sensor.calibrate()
sensor.start_sampling(100)
data = sensor.read()
sensor.stop_sampling()
```

**Por quê?** Operações relacionadas agrupadas logicamente.

---

### 3. **Diferentes implementações da mesma interface**

```python
# ✅ BOM USO DE OO (Polimorfismo)
class Radio:
    """Interface abstrata."""
    def send(self, data):
        raise NotImplementedError

class LoRaRadio(Radio):
    """Implementação LoRa."""
    def send(self, data):
        # Transmite via LoRa
        pass

class WiFiRadio(Radio):
    """Implementação WiFi."""
    def send(self, data):
        # Transmite via WiFi
        pass

# CÓDIGO QUE USA (não muda!):
def telemetry_loop(radio: Radio):
    while True:
        data = collect_data()
        radio.send(data)  # Funciona com LoRa ou WiFi!
```

**Por quê?** Mesmo código funciona com implementações diferentes.

---

### 4. **Reutilização de código (Herança)**

```python
# ✅ BOM USO DE OO
class Sensor:
    """Classe base com funcionalidades comuns."""
    def __init__(self, name):
        self.name = name
        self._last_value = None
    
    def log_reading(self, value):
        """Comum a TODOS os sensores."""
        self._last_value = value
        logger.info(f"{self.name}: {value}")
    
    def read(self):
        raise NotImplementedError

class Barometer(Sensor):
    def read(self):
        pressure = self._i2c.read()
        self.log_reading(pressure)  # ← Herdado!
        return pressure

class IMU(Sensor):
    def read(self):
        accel = self._i2c.read()
        self.log_reading(accel)  # ← Herdado!
        return accel
```

**Por quê?** Código de logging escrito UMA vez, usado por TODOS.

---

### 5. **Encapsulamento de complexidade**

```python
# ✅ BOM USO DE OO
class LoRaRadio:
    def send_telemetry(self, data):
        """API simples, complexidade escondida."""
        packet = self._build_packet(data)  # Privado
        packet = self._add_crc(packet)      # Privado
        self._transmit(packet)               # Privado
    
    def _build_packet(self, data):
        # Complexidade escondida
        pass

# USO SIMPLES:
radio = LoRaRadio()
radio.send_telemetry({'altitude': 1200})
# Usuário não vê struct.pack, CRC, headers, etc
```

**Por quê?** Complexidade escondida, interface simples.

---

## ❌ NÃO Use OO (Use Funções) Quando:

### 1. **Função simples sem estado**

```python
# ✅ FUNÇÃO SIMPLES É MELHOR
def calculate_altitude(pressure_pa):
    """Calcula altitude a partir da pressão."""
    SEA_LEVEL_PRESSURE = 101325
    return 44330 * (1 - (pressure_pa / SEA_LEVEL_PRESSURE) ** 0.1903)

# USO:
altitude = calculate_altitude(98000)

# ❌ NÃO PRECISA DE CLASSE:
class AltitudeCalculator:  # Overhead desnecessário
    def calculate(self, pressure):
        return 44330 * (1 - (pressure / 101325) ** 0.1903)
```

**Por quê?** Função pura, sem estado, cálculo simples.

---

### 2. **Usado apenas uma vez**

```python
# ✅ FUNÇÃO SIMPLES
def parse_gps_nmea(sentence):
    """Parseia sentença NMEA do GPS."""
    parts = sentence.split(',')
    lat = float(parts[2])
    lon = float(parts[4])
    return lat, lon

# Se usado apenas uma vez no código, não precisa de classe
```

---

### 3. **Operação única e independente**

```python
# ✅ FUNÇÃO SIMPLES
def validate_telemetry_packet(packet):
    """Valida CRC de pacote de telemetria."""
    data = packet[:-2]
    crc_received = packet[-2:]
    crc_calculated = calculate_crc(data)
    return crc_received == crc_calculated
```

---

### 4. **Transformação de dados**

```python
# ✅ FUNÇÕES SIMPLES (estilo funcional)
def filter_outliers(data, threshold=3.0):
    """Remove outliers dos dados."""
    mean = statistics.mean(data)
    stdev = statistics.stdev(data)
    return [x for x in data if abs(x - mean) < threshold * stdev]

def normalize(data):
    """Normaliza dados entre 0 e 1."""
    min_val = min(data)
    max_val = max(data)
    return [(x - min_val) / (max_val - min_val) for x in data]
```

---

## 🌳 Árvore de Decisão

```
Precisa manter ESTADO entre chamadas?
├─ SIM → Use OO (classe)
└─ NÃO
    ├─ Múltiplas operações relacionadas?
    │  ├─ SIM → Use OO (classe)
    │  └─ NÃO
    │      ├─ Diferentes implementações possíveis?
    │      │  ├─ SIM → Use OO (interface + subclasses)
    │      │  └─ NÃO → Use função simples
    └─ Função pura (entrada → saída)?
       └─ SIM → Use função simples
```

---

## 📊 Tabela Comparativa

| Cenário | OO | Função | Por quê? |
|---------|:--:|:------:|----------|
| Sensor com calibração e estado | ✅ | ❌ | Estado persistente |
| Cálculo de altitude | ❌ | ✅ | Função pura |
| Rádio (LoRa vs WiFi) | ✅ | ❌ | Polimorfismo |
| Parse de string NMEA | ❌ | ✅ | Transformação única |
| Flight computer (estados) | ✅ | ❌ | Máquina de estados |
| Validação de CRC | ❌ | ✅ | Função pura |
| Logger com níveis | ✅ | ❌ | Estado + configuração |
| Conversão de unidades | ❌ | ✅ | Transformação simples |

---

## 💡 Exemplos Práticos

### ✅ Bom Uso de OO: Sistema de Telemetria

```python
class TelemetrySystem:
    """Sistema completo - estado e operações."""
    
    def __init__(self, radio, sensors, logger):
        self.radio = radio
        self.sensors = sensors
        self.logger = logger
        self.packet_count = 0  # ← Estado
        self.running = False   # ← Estado
    
    def start(self):
        self.running = True
        while self.running:
            data = self._collect_data()
            self.radio.send(data)
            self.logger.log(data)
            self.packet_count += 1
    
    def stop(self):
        self.running = False
```

---

### ✅ Bom Uso de Funções: Processamento de Dados

```python
def process_flight_data(raw_data):
    """Pipeline de processamento."""
    cleaned = remove_invalid_readings(raw_data)
    filtered = apply_kalman_filter(cleaned)
    normalized = normalize_timestamps(filtered)
    return normalized

def remove_invalid_readings(data):
    return [x for x in data if x['altitude'] > 0]

def apply_kalman_filter(data):
    # Aplicar filtro
    pass

def normalize_timestamps(data):
    # Normalizar timestamps
    pass
```

---

## ⚠️ Sinais de Uso Errado de OO

### 🚫 Classes desnecessárias

```python
# ❌ RUIM (God Object)
class Everything:
    def __init__(self):
        self.sensor = Sensor()
        self.radio = Radio()
        self.logger = Logger()
        self.calculator = Calculator()
    
    def do_everything(self):
        # 500 linhas de código
        pass

# ✅ BOM (separado e funcional onde apropriado)
sensor = Sensor()  # OO (tem estado)
radio = Radio()    # OO (tem estado)

def process_data(sensor_value):  # Função (sem estado)
    return sensor_value * CONVERSION_FACTOR
```

---

### 🚫 Classes com apenas um método

```python
# ❌ RUIM (overhead desnecessário)
class AltitudeCalculator:
    def calculate(self, pressure):
        return 44330 * (1 - (pressure / 101325) ** 0.1903)

# ✅ BOM (função simples)
def calculate_altitude(pressure):
    return 44330 * (1 - (pressure / 101325) ** 0.1903)
```

---

## 🎯 Regras de Ouro

1. **OO para COISAS (substantivos)**
   - Sensor, Radio, FlightComputer
   - Têm estado e comportamento

2. **Funções para AÇÕES (verbos)**
   - calculate(), parse(), validate()
   - Entrada → transformação → saída

3. **Comece simples**
   - Função primeiro
   - Refatore para classe se precisar de estado

4. **YAGNI: "You Ain't Gonna Need It"**
   - Não crie classes "para o futuro"
   - Crie quando REALMENTE precisar

---

## 📚 Referências

- [Clean Code - Cap. 10: Classes](https://www.amazon.com.br/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882)
- [Composition Over Inheritance](https://en.wikipedia.org/wiki/Composition_over_inheritance)
- [SOLID Principles](https://www.youtube.com/watch?v=pTB30aXS77U)

---

**💡 Resumo:** OO é ferramenta, não objetivo. Use quando simplifica, não por dogma!

**⏱️ Tempo de decisão:** < 2 minutos com prática

