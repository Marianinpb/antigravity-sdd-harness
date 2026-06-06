# Especificación: [SPEC-ID] Exposición — [Título de la Exposición]

> **Estado:** Borrador | En Revisión | Aprobado | Reemplazado
> **Autor:** [Nombre del expositor — DATO PROPORCIONADO EXPLÍCITAMENTE POR EL USUARIO]
> **Fecha:** [YYYY-MM-DD]
> **Aprobado por:** [Nombre] el [YYYY-MM-DD]

---

> [!IMPORTANT]
> **REGLA CRÍTICA:** Todos los datos de la sección 2 (Datos del Expositor) DEBEN
> ser proporcionados EXPLÍCITAMENTE por el usuario. El agente NUNCA debe inferirlos
> del contenido de la fuente (paper, libro, repositorio), aunque la fuente mencione
> autores, instituciones o títulos. El autor de la fuente ≠ el expositor.

---

## 1. Resumen

**Problema:**
Se requiere preparar una exposición académica sobre [tema] para presentar ante
[audiencia]. No existe un proceso estandarizado para transformar eficientemente
la fuente de contenido en una presentación formal y su guion correspondiente.

**Solución propuesta:**
Generar automáticamente los entregables de la exposición (resumen, presentación
LaTeX compilable, guion) a partir del análisis de la fuente especificada, usando
los datos del expositor proporcionados explícitamente.

---

## 2. Datos del Expositor

> [!IMPORTANT]
> Todos los campos de esta sección deben ser confirmados por el usuario.
> El agente DEBE preguntar cada campo de forma explícita si no fue ya proporcionado.

| Campo | Valor |
|-------|-------|
| **Nombre del expositor** | [PREGUNTAR AL USUARIO] |
| **Institución** | [PREGUNTAR AL USUARIO] |
| **Título de la exposición** | [PREGUNTAR AL USUARIO] |
| **Subtítulo** (opcional) | [PREGUNTAR AL USUARIO — puede ser vacío] |
| **Fecha de presentación** | [PREGUNTAR AL USUARIO] |
| **Audiencia objetivo** | [PREGUNTAR AL USUARIO] |
| **Duración estimada** | [PREGUNTAR AL USUARIO] |
| **Idioma de los entregables** | Español (por defecto — cambiar solo con confirmación explícita) |

---

## 3. Fuente de Contenido

**Tipo de fuente:** [paper | tema+libro | repositorio]

| Tipo | Datos de la fuente |
|------|--------------------|
| `paper` | Ruta al PDF: [valor de `exposition.paper_path` en harness-config.yaml] |
| `tema+libro` | Tema: [valor de `exposition.topic`] / Libro: [valor de `exposition.book_reference`] |
| `repositorio` | URL: [valor de `exposition.repo_url`] |

---

## 4. Actores

| Actor | Descripción | Rol |
|-------|-------------|-----|
| Expositor | Usuario que presentará el contenido | Proveedor de datos de presentación |
| Agente SDD | Antigravity | Generador de los entregables |
| Audiencia | [Definida por el expositor] | Receptor final del contenido |

---

## 5. Requisitos Funcionales

_Se usan palabras clave RFC-2119: **DEBE**, **NO DEBE**, **DEBERÍA**, **PUEDE**._

### 5.1. Recolección de datos del expositor

- **FR-01:** El sistema **DEBE** solicitar explícitamente al usuario los campos de la
  sección 2 antes de comenzar cualquier generación de contenido.
- **FR-02:** El sistema **NO DEBE** inferir el nombre del expositor, la institución
  ni el título de la presentación del contenido de la fuente.
- **FR-03:** El sistema **DEBE** confirmar con el usuario si desea cambiar el idioma
  por defecto (español) antes de aplicar el cambio.

### 5.2. Análisis de la fuente

- **FR-04:** Si la fuente es un `paper`, el sistema **DEBE** leer su contenido con
  capacidades LLM. Si no puede extraer información suficiente, **DEBE** preguntar
  al usuario los datos clave.
- **FR-05:** Si la fuente es un `repositorio`, el sistema **DEBE** leer primero el
  README y la documentación disponible antes de considerar clonar el repo.
- **FR-06:** Si la fuente es `tema+libro`, el sistema **DEBE** usar el tema y la
  referencia del libro como base temática.

### 5.3. Generación de entregables

- **FR-07:** El sistema **DEBE** generar un archivo de resumen del contenido de la
  fuente con el nombre `resumen_paper.md`, `resumen_tema.md`, o
  `resumen_proyecto.md` según el tipo de fuente.
- **FR-08:** El sistema **DEBE** copiar la plantilla LaTeX desde
  `command_assets/exposition/templates/` al directorio `presentacion/` del proyecto.
- **FR-09:** El sistema **DEBE** reemplazar los placeholders `{{TITULO}}`,
  `{{SUBTITULO}}`, `{{AUTOR}}`, `{{INSTITUCION}}`, `{{FECHA}}` y
  `{{CONTENIDO_SECCIONES}}` en `presentacion.tex` con los valores correctos.
- **FR-10:** El sistema **DEBE** generar `guion_exposicion.md` alineado con las
  diapositivas generadas.

### 5.4. Compilación LaTeX

- **FR-11:** Antes de intentar compilar, el sistema **DEBE** verificar si
  `pdflatex` o `latexmk` están disponibles en el sistema.
- **FR-12:** Si el compilador no está disponible, el sistema **DEBE** preguntar
  al usuario si desea instalarlo. Si el usuario dice que no, solo generar el `.tex`.
- **FR-13:** Si la compilación falla, el sistema **DEBE** reportar el error y
  no marcar la tarea como completada.

### 5.5. Diagramas (opcional)
- **FR-14:** Si la presentación requiere diagramas, el sistema **DEBE** generarlos
  con Mermaid en archivos `.mmd` dentro de `presentacion/diagramas/`.
- **FR-15:** Los diagramas **DEBEN** renderizarse a SVG con fondo transparente:
  `mmdc -i <archivo>.mmd -o <archivo>.svg -b transparent`.
- **FR-16:** Los SVG **DEBEN** incluirse en LaTeX vía `\includesvg{}` con
  `\usepackage{svg}` en el preámbulo.
- **FR-17:** El sistema **NO DEBE** usar `\begin{tikzpicture}`, `pgfplots` u otros
  entornos de dibujo LaTeX nativos para generar diagramas.

---

## 6. Entradas y Salidas

**Entradas:**

| Entrada | Tipo | Fuente | Validación |
|---------|------|--------|------------|
| Datos del expositor | Campos YAML + confirmación | Usuario (explícita) | Todos obligatorios excepto subtítulo |
| Fuente de contenido | PDF / texto / URL | `harness-config.yaml` → `exposition` | Exactamente una fuente activa |
| Idioma | String (`"es"` o `"en"`) | `harness-config.yaml` → `exposition.language` | Por defecto `"es"` |

**Salidas:**

| Salida | Tipo | Destino | Formato |
|--------|------|---------|---------|
| Resumen | Markdown | `resumen_{fuente}.md` | Markdown estructurado |
| Presentación | LaTeX | `presentacion/presentacion.tex` | LaTeX (beamer) |
| PDF | Binario | `presentacion/presentacion.pdf` | PDF (si compilador disponible) |
| Guion | Markdown | `guion_exposicion.md` | Markdown con estructura por diapositiva |

---

## 7. Requisitos No Funcionales

- **NFR-01:** [Eficiencia] El sistema **NO DEBE** copiar los assets LaTeX a menos
  que el proyecto sea de tipo `exposition`.
- **NFR-02:** [Idioma] Los entregables **DEBEN** generarse en el idioma configurado
  (español por defecto). El idioma de la fuente **NO DEBE** determinar el idioma
  de los entregables.
- **NFR-03:** [Integridad] Ningún placeholder `{{...}}` **DEBE** quedar sin
  reemplazar en el archivo `.tex` final.
- **NFR-04:** [Diagramas] Si se requieren diagramas, estos **DEBEN** generarse con
  Mermaid y renderizarse a SVG con fondo transparente. **NO DEBEN** usarse
  entornos de dibujo LaTeX nativos (`tikzpicture`, `pgfplots`).
- **NFR-05:** [SVG] Los diagramas SVG generados **DEBEN** tener fondo transparente
  (usar `mmdc -b transparent`).

---

## 8. Criterios de Aceptación

- **AC-01:** Dado que el usuario ejecuta `/exposition`, cuando el agente inicia
  el comando, entonces el agente solicita explícitamente todos los campos del
  expositor antes de generar la especificación.
- **AC-02:** Dado un `paper_path` configurado, cuando el agente analiza la fuente,
  entonces genera un `resumen_paper.md` coherente con el contenido del paper.
- **AC-03:** Dado que el agente genera `presentacion.tex`, cuando se compila con
  `pdflatex`, entonces el archivo compila sin errores y produce un PDF válido.
- **AC-04:** Dado que el agente genera `presentacion.tex`, cuando se inspecciona
  el archivo, entonces no existe ningún placeholder `{{...}}` sin reemplazar.
- **AC-05:** Dado que el idioma no fue cambiado explícitamente por el usuario,
  cuando se generan los entregables, entonces todo el contenido está en español.
- **AC-06:** Dado que el agente genera `guion_exposicion.md`, cuando se compara
  con `presentacion.tex`, entonces cada frame de la presentación tiene su
  sección correspondiente en el guion.
- **AC-07:** Dado que se requieren diagramas, cuando el agente los genera con
  Mermaid, entonces los archivos `.mmd` renderizan a SVG sin errores y los
  SVG tienen fondo transparente.
- **AC-08:** Dado que el agente genera `presentacion.tex`, cuando se inspecciona
  el archivo, entonces no existe ningún `\begin{tikzpicture}`.

---

## 9. Restricciones y Suposiciones

### Restricciones
- Los assets LaTeX (`.sty`, logos) SOLO se copian al ejecutar el comando `/exposition`.
- El título, autor e institución NUNCA se infieren del contenido de la fuente.
- El cambio de idioma requiere confirmación humana explícita.

### Suposiciones
- El usuario ha invocado el comando `/exposition`.
- Exactamente una fuente de contenido está activa (`paper_path` O `topic`+`book_reference` O `repo_url`).
- Los logos `IICO-LOGO-AZUL.png` y `UASLP-LOGO-AZUL.png` son los logos institucionales correctos.

---

## 10. Preguntas Abiertas

> [!IMPORTANT]
> Estas preguntas DEBEN resolverse antes de aprobar esta especificación.

- **Q1:** ¿Cuál es el nombre completo del expositor?
- **Q2:** ¿Cuál es la institución del expositor?
- **Q3:** ¿Cuál es el título de la exposición?
- **Q4:** ¿Hay subtítulo?
- **Q5:** ¿Cuál es la fecha de presentación?
- **Q6:** ¿Cuál es la audiencia objetivo?
- **Q7:** ¿Cuál es la duración estimada?
- **Q8:** ¿Se requiere cambiar el idioma del español (por defecto)?

---

## 11. Referencias

- Plantilla LaTeX: `command_assets/exposition/templates/presentacion.tex`
- Ejemplo de exposición: `ejemplo_expo/` (referencia del harness)
- Estándar de especificación: `templates/spec-template.md`
