# Plan de Implementación: [PLAN-ID] Reporte — [Título del Reporte]

> **Estado:** Borrador | En Revisión | Aprobado
> **Especificación:** [Enlace a la spec aprobada: specs/SPEC-XX-reporte.md]
> **Autor:** [Nombre del autor — dato proporcionado explícitamente por el usuario]
> **Fecha:** [YYYY-MM-DD]
> **Aprobado por:** [Nombre] el [YYYY-MM-DD]

---

## 1. Resumen

Este plan describe cómo se generarán los entregables del reporte académico o técnico a partir de las fuentes de contenido especificadas. El proceso sigue el flujo SDD estándar, usando plantillas y tareas predefinidas para el tipo `reporte`.

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
| Documento | LaTeX (IEEEoj) | Plantilla formal estructurada |
| Compilación | pdflatex | Estándar para compilar LaTeX |
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
- **_Boundary_:** Solo copia archivos de `project_types/reporte/templates/[template_name]/` a `reporte/`.
- **_Depends_:** TASK-01
- **Descripción:** Copiar condicionalmente `reporte.tex` y los logos/archivos de la plantilla configurada (`ieee` o `ciep`).
- **Complejidad:** Baja

#### Tarea 5: Reemplazar placeholders y redactar contenido
- **ID:** TASK-05
- **_Boundary_:** Solo modifica `reporte/reporte.tex`.
- **_Depends_:** TASK-03, TASK-04
- **Descripción:** Inyecta los metadatos del usuario y desarrolla el contenido técnico del reporte estructurando el texto consolidado en las secciones de LaTeX.
- **Complejidad:** Alta

#### Tarea 6: Compilar el documento a PDF
- **ID:** TASK-06
- **_Boundary_:** Solo genera `reporte/reporte.pdf`.
- **_Depends_:** TASK-05
- **Descripción:** Verifica `pdflatex` e intenta compilar, informando al usuario en caso de falta de compilador.
- **Complejidad:** Media

---

## 5. Dependencias Externas

| Dependencia | Propósito | ¿Nueva? |
|-------------|-----------|---------|
| pdflatex | Compilación LaTeX | Solo si no instalado |

---

## 6. Verificación

- `[ ]` Todos los archivos de la plantilla LaTeX existen en `reporte/`.
- `[ ]` `reporte.tex` no contiene la cadena `{{`.
- `[ ]` Si se compiló: `reporte.pdf` existe y es válido.
