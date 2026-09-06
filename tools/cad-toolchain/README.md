# Serra Rocketry CAD Toolchain

Ambiente containerizado para design mecânico e impressão 3D da equipe: geração de peças com LLM, OpenSCAD, análise de interferência e FEA — tudo reproduzível em qualquer máquina.

**Quando usar:** projetando peça, carcaça ou mecanismo (ver [Boas Práticas de Design Mecânico e Impressão 3D](../../hardware/boas-praticas-design-mecanico.md))

---

## 🧰 O que tem na imagem

| Ferramenta | Uso |
|---|---|
| **OpenSCAD** | Compila `.scad` → STL/PNG headless (o código é o modelo) |
| **CadQuery** (Python) | STEP/B-Rep: ler/escrever STEP, reverse engineering de peça |
| **trimesh** (Python) | Checagem de interferência e distância entre malhas (STL) |
| **gmsh** | Remesh de STL (pré-processamento p/ FEA) |
| **CalculiX (ccx)** | Solver de elementos finitos |
| Python 3 + numpy | Scripts do fluxo |

**O LLM fica de fora do container** — a geração acontece via API (ex.: DeepSeek), e o container só valida/fabrica a geometria. Nenhuma chave de API entra na imagem.

---

## 🏗️ Build

```bash
docker build -t serra/cad-toolchain .
```

> No Oráculo (TrueNAS), rodar com `sudo docker build -t serra/cad-toolchain .`

---

## 🚀 Uso rápido

O wrapper `cad-run.sh` monta a pasta atual em `/work` e roda com o seu uid (os arquivos gerados são seus, não do root):

```bash
# Preview PNG de um .scad
./cad-run.sh render peca.scad              # → peca.png

# Exportar STL
./cad-run.sh stl peca.scad                 # → peca.stl

# Script Python (cadquery/trimesh)
./cad-run.sh python checar_encaixe.py a.stl b.stl

# Remesh p/ FEA e solver
./cad-run.sh gmsh peca.geo
./cad-run.sh ccx jobname
```

Sem o wrapper, o comando docker equivalente:

```bash
docker run --rm -v "$PWD":/work -w /work -u "$(id -u):$(id -g)" \
  serra/cad-toolchain openscad -o peca.stl peca.scad
```

---

## 🤖 Loop com LLM (resumo)

1. LLM gera `.scad` a partir da spec (dimensões como variáveis no topo, com unidades)
2. `./cad-run.sh stl peca.scad` — erro de compilação volta com número da linha, LLM se corrige
3. `./cad-run.sh render peca.scad` — inspeção visual
4. Checagem automática: muda uma variável e re-renderiza — geometria tem que seguir
5. Interferência entre peças: trimesh (`intersection` vazio = não encosta)

Detalhes do fluxo e validação: [Boas Práticas de Design Mecânico e Impressão 3D](../../hardware/boas-praticas-design-mecanico.md)

---

## 📐 FEA

Pipeline livre e headless: `STL → gmsh (remesh) → ccx → ParaView`

- STL facetado do OpenSCAD **não vai direto ao solver** — precisa remesh no gmsh
- Hand-calc primeiro, FEA quando a geometria complica; **teste de campo é a verdade final**
- Pós-processamento pesado (ParaView) roda fora do container

---

## ⚠️ Notas

- Versionar o `.scad` (código), nunca só o STL — STL é artefato de build
- No Oráculo, o workspace fica numa pasta do pool (ex.: `/mnt/<pool>/cad-workspace`) montada em `/work`; rodar com `-u 950:950` (truenas_admin) se necessário
- Versões pip ainda não pinadas — pinar quando o ambiente estabilizar

---

## 🔄 Atualizações

Encontrou algo que falta?
1. Edite o Dockerfile/README
2. Commit explicando o motivo (`feat:`, `fix:`)
3. Rebuild da imagem: `docker build -t serra/cad-toolchain .`

---

**Mantido por:** Equipe Serra Rocketry - IPRJ/UERJ
