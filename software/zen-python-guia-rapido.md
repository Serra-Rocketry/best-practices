# 🧘 Zen do Python - Guia Rápido

> Princípios para código limpo e pythônico

[← Voltar para Boas Práticas de Software](./boas-praticas-software.md)

---

## 📜 O Zen Completo

```python
import this
```

```
The Zen of Python, by Tim Peters

Beautiful is better than ugly.
Explicit is better than implicit.
Simple is better than complex.
Complex is better than complicated.
Flat is better than nested.
Sparse is better than dense.
Readability counts.
...
```

---

## 🎯 Top 5 Princípios para Foguetemodelismo

### 1. **"Simple is better than complex"**

**❌ Complexo:**
```python
def calc(d):
    return ((d[0]-d[1])**2+(d[2]-d[3])**2)**0.5 if len(d)==4 else None
```

**✅ Simples:**
```python
def calculate_distance_2d(x1, y1, x2, y2):
    """Calcula distância euclidiana entre dois pontos 2D."""
    dx = x2 - x1
    dy = y2 - y1
    return math.sqrt(dx**2 + dy**2)
```

**Por quê?** Código do foguete deve ser entendido às 3h da manhã antes do lançamento!

---

### 2. **"Explicit is better than implicit"**

**❌ Implícito (números mágicos):**
```python
def calculate_altitude(pressure):
    return 44330 * (1 - (pressure / 101325) ** 0.1903)
```

**✅ Explícito (constantes nomeadas):**
```python
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

### 3. **"Readability counts"**

**❌ Difícil de ler:**
```python
a=[(x,y,z) for x,y,z in data if x>0 and z<100]
b=[math.sqrt(x**2+y**2+z**2) for x,y,z in a]
```

**✅ Legível:**
```python
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

### 4. **"Errors should never pass silently"**

**❌ Erro silencioso (mascarado):**
```python
def read_sensor():
    try:
        return sensor.read()
    except:
        return 0  # ← Problema escondido!
```

**✅ Erro tratado explicitamente:**
```python
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

**Por quê?** Durante o voo, você PRECISA saber de erros! Log é crucial.

---

### 5. **"If the implementation is hard to explain, it's a bad idea"**

**❌ Difícil de explicar:**
```python
def f(d):
    return sum([(d[i]-d[i-1])**2 for i in range(1,len(d))])**0.5
# Você consegue explicar isso em 10 segundos?
```

**✅ Fácil de explicar:**
```python
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

**Teste:** Se você não consegue explicar facilmente = redesenhe!

---

## 🎓 Aplicação Prática

### Nomenclatura

**❌ Ruim:**
```python
a = 9.81
d = read()
t = time()
x = calc(d, t, a)
```

**✅ Bom:**
```python
GRAVITY = 9.81  # m/s²
altitude_m = read_barometer()
timestamp_ms = time.time() * 1000
velocity_ms = calculate_velocity(altitude_m, timestamp_ms, GRAVITY)
```

---

### Estrutura de Código

**❌ Muito aninhado (nested):**
```python
def process():
    if sensor.connected():
        if sensor.ready():
            if data := sensor.read():
                if data > 0:
                    if data < 100:
                        return data
    return None
```

**✅ Flat (guard clauses):**
```python
def process():
    if not sensor.connected():
        return None
    if not sensor.ready():
        return None
    
    data = sensor.read()
    if not data:
        return None
    if data <= 0 or data >= 100:
        return None
    
    return data
```

---

### Funções

**❌ Função longa e complexa:**
```python
def flight_loop():
    # 200 linhas fazendo tudo
    pass
```

**✅ Funções pequenas e focadas:**
```python
def flight_loop():
    """Loop principal de voo."""
    while in_flight:
        sensor_data = read_all_sensors()
        state = update_flight_state(sensor_data)
        log_telemetry(sensor_data, state)
        check_deploy_conditions(state)
        time.sleep(0.01)  # 100 Hz

def read_all_sensors():
    """Lê todos os sensores."""
    return {
        'altitude': barometer.read(),
        'accel': imu.read_acceleration(),
        'gyro': imu.read_gyro(),
    }

def update_flight_state(data):
    """Atualiza máquina de estados."""
    # ...
```

---

## 📋 Checklist Rápido

Antes de commitar código Python:

- [ ] **Nomes descritivos** em variáveis e funções
- [ ] **Constantes nomeadas** (não números mágicos)
- [ ] **Funções < 50 linhas** (se maior, quebrar)
- [ ] **Docstrings** em funções públicas
- [ ] **Tratamento de erros** explícito (não `except:` genérico)
- [ ] **Código lido em voz alta faz sentido**

---

## 🔍 Sinais de Alerta

Seu código pode estar complexo demais se:

- ⚠️ Precisa explicar cada linha em comentário
- ⚠️ Aninhamento > 3 níveis
- ⚠️ Função tem > 100 linhas
- ⚠️ Você mesmo não entende depois de 1 semana
- ⚠️ Nome da variável é `temp`, `data`, `x`

---

## 💡 Regras de Ouro

1. **Código é lido 10x mais que escrito**
   - Otimize para legibilidade, não velocidade de digitação

2. **Simples != Fácil**
   - Simples é resultado de trabalho de design
   - Fácil é pegar o primeiro código que funciona

3. **Explícito > Clever**
   - Código "clever" impressiona em competição
   - Código explícito salva missões

4. **Se precisa comentar, nomeie melhor**
   ```python
   # ❌
   x = x * 0.48828  # Conversão ADC

   # ✅
   ADC_TO_TEMPERATURE = 0.48828
   temperature = raw_adc * ADC_TO_TEMPERATURE
   ```

---

## 🎯 Resumo: Zen na Prática

| Princípio | Aplicação em Foguetes |
|-----------|----------------------|
| **Simples > Complexo** | Código deve funcionar sob pressão |
| **Explícito > Implícito** | Constantes físicas nomeadas |
| **Legibilidade** | Equipe deve entender rapidamente |
| **Erros visíveis** | Log de erros = debug pós-voo |
| **Fácil de explicar** | Revisão de código eficiente |

---

## 📚 Referências

- [PEP 20 - The Zen of Python](https://www.python.org/dev/peps/pep-0020/)
- [Clean Code](https://www.amazon.com.br/Clean-Code-Handbook-Software-Craftsmanship/dp/0132350882) - Robert C. Martin
- [The Hitchhiker's Guide to Python](https://docs.python-guide.org/)

---

**💡 Lembre-se:** Código bom é código que você entende às 3h da manhã! 🌙

**⏱️ Revisão:** 5 minutos antes de cada commit

