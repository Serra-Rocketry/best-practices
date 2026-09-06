# 📁 Hardware - Boas Práticas e Checklists

[← Voltar ao índice principal](../README.md)

---

## 📚 Conteúdo desta Pasta

### 📖 Guia Principal
- **[boas-praticas-hardware.md](./boas-praticas-hardware.md)** - Guia completo de boas práticas
  - Fungibilidade e padronização
  - Modularidade em hardware
  - Resiliência para ambientes hostis
  - Técnicas de proteção
  - Exemplos práticos

### 🧩 [Design Mecânico e Impressão 3D](./boas-praticas-design-mecanico.md)
**Quando usar:** projetando peça, carcaça ou mecanismo (CAD, simulação, impressão)

- Escolha da ferramenta CAD (OpenSCAD vs CadQuery/build123d vs FreeCAD)
- Montagem em 3 níveis: encaixe estático → simulador físico (PyBullet/MuJoCo) → assembly profissional
- Análise de resistência (gmsh + CalculiX) e regras de impressão FDM
- IA generativa no fluxo de design e versionamento de peças

---

### ✅ Checklists (Uso Rápido)

Arquivos otimizados para **impressão e uso no campo**:

#### 🚀 [Checklist Pré-Voo](./checklist-pre-voo.md)
**Quando usar:** 5 minutos antes do lançamento

Verificação rápida de:
- Alimentação e conexões
- Fixação mecânica
- Soldas e componentes
- Funcionalidade do sistema
- Proteção ambiental

**💡 Dica:** Imprima e leve em pasta plastificada!

---

#### 🧰 [Kit de Campo](./kit-campo.md)
**Quando usar:** Preparação para ida ao campo

Lista completa de:
- Ferramentas essenciais
- Consumíveis (hot glue, fios, etc)
- Componentes sobressalentes
- Documentação necessária
- Troubleshooting rápido

**💡 Dica:** Use como checklist ao montar seu kit!

---

#### ✅ [Checklist de Design](./checklist-design.md)
**Quando usar:** Antes de fabricar PCB

Verificações de:
- Fungibilidade dos componentes
- Modularidade do sistema
- Testabilidade (test points, LEDs)
- Robustez (fixação, vibração)
- Documentação completa

**💡 Dica:** Faça design review com a equipe!

---

## 🎯 Fluxo de Trabalho Recomendado

```
1. DESIGN
   ↓
   Usar: checklist-design.md
   Verificar: Todos os itens antes de fabricar
   ↓
2. FABRICAÇÃO & MONTAGEM
   ↓
3. TESTES EM BANCADA
   ↓
   Usar: boas-praticas-hardware.md (seção de testes)
   ↓
4. PREPARAÇÃO PARA CAMPO
   ↓
   Usar: kit-campo.md
   Montar kit de reparo completo
   ↓
5. NO DIA DO LANÇAMENTO
   ↓
   Usar: checklist-pre-voo.md
   5 minutos antes do lançamento
   ↓
6. LANÇAMENTO 🚀
```

---

## 📱 Uso Mobile-Friendly

Todos os checklists são otimizados para:
- ✅ Visualização em smartphone
- ✅ Impressão em papel A4
- ✅ Checkboxes interativos no GitHub
- ✅ Marcação com caneta quando impresso

---

## 🖨️ Sugestão de Impressão

### Para o Campo (Laminar)
```
✓ checklist-pre-voo.md     → Papel A4, laminar
✓ kit-campo.md (resumo)    → Papel A4, laminar
✓ Pinout do projeto        → Papel A4, laminar
```

### Para o Lab
```
✓ checklist-design.md      → Pasta no lab
✓ boas-praticas-hardware.md → Referência digital
```

---

## 🔄 Atualizações

Encontrou algo que falta nos checklists?
1. Adicione no arquivo relevante
2. Faça commit explicando o motivo
3. Compartilhe com a equipe

---

## 📊 Estatísticas

| Arquivo | Linhas | Uso | Tempo Leitura |
|---------|--------|-----|---------------|
| boas-praticas-hardware.md | ~1500 | Referência | 30-40 min |
| boas-praticas-design-mecanico.md | ~170 | Referência | 10-15 min |
| checklist-pre-voo.md | ~200 | Campo | 5 min |
| kit-campo.md | ~250 | Preparação | 10 min |
| checklist-design.md | ~350 | Desenvolvimento | 15-20 min |

---

**Mantido por:** Equipe Serra Rocketry - IPRJ/UERJ

**Contribuições:** Sempre bem-vindas via Pull Request!

