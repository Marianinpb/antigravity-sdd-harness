# Especificación: [SPEC-ID] Reporte — [Título del Reporte]

> **Estado:** Borrador | En Revisión | Aprobado | Reemplazado
> **Autor:** [Nombre del autor — DATO PROPORCIONADO EXPLÍCITAMENTE POR EL USUARIO]
> **Fecha:** [YYYY-MM-DD]
> **Aprobado por:** [Nombre] el [YYYY-MM-DD]

---

> [!IMPORTANT]
> **REGLA CRÍTICA:** Todos los datos de la sección 2 (Datos del Autor) DEBEN
> ser proporcionados EXPLÍCITAMENTE por el usuario. El agente NUNCA debe inferirlos
> del contenido de la fuente, aunque la fuente mencione autores, instituciones o títulos.

---

## 1. Resumen

**Problema:**
Se requiere preparar un reporte técnico/académico estructurado a partir de diversas fuentes de información.

**Solución propuesta:**
Generar automáticamente el código LaTeX de un reporte formal en formato IEEE que sintetice y estructure la información extraída de las fuentes especificadas.

---

## 2. Datos del Autor

> [!IMPORTANT]
> Todos los campos de esta sección deben ser confirmados por el usuario.
> El agente DEBE preguntar cada campo de forma explícita si no fue ya proporcionado.

| Campo | Valor |
|-------|-------|
| **Nombre del autor** | [PREGUNTAR AL USUARIO] |
| **Autor (Corto)** | [PREGUNTAR AL USUARIO] |
| **Institución** | [PREGUNTAR AL USUARIO] |
| **Título del reporte** | [PREGUNTAR AL USUARIO] |
| **Título (Corto)** | [PREGUNTAR AL USUARIO] |
| **Correspondencia (Email)** | [PREGUNTAR AL USUARIO] |
| **Fecha** | [PREGUNTAR AL USUARIO] |
| **Idioma de los entregables** | Español (por defecto) |
| **Plantilla** | [PREGUNTAR AL USUARIO — "ieee" o "ciep"] |

---

## 3. Fuentes de Contenido

**Fuentes configuradas:**

| Tipo | Referencia / URL |
|------|------------------|
| [tipo] | [valor] |

---

## 4. Requisitos Funcionales

_Se usan palabras clave RFC-2119: **DEBE**, **NO DEBE**, **DEBERÍA**, **PUEDE**._

### 4.1. Recolección de datos del autor
- **FR-01:** El sistema **DEBE** solicitar explícitamente al usuario los campos de la sección 2.
- **FR-02:** El sistema **NO DEBE** inferir los metadatos del reporte a partir del contenido fuente.

### 4.2. Análisis de las fuentes
- **FR-03:** El sistema **DEBE** consolidar la información de todas las fuentes provistas en el `harness-config.yaml` bajo la sección `reporte.sources`.

### 4.3. Generación del reporte
- **FR-04:** El sistema **DEBE** copiar la plantilla y assets de `project_types/reporte/templates/[template_name]/` al directorio `reporte/` del proyecto.
- **FR-05:** El sistema **DEBE** reemplazar los placeholders del documento LaTeX con los metadatos y el contenido extraído.
- **FR-06:** El sistema **DEBE** intentar compilar el reporte si dispone de `pdflatex` o similar.

---

## 5. Preguntas Abiertas

> [!IMPORTANT]
> Estas preguntas DEBEN resolverse antes de aprobar esta especificación.

- **Q1:** ¿Cuál es el nombre del autor?
- **Q2:** ¿Cuál es la institución del autor?
- **Q3:** ¿Cuál es el título del reporte?
- **Q4:** ¿Cuál es el email de correspondencia?
- **Q5:** ¿Cuál es la fecha del reporte?
