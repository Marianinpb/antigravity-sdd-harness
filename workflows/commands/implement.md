# Command: /implement

> **Phase:** 3 — Implementation (TDD)
> **Purpose:** Execute the approved plan task by task using RED-GREEN-REFACTOR.

---

## Trigger

User invokes `/implement` after plan approval.

## Pre-Conditions

1. Plan (`plans/{PLAN-ID}-{name}.md`) MUST be approved.
2. Task breakdown (`tasks/{PLAN-ID}-tasks.md`) MUST exist.
3. Harness MUST be activated.

## Execution Steps (Per Task)

### Step 1: Select Next Task
Select highest-priority `[ ]` task with all `_Depends_` resolved (`[x]`). Mark as `[/]`.

### Step 2: Write Test (RED 🔴)
Write tests before implementation. Run them. Verify they FAIL.

| Language | Framework | Location |
|----------|-----------|----------|
| Python | pytest | `tests/` |
| C | Unity/custom | `test/` |
| VHDL | GHDL testbench | `testbench/` |
| Verilog | Testbench | `testbench/` |

> For LaTeX, MATLAB, Mathematica: define verification criteria instead.

### Step 3: Implement (GREEN 🟢)
Write **minimum code** to pass tests. Follow coding-standards and security-rules. Stay within `_Boundary_`.

### Step 4: Refactor (BLUE 🔵) — Optional
Improve code without changing behavior. Re-run ALL tests.

### Step 5: Self-Review
- [ ] Follows coding-standards.md
- [ ] Respects security-rules.md
- [ ] Stays within `_Boundary_`
- [ ] No dead code or debug statements
- [ ] Functions documented

### Step 6: Quality Gates (`/review`)
Trigger review command.

### Step 7: Record and Update
1. Update task to `[x]`
2. Update progress summary
3. Add implementation notes to plan
4. Log decisions in decision-log.md

### Step 8: Repeat or Finish
Continue until all tasks are `[x]`.

## Error Handling

| Scenario | Action |
|----------|--------|
| No approved plan | Direct to `/plan` first |
| Test won't fail in RED | Rewrite more specific test |
| Breaks other tests | Fix within boundary or flag to human |
| Quality gate fails 2x | Pause, request human guidance |
| Scope creep | Flag to human, do NOT implement |
