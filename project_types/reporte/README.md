# Módulo de Tipo de Proyecto: Reporte

> **Tipo:** `reporte`
> **Versión:** 1.0.0
> **Parte del:** Harness SDD Antigravity

---

## ¿Qué es este módulo?

El módulo `reporte` extiende el harness SDD Antigravity para soportar la generación automática de reportes académicos o técnicos en LaTeX. Dado un conjunto de fuentes de información (repositorios, libros, artículos, etc.), el agente estructura, redacta y compila un reporte formal.

1. **Especificación** — Recolección de datos del autor y de las fuentes.
2. **Reporte LaTeX** — Documento estructurado con plantilla IEEE.

---

## Cómo activar el módulo

### 1. Configurar `harness-config.yaml`

Establece el tipo de proyecto y la sección de reporte:

```yaml
project:
  name: "Mi Reporte de Investigación"
  type: "reporte"
  description: "Reporte estructurado sobre un tema técnico"

reporte:
  # Fuentes de contenido (puedes combinar o usar varias):
  sources:
    - type: "repo"
      url: "https://github.com/usuario/repo"
    - type: "book"
      reference: "Nombre del libro o teoría base"
    - type: "paper"
      path: "ruta/al/documento.pdf"

  # Datos del autor (el agente los preguntará explícitamente):
  title: ""
  title_short: ""
  author: ""
  author_short: ""
  institution: ""
  correspondence: ""
  date: ""
  language: "es"                       # "es" por defecto
  template_name: "ieee"                # "ieee" o "ciep"
```

### 2. Iniciar el flujo SDD

Ejecuta los comandos en orden:

```
/specify  — El agente solicita datos del reporte y genera la especificación
/plan     — El agente diseña el plan con las fases predefinidas
/implement — El agente ejecuta las tareas y genera los entregables
```

---

## Reglas críticas del módulo

> [!IMPORTANT]
> ### Regla 1: Los datos del autor SIEMPRE se preguntan
>
> El agente NUNCA debe inferir el nombre del autor, la institución, ni el título del reporte a partir de las fuentes.
> El agente DEBE preguntar explícitamente CADA campo al usuario.

> [!IMPORTANT]
> ### Regla 2: El idioma de los entregables es español por defecto
>
> Aunque la fuente esté en otro idioma, el reporte se genera en ESPAÑOL a menos que el usuario confirme explícitamente un cambio.

---

## Entregables generados

| Entregable | Ruta | Generado en |
|------------|------|-------------|
| Especificación | `specs/SPEC-XX-reporte.md` | `/specify` |
| Plan | `plans/PLAN-XX-reporte.md` | `/plan` |
| Tareas | `tasks/TASKS-XX-reporte.md` | `/plan` |
| Documento LaTeX | `reporte/reporte.tex` | `/implement` |
| PDF del Reporte | `reporte/reporte.pdf` | `/implement` (si compilador disponible) |

---

## Compilación LaTeX

**Instrucciones de compilación manual:**
```bash
cd reporte
pdflatex reporte.tex
pdflatex reporte.tex
```
