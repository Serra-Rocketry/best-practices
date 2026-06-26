# AGENTS.md

## What this repo is

Documentation-only repository for the Serra Rocketry team (IPRJ/UERJ). Contains best-practices guides in **Portuguese (pt-BR)** for Git/GitHub, project organization, software, and hardware. There is no application code to build, test, or lint.

## Language

All content files are written in Portuguese. When editing or creating markdown files, **write in Portuguese** to match the existing style. Commit messages and PR descriptions follow the team's convention (also Portuguese, using [Conventional Commits](https://www.conventionalcommits.org/pt-br/) prefixes: `feat:`, `fix:`, `docs:`, `refactor:`, `test:`, `chore:`).

## Repo structure

```
README.md                          # Root index (links to all guides)
boas-praticas-git-github.md        # Git/GitHub workflow guide
boas-praticas-organizacao.md       # Project structure templates
init_arduino.sh                    # Scaffolds a new Arduino project directory
software/
  README.md                        # Software guides index
  boas-praticas-software.md        # Software principles (Unix philosophy, OOP, Zen of Python)
  checklist-pre-deploy.md          # Pre-firmware-flash checklist
  watchdog-guia-rapido.md          # Watchdog template for ESP32/Arduino
  zen-python-guia-rapido.md        # Python style quick-reference
  quando-usar-oo.md                # When to use classes vs functions
hardware/
  README.md                        # Hardware guides index
  boas-praticas-hardware.md        # Hardware best practices
  checklist-design.md              # Pre-PCB design review checklist
  checklist-pre-voo.md             # Pre-launch checklist
  kit-campo.md                     # Field kit packing list
```

## Key facts for agents

- **No build system, tests, lint, or CI.** There is nothing to run. Do not invent tooling that doesn't exist.
- **No package manager or dependencies.** The only executable is `init_arduino.sh` (bash, run with `./init_arduino.sh <project-name>`).
- **No `.gitignore` at root.** Each project scaffolded by `init_arduino.sh` gets its own `.gitignore`.
- **Markdown-only edits.** When making changes, you are editing documentation. Preserve the existing emoji-heavy heading style and the `[← Voltar ao índice]` back-link pattern used in sub-pages.
- **Fork + PR workflow.** The team uses forks, not direct pushes. Branch naming: `feature/*`, `fix/*`, `docs/*`.
- **Commit convention.** Prefixes (`feat:`, `fix:`, `docs:`, etc.) per `boas-praticas-git-github.md`.

## Team domains and repo boundaries

The Serra Rocketry team is organized into three domains. Each repository belongs to one domain and tells a short, self-contained story.

### Propulsão (7 repos)
Motor design, static testing, ignition. **Produces raw data** (thrust curves, test logs, geometry specs).

`solid-propulsion` · `liquid-propulsion` · `thrust-stand` · `chamber-heater` · `grinding-mill` · `ignitor` · `ignitor-rf`

### Telemetria e Controle (7 repos)
Flight computers, data analysis, simulations, ground-station software. **Consumes raw data from propulsão and processes it.** This is where software development happens.

`flight-computer` · `analysis` · `flight-simulations` · `satellite` · `recovery-webui` · `old-cdb` · `telemetry-trainee-program`

### Aerodinâmica e Estruturas (2 repos)
Mechanical work: CAD, structural calculations, recovery hardware. Uses existing tools (no software development).

`structure` · `recovery`

### Transversal (3 repos)
Cross-cutting or team-wide repos.

`Lander` · `best-practices` · `lasc-reports`

### Key principles

- **"Contar uma história"** — each repo must be self-explanatory for newcomers. Keep repos specific and lean, not monolithic.
- **Data flow** — who produces raw data documents it; who consumes it processes and documents their analysis. Propulsion owns geometry + static test data; telemetry consumes that raw data for analysis and simulations.
- **Boundary rule** — "onde acaba o trabalho da propulsão e começa o da telemetria": geometry + thrust + test data → propulsão; analysis + simulations + onboard software → telemetria.
- **Software vs mechanical** — if it involves writing code, it's likely Telemetria e Controle. If it's CAD, structural calculations, or using existing tools, it's Aerodinâmica e Estruturas.
- **Test infrastructure vs test data** — repos like `thrust-stand` contain hardware/software for building equipment, NOT the test data itself. Raw test data (static, hydrostatic) lives in `solid-propulsion` or `liquid-propulsion`. Telemetry consumes that raw data for analysis.

## Team members by domain

| Domain | Member | GitHub | Notes |
|--------|--------|--------|-------|
| Propulsão | — | — | |
| Telemetria e Controle | — | — | |
| Aerodinâmica e Estruturas | — | — | |

_Fill in when members create GitHub accounts. Keep this table as the source of truth for issue assignment._

## Issue conventions

Prefix issues with a category tag (used in `solid-propulsion` as the reference pattern):

| Prefix | Meaning | Example |
|--------|---------|---------|
| `[Doc]` | Documentation | `[Doc] Definir fronteira motor vs analysis` |
| `[Data]` | Data contribution, files, datasets | `[Data] Contribuir dados de teste estático definitivos` |
| `[RTC]` | Technical review, compliance, migration | `[RTC] Revisão da migração do Drive para Git` |
| `[Bug]` | Something is broken | `[Bug] Leitura incorreta do sensor BMP388` |
| `[Feat]` | New feature or capability | `[Feat] Adicionar filtro Kalman` |
| _(no prefix)_ | General task | `Esclarecer diferença do Propelente 2` |

Labels: use GitHub default labels (`documentation`, `enhancement`, `bug`, `question`) in addition to title prefixes.

## Creating issues with `gh`

```bash
# Create issue with prefix and assignee
gh issue create --repo Serra-Rocketry/REPO \
  --title "[Doc] Descrição curta" \
  --body "Contexto, critérios de aceite, referências." \
  --assignee github-username \
  --label documentation

# List open issues
gh issue list --repo Serra-Rocketry/REPO

# View issue details
gh issue view NUMBER --repo Serra-Rocketry/REPO

# Close an issue
gh issue close NUMBER --repo Serra-Rocketry/REPO
```

### Golden rules for issue creation

- **Who produces data creates data contribution issues** (e.g., `[Data]` in propulsion repos).
- **Who consumes data creates analysis issues** (e.g., `[Doc]` in telemetry repos).
- **Always confirm with a human before creating issues** — AI drafts the title, body, and assignee; human approves.
- **Keep issues specific and actionable** — one clear deliverable per issue.
- **Reference the issue in commits** — `Closes #123` or `Ref #123`.

## When editing

- Keep guides practical and example-driven (that's the repo's style).
- Don't add English-only content unless asked.
- Don't add build/test/lint tooling suggestions unless the user asks — this repo intentionally has none.
