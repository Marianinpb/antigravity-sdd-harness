# Command: /report

> **Purpose:** Generate academic/technical reports in LaTeX (IEEE/CIEP format) from multiple content sources, with Mermaid-based diagrams.
> **Scope:** Self-contained — does not follow the main SDD lifecycle. Generates spec/plan/tasks as traceability artifacts.

---

## Trigger

The user invokes `/report` from any project. The agent generates all deliverables within the current project directory.

Examples:
- `/report` — starts the report generation workflow

---

## Pre-Conditions

1. The harness MUST be activated.
2. `harness-config.yaml` MAY contain pre-configured `reporte:` section (optional, overrides are asked interactively).
3. Mermaid CLI (`mmdc`) SHOULD be installed. If not, the agent offers to install it.

---

## Execution Steps

### Step 1: Gather Author Metadata

The agent solicits the following data EXPLICITLY from the user:

| Field | Required | Example |
|-------|----------|---------|
| Full name | Yes | "Mariano Prado Berman" |
| Short name (header) | Yes | "M. Prado" |
| Institution | Yes | "IICO, Universidad Autónoma de San Luis Potosí" |
| Report title | Yes | "Implementación de Filtros Adaptativos en FPGA" |
| Short title (header) | Yes | "Filtros Adaptativos en FPGA" |
| Correspondence email | Yes | "mariano@example.com" |
| Date | Yes | "2026-06-15" |
| Language | Yes | "es" (default, change only with explicit confirmation) |
| Template | Yes | "ieee" or "ciep" |

If `harness-config.yaml` → `reporte` has fields pre-filled, present them for confirmation instead of re-asking.

### Step 2: Identify Content Sources

The agent reads `harness-config.yaml` → `reporte.sources` if configured. Otherwise, asks the user for sources interactively.

Supported source types:

| Type | Config | Agent Action |
|------|--------|--------------|
| Repository | `type: repo`, `url: ...` | Read README and docs via HTTP. Clone only if necessary. |
| Book | `type: book`, `reference: ...` | Use as bibliographic reference and thematic source. |
| Paper | `type: paper`, `path: ...` | Read PDF with LLM capabilities. |

Multiple sources can be combined. The agent consolidates all information into a coherent report.

### Step 3: Identify Diagram Needs

The agent asks the user: *"Does this report require diagrams (architecture, flowcharts, block diagrams, etc.)?"*

- If **yes**: Proceed with Mermaid diagrams as part of the plan.
- If **no**: Skip diagram generation entirely.

If the user is unsure, the agent suggests common diagrams based on the project type (e.g., block diagram for FPGA projects, flowcharts for algorithm descriptions).

### Step 4: Generate Specification

Using `command_assets/reporte/spec_template.md`, create `specs/SPEC-XX-reporte.md`.

Fill all sections including:
- Author metadata (from Step 1)
- Sources (from Step 2)
- Diagram requirements (from Step 3)
- Functional requirements for generation

Present for human approval before proceeding.

### Step 5: Generate Plan and Task Breakdown

Using `command_assets/reporte/plan_template.md` and `command_assets/reporte/tasks_template.md`:

- **Plan:** `plans/PLAN-XX-reporte.md`
- **Tasks:** `tasks/TASKS-XX-reporte.md`

Tasks are predefined (6 base + 1 if diagrams needed):

| Task | Phase | Description | Mermaid? |
|------|-------|-------------|----------|
| TASK-01 | A | Solicit author metadata (already done, confirm) | No |
| TASK-02 | B | Read and analyze all sources | No |
| TASK-03 | B | Consolidate knowledge into structured outline | No |
| TASK-04 | C | Copy LaTeX template to `reporte/` | No |
| TASK-05 | C | Replace placeholders and redact content in `reporte.tex` | Yes — if diagrams enabled |
| TASK-06 | D | Generate Mermaid diagrams and render to SVG | Yes |
| TASK-07 | C | Compile `reporte.pdf` (conditional) | No |

> **If diagrams are NOT needed:** Skip TASK-06 and remove it from the breakdown.

Present for human approval before proceeding.

### Step 6: Execute TASKS

Execute each task in order following:

#### TASK-05: Content Generation (Diagram Rules)
When redacting content that references diagrams:
1. Add `\usepackage{svg}` to the LaTeX preamble.
2. Reference figures as: `\includesvg[width=0.9\linewidth]{reporte/diagramas/<nombre>}`
3. Each figure MUST have a `\caption{}` and `\label{}`.

#### TASK-06: Mermaid Diagram Generation
For each diagram needed:
1. Define in `reporte/diagramas/<nombre>.mmd` using Mermaid syntax.
2. Render to SVG: `mmdc -i reporte/diagramas/<nombre>.mmd -o reporte/diagramas/<nombre>.svg -b transparent`
3. Verify the output SVG exists and has no rendering errors.
4. Follow `rules/diagram-standards.md` strictly.

### Step 7: Quality Gates

- [ ] `rules/diagram-standards.md` checks passed (if diagrams generated)
- [ ] No `{{` placeholders remain in `reporte.tex`
- [ ] No `\begin{tikzpicture}` in `reporte.tex`
- [ ] All referenced SVGs exist
- [ ] `mmdc` rendered all `.mmd` files without errors
- [ ] Metadatos are user-provided values, not source-inferred

---

## Post-Conditions

- [ ] `specs/SPEC-XX-reporte.md` exists and is approved
- [ ] `plans/PLAN-XX-reporte.md` exists and is approved
- [ ] `tasks/TASKS-XX-reporte.md` exists
- [ ] `reporte/reporte.tex` exists (no `{{` placeholders, no tikzpicture)
- [ ] `reporte/reporte.pdf` exists OR user was informed about manual compilation
- [ ] `reporte/diagramas/` exists with `.mmd` + `.svg` files (if diagrams were needed)

---

## Output Structure

```
proyecto/
├── specs/SPEC-XX-reporte.md
├── plans/PLAN-XX-reporte.md
├── tasks/TASKS-XX-reporte.md
└── reporte/
    ├── reporte.tex
    ├── reporte.pdf              (conditional)
    ├── [template assets]        (logo, .cls, .sty, etc.)
    └── diagramas/               (if diagrams were needed)
        ├── diagrama_01.mmd
        ├── diagrama_01.svg
        ├── diagrama_02.mmd
        └── diagrama_02.svg
```

---

## Error Handling

| Scenario | Action |
|----------|--------|
| No sources configured | Ask user for sources interactively |
| Source URL not accessible | Inform user, ask for alternative or manual content |
| Cannot read PDF | Ask user for key points |
| `mmdc` not installed | Offer to install: `npm install -g @mermaid-js/mermaid-cli`. If refused, skip diagram generation and warn user. |
| Mermaid syntax error | Fix syntax, re-render. If persists, simplify the diagram. |
| Compiler not available | Generate `.tex` only, provide manual instructions |
| Placeholders remain | Block completion, fix before continuing |
