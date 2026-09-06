#!/usr/bin/env bash
# cad-run.sh — wrapper do toolchain CAD da Serra Rocketry (container).
#
# Monta a pasta atual em /work e roda com o seu uid/gid, para os arquivos
# gerados serem seus (não do root).
#
# Uso:
#   ./cad-run.sh render peca.scad            → preview PNG (peca.png)
#   ./cad-run.sh stl peca.scad               → exporta STL (peca.stl)
#   ./cad-run.sh python script.py [args...]  → Python (cadquery/trimesh)
#   ./cad-run.sh gmsh arquivo.geo            → gmsh CLI
#   ./cad-run.sh ccx jobname                 → CalculiX (FEA)
#   ./cad-run.sh shell                        → bash interativo no container
#
# Variáveis:
#   CAD_IMAGE   imagem a usar (padrão: serra/cad-toolchain:latest)
#   CAD_UID_GID uid:gid override (padrão: $(id -u):$(id -g))

set -euo pipefail

IMAGE="${CAD_IMAGE:-serra/cad-toolchain:latest}"
UID_GID="${CAD_UID_GID:-$(id -u):$(id -g)}"

cmd="${1:-help}"
shift || true

docker_run() {
    docker run --rm -v "$PWD":/work -w /work -u "$UID_GID" "$IMAGE" "$@"
}

case "$cmd" in
    render)
        [ $# -ge 1 ] || { echo "uso: $0 render arquivo.scad"; exit 1; }
        f="$1"; out="${f%.scad}.png"
        docker_run openscad -o "$out" --viewall --autocenter --imgsize=1200,900 "$f"
        echo "→ $out"
        ;;
    stl)
        [ $# -ge 1 ] || { echo "uso: $0 stl arquivo.scad"; exit 1; }
        f="$1"; out="${f%.scad}.stl"
        docker_run openscad -o "$out" "$f"
        echo "→ $out"
        ;;
    python)
        docker_run python3 "$@"
        ;;
    gmsh)
        docker_run gmsh "$@"
        ;;
    ccx)
        docker_run ccx "$@"
        ;;
    shell)
        docker_run bash
        ;;
    *)
        echo "uso: $0 {render|stl|python|gmsh|ccx|shell} [args...]"
        exit 1
        ;;
esac
