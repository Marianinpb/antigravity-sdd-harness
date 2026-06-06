# Plan de Implementación: [PLAN-ID] Reporte — [Título del Reporte]

> **Estado:** Borrador | En Revisión | Aprobado
> **Especificación:** [Enlace a la spec aprobada: specs/SPEC-XX-reporte.md]
> **Comando:** `/report`
> **Autor:** [Nombre del autor — dato proporcionado explícitamente por el usuario]
> **Fecha:** [YYYY-MM-DD]
> **Aprobado por:** [Nombre] el [YYYY-MM-DD]

---

## 1. Resumen

Este plan describe cómo se generarán los entregables del reporte académico o técnico a partir de las fuentes de contenido especificadas. El proceso usa el comando `/report` con plantillas y tareas predefinidas.

**Enfoque técnico:**
El agente analiza las fuentes de contenido con sus capacidades LLM, consolida la información y la estructura en un documento LaTeX (formato IEEE).

**Datos del autor (obtenidos explícitamente del usuario):**

| Campo | Valor |
|-------|-------|
| Nombre del autor | [Valor confirmado por el usuario] |
| Autor (Corto) | [Valor confirmado por el usuario] |
| Institución | [Valor confirmado por el usuario] |
| Título del reporte | [Valor confirmado por el usuario] |
| Título (Corto) | [Valor confirmado por el usuario] |
| Correspondencia | [Valor confirmado por el usuario] |
| Fecha | [Valor confirmado por el usuario] |
| Idioma | Español (por defecto) |

---

## 2. Arquitectura de los Entregables

```
proyecto/
├── specs/
│   └── SPEC-XX-reporte.md          (generado en /specify)
├── plans/
│   └── PLAN-XX-reporte.md          (este archivo)
├── tasks/
│   └── TASKS-XX-reporte.md         (generado en /plan)
└── reporte/
    ├── reporte.tex                 (generado en TASK-05)
    ├── reporte.pdf                 (generado en TASK-06, si compilador disponible)
    └── [archivos de la plantilla seleccionada] (copiados en TASK-04)
```

---

## 3. Tecnologías y Herramientas

| Componente | Tecnología | Justificación |
|------------|-----------|---------------|
| Documento | LaTeX (IEEEoj / CIEP) | Plantilla formal estructurada |
| Compilación | pdflatex | Estándar para compilar LaTeX |
| Diagramas | Mermaid → SVG | Diagramas vectoriales con fondo transparente |
| Análisis de fuente | Capacidades LLM del agente | Consolidar conocimiento de múltiples fuentes |

---

## 4. Desglose de Tareas

_Cada tarea incluye `_Boundary_` y `_Depends_`. Ver `tasks/TASKS-XX-reporte.md`._

### Fase A: Recolección de datos del autor

#### Tarea 1: Solicitar datos al autor
- **ID:** TASK-01
- **_Boundary_:** Solo interacción con el usuario para recopilar metadatos. No modifica archivos.
- **_Depends_:** None
- **Descripción:** El agente solicita EXPLÍCITAMENTE al usuario cada campo necesario. NUNCA infiere estos datos.
- **Complejidad:** Baja

---

### Fase B: Análisis de fuentes

#### Tarea 2: Leer y analizar las fuentes
- **ID:** TASK-02
- **_Boundary_:** Lectura de fuentes en `harness-config.yaml`.
- **_Depends_:** TASK-01
- **Descripción:** El agente lee o analiza todas las fuentes proporcionadas (repositorios, papers, libros) para extraer información, metodologías y conclusiones.
- **Complejidad:** Media

#### Tarea 3: Consolidar conocimiento
- **ID:** TASK-03
- **_Boundary_:** Genera un esquema o resumen consolidado (memoria de trabajo).
- **_Depends_:** TASK-02
- **Descripción:** Estructura la información extraída de las fuentes en un formato lógico para el reporte.
- **Complejidad:** Media

---

### Fase C: Generación del documento LaTeX

#### Tarea 4: Copiar plantilla LaTeX al directorio del proyecto
- **ID:** TASK-04
- **_Boundary_:** Solo copia archivos de `command_assets/reporte/templates/[template_name]/` a `reporte/`.
- **_Depends_:** TASK-01
- **Descripción:** Copiar condicionalmente `reporte.tex` y los logos/archivos de la plantilla configurada (`ieee` o `ciep`).
- **Complejidad:** Baja

#### Tarea 5: Reemplazar placeholders y redactar contenido
- **ID:** TASK-05
- **_Boundary_:** Modifica `reporte/reporte.tex`. Si se requieren diagramas, crear `reporte/diagramas/`.
- **_Depends_:** TASK-03, TASK-04
- **Descripción:** Inyecta los metadatos del usuario y desarrolla el contenido técnico del reporte estructurando el texto consolidado en las secciones de LaTeX. Si el reporte requiere diagramas:
  1. Agregar `\usepackage{svg}` al preámbulo de `reporte.tex`.
  2. Definir los diagramas en `reporte/diagramas/*.mmd` usando sintaxis Mermaid.
  3. Referenciar en LaTeX usando `\includesvg[width=0.9\linewidth]{reporte/diagramas/<nombre>}`.
  4. NO usar `\begin{tikzpicture}` ni otros entornos de dibujo LaTeX.
  Seguir `rules/diagram-standards.md` estrictamente.
- **Complejidad:** Alta

#### Tarea 6: Generar diagramas Mermaid y renderizar a SVG (si aplica)
- **ID:** TASK-06
- **_Boundary_:** Crea y modifica archivos en `reporte/diagramas/`.
- **_Depends_:** TASK-05
- **Descripción:** Para cada diagrama definido en TASK-05:
  1. Verificar que `mmdc` está instalado (`mmdc --version`). Si no, ofrecer instalación: `npm install -g @mermaid-js/mermaid-cli`.
  2. Renderizar cada `.mmd` a SVG:
     ```bash
     mmdc -i reporte/diagramas/<archivo>.mmd -o reporte/diagramas/<archivo>.svg -b transparent
     ```
  3. Verificar que el SVG se generó correctamente y tiene fondo transparente.
  4. Si un diagrama falla al renderizar, corregir la sintaxis y reintentar.
- **Complejidad:** Media
- **Nota:** Si el usuario indicó que NO se requieren diagramas, esta tarea se omite.

#### Tarea 7: Compilar el documento a PDF
- **ID:** TASK-07
- **_Boundary_:** Solo genera `reporte/reporte.pdf`.
- **_Depends_:** TASK-05, TASK-06 (si aplica)
- **Descripción:** Verifica `pdflatex` e intenta compilar, informando al usuario en caso de falta de compilador.
- **Complejidad:** Media

---

## 5. Dependencias Externas

| Dependencia | Propósito | ¿Nueva? |
|-------------|-----------|---------|
| pdflatex / latexmk | Compilación LaTeX | Solo si no instalado |
| mmdc (Mermaid CLI) | Renderizado de diagramas a SVG | Solo si se requieren diagramas |

---

## 6. Verificación

### Verificación automática
- `[ ]` Todos los archivos de la plantilla LaTeX existen en `reporte/`.
- `[ ]` `reporte.tex` no contiene la cadena `{{`.
- `[ ]` `reporte.tex` no contiene `\begin{tikzpicture}`.
- `[ ]` Si se requieren diagramas: `reporte/diagramas/` existe con `.mmd` + `.svg`.
- `[ ]` Si se requieren diagramas: todos los `.mmd` renderizan sin errores.
- `[ ]` Si se compiló: `reporte.pdf` existe y es válido.

### Verificación manual
- `[ ]` Revisar que los metadatos del reporte son correctos (autor, título, etc.).
- `[ ]` Revisar que el contenido es coherente con las fuentes proporcionadas.
- `[ ]` Revisar que los diagramas SVG se ven correctamente y tienen fondo transparente.
