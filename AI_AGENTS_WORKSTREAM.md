# 🤖 Organización de Trabajo para Agentes de IA

## Objetivo
Este documento define las **líneas de trabajo paralelas** que pueden realizar diferentes agentes de IA simultáneamente para acelerar el desarrollo del proyecto.

---

## 🎯 Premisa Importante

Los agentes de IA **NO pueden** crear assets visuales ni de audio. Su trabajo se centra en:
- ✅ Arquitectura y código
- ✅ Documentación técnica
- ✅ Sistemas y lógica
- ✅ Definiciones de datos
- ✅ Testing y debugging

---

## 📋 Líneas de Trabajo Independientes

### 🔴 AGENTE 1: Arquitectura Core y Setup
**Prioridad:** CRÍTICA
**Dependencias:** Decisión de motor (Godot/Unity) por humano
**Duración estimada:** 1-2 semanas

#### Tareas:
1. **Crear estructura del proyecto iOS**
   - Configurar proyecto base en motor elegido
   - Configurar build para iOS (portrait 1080×1920)
   - Crear estructura de carpetas estándar
   - Configurar .gitignore apropiado

2. **Implementar sistemas core**
   - Sistema de gestión de escenas (SceneManager)
   - Sistema de input touch para iOS
   - Sistema de cámara side-scrolling
   - Sistema de pausa y menú básico
   - AudioManager básico

3. **Crear arquitectura base**
   - Definir patrón arquitectónico (MVC, ECS, o híbrido)
   - Crear clases base: GameEntity, Character, Enemy, NPC
   - Sistema de eventos (EventBus)
   - Sistema de configuración (GameSettings)

4. **Documentación**
   - README.md con instrucciones de setup
   - CONTRIBUTING.md con guías de código
   - Documentar arquitectura en docs/ARCHITECTURE.md

**Entregables:**
- ✅ Proyecto que compila para iOS
- ✅ Sistemas core funcionales (sin assets)
- ✅ Documentación completa de setup

---

### 🟢 AGENTE 2: Sistema de Jugador y Movimiento
**Prioridad:** ALTA
**Dependencias:** AGENTE 1 (arquitectura core)
**Duración estimada:** 2 semanas

#### Tareas:
1. **Clase Player base**
   - Sistema de movimiento lateral (left/right)
   - Sistema de salto con física realista
   - Sistema de estados (idle, walking, jumping, attacking, etc.)
   - Gestión de transformaciones (niño → anciano)

2. **Controles touch iOS**
   - Botones virtuales optimizados para touch
   - Virtual joystick (opcional)
   - Detección de gestos (swipe, tap, hold)
   - Feedback haptic

3. **Sistema de colisiones**
   - Colisión con terreno y plataformas
   - Detección de fosos (reset)
   - Zonas interactivas (NPCs, objetos)

4. **Sistema de animaciones del jugador**
   - State machine de animaciones
   - Transiciones suaves entre estados
   - Integración con sprites (preparado para cuando lleguen)

**Entregables:**
- ✅ Clase Player completamente funcional
- ✅ Controles touch pulidos
- ✅ Sistema de física y colisiones
- ✅ Tests unitarios de movimiento

---

### 🟡 AGENTE 3: Sistema de Combate y Armas
**Prioridad:** ALTA
**Dependencias:** AGENTE 2 (clase Player)
**Duración estimada:** 2 semanas

#### Tareas:
1. **Sistema de armas**
   - Clase base Weapon
   - Tipos de armas por etapa:
     - WeaponWood (niño)
     - WeaponIron (adolescente)
     - WeaponTemplar (caballero)
     - WeaponStaff (anciano)
   - Sistema de degradación (energía de arma)
   - Sistema de switching de armas

2. **Sistema de combate**
   - Ataque básico (melee)
   - Hitboxes y hurtboxes
   - Detección de impactos
   - Sistema de daño (jugador y enemigos)
   - Escudo y defensa
   - Combo system (opcional)

3. **Feedback de combate**
   - Screenshake
   - Hitstop/freeze frames
   - Partículas de impacto (placeholders)
   - Sonido de impacto (hook para audio)

4. **Sistema de energía**
   - Energía del jugador (vida)
   - Energía del arma
   - Regeneración
   - Power-ups

**Entregables:**
- ✅ Sistema de combate funcional
- ✅ Todas las armas implementadas (sin sprites finales)
- ✅ Feedback satisfactorio
- ✅ Tests de combate

---

### 🔵 AGENTE 4: Sistema de Enemigos e IA
**Prioridad:** ALTA
**Dependencias:** AGENTE 3 (sistema de combate)
**Duración estimada:** 2-3 semanas

#### Tareas:
1. **Clase base Enemy**
   - Sistema de vida y muerte
   - Integración con combate
   - Sistema de drops (objetos, energía)
   - Estados básicos (patrol, chase, attack, flee, death)

2. **Implementar tipos de enemigos específicos**
   - **Animales:**
     - EnemyCow (patrullaje simple)
     - EnemyGoat (huida al acercarse)
     - EnemyBoar (carga agresiva)
     - EnemyVulture (ataque aéreo)
     - EnemyWolf (pack behavior)

   - **Humanos:**
     - EnemyThief (persecución rápida)
     - EnemyBandit (ataque a distancia)
     - EnemyDarkKnight (combate avanzado)

   - **Espectros:**
     - EnemyShade (movimiento errático)
     - EnemyFear (basado en Virtud del jugador)
     - EnemyDemon (boss-like)

3. **Sistema de spawn**
   - SpawnManager con control semi-aleatorio
   - Waves de enemigos
   - Scaling de dificultad por nivel
   - Límite de enemigos en pantalla

4. **IA behaviors**
   - Pathfinding simple (izquierda/derecha)
   - Detección de jugador
   - Comportamientos de grupo (manada de lobos)
   - Estados reactivos (huida si poca vida)

**Entregables:**
- ✅ Sistema de enemigos modular
- ✅ ~10 tipos de enemigos funcionales
- ✅ IA básica pero efectiva
- ✅ Sistema de spawn balanceado

---

### 🟣 AGENTE 5: Sistema de Hechizos y Habilidades
**Prioridad:** MEDIA
**Dependencias:** AGENTE 3 (combate), AGENTE 4 (enemigos)
**Duración estimada:** 1-2 semanas

#### Tareas:
1. **Sistema base de hechizos**
   - Clase base Spell
   - Sistema de cooldowns
   - Costo de energía mágica
   - Hotbar de hechizos

2. **Implementar hechizos específicos**
   - **SpellDivineInspiration:** invulnerabilidad temporal
   - **SpellPetrification:** convierte enemigos en piedra
   - **SpellAnnihilation:** elimina enemigos en pantalla
   - **SpellTemplarCall:** invoca caballeros (modo anciano)

3. **VFX de hechizos**
   - Sistema de partículas placeholder
   - Animaciones de cast
   - Feedback visual

4. **Balanceo**
   - Ajustar duración y cooldowns
   - Costo de energía
   - Efectividad por tipo de enemigo

**Entregables:**
- ✅ 4 hechizos completamente funcionales
- ✅ Sistema de magia balanceado
- ✅ VFX placeholders

---

### 🟠 AGENTE 6: Sistema de Virtud y Moral
**Prioridad:** MEDIA-ALTA
**Dependencias:** AGENTE 2 (jugador), AGENTE 4 (enemigos)
**Duración estimada:** 1-2 semanas

#### Tareas:
1. **Sistema de Virtud**
   - VirtueManager que rastrea puntos de virtud
   - Acciones que dan Virtud:
     - Ayudar peregrinos
     - Compartir energía
     - Rezar en lugares santos
     - No matar animales innecesariamente
   - Acciones que quitan Virtud:
     - Atacar inocentes
     - Ignorar peregrinos en peligro
     - Comportamiento egoísta

2. **Sistema de evaluación de nivel**
   - Objetivo de Virtud por nivel
   - Evaluación al final (monje/monja)
   - Bendición (bonus) o reprensión (repetir)
   - Cinematics simples de evaluación

3. **Feedback visual de Virtud**
   - Medidor en HUD
   - Efectos visuales al ganar/perder Virtud
   - Aura del jugador según Virtud

4. **Integración con gameplay**
   - NPCs reaccionan según Virtud
   - Enemigos se comportan diferente con alta Virtud
   - Desbloqueables basados en Virtud acumulada

**Entregables:**
- ✅ Sistema de Virtud completo
- ✅ Evaluación de niveles funcional
- ✅ Feedback visual integrado

---

### 🟤 AGENTE 7: NPCs e Interacciones
**Prioridad:** MEDIA
**Dependencias:** AGENTE 6 (sistema de Virtud)
**Duración estimada:** 2 semanas

#### Tareas:
1. **Clase base NPC**
   - Sistema de diálogos
   - Estados (idle, talking, walking)
   - Integración con Virtud

2. **Tipos de NPCs específicos**
   - **NPCMonk / NPCNun:** evaluadores de nivel
   - **NPCPilgrim:** necesitan ayuda
   - **NPCElderRiddle:** acertijos morales
   - **NPCTemplar:** aliados invocables (modo anciano)
   - **NPCMerchant:** intercambio de objetos (opcional)

3. **Sistema de diálogos**
   - DialogueManager simple
   - Textos en JSON/XML
   - Opciones de diálogo (elecciones morales)
   - Integración con UI

4. **Misiones simples**
   - Quest system básico
   - Objetivos activos en HUD
   - Recompensas por ayudar NPCs

5. **Acertijos del anciano**
   - 10-15 acertijos morales
   - Sistema de preguntas y respuestas
   - Impacto en Virtud

**Entregables:**
- ✅ Sistema de NPCs modular
- ✅ 5 tipos de NPCs funcionales
- ✅ Sistema de diálogos y misiones
- ✅ 15 acertijos implementados

---

### 🔴 AGENTE 8: HUD y UI del Juego
**Prioridad:** MEDIA
**Dependencias:** AGENTE 2, 3, 6 (jugador, combate, virtud)
**Duración estimada:** 1-2 semanas

#### Tareas:
1. **HUD en juego**
   - Barra de energía del jugador
   - Contador de vidas
   - Energía del arma
   - Medidor de Virtud
   - Inventario visual (objetos y hechizos)
   - Objetivos activos
   - Mini-mapa (opcional)

2. **Menús**
   - Menú principal
   - Menú de pausa
   - Menú de configuración (audio, controles)
   - Pantalla de selección de nivel
   - Pantalla de game over
   - Pantalla de victoria

3. **Transiciones**
   - Fade in/out entre escenas
   - Transiciones de nivel
   - Animaciones de menú

4. **Optimización iOS**
   - UI adaptada a safe areas
   - Soporte para notch
   - Escalado para diferentes resoluciones

**Entregables:**
- ✅ HUD completo y funcional
- ✅ Todos los menús implementados
- ✅ UI pulida y responsive para iOS

---

### 🟢 AGENTE 9: Sistema de Niveles y Progresión
**Prioridad:** ALTA
**Dependencias:** Todos los agentes de gameplay (2-7)
**Duración estimada:** 2-3 semanas

#### Tareas:
1. **Arquitectura de niveles**
   - LevelManager que carga y gestiona niveles
   - Formato de definición de niveles (JSON/XML)
   - Sistema de tiles y plataformas

2. **Definición de datos de niveles**
   - Crear JSON schemas para:
     - Layout del nivel
     - Spawn points de enemigos
     - Ubicación de NPCs
     - Objetos y power-ups
     - Objetivo de Virtud
     - Texto educativo histórico

3. **Parser de niveles**
   - Leer archivos de definición
   - Instanciar elementos en escena
   - Validación de datos

4. **Sistema de progresión**
   - Tracking de niveles completados
   - Desbloqueo progresivo
   - Transformación del personaje (niño → anciano)
   - Guardado de progreso

5. **Transiciones entre fases**
   - Cinematics simples (texto)
   - Cambio de modelo del jugador
   - Cambio de habilidades disponibles

6. **Crear plantillas de 32 niveles**
   - Archivos JSON con estructura básica
   - Listas para ser rellenados por game designer
   - Textos históricos (investigar Camino de Santiago)

**Entregables:**
- ✅ Sistema de niveles completo
- ✅ 32 plantillas de niveles con datos básicos
- ✅ Sistema de progresión funcional
- ✅ Textos educativos de lugares históricos

---

### 🟡 AGENTE 10: Sistema de Guardado y Persistencia
**Prioridad:** MEDIA
**Dependencias:** AGENTE 9 (progresión)
**Duración estimada:** 1 semana

#### Tareas:
1. **Save system**
   - SaveManager para iOS (PlayerPrefs o serialización)
   - Estructura de datos de guardado:
     - Nivel actual
     - Virtud acumulada
     - Armas desbloqueadas
     - Hechizos disponibles
     - Estadísticas (enemigos derrotados, etc.)

2. **Auto-save**
   - Guardado automático al completar nivel
   - Guardado al salir del juego

3. **Multiple save slots (opcional)**
   - 3 slots de guardado
   - UI para seleccionar slot

4. **Integración con iCloud (opcional)**
   - Sincronización entre dispositivos iOS
   - Backup en iCloud

**Entregables:**
- ✅ Sistema de guardado robusto
- ✅ Auto-save funcional
- ✅ Integración con iOS APIs

---

### 🔵 AGENTE 11: Sistema de Audio
**Prioridad:** BAJA (hasta tener assets de audio)
**Dependencias:** Assets de audio del compositor
**Duración estimada:** 1 semana

#### Tareas:
1. **AudioManager avanzado**
   - Gestión de música por nivel/fase
   - Transiciones suaves entre tracks
   - Sistema de layers (combate, ambiente)
   - Música dinámica según momento del día

2. **SFX Manager**
   - Pools de sonidos
   - Priorización de SFX
   - 3D sound (opcional para ambiente)

3. **Configuración de audio**
   - Volumen separado (música, SFX)
   - Mute toggle
   - Persistencia de preferencias

4. **Integración**
   - Triggers de audio en eventos de juego
   - Sonido ambiente por tipo de nivel
   - Música adaptativa

**Entregables:**
- ✅ Sistema de audio completo
- ✅ Música y SFX integrados
- ✅ Configuración de audio funcional

---

### 🟣 AGENTE 12: Testing, Optimización y Documentación
**Prioridad:** CONTINUA
**Dependencias:** Todos los agentes
**Duración estimada:** Continuo + 2 semanas al final

#### Tareas:
1. **Unit Testing**
   - Tests de sistemas core
   - Tests de mecánicas de juego
   - Tests de guardado/carga
   - Cobertura >70%

2. **Integration Testing**
   - Tests de flujo completo de nivel
   - Tests de transiciones
   - Tests de UI

3. **Performance Testing**
   - Profiling de rendimiento
   - Optimización de draw calls
   - Optimización de memoria
   - Target: 60 FPS estable en iPhone 8+

4. **Documentación técnica**
   - API documentation (in-code)
   - ARCHITECTURE.md detallado
   - GAMEPLAY.md con todas las mecánicas
   - LEVEL_DESIGN_GUIDE.md
   - TROUBLESHOOTING.md

5. **Tools y utilities**
   - Level editor helper (si es posible)
   - Debug tools (god mode, level skip, etc.)
   - Performance overlay

**Entregables:**
- ✅ Suite de tests completa
- ✅ Juego optimizado para iOS
- ✅ Documentación exhaustiva
- ✅ Tools de desarrollo

---

## 📊 Orden de Ejecución Recomendado

### Fase 1: Fundamentos (Paralelo)
- AGENTE 1 (Arquitectura Core) → **CRÍTICO, EMPEZAR YA**

### Fase 2: Gameplay Core (Paralelo tras Fase 1)
- AGENTE 2 (Jugador)
- AGENTE 3 (Combate) → depende de AGENTE 2
- AGENTE 4 (Enemigos) → depende de AGENTE 3

### Fase 3: Sistemas Avanzados (Paralelo)
- AGENTE 5 (Hechizos) → depende de AGENTE 3, 4
- AGENTE 6 (Virtud) → depende de AGENTE 2, 4
- AGENTE 7 (NPCs) → depende de AGENTE 6
- AGENTE 8 (UI/HUD) → depende de AGENTE 2, 3, 6

### Fase 4: Integración (Paralelo)
- AGENTE 9 (Niveles) → depende de todos los anteriores
- AGENTE 10 (Guardado) → depende de AGENTE 9
- AGENTE 11 (Audio) → cuando lleguen assets

### Fase 5: Pulido (Continuo)
- AGENTE 12 (Testing) → durante todo el desarrollo

---

## 🔄 Sistema de Coordinación

### Comunicación entre agentes:
1. **Contratos de interfaces:** Cada agente define interfaces claras para sus sistemas
2. **Stubs y mocks:** Usar placeholders cuando falten dependencias
3. **Pull requests separados:** Cada agente trabaja en su branch
4. **Code reviews:** Revisión cruzada de código
5. **Integration meetings:** Sincronización semanal de avances

### Branch strategy:
```
main
├── develop
    ├── feature/agent1-core-architecture
    ├── feature/agent2-player-movement
    ├── feature/agent3-combat-system
    ├── feature/agent4-enemy-ai
    ├── feature/agent5-spells
    ├── feature/agent6-virtue-system
    ├── feature/agent7-npcs
    ├── feature/agent8-ui-hud
    ├── feature/agent9-level-system
    ├── feature/agent10-save-system
    ├── feature/agent11-audio
    └── feature/agent12-testing
```

---

## 💡 Notas Importantes

### Lo que los agentes NO deben intentar:
- ❌ Crear sprites o pixel art
- ❌ Componer música
- ❌ Diseñar SFX
- ❌ Hacer game design decisions sin consultar
- ❌ Publicar a App Store (requiere cuenta real)

### Lo que los agentes SÍ pueden hacer solos:
- ✅ Implementar lógica y sistemas
- ✅ Crear arquitecturas de código
- ✅ Escribir tests
- ✅ Documentar técnicamente
- ✅ Optimizar rendimiento
- ✅ Crear placeholders para assets
- ✅ Implementar algoritmos y IA
- ✅ Configurar herramientas de desarrollo

---

## 📈 Métricas de Progreso

Cada agente debe reportar:
- [ ] Tareas completadas vs. totales
- [ ] Tests passing
- [ ] Cobertura de código
- [ ] Issues encontrados
- [ ] Dependencias bloqueantes

---

## 🎯 Próximos Pasos

1. **Decidir motor:** Godot o Unity (REQUIERE DECISIÓN HUMANA)
2. **Asignar agentes:** Distribuir trabajo entre agentes disponibles
3. **Crear branches:** Cada agente en su feature branch
4. **Empezar con AGENTE 1:** La arquitectura core es bloqueante para los demás
5. **Parallelizar:** Una vez core está, lanzar AGENTES 2-4 en paralelo

---

**¿Quieres que algún agente específico empiece con su trabajo ahora?**
