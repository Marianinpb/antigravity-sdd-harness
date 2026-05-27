# Desglose de Tareas: Reporte — [Título del Reporte]

> **Plan de referencia:** [Enlace al plan aprobado: plans/PLAN-XX-reporte.md]
> **Fecha:** [YYYY-MM-DD]
> **Total de tareas:** 6

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
  - **_Boundary_:** Copiar archivos de `project_types/reporte/templates/[template_name]/` a `reporte/`.
  - **_Depends_:** TASK-01
  - **Descripción:** Copiar `reporte.tex` y los logos/archivos correspondientes a la plantilla elegida (`ieee` o `ciep`).
  - **Criterios de aceptación:**
    - [ ] Los archivos existen en `reporte/`.

- `[ ]` **TASK-05:** Reemplazar placeholders y redactar contenido
  - **_Boundary_:** Modifica `reporte/reporte.tex`.
  - **_Depends_:** TASK-03, TASK-04
  - **Descripción:** Reemplaza `{{TITULO}}`, `{{AUTOR}}`, etc. con datos reales y redacta el texto del reporte en el bloque `{{CONTENIDO_SECCIONES}}`.
  - **Criterios de aceptación:**
    - [ ] No hay `{{` en `reporte.tex`.
    - [ ] El texto del reporte refleja las fuentes provistas.

- `[ ]` **TASK-06:** Compilar el documento a PDF (condicional)
  - **_Boundary_:** Genera `reporte/reporte.pdf`.
  - **_Depends_:** TASK-05
  - **Descripción:** Verifica si `pdflatex` está instalado. Compila el documento o da instrucciones al usuario de cómo hacerlo.
  - **Criterios de aceptación:**
    - [ ] Si `pdflatex` está disponible, se genera un `.pdf` sin errores catastróficos.
