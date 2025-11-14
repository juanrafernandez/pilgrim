# 🎮 Camino Maldito: Plan de Desarrollo

## Estado: FASE DE PLANIFICACIÓN

---

## 📋 BLOQUE 1: FUNDAMENTOS Y SETUP DEL PROYECTO (Semanas 1-2)

### Objetivo
Establecer la infraestructura técnica básica del proyecto iOS.

### Tareas Técnicas (IA puede ayudar)

#### 1.1 Decisión de Motor y Configuración
- [ ] **Decisión crítica:** Elegir entre Godot o Unity
  - Godot: mejor para 2D, open source, exporta a iOS
  - Unity: más maduro para iOS, más recursos
  - **Requiere decisión humana basada en experiencia del equipo**
- [ ] Crear proyecto base en el motor elegido
- [ ] Configurar para target iOS (1080×1920 portrait)
- [ ] Configurar sistema de build para iOS
- [ ] Documentar proceso de build en README.md

#### 1.2 Arquitectura del Código
- [ ] Diseñar arquitectura modular (MVC o ECS)
- [ ] Crear estructura de carpetas:
  ```
  /Assets
    /Sprites (pixel art - REQUIERE ARTISTA)
    /Audio (música y SFX - REQUIERE COMPOSITOR)
    /Fonts
    /Scenes
  /Scripts
    /Core (sistemas centrales)
    /Gameplay (mecánicas de juego)
    /UI
    /Data (definiciones de niveles)
  /Docs
  ```
- [ ] Implementar sistema de gestión de escenas
- [ ] Crear sistema de configuración (settings)

#### 1.3 Sistemas Core
- [ ] Sistema de input para touch (iOS específico)
- [ ] Sistema de cámara (seguimiento lateral)
- [ ] Sistema de pausa/menú
- [ ] Sistema básico de audio manager

#### 1.4 Documentación Inicial
- [ ] README.md con instrucciones de setup
- [ ] CONTRIBUTING.md con guías de código
- [ ] Actualizar CLAUDE.md con stack técnico elegido

**Dependencias externas:** Decisión de motor (humana)
**Entregable:** Proyecto vacío funcional que compila para iOS

---

## 🎨 BLOQUE 2: ASSETS Y DISEÑO VISUAL (Semanas 3-8)

### Objetivo
Crear todos los assets visuales y de audio necesarios.

### ⚠️ **ESTE BLOQUE REQUIERE EQUIPO HUMANO ESPECIALIZADO**

#### 2.1 Pixel Art (ARTISTA PIXEL ART)
- [ ] Definir paleta de colores (medieval, templario)
- [ ] Crear sprite sheet del protagonista en 4 etapas:
  - [ ] Niño (8 frames walk, 4 attack, 2 idle, 4 jump)
  - [ ] Adolescente (12 frames walk, 6 attack, 2 idle, 4 jump)
  - [ ] Caballero templario (16 frames walk, 8 attack, 2 idle, 4 jump, 4 special)
  - [ ] Anciano (12 frames walk, 4 magic, 2 idle, 2 pray)
- [ ] Crear enemigos (vacas, lobos, espectros, etc.) - ~20 tipos
- [ ] Crear NPCs (monjes, peregrinos, templarios) - ~10 tipos
- [ ] Crear tilesets para 32 niveles (tierra, piedra, puentes, iglesias)
- [ ] Crear UI elements (HUD, menús, iconos)
- [ ] Crear efectos visuales (hechizos, partículas, muerte)

**Estimación:** 150-200 horas de trabajo de pixel artist profesional

#### 2.2 Audio (COMPOSITOR + DISEÑADOR DE SONIDO)
- [ ] Componer música temática por fase (4 tracks principales)
- [ ] Música de combate (2-3 variaciones)
- [ ] Música ambiental (amanecer, noche, iglesias)
- [ ] Efectos de sonido:
  - [ ] Combate (espada, escudo, golpes) - ~20 sonidos
  - [ ] Ambiente (pasos, viento, campanas) - ~30 sonidos
  - [ ] UI (menú, selección, pausa) - ~10 sonidos
  - [ ] Hechizos y magia - ~15 sonidos
- [ ] Voces y oraciones (opcional)

**Estimación:** 80-120 horas de compositor + diseñador de audio

#### 2.3 Integración de Assets (IA puede ayudar)
- [ ] Crear sistema de carga de sprites
- [ ] Implementar animaciones del personaje
- [ ] Configurar atlas de texturas optimizado
- [ ] Integrar música con sistema de audio manager
- [ ] Optimizar tamaño de assets para iOS

**Dependencias:** Todos los assets anteriores
**Entregable:** Biblioteca completa de assets integrados y funcionales

---

## 🎮 BLOQUE 3: SISTEMAS DE GAMEPLAY (Semanas 9-14)

### Objetivo
Implementar todas las mecánicas jugables del juego.

### ⚡ **IA PUEDE AYUDAR SIGNIFICATIVAMENTE AQUÍ**

#### 3.1 Movimiento y Control del Jugador
- [ ] Sistema de movimiento lateral (left/right)
- [ ] Sistema de salto con física
- [ ] Detección de colisiones con enemigos/terreno
- [ ] Sistema de animaciones basado en estado
- [ ] Controles touch optimizados para iOS (botones virtuales)
- [ ] Sistema de fosos y caída (reset energía)

#### 3.2 Sistema de Combate
- [ ] Ataque básico (espada)
- [ ] Sistema de hitboxes y hurtboxes
- [ ] Diferentes armas por etapa (madera → hierro → templaria)
- [ ] Degradación de armas (energía del arma)
- [ ] Sistema de escudo/defensa
- [ ] Feedback visual de daño

#### 3.3 Sistema de Enemigos e IA
- [ ] Clase base Enemy con comportamiento genérico
- [ ] IA específica por tipo de enemigo:
  - [ ] Animales (patrullaje simple)
  - [ ] Ladrones (persecución)
  - [ ] Espectros (comportamiento errático)
  - [ ] Caballeros oscuros (combate avanzado)
- [ ] Sistema de spawn semi-aleatorio controlado
- [ ] Escalado de dificultad por nivel

#### 3.4 Sistema de Hechizos y Habilidades
- [ ] Hechizo: Inspiración Divina (invulnerabilidad)
- [ ] Hechizo: Petrificación
- [ ] Hechizo: Aniquilación
- [ ] Habilidad especial: Llamada Templaria (modo anciano)
- [ ] Sistema de cooldowns y energía mágica
- [ ] VFX para cada hechizo

#### 3.5 Sistema de Virtud Templaria
- [ ] Medidor de Virtud en HUD
- [ ] Acciones que dan Virtud:
  - [ ] Ayudar a peregrinos
  - [ ] Compartir energía
  - [ ] Rezar en lugares sagrados
- [ ] Acciones que quitan Virtud:
  - [ ] Atacar inocentes
  - [ ] Ignorar peregrinos necesitados
- [ ] Sistema de evaluación al final de nivel
- [ ] Bendición o reprensión de monje/monja

#### 3.6 Sistema de NPCs e Interacciones
- [ ] Diálogos con monjes y monjas
- [ ] Sistema de misiones simples (ayudar peregrino)
- [ ] Anciano de los acertijos (preguntas morales)
- [ ] Intercambio de objetos
- [ ] Sistema de recompensas

#### 3.7 HUD y UI en Juego
- [ ] Barra de energía del jugador
- [ ] Contador de vidas
- [ ] Energía del arma
- [ ] Inventario de objetos
- [ ] Medidor de Virtud
- [ ] Objetivos activos
- [ ] Mini-mapa (opcional)

#### 3.8 Gestión de Niveles
- [ ] Sistema de carga de niveles (32 total)
- [ ] Transiciones entre pantallas
- [ ] Puntos de checkpoint
- [ ] Sistema de guardado/carga
- [ ] Progresión de etapas (niño → anciano)

**Dependencias:** Assets del Bloque 2
**Entregable:** Prototipo jugable con todas las mecánicas funcionales

---

## 🏰 BLOQUE 4: CONTENIDO DE NIVELES (Semanas 15-20)

### Objetivo
Crear y balancear los 32 niveles del juego.

### 🎨 **REQUIERE GAME DESIGNER + IA PUEDE AYUDAR**

#### 4.1 Definición de Niveles (GAME DESIGNER)
Para cada uno de los 32 niveles, definir:
- [ ] Layout del nivel (mapa en papel o Tiled)
- [ ] Ubicación de enemigos
- [ ] Ubicación de NPCs y objetos
- [ ] Objetivo de Virtud mínima
- [ ] Curva de dificultad
- [ ] Texto educativo del lugar histórico

**Estructura sugerida:**

##### FASE I: NIÑEZ (Navarra) - Niveles 1-8
- [ ] Nivel 1: Saint-Jean-Pied-de-Port (tutorial)
- [ ] Nivel 2: Roncesvalles
- [ ] Nivel 3: Zubiri
- [ ] Nivel 4: Pamplona
- [ ] Nivel 5: Puente la Reina
- [ ] Nivel 6: Estella
- [ ] Nivel 7: Los Arcos
- [ ] Nivel 8: Eunate (iglesia octogonal)

##### FASE II: ADOLESCENCIA (La Rioja/Burgos) - Niveles 9-16
- [ ] Nivel 9: Logroño
- [ ] Nivel 10: Nájera
- [ ] Nivel 11: Santo Domingo de la Calzada
- [ ] Nivel 12: Belorado
- [ ] Nivel 13: Atapuerca
- [ ] Nivel 14: Burgos (Catedral)
- [ ] Nivel 15: Castrojeriz
- [ ] Nivel 16: Frómista

##### FASE III: ADULTEZ TEMPLARIA (León/Galicia) - Niveles 17-24
- [ ] Nivel 17: Carrión de los Condes
- [ ] Nivel 18: Sahagún
- [ ] Nivel 19: León (Catedral y murallas)
- [ ] Nivel 20: Astorga
- [ ] Nivel 21: Ponferrada (Castillo Templario)
- [ ] Nivel 22: O Cebreiro
- [ ] Nivel 23: Sarria
- [ ] Nivel 24: Portomarín

##### FASE IV: ANCIANIDAD (Camino inverso) - Niveles 25-32
- [ ] Nivel 25: Santiago de Compostela (inicio del retorno)
- [ ] Nivel 26-32: Regreso por camino inverso con encuentros espectrales

#### 4.2 Implementación de Niveles (IA puede ayudar)
- [ ] Crear archivos JSON/XML de definición de niveles
- [ ] Implementar parser de niveles
- [ ] Sistema de generación procedural de elementos decorativos
- [ ] Colocar enemigos y NPCs según diseño
- [ ] Integrar textos educativos

#### 4.3 Balanceo (GAME DESIGNER + PLAYTESTING)
- [ ] Ajustar dificultad por nivel
- [ ] Balancear cantidad y tipo de enemigos
- [ ] Ajustar vida de jugador y enemigos
- [ ] Equilibrar recompensas
- [ ] Testear curva de progresión

**Dependencias:** Bloque 3 completo
**Entregable:** 32 niveles jugables y balanceados

---

## 🔧 BLOQUE 5: PULIDO Y PUBLICACIÓN (Semanas 21-26)

### Objetivo
Optimizar, testear y publicar en App Store.

### 📱 **REQUIERE DESARROLLADOR iOS EXPERIMENTADO**

#### 5.1 Optimización iOS
- [ ] Optimización de rendimiento (60 FPS mínimo)
- [ ] Reducción de uso de memoria
- [ ] Optimización de batería
- [ ] Soporte para diferentes dispositivos iOS
- [ ] Soporte para notch y safe areas
- [ ] Optimización de tamaño del .ipa

#### 5.2 Funcionalidades iOS Específicas
- [ ] Integración con Game Center
  - [ ] Logros
  - [ ] Leaderboards
- [ ] Guardado en iCloud
- [ ] Soporte para haptic feedback
- [ ] Localización (español/inglés mínimo)
- [ ] Sistema de IAPs (opcional, si hay expansiones)

#### 5.3 Testing Completo
- [ ] Testing en dispositivos reales (iPhone/iPad)
- [ ] Testing de todos los 32 niveles
- [ ] Testing de todos los sistemas
- [ ] Bug fixing
- [ ] Playtesting externo (beta testers)
- [ ] Ajustes basados en feedback

#### 5.4 Preparación para App Store (REQUIERE CUENTA DE DESARROLLADOR)
- [ ] Crear cuenta de Apple Developer ($99/año)
- [ ] Configurar certificados y profiles
- [ ] Crear App ID y provisioning
- [ ] Preparar screenshots y preview videos
- [ ] Escribir descripción de App Store
- [ ] Configurar metadata (keywords, categoría)
- [ ] Crear icono de app (1024×1024)

#### 5.5 Publicación
- [ ] Submit a App Store Review
- [ ] Responder a feedback de Apple
- [ ] Lanzamiento oficial
- [ ] Monitoreo post-lanzamiento
- [ ] Plan de updates y parches

**Dependencias:** Todos los bloques anteriores
**Entregable:** Juego publicado en App Store

---

## 📊 Resumen de Recursos Necesarios

### Equipo Mínimo Recomendado
1. **Programador/a iOS con experiencia en juegos** (1 persona, tiempo completo)
2. **Pixel Artist** (1 persona, medio tiempo durante 2 meses)
3. **Compositor/a y diseñador/a de audio** (1 persona, proyecto específico)
4. **Game Designer** (1 persona, consultoría durante desarrollo)
5. **Asistencia IA** (para código, documentación, sistemas)

### Presupuesto Estimado (rough)
- Programador iOS: $30-60k (6 meses)
- Pixel Artist: $10-15k (200 horas)
- Audio: $5-8k
- Apple Developer: $99
- Testing devices: $1-2k
- **TOTAL: ~$46-85k USD**

### Tiempo Estimado
- **Mínimo optimista:** 6 meses con equipo completo
- **Realista:** 9-12 meses
- **Conservador:** 12-18 meses

---

## 🚦 Próximos Pasos Inmediatos

### Para empezar HOY:

1. **Decidir motor de juego** (Godot vs Unity)
   - Requiere investigación y decisión del equipo humano

2. **Configurar repositorio y estructura**
   - La IA puede ayudar una vez elegido el motor

3. **Crear documentos de diseño detallado**
   - Especificaciones técnicas
   - Game Design Document completo

4. **Buscar/contratar artista pixel art**
   - Es el recurso más crítico y que más tiempo consume

5. **Crear prototipo vertical**
   - 1 nivel completo end-to-end
   - Validar concepto antes de escalar a 32 niveles

---

## 💡 Recomendación Final

Este es un proyecto **ambicioso y viable**, pero requiere:
- ✅ Equipo multidisciplinar (no solo IA)
- ✅ Presupuesto moderado ($50-80k)
- ✅ Tiempo realista (9-12 meses)
- ✅ Experiencia en desarrollo de juegos iOS

**La IA puede acelerar significativamente:**
- Programación de sistemas
- Documentación
- Estructura de código
- Testing básico

**Pero NO puede reemplazar:**
- Arte profesional
- Música original
- Game design con playtesting
- Experiencia iOS específica

### Mi recomendación: Empezar con un MVP (Minimum Viable Product)

**Fase 1 MVP: 8 niveles (Fase I: Niñez)**
- Validar concepto
- Menor inversión inicial
- Posibilidad de early access / feedback
- Si funciona, expandir a las 4 fases completas

¿Quieres que empecemos con algún bloque específico?
