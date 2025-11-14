# 🎨 Estrategia de Desarrollo con Placeholders

## 🎯 Filosofía: Gameplay First, Art Last

Este documento define cómo desarrollaremos **Camino Maldito** usando placeholders visuales y de audio, dejando la producción de assets profesionales para la fase final.

---

## ✅ Por Qué Esta Estrategia Funciona

### Principio Fundamental
> "Si tu juego no es divertido con cubos de colores, no será divertido con arte profesional."

### Ventajas Comprobadas

1. **Validación rápida de mecánicas**
   - Iteración en minutos, no en días
   - Cambios de diseño sin costo de arte

2. **Enfoque en lo esencial**
   - Gameplay, balance, progresión
   - Sin distraerse con estética

3. **Presupuesto optimizado**
   - $0 invertido hasta validar concepto
   - Solo gastas en arte cuando SABES que funciona

4. **Brief perfecto para artistas**
   - Juego completo como referencia
   - Especificaciones exactas
   - Menos retrabajos

5. **Beta testing enfocado**
   - Testers evalúan jugabilidad, no gráficos
   - Feedback más honesto

---

## 🎨 Sistema de Placeholders Visuales

### Paleta de Colores Funcional

Usaremos colores significativos para identificar elementos rápidamente:

#### **Personaje (Jugador)**
- **Niño:** Verde claro (`#4CAF50`)
- **Adolescente:** Azul (`#2196F3`)
- **Caballero Templario:** Blanco + Rojo (`#FFFFFF` + `#F44336`)
- **Anciano:** Gris claro (`#9E9E9E`)

#### **Enemigos**
- **Animales:** Marrón (`#795548`)
  - Vaca: Marrón claro
  - Lobo: Marrón oscuro
  - Jabalí: Marrón medio
  - Buitre: Negro (`#000000`)

- **Humanos hostiles:** Rojo (`#F44336`)
  - Ladrón: Rojo claro
  - Caballero oscuro: Rojo oscuro

- **Espectros:** Púrpura (`#9C27B0`)
  - Transparencia 50%

#### **NPCs Aliados**
- **Monje/Monja:** Amarillo (`#FFC107`)
- **Peregrino:** Verde oliva (`#689F38`)
- **Templario aliado:** Blanco (`#FFFFFF`)

#### **Elementos del Mundo**
- **Terreno:** Gris oscuro (`#424242`)
- **Plataformas:** Gris medio (`#757575`)
- **Fosos/Peligros:** Negro con borde rojo
- **Objetos recolectables:** Dorado (`#FFD700`)
- **Zonas de oración:** Azul celeste (`#03A9F4`)

#### **UI/HUD**
- **Energía del jugador:** Verde (`#4CAF50`)
- **Energía del arma:** Naranja (`#FF9800`)
- **Virtud:** Dorado (`#FFC107`)
- **Fondo HUD:** Negro semi-transparente

### Formas Geométricas Básicas

```
JUGADOR:
- Cuerpo: Rectángulo 32×48 píxeles
- Cabeza: Círculo 16 píxeles
- Arma: Línea de 24 píxeles
- Escudo: Rectángulo 16×20 píxeles

ENEMIGOS:
- Vaca/Jabalí: Rectángulo 48×32
- Lobo: Rectángulo 40×24
- Humano: Similar al jugador (32×48)
- Espectro: Forma irregular (sprite simple)

TERRENO:
- Tiles: Cuadrados 32×32 píxeles
- Puentes: Rectángulos largos
- Iglesias: Rectángulos con triángulo (techo)
```

### Animaciones Placeholder

No necesitamos animaciones complejas, solo:

1. **Movimiento:**
   - Alternar inclinación 5° izquierda/derecha (simula walk)
   - 4 frames básicos

2. **Salto:**
   - Rotación leve
   - 2 frames (subir/bajar)

3. **Ataque:**
   - Extensión del arma
   - 2 frames (preparar/golpear)

4. **Muerte:**
   - Fade out + caída
   - 3 frames

---

## 🎵 Sistema de Audio Placeholder

### Música Temporal

**Fuentes gratuitas/baratas:**

1. **Freesound.org** (gratis, CC0)
   - Buscar: "medieval ambient", "gregorian chant"

2. **Incompetech.com** (gratis con atribución)
   - Muchas pistas medievales

3. **OpenGameArt.org** (gratis)
   - Assets de comunidad

4. **YouTube Audio Library** (gratis)
   - Filtrar por medieval/orchestral

**Lista de música necesaria:**
- [ ] Track 1: Menú principal (2-3 min, loop)
- [ ] Track 2: Niveles Fase I (ambiente tranquilo, 3-4 min)
- [ ] Track 3: Niveles Fase II-III (más épico, 3-4 min)
- [ ] Track 4: Niveles Fase IV (contemplativo, 3-4 min)
- [ ] Track 5: Combate (intenso, 2 min, loop)
- [ ] Track 6: Victoria/Bendición (30 seg)
- [ ] Track 7: Game Over (15 seg)

### Efectos de Sonido Temporales

**Fuentes:**
- Freesound.org
- Sonniss Game Audio GDC Bundles (gratis anuales)
- Generadores online (jsfxr, Bfxr)

**Lista de SFX necesarios:**

#### Jugador
- [ ] Paso (footstep) - reutilizar 2-3 variaciones
- [ ] Salto
- [ ] Aterrizaje
- [ ] Golpe de espada (3 variaciones)
- [ ] Escudo bloquea
- [ ] Recibir daño
- [ ] Muerte
- [ ] Recoger objeto
- [ ] Rezar/Oración

#### Enemigos
- [ ] Gruñido animal (genérico, 3 variaciones)
- [ ] Enemigo recibe daño
- [ ] Enemigo muerte
- [ ] Ataque enemigo

#### Ambiente
- [ ] Viento (loop)
- [ ] Campana de iglesia
- [ ] Puerta
- [ ] Río/Agua (loop)

#### UI
- [ ] Click menú
- [ ] Hover botón
- [ ] Pausa
- [ ] Ganar Virtud (campanita)
- [ ] Perder Virtud (sonido negativo)

#### Hechizos
- [ ] Cast genérico
- [ ] Inspiración Divina (celestial)
- [ ] Petrificación (piedra)
- [ ] Aniquilación (explosión)
- [ ] Llamada Templaria (cuerno de guerra)

---

## 📋 Especificaciones Técnicas para Futuro Artista

### Documento de Referencia

Mientras desarrollamos con placeholders, documentaremos EXACTAMENTE qué necesitará el artista:

#### Por cada Asset Visual

```markdown
## ASSET: Protagonista - Niño

**Dimensiones:** 32×48 píxeles (sin arma), 64×64 (con arma)
**Paleta:** [link a paleta de colores]
**Animaciones necesarias:**
- Idle: 2 frames, 0.5s loop
- Walk: 8 frames, ciclo completo
- Jump: 4 frames (preparar, subir, peak, bajar)
- Attack: 6 frames (preparar, swing, impacto, retorno)
- Hurt: 2 frames
- Death: 4 frames

**Referencias visuales:**
- [Concept art generado por IA]
- [Screenshot del placeholder en juego]
- [Referencias históricas: niño peregrino medieval]

**Notas especiales:**
- Debe verse inocente y vulnerable
- Ropa humilde, desgastada
- Porta bastón de madera (que hace de espada)
```

Este documento se generará automáticamente desde el código.

### Asset List Master

Crearemos un Excel/Google Sheet con:

| Asset ID | Tipo | Nombre | Dimensiones | Frames | Prioridad | Estado | Costo Est. |
|----------|------|--------|-------------|--------|-----------|---------|-----------|
| CHAR_001 | Character | Niño Idle | 32×48 | 2 | ALTA | Placeholder | $50 |
| CHAR_002 | Character | Niño Walk | 32×48 | 8 | ALTA | Placeholder | $80 |
| ... | ... | ... | ... | ... | ... | ... | ... |

**Total estimado automático.**

---

## 🎮 Workflow de Desarrollo

### Fase 1: Core Systems (Mes 1-2)
**100% placeholders geométricos**

```
Jugador = Cuadrado verde
Enemigos = Triángulos rojos
Terreno = Líneas grises
```

**Objetivo:** Mecánicas básicas funcionando
- Movimiento
- Salto
- Colisiones
- Combate básico

### Fase 2: Gameplay Systems (Mes 2-4)
**Placeholders con colores y formas definidas**

```
Jugador = Rectángulo + círculo (cabeza) + arma
Enemigos = Formas diferenciadas por tipo
NPCs = Formas con colores específicos
```

**Objetivo:** Todos los sistemas implementados
- Enemigos con IA
- NPCs e interacciones
- Hechizos
- Virtud
- HUD completo

### Fase 3: Content Creation (Mes 4-6)
**Placeholders refinados + audio temporal**

```
Sprites placeholder mejorados (16 colores)
Animaciones básicas
Audio de Freesound integrado
```

**Objetivo:** 32 niveles completos y jugables
- Todos los niveles diseñados
- Balanceo completo
- Textos educativos
- Progresión funcional

### Fase 4: Beta Testing (Mes 6-7)
**Sin cambios visuales, solo balanceo**

**Objetivo:** Juego perfeccionado mecánicamente
- 10-20 beta testers
- Iterar balance
- Fix de bugs
- Optimización iOS

### Fase 5: Art Production (Mes 7-10)
**AHORA SÍ: contratar artista y compositor**

**Proceso:**
1. Entregar juego completo + especificaciones
2. Artista crea sprites siguiendo placeholders exactos
3. Integración progresiva (nivel por nivel)
4. Compositor crea música basada en audio temporal

**Ventaja:** El artista sabe EXACTAMENTE qué hacer

### Fase 6: Polish & Release (Mes 10-12)
**Arte final integrado**

- Tweaks finales
- Marketing materials
- App Store submission

---

## 🔧 Herramientas Necesarias (Fase Placeholder)

### Para Desarrollo
- **Motor:** Godot (gratis) o Unity Personal (gratis)
- **Code editor:** VS Code (gratis)
- **Git:** Para control de versiones (gratis)

### Para Placeholders Visuales
- **Figma** (gratis) - diseñar formas básicas
- **Paint.net / GIMP** (gratis) - sprites simples
- O directamente en el motor (primitivas geométricas)

### Para Audio Temporal
- **Audacity** (gratis) - editar audio
- **Freesound.org** (gratis) - biblioteca SFX
- **Incompetech** (gratis) - música

### Para Concepts (IA)
- **Midjourney** ($10/mes) - concept art
- **ChatGPT Plus** ($20/mes, opcional) - DALL-E 3
- **Stable Diffusion** (gratis, local) - alternativa

**Costo total herramientas: $0-30/mes**

---

## 📊 Métricas de Éxito (Fase Placeholder)

### Antes de Contratar Artista, el Juego Debe:

- [ ] Ser jugable de inicio a fin (32 niveles)
- [ ] Tener dificultad balanceada
- [ ] Sistema de Virtud funcionando correctamente
- [ ] Todas las mecánicas implementadas (combate, hechizos, NPCs)
- [ ] Sin bugs críticos
- [ ] 60 FPS estable en iPhone 8 o superior
- [ ] Guardado/carga funcional
- [ ] Al menos 5 beta testers lo han completado
- [ ] Feedback mayormente positivo sobre jugabilidad
- [ ] Tiempo de juego: 2-3 horas (target)

### Criterio de Decisión

**SI** todas las métricas se cumplen:
→ ✅ Contratar artista ($6-15k)

**SI NO**:
→ ⚠️ Iterar más o cancelar (ahorraste $6-15k)

---

## 🎨 Generación de Concepts con IA

### Cuándo Generar Concepts

**Durante desarrollo:**
- Referencias visuales para mantener visión
- Mood boards para guiar diseño
- Paletas de colores

**Antes de contratar artista:**
- Concept art detallado de TODOS los personajes
- Referencias de escenarios por nivel
- Style guide completo

### Prompts Ejemplo para Midjourney/DALL-E

```
PERSONAJE - NIÑO PEREGRINO:
"Young medieval pilgrim boy, 10 years old, humble worn clothes,
wooden walking stick, innocent expression, side view character
design, pixel art style reference, 16-bit game aesthetic,
simple color palette, white background"

PERSONAJE - CABALLERO TEMPLARIO:
"Templar knight, white tunic with red cross pattée, medieval
armor, sword and shield, noble pose, side view character design,
pixel art style reference, 16-bit game, detailed but simple,
white background"

ESCENARIO - RONCESVALLES:
"Roncesvalles monastery, medieval stone architecture, octagonal
church, Pyrenees mountains background, atmospheric lighting,
pixel art game background reference, 16-bit style, side-scrolling
game perspective"
```

### Organización de Concepts

```
/Concepts
  /Characters
    /Player
      - 001_nino_idle_concept.png
      - 002_nino_walk_concept.png
      - 003_adolescente_concept.png
      - 004_templario_concept.png
      - 005_anciano_concept.png
    /Enemies
      - 010_vaca.png
      - 011_lobo.png
      - ...
    /NPCs
      - 020_monje.png
      - 021_peregrino.png
      - ...
  /Environments
    /Fase1_Navarra
      - nivel_01_saint_jean.png
      - nivel_02_roncesvalles.png
      - ...
  /UI
    - hud_mockup.png
    - menu_concept.png
  /StyleGuide
    - color_palette.png
    - proportions_guide.png
```

---

## 💰 Presupuesto Actualizado

### Fase Placeholder (Mes 1-7)
```
Motor de juego:              $0 (Godot/Unity Personal)
Herramientas:               $0 (todo gratis)
Audio temporal:             $0 (Freesound, Incompetech)
Concepts de IA:             $10-20/mes × 7 = $70-140
Apple Developer Account:    $99

TOTAL FASE PLACEHOLDER:     ~$170-240
```

### Fase Arte Final (Mes 7-10)
```
Pixel Artist profesional:   $8,000-15,000
Compositor + SFX:           $3,000-8,000
Herramientas del artista:   Incluido en fee

TOTAL FASE ARTE:            $11,000-23,000
```

### TOTAL PROYECTO
```
ESCENARIO ECONÓMICO:        $11,170-23,240
ESCENARIO PREMIUM:          $11,170-23,240

VS. Hacer Arte Primero:     $50,000-85,000
AHORRO:                     $26,760-61,760
```

**Ahorro de tiempo:** 3-6 meses (iteraciones de arte evitadas)

---

## 🎯 Ventaja Competitiva de Este Approach

### Lo Que Otros Hacen (Mal)
```
Mes 1-3:   Contratan artista, hacen sprites
Mes 4:     Implementan juego
Mes 5:     Se dan cuenta que gameplay no funciona
Mes 6:     Piden cambios al artista (más costo)
Mes 7-8:   Re-implementan
Mes 9:     Gameplay aún no convence
Mes 10:    Cancelan proyecto
RESULTADO: $15k gastados, 0 juego
```

### Lo Que Haremos (Bien)
```
Mes 1-2:   Prototipo con placeholders
Mes 3:     Gameplay validado, divertido
Mes 4-6:   32 niveles completos con placeholders
Mes 7:     Beta testing exitoso
Mes 8:     AHORA contratan artista
Mes 9-10:  Integración de arte
Mes 11:    Juego completo y publicable
RESULTADO: $12k gastados, juego exitoso
```

---

## ✅ Próximos Pasos Inmediatos

1. **Decidir motor** (Godot vs Unity)
   - Lee `MOTOR_DECISION.md`
   - Toma decisión hoy

2. **Setup del proyecto**
   - Instalar motor + Xcode
   - Crear proyecto base iOS
   - Configurar Git

3. **Implementar sistema de placeholders**
   - Colores definidos
   - Formas geométricas
   - Primitivas del motor

4. **Activar AGENTE 1**
   - Arquitectura core
   - Sistemas base
   - Todo con placeholders

5. **Desarrollo paralelo**
   - Activar AGENTES 2-9
   - Construir juego completo
   - Solo placeholders

6. **Generar concepts**
   - Mientras desarrollamos
   - Midjourney/DALL-E
   - Para futura referencia

7. **Beta testing (Mes 6-7)**
   - Con placeholders
   - Validar jugabilidad

8. **SOLO SI beta exitosa: contratar artista**
   - Brief perfecto
   - Juego completo como referencia
   - Integración rápida

---

## 🎮 Resumen Ejecutivo

**¿Podemos desarrollar el juego completo con placeholders y añadir arte al final?**

# ✅ SÍ, ABSOLUTAMENTE

**Es la mejor estrategia posible para este proyecto.**

**Beneficios:**
- ✅ Riesgo financiero mínimo
- ✅ Validación rápida de concepto
- ✅ Iteración ágil
- ✅ Brief perfecto para artista
- ✅ Ahorro de $27-62k
- ✅ Ahorro de 3-6 meses

**Podemos empezar HOY con inversión de $0.**

---

**¿Listo para decidir el motor y empezar?** 🚀
