# Desglose de Tareas: Reporte — [Título del Reporte]

> **Plan de referencia:** [Enlace al plan aprobado: plans/PLAN-XX-reporte.md]
> **Fecha:** [YYYY-MM-DD]
> **Total de tareas:** 7 (6 si no se requieren diagramas)

---

## Leyenda de estado

- `[ ]` — No iniciada
- `[/]` — En progreso
- `[x]` — Completada
- `[!]` — Bloqueada

---

> [!IMPORTANT]
> **REGLA CRÍTICA ANTES DE COMENZAR:** El agente DEBE completar TASK-01 (solicitar datos del autor) antes de proceder con cualquier otra tarea. Los datos (título, autor, institución, etc.) NUNCA se infieren de la fuente de información.

---

## Fase A: Recolección de datos del autor

- `[ ]` **TASK-01:** Solicitar datos del autor al usuario
  - **_Boundary_:** Interacción con el usuario.
  - **_Depends_:** None
  - **Descripción:** Solicitar al usuario nombre, institución, título del reporte, email, fecha e idioma.
  - **Criterios de aceptación:**
    - [ ] El agente recopiló todos los campos.
    - [ ] No usó datos inferidos de la fuente.

---

## Fase B: Análisis de fuentes

- `[ ]` **TASK-02:** Leer y analizar las fuentes de contenido
  - **_Boundary_:** Solo lectura.
  - **_Depends_:** TASK-01
  - **Descripción:** Procesar todas las fuentes en `reporte.sources` (ej. clonar repositorios si necesario, leer PDFs).
  - **Criterios de aceptación:**
    - [ ] Extrajo conceptos clave de las fuentes.

- `[ ]` **TASK-03:** Consolidar conocimiento
  - **_Boundary_:** Memoria de trabajo.
  - **_Depends_:** TASK-02
  - **Descripción:** Generar el esquema estructurado del reporte (resumen, introducción, desarrollo, conclusiones) basado en las fuentes.
  - **Criterios de aceptación:**
    - [ ] El agente tiene un esquema claro del contenido.

---

## Fase C: Generación del documento LaTeX

- `[ ]` **TASK-04:** Copiar plantilla LaTeX al directorio del proyecto
  - **_Boundary_:** Copiar archivos de `command_assets/reporte/templates/[template_name]/` a `reporte/`.
  - **_Depends_:** TASK-01
  - **Descripción:** Copiar `reporte.tex` y los logos/archivos correspondientes a la plantilla elegida (`ieee` o `ciep`).
  - **Criterios de aceptación:**
    - [ ] Los archivos existen en `reporte/`.

- `[ ]` **TASK-05:** Reemplazar placeholders, redactar contenido y definir diagramas
  - **_Boundary_:** Modifica `reporte/reporte.tex`. Si se requieren diagramas, crea `reporte/diagramas/`.
  - **_Depends_:** TASK-03, TASK-04
  - **Descripción:**
    1. Reemplaza `{{TITULO}}`, `{{AUTOR}}`, etc. con datos reales.
    2. Redacta el texto del reporte en el bloque `{{CONTENIDO_SECCIONES}}`.
    3. Si el reporte requiere diagramas:
       - Agrega `\usepackage{svg}` al preámbulo.
       - Define los diagramas en `reporte/diagramas/*.mmd` (sintaxis Mermaid).
       - Referencia en LaTeX: `\includesvg[width=0.9\linewidth]{reporte/diagramas/<nombre>}`.
       - NO usar `\begin{tikzpicture}` para generar diagramas.
    4. Verifica que no hay `{{` sin reemplazar.
  - **Criterios de aceptación:**
    - [ ] No hay `{{` en `reporte.tex`.
    - [ ] El texto del reporte refleja las fuentes provistas.
    - [ ] No hay `\begin{tikzpicture}` en el `.tex`.
    - [ ] Si hay diagramas, `\usepackage{svg}` está presente en el preámbulo.

## Fase D: Generación de diagramas Mermaid (si aplica)

- `[ ]` **TASK-06:** Renderizar diagramas Mermaid a SVG
  - **_Boundary_:** Crea/modifica archivos en `reporte/diagramas/`.
  - **_Depends_:** TASK-05
  - **Descripción:**
    1. Verificar `mmdc --version`. Si no instalado, ofrecer instalación.
    2. Para cada `.mmd` definido en TASK-05:
       ```bash
       mmdc -i reporte/diagramas/<archivo>.mmd -o reporte/diagramas/<archivo>.svg -b transparent
       ```
    3. Verificar que cada SVG se generó sin errores.
    4. Si un diagrama falla, corregir sintaxis y reintentar.
  - **Criterios de aceptación:**
    - [ ] Todos los `.mmd` renderizan sin errores.
    - [ ] Todos los `.svg` existen y tienen fondo transparente.
  - **Nota:** Omitir esta tarea si el usuario indicó que no se requieren diagramas.

- `[ ]` **TASK-07:** Compilar el documento a PDF (condicional)
  - **_Boundary_:** Genera `reporte/reporte.pdf`.
  - **_Depends_:** TASK-05, TASK-06 (si aplica)
  - **Descripción:** Verifica si `pdflatex` está instalado. Compila el documento o da instrucciones al usuario de cómo hacerlo.
  - **Criterios de aceptación:**
    - [ ] Si `pdflatex` está disponible, se genera un `.pdf` sin errores catastróficos.
