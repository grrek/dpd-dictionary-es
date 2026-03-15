# Diccionario Pāli — Digital Pali Dictionary en Español

**72,698 definiciones Pāli → Español** del [Digital Pali Dictionary](https://digitalpalidictionary.github.io/) (DPD), disponibles en una aplicación web estática, rápida y sin dependencias.

**[Ver en línea → dhamma-pb.org/dpd-espanol](https://dhamma-pb.org/dpd-espanol/)**

---

## Características

- **Búsqueda instantánea** con autocompletado sobre 92,541 formas indexadas (flexiones, variantes, sandhi)
- **Definiciones bilingües**: español como idioma principal, inglés original como referencia, con etiqueta `ES` / `EN`
- **Raíces etimológicas** (√): muestra la raíz Pāli de cada palabra con su significado en español, construcción morfológica y enlace a la familia de palabras
- **Explorador de familias de raíces**: panel interactivo con 753 raíces y 36,485 palabras agrupadas por sub-familias, con chips clickeables y tooltips en español (cobertura del 81%)
- **Análisis de compuestos**: deconstrucción automática de palabras compuestas Pāli (sandhi splitting)
- **Categorías gramaticales** traducidas al español (adjetivo, masculino, participio pasado, etc.)
- **Navegación alfabética** con barra de letras del alfabeto Pāli completo (incluye ā, ī, ū, ṃ, ṅ, ñ, ṭ, ḍ, ṇ, ḷ)
- **Teclado de diacríticos** integrado para insertar caracteres Pāli fácilmente
- **Historial de búsqueda** persistente (últimas 20 palabras, almacenado en `localStorage`)
- **Búsqueda fuzzy**: encuentra palabras incluso sin diacríticos (`nibbana` → `nibbāna`)
- **URLs compartibles**: cada palabra tiene un enlace directo vía hash (`#nibbāna`)
- **Carga progresiva**: el buscador se habilita tras cargar el índice + español (~12 MB), mientras inglés y deconstructor se cargan en segundo plano
- **100% estático**: un solo archivo HTML + 4 archivos JS de datos. Sin servidor, sin API, sin framework
- **Responsive**: diseño adaptable a móvil, tablet y escritorio
- **SEO optimizado**: Open Graph, Twitter Cards, meta tags, canonical URL

---

## Demo

Busca cualquier palabra Pāli y obtén su definición completa:

| Búsqueda | Resultado |
|----------|-----------|
| `dhamma` | 16 acepciones (masculino, indeclinable, sandhi...) |
| `nibbāna` | neutro — "liberación; el objetivo final; extinguir..." |
| `sutta` | neutro — "discurso; un texto individual del canon Pāli" |
| `dukkha` | neutro/adjetivo — "sufrimiento; dolor; insatisfactoriedad..." |
| `kamma` | neutro — "acción; acción volitiva con consecuencia..." |

---

## Arquitectura

La aplicación es un único archivo `index.html` (~42 KB) con todo el CSS y JavaScript inline. Los datos del diccionario se cargan como 4 archivos JS estáticos:

```
dpd-dictionary-es/
├── index.html              # App completa (HTML + CSS + JS)
├── favicon.svg             # Icono SVG (rueda del Dhamma)
├── favicon-32.png          # Icono PNG 32×32
├── apple-touch-icon.png    # Icono Apple 180×180
├── js/
│   ├── dpd_i2h.js          # Índice input→headword (92,541 entradas, ~5.9 MB)
│   ├── dpd_ebts_es.js      # Definiciones en español (72,698 entradas, ~6.5 MB)
│   ├── dpd_ebts.js         # Definiciones en inglés (72,698 entradas, ~6.3 MB)
│   ├── dpd_deconstructor.js # Análisis de compuestos (~1.1 MB)
│   ├── dpd_roots.js        # Significados de raíces EN+ES (753 raíces, ~41 KB)
│   └── dpd_root_families.js # Familias de raíces (36,485 palabras, ~2.3 MB)
└── README.md
```

### Archivos de datos

| Archivo | Contenido | Entradas | Tamaño |
|---------|-----------|----------|--------|
| `dpd_i2h.js` | Mapeo forma → headwords. Cada forma Pāli apunta a una lista de IDs numéricos. | 92,541 | 5.9 MB |
| `dpd_ebts_es.js` | Definiciones en español. Clave numérica → texto con POS, definición, literales y etimología. | 72,698 | 6.5 MB |
| `dpd_ebts.js` | Definiciones originales en inglés (misma estructura que ES). | 72,698 | 6.3 MB |
| `dpd_deconstructor.js` | Descomposición de palabras compuestas y sandhi. | — | 1.1 MB |
| `dpd_roots.js` | Significados de raíces Pāli en inglés y español. | 753 | 41 KB |
| `dpd_root_families.js` | Familias de raíces: sub-familias con lemas, POS y significados. | 36,485 palabras | 2.3 MB |

Los archivos JS declaran variables globales (`dpd_i2h`, `dpd_ebts_es`, `dpd_ebts`, `dpd_deconstructor`, `dpd_roots`, `dpd_root_families`) que la aplicación consulta en tiempo de ejecución.

### Motor de búsqueda

1. **Normalización**: minúsculas, eliminación de puntuación, normalización de `ṁ` → `ṃ`
2. **Búsqueda por prefijo**: búsqueda binaria sobre las claves ordenadas del índice `dpd_i2h`
3. **Búsqueda fuzzy**: si hay pocos resultados, busca sin diacríticos (`ā` → `a`, `ṇ` → `n`, etc.) usando un mapa pre-construido de 92K claves stripped
4. **Resolución**: cada forma apunta a uno o más headwords (IDs); para cada ID se busca la definición ES y EN
5. **Fallback directo**: si la palabra no está en `dpd_i2h`, se busca directamente como headword key en `dpd_ebts_es`/`dpd_ebts`, incluyendo variantes numeradas (`palabra 1`, `palabra 1.1`, etc.). Esto cubre 13,400+ palabras adicionales que existen como headwords pero no están indexadas como formas buscables
6. **Raíces**: se extrae el símbolo de raíz (√) de la etimología y se busca en `dpd_roots` para mostrar el significado ES. Click en la raíz despliega el explorador de familias con chips clickeables
7. **Renderizado**: se parsea la definición (POS, texto, literales, etimología) y se muestra con formato bilingüe

---

## Sobre la traducción al español

Las 72,698 definiciones en español fueron traducidas a partir de las definiciones originales en inglés del DPD con la asistencia del modelo de inteligencia artificial [Claude Opus 4.6](https://www.anthropic.com/claude) (Anthropic).

### Proceso de traducción

El proceso se realizó en tres etapas:

1. **Traducción inicial**: las 72,698 definiciones se dividieron en 364 lotes de 200 entradas cada uno. Cada lote fue traducido por Claude Opus 4.6, respetando la estructura original (categoría gramatical, definición, literales, etimología).

2. **Verificación terminológica budista**: cada traducción fue cotejada contra un *glosario maestro* de terminología Pāli→Español basado en las convenciones de traducción de **Bhikkhu Nandisena** y **Juan Carlos Baron**, asegurando consistencia en términos técnicos como:
   - *dukkha* → sufrimiento (no "dolor" genérico)
   - *saṅkhāra* → formaciones (no "construcciones")
   - *viññāṇa* → consciencia (no "conciencia")
   - *jhāna* → jhāna (sin traducir)
   - Y muchos más términos del canon Pāli

3. **Corrección de estilo y consistencia**: revisión doble (audit) de cada lote para detectar y corregir fragmentos no traducidos, falsos cognados, inconsistencias de género/número, y naturalidad del español.

### Calidad final

- **364/364 lotes** completados y auditados
- **100% grado A** (menos del 3% de inglés residual por lote)
- Terminología budista unificada según el glosario maestro

### Limitaciones

El DPD original solo ofrece definiciones en inglés (no existe una versión oficial en español). Esta traducción automatizada, aunque ha sido cuidadosamente revisada, puede contener imprecisiones o matices mejorables. Agradecemos cualquier sugerencia o corrección a través del [formulario de contacto de dhamma-pb.org](https://dhamma-pb.org/#contacto).

---

## Despliegue

Al ser 100% estático, se puede servir desde cualquier servidor web o CDN:

### Servidor local

```bash
# Con Python
python3 -m http.server 8000

# Con Node.js
npx serve .
```

### En producción

Simplemente copia todos los archivos a cualquier directorio servido por un servidor web (Nginx, Apache, Caddy, S3, GitHub Pages, etc.):

```bash
rsync -avz ./ tu-servidor:/ruta/al/sitio/dpd-espanol/
```

No requiere build, compilación, ni procesamiento alguno.

---

## Integración como overlay

Además de funcionar como diccionario independiente, los archivos de datos pueden integrarse como overlay (tooltip) en otras páginas con textos Pāli. Para ello:

1. Incluye los 4 archivos JS en tu HTML
2. Escucha eventos de hover/click sobre palabras Pāli
3. Busca la palabra en `dpd_i2h` para obtener los headwords
4. Muestra la definición de `dpd_ebts_es` (o `dpd_ebts` como fallback)

El sitio [dhamma-pb.org/recitaciones](https://dhamma-pb.org/recitaciones/) utiliza este enfoque.

---

## Créditos y agradecimientos

Este proyecto es posible gracias al trabajo de muchas personas:

- **[Digital Pali Dictionary](https://digitalpalidictionary.github.io/)** — Creado por **Ven. Bodhirasa** (Sri Lanka). La fuente autoritativa de definiciones Pāli→Inglés más completa disponible como recurso abierto.
- **Ven. Cittadhammo** — Por la integración JavaScript original en [thebuddhaswords.net](https://www.thebuddhaswords.net/), que sirvió como referencia técnica para los archivos de datos JS.
- **Ven. Devamitta** — Por las correcciones lingüísticas y los cursos de Pāli.
- **Ven. Gambhiro** — Por el exportador GoldenDict del DPD.
- **Falko** — Por [dpdict.net](https://dpdict.net/), otra interfaz web del DPD.
- **Prof. Bryan Levman**, **Prof. Aleix Ruiz Falques**, **Ven. Sujato** — Y toda la [comunidad de colaboradores](https://digitalpalidictionary.github.io/thanks/) del DPD.
- **Bhikkhu Nandisena** y **Juan Carlos Baron** — Por las convenciones de traducción Pāli→Español recogidas en el glosario maestro.
- **[Claude Opus 4.6](https://www.anthropic.com/claude)** (Anthropic) — Modelo de IA utilizado para la traducción asistida y revisión de las 72,698 definiciones.

Traducción al español coordinada por **[Paññābhūmi — dhamma-pb.org](https://dhamma-pb.org/)**.

---

## Licencia

Este trabajo se distribuye bajo la licencia [**Creative Commons BY-NC-SA 4.0**](https://creativecommons.org/licenses/by-nc-sa/4.0/deed.es), siguiendo la licencia del Digital Pali Dictionary original.

Eres libre de:
- **Compartir** — copiar y redistribuir el material
- **Adaptar** — remezclar, transformar y construir sobre el material

Bajo las condiciones:
- **Atribución** — Debes dar crédito al DPD y a este proyecto
- **No Comercial** — No puedes usar el material con fines comerciales
- **Compartir Igual** — Si remezclas o transformas, debes distribuir bajo la misma licencia

---

## Contacto

Para sugerencias, correcciones o colaboración:

**[Formulario de contacto — dhamma-pb.org](https://dhamma-pb.org/#contacto)**
