# 🚀 Boas Práticas - Serra Rocketry

> Guia essencial para desenvolvimento profissional e colaborativo de projetos de foguetemodelismo

---

## 📖 Sobre Este Guia

Este repositório contém as diretrizes e boas práticas adotadas pela equipe Serra Rocketry para garantir que nossos projetos sejam:
- **Profissionais**: Organizados e documentados adequadamente
- **Colaborativos**: Fáceis de contribuir e revisar
- **Sustentáveis**: Mantidos e evoluídos ao longo do tempo
- **Modulares**: Componentes independentes e reutilizáveis

---

## 🗂️ Estrutura Deste Guia

### 📚 [Boas Práticas de Git e GitHub](./boas-praticas-git-github.md)
**Versionamento não é Backup - É uma Máquina do Tempo Colaborativa**

Entenda a diferença fundamental entre fazer backup e versionar código:
- **Backup**: Cópia estática dos arquivos em um momento
- **Versionamento (Git)**: História completa de TODAS as mudanças, com contexto

**Por que isso importa?**
- 🔍 **Rastreabilidade**: "Por que mudamos o sensor no ano passado?" - Git tem a resposta
- 🛡️ **Segurança**: Se algo quebrar, você sabe EXATAMENTE qual mudança causou
- 📊 **Portfólio**: Suas contribuições ficam registradas no seu perfil GitHub
- 🤝 **Colaboração**: Várias pessoas trabalhando sem conflitos

**O que você aprenderá:**
- Fluxo Fork → Branch → Commit → Pull Request
- Estratégia de branches para competições
- Como escrever commits e PRs profissionais
- Comandos Git essenciais

---

### 📁 [Boas Práticas de Organização de Projetos](./boas-praticas-organizacao.md)
**Estrutura Profissional de Repositórios**

Aprenda a organizar seus projetos de forma que qualquer pessoa consiga entender e contribuir:
- Estrutura de diretórios (`docs/`, `firmware/`, `hardware/`, `test/`)
- O que versionar e o que ignorar (`.gitignore`)
- Documentação distribuída: cada coisa em seu lugar
- Templates de README, CHANGELOG, e documentação técnica

**Benefícios:**
- ⚡ Onboarding rápido de novos membros
- 📖 Documentação sempre atualizada e fácil de encontrar
- 🔧 Manutenção simplificada do código

---

### 💻 [Boas Práticas de Software](./software/boas-praticas-software.md)
**Modularidade, Reutilização e Filosofia Unix**

Princípios fundamentais para desenvolvimento de software sustentável:

#### 🔧 **One Tool, One Job** (Filosofia Unix)
Cada projeto deve fazer UMA coisa bem feita:
- ✅ **ignitor**: Apenas aciona ignitores remotamente
- ✅ **thrust-stand**: Apenas mede empuxo em bancada
- ❌ **Misturar os dois**: Ignitor pegando dados de thrust-stand para transmitir → Complexidade desnecessária

#### 🧩 **Modularidade e Separação**
Quando separar em repositórios diferentes vs quando juntar:
- **Repositórios separados**: Projetos independentes (ignitor vs thrust-stand)
- **Fork**: Variações de um mesmo projeto (satellite ← fork de flight-computer)
- **Monorepo**: Quando há alta interdependência (firmware + ground-station)

#### 📚 **Não Reinvente a Roda**
Use bibliotecas mantidas pela comunidade:
- Sensor MPU6050? Use a biblioteca do Jeff Rowberg
- LoRa? Use RadioHead ou a biblioteca oficial
- Foco: resolver o PROBLEMA do foguete, não reimplementar protocolos

**Exemplos práticos** com os repositórios da Serra Rocketry incluídos!

---

### ⚙️ [Boas Práticas de Hardware](./hardware/boas-praticas-hardware.md)
**Fungibilidade, Padronização e Resiliência para Ambientes Hostis**

Hardware deve ser projetado para ser **facilmente substituível e intercambiável**, mas também **robusto e resiliente** para suportar condições extremas:

#### 🔄 **Fungibilidade**
Partes devem ser trocáveis sem redesenhar o sistema:
- ✅ Sensores com interface I2C padrão (trocar MPU6050 por BNO055 sem mudar PCB)
- ✅ Microcontroladores pin-compatible (ESP32-S3 → ESP32-C3)
- ✅ Conectores padronizados (JST, Molex)
- ❌ Sensores soldados direto na PCB sem alternativa

#### 📏 **Padronização**
Adote padrões de mercado:
- Conectores: JST-XH para sinais, XT30/XT60 para potência
- Protocolos: I2C, SPI, UART (evite interfaces proprietárias)
- Form-factors: PC104 para CubeSats, tamanhos comerciais de baterias

#### 🚀 **Resiliência e Robustez**
Hardware de foguete enfrenta condições extremas:
- **Vibração**: 10-30G durante lançamento, teste com furadeira/subwoofer
- **Soldas**: Inspeção rigorosa, soldas brilhantes e côncavas (soldas frias = falha)
- **Fixação**: Tudo parafusado ou com hot glue, nada solto
- **Strain relief**: Cabos com alívio de tensão (hot glue/heat shrink na raiz)
- **Testes**: Vibração, queda, temperatura ANTES do lançamento
- **Proteção**: Conformal coating, cases rígidos, kit de reparo de campo

#### 🛠️ **Redundância e Modularidade**
- Módulos substituíveis (sensor board, power board, telemetry board)
- Pontos de teste acessíveis
- Documentação de pinagem e especificações elétricas

**Resultado:** Hardware que sobrevive ao transporte E ao lançamento!

---

### 🧰 [CAD Toolchain](./tools/cad-toolchain/README.md)
**Ambiente containerizado para design mecânico e impressão 3D**

Quando for gerar ou validar uma peça (com LLM ou não), use o toolchain da equipe — o mesmo ambiente roda em qualquer máquina:
- **OpenSCAD**: compila `.scad` → STL/PNG (o código é o modelo)
- **CadQuery**: STEP/B-Rep para reverse engineering de peça
- **trimesh**: checagem de interferência e folga entre malhas
- **gmsh + CalculiX**: análise de resistência (FEA) headless
- Geração por **LLM fica fora do container** (API) — nada de chave na imagem

**Resultado:** Peças versionadas como código (`.scad`), validadas antes de imprimir!

---

## 🎯 Por Que Seguir Estas Práticas?

### Para Você (Aluno)
- 💼 **Portfólio profissional** que impressiona recrutadores
- 🧠 **Aprende práticas da indústria** usadas em empresas de tecnologia
- 🤝 **Colabora melhor** com a equipe e comunidade open-source

### Para a Equipe
- 🚀 **Produtividade maior** - menos tempo corrigindo problemas bobos
- 📈 **Conhecimento preservado** - não perdemos know-how quando alguém sai
- 🏆 **Projetos melhores** - qualidade que se destaca em competições

### Para o Projeto
- ⏱️ **Sustentabilidade** - código que dura anos, não semestres
- 🔧 **Manutenibilidade** - fácil de entender e modificar
- 🌍 **Visibilidade** - projetos bem documentados atraem colaboradores

---

## 🚦 Quick Start

1. **Novo na equipe?** Comece por [Git e GitHub](./boas-praticas-git-github.md)
2. **Criando um projeto?** Veja [Organização](./boas-praticas-organizacao.md) e [Software](./boas-praticas-software.md)
3. **Projetando hardware?** Leia [Hardware](./boas-praticas-hardware.md)
4. **Gerando/validando peça 3D?** Veja [Design Mecânico e Impressão 3D](./hardware/boas-praticas-design-mecanico.md) e o [CAD Toolchain](./tools/cad-toolchain/README.md)
5. **Contribuindo?** Siga o fluxo Fork → PR explicado em [Git e GitHub](./boas-praticas-git-github.md)

---

## 🤝 Contribuindo com Este Guia

Este documento é vivo e evolui com a equipe! 

**Encontrou algo confuso? Tem uma sugestão?**
1. Faça um fork deste repositório
2. Edite o arquivo relevante
3. Abra um Pull Request explicando sua melhoria

**Dúvidas?** Abra uma [Issue](https://github.com/Serra-Rocketry/best-practices/issues) para discussão.

---

## 📚 Recursos Adicionais

### Aprendizado
- 🎮 [Learn Git Branching](https://learngitbranching.js.org/?locale=pt_BR) - Tutorial interativo
- 📖 [Pro Git Book](https://git-scm.com/book/pt-br/v2) - Livro completo gratuito
- 📺 [Awesome Embedded](https://github.com/nhivp/Awesome-Embedded) - Recursos para sistemas embarcados

### Comunidade
- 🌐 [Repositórios da Serra Rocketry](https://github.com/orgs/Serra-Rocketry/repositories)
- 💬 Entre em contato com a equipe para acesso aos canais de comunicação

---

**Mantido por**: Equipe Serra Rocketry - IPRJ/UERJ

**Licença**: MIT - Use, modifique e compartilhe livremente!
