# Command: /exposition

> **Purpose:** Generate academic presentation deliverables (summary, LaTeX slides, script) from a content source.
> **Scope:** Self-contained — does not follow the main SDD lifecycle. Generates spec/plan/tasks as traceability artifacts.

---

## Trigger

The user invokes `/exposition` from any project. The agent generates all deliverables within the current project directory.

Examples:
- `/exposition` — starts the exposition generation workflow

---

## Pre-Conditions

1. The harness MUST be activated.
2. `harness-config.yaml` MAY contain pre-configured `exposition:` section (optional, overrides are asked interactively).

---

## Execution Steps

### Step 1: Gather Expositor Metadata

The agent solicits the following data EXPLICITLY from the user. These values MUST NOT be inferred from any source:

| Field | Required | Example |
|-------|----------|---------|
| Full name of expositor | Yes | "Mariano Prado Berman" |
| Institution | Yes | "IICO, UASLP" |
| Presentation title | Yes | "Filtros Adaptativos: Teoría y Aplicaciones" |
| Subtitle | No | "Filtros de Wiener y LMS" |
| Presentation date | Yes | "2026-06-15" |
| Target audience | Yes | "Maestría en Ciencias" |
| Estimated duration | Yes | "20 min" |
| Language | Yes | "es" (default, change only with explicit confirmation) |

If `harness-config.yaml` → `exposition` has fields pre-filled, present them to the user for confirmation instead of re-asking.

### Step 2: Identify Content Source

The agent identifies which source type is active (ONE of the following):

| Source | Config Field | Agent Action |
|--------|-------------|--------------|
| Paper (PDF) | `exposition.paper_path` | Read PDF with LLM capabilities. Extract title, authors, abstract, key concepts. If extraction fails, ask user. |
| Topic + Book | `exposition.topic` + `exposition.book_reference` | Use topic and book reference as thematic base. |
| Repository | `exposition.repo_url` | Read README and docs via HTTP. Only clone if assets require it. |

If none is configured in YAML, ask the user which type and for the specific values.

> **RULE:** The content source's author, title, and institution are NOT the expositor's. The agent MUST keep these separate.

### Step 3: Generate Specification

Using `command_assets/exposition/spec_template.md`, create `specs/SPEC-XX-exposicion.md`.

Fill all sections including:
- Expositor data (from Step 1)
- Source description (from Step 2)
- Functional requirements for the generation process

Present for human approval before proceeding.

### Step 4: Generate Plan and Task Breakdown

Using `command_assets/exposition/plan_template.md` and `command_assets/exposition/tasks_template.md`:

- **Plan:** `plans/PLAN-XX-exposicion.md` — Adapt the predefined phases to the source type
- **Tasks:** `tasks/TASKS-XX-exposicion.md` — All 7 tasks predefined

Present for human approval before proceeding.

### Step 5: Execute TASKS

Execute each task in order. Tasks are defined in the tasks template:

| Task | Phase | Description | Mermaid? |
|------|-------|-------------|----------|
| TASK-01 | A | Solicit expositor data (already done, confirm) | No |
| TASK-02 | B | Read and analyze content source | No |
| TASK-03 | B | Generate summary (`resumen_{fuente}.md`) | No |
| TASK-04 | C | Copy LaTeX template assets to `presentacion/` | No |
| TASK-05 | C | Replace placeholders and generate slide content in `presentacion.tex` | Yes — if diagrams are needed |
| TASK-06 | C | Compile `presentacion.pdf` (conditional on pdflatex) | No |
| TASK-07 | D | Generate `guion_exposicion.md` aligned with slides | No |

> **Mermaid diagrams in `presentacion.tex`:** If the presentation requires diagrams (architecture, flowcharts, etc.), the agent MUST:
> 1. Define them in `presentacion/diagramas/*.mmd`
> 2. Render to SVG: `mmdc -i presentacion/diagramas/<file>.mmd -o presentacion/diagramas/<file>.svg -b transparent`
> 3. Include in LaTeX: `\includesvg[width=0.8\linewidth]{presentacion/diagramas/<file>}`
> 4. Add `\usepackage{svg}` to the preamble if diagrams are used
> 5. Follow `rules/diagram-standards.md` for all diagram-related decisions

### Step 6: Quality Gates

Run `rules/diagram-standards.md` checks if diagrams were generated:

- [ ] All `.mmd` files render to SVG without errors
- [ ] No `{{` placeholders remain in `.tex` files
- [ ] All referenced SVGs exist in `presentacion/diagramas/`
- [ ] Metadatos (title, author, institution) are the user-provided values, not source-inferred

---

## Post-Conditions

- [ ] `specs/SPEC-XX-exposicion.md` exists and is approved
- [ ] `plans/PLAN-XX-exposicion.md` exists and is approved
- [ ] `tasks/TASKS-XX-exposicion.md` exists
- [ ] `resumen_{fuente}.md` exists
- [ ] `presentacion/presentacion.tex` exists (no `{{` placeholders)
- [ ] `presentacion/presentacion.pdf` exists OR user was informed about manual compilation
- [ ] `guion_exposicion.md` exists with narration per slide
- [ ] `presentacion/diagramas/` exists with `.mmd` + `.svg` files (if diagrams were needed)

---

## Output Structure

```
proyecto/
├── specs/SPEC-XX-exposicion.md
├── plans/PLAN-XX-exposicion.md
├── tasks/TASKS-XX-exposicion.md
├── resumen_{fuente}.md
├── guion_exposicion.md
└── presentacion/
    ├── presentacion.tex
    ├── presentacion.pdf       (conditional)
    ├── beamercolorthemeaggie.sty
    ├── presentacion.bib
    ├── IICO-LOGO-AZUL.png
    ├── UASLP-LOGO-AZUL.png
    └── diagramas/             (if diagrams were needed)
        ├── diagrama_01.mmd
        └── diagrama_01.svg
```

---

## Error Handling

| Scenario | Action |
|----------|--------|
| No source configured | Ask user for source type and values |
| Cannot read PDF | Ask user to provide key points manually |
| Compiler not available | Generate `.tex` only, provide manual instructions |
| `mmdc` not installed | Inform user, suggest `npm install -g @mermaid-js/mermaid-cli` |
| Placeholders remain | Block completion, fix before continuing |
