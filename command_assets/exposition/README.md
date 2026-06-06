# Command Assets: `/exposition`

> **Comando:** `/exposition`
> **Versión:** 2.0.0
> **Parte del:** Harness SDD Antigravity

---

## ¿Qué es este módulo?

El módulo `exposition` contiene las plantillas y assets para el comando
`/exposition` del harness SDD Antigravity. Este comando genera presentaciones
académicas a partir de una fuente de contenido (paper, tema+libro, repositorio).

Entregables generados:
1. **Resumen** — Síntesis estructurada del contenido de la fuente.
2. **Presentación LaTeX** — Diapositivas en formato beamer con plantilla institucional.
3. **Guion de exposición** — Narración sugerida alineada con cada diapositiva.
4. **Diagramas Mermaid** — Diagramas en SVG con fondo transparente (opcional).

---

## Cómo usar el comando

### Desde cualquier proyecto con el harness activado:

```
/exposition
```

El agente te pedirá los datos del expositor y la fuente de contenido, y generará
todo automáticamente.

### Configuración previa opcional en `harness-config.yaml`:

```yaml
exposition:
  paper_path: "docs/paper.pdf"        # Opción 1: ruta a un PDF
  topic: ""                            # Opción 2: tema libre
  book_reference: ""                   # Opción 2: libro de referencia (con topic)
  repo_url: ""                         # Opción 3: repositorio

  title: ""
  subtitle: ""
  author: ""
  institution: ""
  date: ""
  estimated_duration: ""
  audience: ""
  language: "es"
```

Si los campos están vacíos, el agente los pregunta interactivamente.

---

## Reglas críticas

> [!IMPORTANT]
> ### Regla 1: Los datos del expositor SIEMPRE se preguntan
>
> El agente NUNCA debe inferir el nombre del expositor, la institución, ni el
> título de la presentación del contenido de la fuente.
>
> El autor del paper ≠ el expositor.
> El título del paper ≠ el título de la exposición.
> La institución de los autores ≠ la institución del expositor.

> [!IMPORTANT]
> ### Regla 2: El idioma de los entregables es español por defecto

> [!CAUTION]
> ### Regla 3: Diagramas en Mermaid, no en LaTeX nativo
>
> Todos los diagramas DEBEN hacerse con Mermaid y convertirse a SVG con fondo
> transparente. Prohibido usar `tikzpicture`, `pgfplots`, etc.

---

## Entregables generados

| Entregable | Ruta |
|------------|------|
| Especificación | `specs/SPEC-XX-exposicion.md` |
| Plan | `plans/PLAN-XX-exposicion.md` |
| Tareas | `tasks/TASKS-XX-exposicion.md` |
| Resumen del contenido | `resumen_{fuente}.md` |
| Presentación LaTeX | `presentacion/presentacion.tex` |
| PDF de la presentación | `presentacion/presentacion.pdf` |
| Guion de exposición | `guion_exposicion.md` |
| Diagramas Mermaid | `presentacion/diagramas/*.mmd` + `*.svg` |

---

## Estructura de archivos del módulo

```
command_assets/exposition/
├── README.md                        # Este archivo
├── spec_template.md                 # Plantilla de especificación
├── plan_template.md                 # Plantilla de plan de implementación
├── tasks_template.md                # Plantilla de desglose de tareas
└── templates/                       # Assets LaTeX
    ├── presentacion.tex             # Plantilla LaTeX con placeholders
    ├── beamercolorthemeaggie.sty    # Tema de colores institucional (UASLP)
    ├── presentacion.bib             # Bibliografía base
    ├── IICO-LOGO-AZUL.png           # Logo del IICO
    └── UASLP-LOGO-AZUL.png         # Logo de la UASLP
```

---

## Registro de cambios

| Versión | Fecha | Cambio |
|---------|-------|--------|
| 2.0.0 | 2026-06-06 | Migrado de tipo de proyecto a comando `/exposition`. Agregado soporte para diagramas Mermaid. |
| 1.0.0 | 2026-05-23 | Primera versión del módulo |
