# 🧩 Boas Práticas de Design Mecânico e Impressão 3D

> Como projetar, montar, validar e versionar peças mecânicas da equipe — do CAD à impressão, com simulação antes do campo

[← Voltar para Boas Práticas de Hardware](./boas-praticas-hardware.md)

---

## 🛠️ Escolha da Ferramenta de CAD

Não existe uma ferramenta só. A decisão depende do que a peça vai precisar:

| Necessidade | Ferramenta | Por quê |
|---|---|---|
| Peça impressa, iteração rápida | **OpenSCAD** | Código é o modelo: paramétrico, roda headless no CLI, exporta STL direto. Ideal p/ carcaças, suportes, cases |
| STEP/B-Rep, assembly real, entregar p/ CAD profissional | **CadQuery / build123d** | Python paramétrico sobre kernel OCCT (mesmo do FreeCAD). Lê/escreve STEP nativo. Ambos open source (Apache 2.0) |
| Projeto que já vive no FreeCAD | **FreeCAD** | LGPL, gratuito; hoje dá p/ dirigir via MCP com LLM, mas API de macro muda entre versões — último recurso p/ fluxo novo |

**Regra prática da equipe:** começar no OpenSCAD quando a peça é nossa e vai pra impressora. Migrar pra CadQuery/build123d só quando o destino for CAD profissional (B-Rep/STEP obrigatório).

---

## 🔩 Montagem de Peças: Três Níveis

### 1. Encaixe estático (folga/interferência) — OpenSCAD resolve
- Modelar **todas as peças montadas no lugar**, cada uma com sua cor
- Variável `exploded` para alternar entre vista montada e vista de impressão (peças lado a lado no Z=0)
- Checagem de interferência: `intersection(pecaA, pecaB)` tem que dar volume vazio; folga mínima via distância entre malhas (trimesh)
- Modelar o componente protegido como caixa simplificada para o fit check rodar no mesmo script

### 2. Mecanismo (ver funcionar) — simulador físico, não CAD de assembly
CAD de montagem com vínculos exige STEP e é impreciso com STL facetado. O caminho curto:
- Exporta os STLs do OpenSCAD → **PyBullet** (teste rápido, STL entra direto) ou **MuJoCo** (mantido pelo Google DeepMind, solver mais robusto)
- Juntas/atuadores definidos em Python (pino, slider, servo com PID)
- Valida movimento, colisão e força **antes do teste de campo**

**Exemplo na equipe:** mecanismo ratchet do recovery e atuadores do FC podem ser simulados assim antes de imprimir e queimar um servo em bancada.

### 3. Assembly profissional — só quando exigido
Quando a entrega pede BOM, desenho de fabricação ou o time externo usa SolidWorks/Fusion:
- Peças paramétricas em CadQuery/build123d → exporta STEPs → monta no FreeCAD/Onshape
- Caminho mais caro; não usar para iteração interna

---

## 📐 Análise de Resistência

OpenSCAD **não faz FEA** — é só geometria. Pipeline livre e headless:

```
STL → gmsh (remesh) → CalculiX (ccx) → ParaView
```

- STL facetado do OpenSCAD **não pode ir direto ao solver** — precisa remesh no gmsh
- **Hand-calc primeiro**, FEA quando a geometria complica, e **teste de campo é a verdade final**
  - Exemplo real: carcaça anti-queda do AltimeterTwo (TPU 95A) validada em queda balística — FEA ajudaria a prever, mas o voo real bateu o martelo
- Otimização automática de geometria: só faz sentido com **função de fitness definida** (ex.: massa ≤ X, tensão ≤ Y, folga ≥ Z) + otimizador paramétrico (ex.: pymoo). Topology optimization de verdade gera malha orgânica e quebra o fluxo paramétrico — evitar no dia a dia

---

## 🖨️ Regras de Impressão FDM (tabela rápida)

| Parâmetro | Valor |
|---|---|
| Parede mínima | 1.2 mm (bico 0.4 × 3 perímetros) |
| Feature mínima | 0.4 mm |
| Overhang máximo | 45° |
| Ponte máxima | 10 mm |
| Compensação de furo | +0.2 mm justo / +0.4 mm folgado |

**Folga por tipo de encaixe (PLA/PETG):**

| Tipo | Folga |
|---|---|
| Pressão (interference) | −0.05 a −0.15 mm |
| Justo (snug) | 0.1–0.2 mm |
| Deslizante | 0.2–0.3 mm |
| Folgado | 0.3–0.5 mm |
| Rosca | 0.3 mm de folga |

⚠️ Cuidado com sensores de pressão/altímetro: **nunca selar o port de pressão** — o compartimento precisa de respiro (vent hole).

---

## 🤖 IA Generativa no Fluxo de Design

### Loop que funciona (validação está no loop, não no modelo)
```
1. LLM gera .scad a partir da spec
2. Compila (erro volta com número da linha — LLM se corrige bem)
3. Renderiza + inspeção visual
4. Mede dimensões e muda uma variável → confirma que nada está hardcoded
5. Repete até a geometria seguir os parâmetros
```

### Converter peça existente (STL/STEP) para OpenSCAD
- **Nunca mandar STEP cru (texto AP214) pro LLM** — é sopa de entidades e estoura contexto
- **Medições vêm do arquivo, visão não mede**: extrair dimensões reais (STL: malha; STEP: CadQuery) e passar ao gerador. LLM de visão chuta número absoluto
- Visão serve para conferir **topologia/forma**, validando o resultado ângulo por ângulo

### Modelos (verificado em setembro/2026)
- **DeepSeek V4 Flash Vision** (`deepseek-v4-flash-vision-exp`): entrada de imagem + texto, mesmo preço do Flash texto (~US$0.14/0.28 por 1M). **Padrão da equipe**
- **OpenAI GPT-6 Astra**: mais capaz, porém ~180× mais caro (US$10/50 por 1M). Reservar para geometria difícil que o Flash não resolve
- Rodar o loop com o modelo barato e escalar só quando travar — iteração custa caro no modelo top

---

## 🗃️ Versionamento: o Código é o Modelo

- **Versionar o `.scad` (e parâmetros), nunca só o STL** — STL é artefato de build, igual binário
- Commit de peça = commit de código: mensagem explica o *porquê* da mudança (ex.: `fix: aumenta parede do acoplador após degradação em campo`)
- Rastreabilidade: "por que mudou a parede?" → resposta no git, igual firmware
- Ver [Boas Práticas de Git e GitHub](../boas-praticas-git-github.md)

---

## 🔄 Atualizações

Encontrou algo que falta? 
1. Adicione neste arquivo
2. Faça commit explicando o motivo
3. Compartilhe com a equipe

---

**Mantido por:** Equipe Serra Rocketry - IPRJ/UERJ
