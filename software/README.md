# 📁 Software - Boas Práticas e Guias Rápidos

[← Voltar ao índice principal](../README.md)

---

## 📚 Conteúdo desta Pasta

### 📖 Guia Principal
- **[boas-praticas-software.md](./boas-praticas-software.md)** - Guia completo de boas práticas
  - Filosofia Unix (One Tool, One Job)
  - Modularidade e separação
  - Fork vs Novo Repo vs Monorepo
  - Não reinvente a roda
  - Watchdog (completo)
  - Zen do Python (completo)
  - Orientação a Objetos (completo)
  - Casos reais da Serra Rocketry

### ✅ Guias Rápidos (Uso Diário)

Arquivos otimizados para **consulta rápida durante desenvolvimento**:

#### 🚀 [Checklist Pré-Deploy](./checklist-pre-deploy.md)
**Quando usar:** Antes de gravar firmware no foguete

Verificações de:
- Compilação e configuração
- Watchdog habilitado
- Testes em bancada
- Logging e telemetria
- Lógica de voo
- Code review

**💡 Dica:** Use antes de CADA gravação de firmware!

---

#### 🐕 [Watchdog - Guia Rápido](./watchdog-guia-rapido.md)
**Quando usar:** Implementando proteção contra travamentos

Conteúdo:
- Template completo (ESP32 + Arduino)
- 3 regras de ouro
- Detecção de resets
- Telemetria de problemas
- Checklist de implementação

**💡 Dica:** Copie e cole o template, customize para seu projeto!

---

#### 🧘 [Zen do Python - Guia Rápido](./zen-python-guia-rapido.md)
**Quando usar:** Escrevendo código Python

Top 5 princípios:
- Simple > Complex
- Explicit > Implicit
- Readability counts
- Errors should never pass silently
- If hard to explain, it's bad

**💡 Dica:** Revise antes de cada commit!

---

#### 🎯 [Quando Usar OO](./quando-usar-oo.md)
**Quando usar:** Decidindo entre classes ou funções

Guia de decisão com:
- Árvore de decisão
- Tabela comparativa
- Exemplos práticos
- Sinais de uso errado
- Regras de ouro

**💡 Dica:** Consulte quando em dúvida sobre design!

---

## 🎯 Fluxo de Trabalho Recomendado

```
1. DESIGN/ARQUITETURA
   ↓
   Usar: quando-usar-oo.md
   Decidir: Classes ou funções?
   ↓
2. DESENVOLVIMENTO
   ↓
   Usar: zen-python-guia-rapido.md
   Código limpo e legível
   ↓
3. IMPLEMENTAR PROTEÇÕES
   ↓
   Usar: watchdog-guia-rapido.md
   Adicionar watchdog
   ↓
4. TESTES EM BANCADA
   ↓
   Testar extensivamente
   ↓
5. PRÉ-DEPLOY
   ↓
   Usar: checklist-pre-deploy.md
   Verificar TUDO antes de gravar
   ↓
6. GRAVAÇÃO NO FOGUETE
   ↓
7. LANÇAMENTO 🚀
```

---

## 📱 Uso Durante Desenvolvimento

### Consulta Rápida

| Situação | Arquivo | Tempo |
|----------|---------|-------|
| "Classe ou função?" | quando-usar-oo.md | 2 min |
| "Código está limpo?" | zen-python-guia-rapido.md | 3 min |
| "Como implementar watchdog?" | watchdog-guia-rapido.md | 5 min |
| "Posso gravar firmware?" | checklist-pre-deploy.md | 15 min |
| "Aprender conceitos" | boas-praticas-software.md | 40 min |

---

## 🔍 Quando Usar Cada Arquivo

### boas-praticas-software.md (Completo)
- ✅ Aprendizado inicial
- ✅ Entender conceitos em profundidade
- ✅ Referência para decisões arquiteturais
- ✅ Exemplos detalhados

### Guias Rápidos
- ✅ Consulta diária
- ✅ Templates para copiar
- ✅ Checklists antes de ações críticas
- ✅ Decisões rápidas

---

## 💡 Dicas de Uso

### Para Desenvolvimento Individual
1. **Antes de codificar:** Leia quando-usar-oo.md
2. **Durante código:** Tenha zen-python-guia-rapido.md aberto
3. **Implementando watchdog:** Copie template de watchdog-guia-rapido.md
4. **Antes de deploy:** Siga checklist-pre-deploy.md

### Para Code Review
1. Use zen-python-guia-rapido.md como referência
2. Verifique se código segue princípios
3. Use quando-usar-oo.md para julgar design
4. Checklist-pre-deploy.md para aprovação final

### Para Onboarding
1. Comece com boas-praticas-software.md (visão geral)
2. Depois use guias rápidos para referência diária
3. Imprima checklists para consulta física

---

## 📊 Estatísticas

| Arquivo | Linhas | Uso | Tempo Leitura |
|---------|--------|-----|---------------|
| boas-praticas-software.md | ~1755 | Referência | 40-50 min |
| checklist-pre-deploy.md | ~350 | Pré-deploy | 15 min |
| watchdog-guia-rapido.md | ~250 | Implementação | 10 min |
| zen-python-guia-rapido.md | ~250 | Consulta diária | 5 min |
| quando-usar-oo.md | ~350 | Decisão design | 10 min |

---

## 🖨️ Sugestão de Impressão

### Para o Lab
```
✓ checklist-pre-deploy.md  → Cole na parede perto do computador
✓ zen-python-guia-rapido.md → Consulta rápida
✓ quando-usar-oo.md → Decisões de design
```

### Para Consulta Digital
```
✓ boas-praticas-software.md → Referência completa
✓ watchdog-guia-rapido.md → Template para copiar
```

---

## 🔄 Atualizações

Melhorias nos guias?
1. Edite o arquivo relevante
2. Faça commit explicando
3. Compartilhe com a equipe

---

## 📚 Recursos Adicionais

### Livros Recomendados
- Clean Code - Robert C. Martin
- The Pragmatic Programmer
- Fluent Python - Luciano Ramalho

### Cursos Online
- [Python OOP Tutorial - Corey Schafer](https://www.youtube.com/watch?v=ZDa-Z5JzLYM&list=PL-osiE80TeTsqhIuOqKhwlXsIBIdSeYtc)
- [Real Python OOP](https://realpython.com/python3-object-oriented-programming/)

### Ferramentas
- [PEP 8 Checker](https://pep8online.com/)
- [Pylint](https://pylint.org/)
- [Black](https://black.readthedocs.io/) - Code formatter

---

**Mantido por:** Equipe Serra Rocketry - IPRJ/UERJ

**Contribuições:** Sempre bem-vindas via Pull Request!

