# Command Assets: `/report`

> **Comando:** `/report`
> **Versión:** 2.0.0
> **Parte del:** Harness SDD Antigravity

---

## ¿Qué es este módulo?

El módulo `reporte` contiene las plantillas y assets para el comando `/report`
del harness SDD Antigravity. Este comando genera reportes académicos o técnicos
en LaTeX a partir de fuentes de información, con diagramas Mermaid.

Entregables generados:
1. **Reporte LaTeX** — Documento estructurado con plantilla IEEE o CIEP.
2. **PDF del reporte** — Compilado desde LaTeX (si hay compilador disponible).
3. **Diagramas Mermaid** — Diagramas en SVG con fondo transparente.

---

## Cómo usar el comando

### Desde cualquier proyecto con el harness activado:

```
/report
```

El agente te pedirá los datos del autor y las fuentes, y generará todo.

### Configuración previa opcional en `harness-config.yaml`:

```yaml
reporte:
  sources:
    - type: "repo"
      url: "https://github.com/usuario/repo"
    - type: "book"
      reference: "Nombre del libro"
    - type: "paper"
      path: "ruta/al/documento.pdf"

  title: ""
  title_short: ""
  author: ""
  author_short: ""
  institution: ""
  correspondence: ""
  date: ""
  language: "es"
  template_name: "ieee"
```

---

## Reglas críticas

> [!IMPORTANT]
> ### Regla 1: Los datos del autor SIEMPRE se preguntan
>
> El agente NUNCA debe inferir el nombre del autor, la institución, ni el título
> del reporte a partir de las fuentes.

> [!IMPORTANT]
> ### Regla 2: El idioma de los entregables es español por defecto

> [!CAUTION]
> ### Regla 3: Todos los diagramas en Mermaid
>
> Prohibido usar `tikzpicture` para dibujar diagramas. Usar Mermaid → SVG
> con `-b transparent`. Ver `rules/diagram-standards.md`.

---

## Entregables generados

| Entregable | Ruta |
|------------|------|
| Especificación | `specs/SPEC-XX-reporte.md` |
| Plan | `plans/PLAN-XX-reporte.md` |
| Tareas | `tasks/TASKS-XX-reporte.md` |
| Documento LaTeX | `reporte/reporte.tex` |
| PDF del Reporte | `reporte/reporte.pdf` |
| Diagramas Mermaid | `reporte/diagramas/*.mmd` + `*.svg` |

---

## Registro de cambios

| Versión | Fecha | Cambio |
|---------|-------|--------|
| 2.0.0 | 2026-06-06 | Migrado de tipo de proyecto a comando `/report`. Agregado soporte para diagramas Mermaid. |
| 1.0.0 | 2026-05-23 | Primera versión del módulo |
