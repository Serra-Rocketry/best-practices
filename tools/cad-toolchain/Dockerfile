# Serra Rocketry CAD Toolchain
#
# Ambiente reproduzível p/ design mecânico com LLM + OpenSCAD:
# openscad (compile/render), CadQuery (STEP/B-Rep), trimesh (interferência),
# gmsh + CalculiX (FEA). LLM roda FORA do container (API) — sem chaves aqui.
#
# Build:  docker build -t serra/cad-toolchain .
# Uso:    ver README.md (wrapper cad-run.sh)

FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Toolchain CAD/FEA + Python
RUN apt-get update && apt-get install -y --no-install-recommends \
        openscad \
        xvfb \
        xauth \
        gmsh \
        calculix-ccx \
        python3 \
        python3-venv \
        python3-pip \
        git \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# OpenSCAD headless precisa de contexto GL p/ preview PNG → xvfb-run
ENV HOME=/tmp

# CadQuery/trimesh num venv isolado (evita conflito com python do sistema)
RUN python3 -m venv /opt/venv \
    && /opt/venv/bin/pip install --no-cache-dir --upgrade pip \
    && /opt/venv/bin/pip install --no-cache-dir \
        cadquery \
        trimesh \
        numpy

ENV PATH="/opt/venv/bin:${PATH}"

# Verificação de build: falha cedo se faltar binário
RUN openscad --version && gmsh --version && ccx -V

WORKDIR /work
CMD ["/bin/bash"]
