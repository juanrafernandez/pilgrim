# 🤖 Tareas Paralelas para Agentes IA

Este documento define tareas **independientes y aisladas** que pueden ser realizadas por diferentes agentes simultáneamente sin conflictos. Cada tarea sigue principios SOLID para minimizar dependencias.

## 📋 Índice de Tareas

- [TASK-001: Weapon Shield System](#task-001-weapon-shield-system)
- [TASK-002: NPC Monk Instances](#task-002-npc-monk-instances)
- [TASK-003: NPC Pilgrim Instances](#task-003-npc-pilgrim-instances)
- [TASK-004: Virtue HUD Component](#task-004-virtue-hud-component)
- [TASK-005: Level Transition System](#task-005-level-transition-system)
- [TASK-006: Audio Hooks System](#task-006-audio-hooks-system)
- [TASK-007: Quest System](#task-007-quest-system)
- [TASK-008: Enemy Wolf Pack AI](#task-008-enemy-wolf-pack-ai)
- [TASK-009: Weapon Repair Items](#task-009-weapon-repair-items)
- [TASK-010: Combo Visual Effects](#task-010-combo-visual-effects)

---

## TASK-001: Weapon Shield System

### 🎯 Objetivo
Implementar sistema de escudo/defensa que consume energía y permite parry con timing perfecto.

### 📁 Archivos a Crear
```
scripts/weapons/shield.gd
scripts/player/states/state_block.gd
```

### 📁 Archivos a Modificar
```
scripts/player/player.gd (añadir shield_energy variable)
scripts/player/player_state_machine.gd (registrar nuevo estado)
```

### ✅ Requisitos
1. Shield tiene energía separada (100 puntos)
2. Bloqueo consume 10 energía/segundo
3. Bloqueo reduce daño en 75%
4. Perfect parry (timing 0.2s) devuelve daño
5. Regenera 5 energía/segundo cuando no está en uso

### 🔌 Dependencias
- `scripts/player/player.gd` (leer)
- Ninguna modificación en managers

### 🧪 Testing
```gdscript
# Test casos:
1. Mantener bloqueo consume energía
2. Bloqueo sin energía no funciona
3. Perfect parry timing
4. Regeneración de energía
```

### 📊 Criterios de Aceptación
- [ ] Escudo funciona sin romper sistema de combate existente
- [ ] Nuevo estado "Block" en state machine
- [ ] Shield energy bar en HUD
- [ ] Sin conflictos con weapon system

---

## TASK-002: NPC Monk Instances

### 🎯 Objetivo
Crear instancias específicas de monjes con diálogos únicos y ubicaciones en el Camino de Santiago.

### 📁 Archivos a Crear
```
scripts/npcs/monk_roncesvalles.gd
scripts/npcs/monk_pamplona.gd
scripts/npcs/monk_logrono.gd
scenes/npcs/monk_roncesvalles.tscn
scenes/npcs/monk_pamplona.tscn
scenes/npcs/monk_logrono.tscn
```

### 📁 Archivos a Modificar
```
Ninguno (solo hereda de npc.gd)
```

### ✅ Requisitos
1. Cada monje tiene diálogo único historicamente correcto
2. Posicionados en ubicaciones reales del Camino
3. Bendiciones varían según Virtue level
4. Usan sistema de Virtue Manager para rewards

### 🔌 Dependencias
- `scripts/npcs/npc.gd` (heredar)
- `VirtueManager` (usar, no modificar)

### 📝 Datos Históricos
```gdscript
# Roncesvalles: Primera parada importante
dialogue = "Bienvenido al hospital de peregrinos de Roncesvalles..."
virtue_requirement = 100

# Pamplona: Ciudad de San Fermín
dialogue = "La ciudad de Pamplona te da la bienvenida, peregrino..."
virtue_requirement = 200

# Logroño: Región de La Rioja
dialogue = "En estas tierras de viñedos, reflexiona sobre..."
virtue_requirement = 300
```

### 📊 Criterios de Aceptación
- [ ] 3 monjes implementados con datos históricos
- [ ] Diálogos únicos y temáticos
- [ ] Sin modificar clase base NPC
- [ ] Compatible con VirtueManager

---

## TASK-003: NPC Pilgrim Instances

### 🎯 Objetivo
Crear peregrinos que necesitan ayuda con quests simples.

### 📁 Archivos a Crear
```
scripts/npcs/pilgrim_injured.gd
scripts/npcs/pilgrim_lost.gd
scripts/npcs/pilgrim_elderly.gd
scripts/quests/quest_help_pilgrim.gd
```

### 📁 Archivos a Modificar
```
Ninguno (herencia y composición)
```

### ✅ Requisitos
1. Cada peregrino tiene quest específico
2. Quests dan +100 Virtue al completar
3. Estados: WAITING → HELPED → GRATEFUL
4. Timeout si player ignora (pierde Virtue)

### 🔌 Dependencias
- `scripts/npcs/npc.gd` (heredar)
- `VirtueManager` (usar)

### 💡 Quest Ideas
```gdscript
# Pilgrim Injured
quest: "Llévame a la próxima iglesia"
reward: +100 Virtue
penalty: -50 Virtue si ignoras

# Pilgrim Lost
quest: "¿Dónde está el camino a Santiago?"
reward: +100 Virtue
penalty: -30 Virtue si das direcciones incorrectas

# Pilgrim Elderly
quest: "Ayúdame a llevar mi carga"
reward: +100 Virtue
penalty: -70 Virtue si ignoras
```

### 📊 Criterios de Aceptación
- [ ] 3 peregrinos con quests únicos
- [ ] Sistema de timeout funcional
- [ ] Penalty por ignorar
- [ ] Señales emitidas correctamente

---

## TASK-004: Virtue HUD Component

### 🎯 Objetivo
Crear componente visual para mostrar Virtud en HUD con indicador de nivel.

### 📁 Archivos a Crear
```
scripts/ui/virtue_display.gd
scenes/ui/virtue_display.tscn
```

### 📁 Archivos a Modificar
```
scripts/ui/arcade_hud.gd (añadir referencia @onready)
scenes/ui/arcade_hud.tscn (añadir hijo VirtueDisplay)
```

### ✅ Requisitos
1. Barra visual 0-1000 puntos
2. Indicador de nivel (FALLEN, SEEKER, FAITHFUL, RIGHTEOUS, EXEMPLARY)
3. Color-coded por nivel:
   - FALLEN: Rojo
   - SEEKER: Naranja
   - FAITHFUL: Amarillo
   - RIGHTEOUS: Verde claro
   - EXEMPLARY: Oro brillante
4. Animación al cambiar nivel

### 🔌 Dependencias
- `VirtueManager` (conectar señales)
- `scripts/ui/arcade_hud.gd` (añadir como hijo)

### 🎨 Visual Design
```
┌─────────────────────────────┐
│ VIRTUE: FAITHFUL (450/1000) │
│ ████████░░░░░░░░░░░░░░░░░░  │
└─────────────────────────────┘
```

### 📊 Criterios de Aceptación
- [ ] Barra actualiza con VirtueManager.virtue_changed
- [ ] Niveles tienen colores distintos
- [ ] Animación suave en transiciones
- [ ] No modifica ArcadeHUD existente

---

## TASK-005: Level Transition System

### 🎯 Objetivo
Sistema de transiciones visuales entre niveles con fade in/out y pantalla de "LEVEL COMPLETE".

### 📁 Archivos a Crear
```
scripts/ui/transition_manager.gd
scenes/ui/level_complete_screen.tscn
scripts/ui/level_complete_screen.gd
```

### 📁 Archivos a Modificar
```
project.godot (añadir TransitionManager autoload)
```

### ✅ Requisitos
1. Fade to black al terminar nivel (1 segundo)
2. Pantalla LEVEL COMPLETE muestra:
   - Score ganado
   - Virtue ganado
   - Combos totales
   - Tiempo completado
3. Fade in al nuevo nivel (1 segundo)
4. No bloquea GameManager

### 🔌 Dependencias
- `GameManager.level_completed` signal (leer)
- `ScoreManager`, `VirtueManager`, `ComboManager` (leer stats)
- No modifica managers

### 🎨 Screen Layout
```
╔═══════════════════════════╗
║    LEVEL 3 COMPLETE!      ║
║                           ║
║  Score:        +2,500     ║
║  Virtue:       +150       ║
║  Max Combo:    x12        ║
║  Time:         3:45       ║
║                           ║
║    Press SPACE            ║
╚═══════════════════════════╝
```

### 📊 Criterios de Aceptación
- [ ] Transiciones suaves sin freezes
- [ ] Stats correctos en pantalla
- [ ] Funciona con cualquier nivel
- [ ] Autoload independiente

---

## TASK-006: Audio Hooks System

### 🎯 Objetivo
Sistema de hooks para audio con placeholders (beeps) hasta tener audio real.

### 📁 Archivos a Crear
```
scripts/audio/audio_event_manager.gd
scripts/audio/audio_placeholder.gd
```

### 📁 Archivos a Modificar
```
project.godot (añadir AudioEventManager autoload)
scripts/core/audio_manager.gd (integrar hooks)
```

### ✅ Requisitos
1. Eventos de audio definidos como constantes
2. Placeholders generan beeps con frecuencias específicas:
   - HIT: 440Hz beep (0.1s)
   - DEATH: descending tone (0.5s)
   - LEVEL_UP: ascending tone (0.8s)
   - COMBO: increasing pitch per combo level
3. Fácil reemplazar placeholders con audio real
4. Sistema de volumen configurable

### 🔌 Dependencias
- `AudioManager` (modificar mínimamente)
- Señales de múltiples managers (solo escuchar)

### 💡 Event Examples
```gdscript
enum AudioEvent {
	PLAYER_HIT,
	PLAYER_DEATH,
	ENEMY_HIT,
	ENEMY_DEATH,
	COMBO_INCREMENT,
	LEVEL_COMPLETE,
	VIRTUE_GAIN,
	VIRTUE_LOSS,
	WEAPON_BREAK
}
```

### 📊 Criterios de Aceptación
- [ ] Todos los eventos tienen placeholder
- [ ] Volumen respeta settings de GameManager
- [ ] Fácil swap de beep a real audio
- [ ] No acoplado a componentes específicos

---

## TASK-007: Quest System

### 🎯 Objetivo
Sistema general de quests con tracking y rewards.

### 📁 Archivos a Crear
```
scripts/quests/quest.gd (clase base)
scripts/quests/quest_manager.gd (autoload)
scripts/quests/quest_objective.gd
scripts/ui/quest_tracker.gd
```

### 📁 Archivos a Modificar
```
project.godot (añadir QuestManager autoload)
```

### ✅ Requisitos
1. Quest tiene: ID, título, descripción, objetivos, rewards
2. Objetivos pueden ser: KILL, REACH, TALK, COLLECT
3. Tracking en tiempo real
4. UI muestra quest activo
5. Rewards automáticos al completar

### 🔌 Dependencias
- NPCs (emit quest_given signal)
- Managers (dar rewards)
- Completamente independiente de otros sistemas

### 📝 Quest Structure
```gdscript
class_name Quest:
	var id: String
	var title: String
	var description: String
	var objectives: Array[QuestObjective]
	var virtue_reward: int
	var score_reward: int
	var completed: bool = false
```

### 📊 Criterios de Aceptación
- [ ] Múltiples quests simultáneos
- [ ] Objectives track correctamente
- [ ] UI actualiza en tiempo real
- [ ] Rewards se otorgan vía managers

---

## TASK-008: Enemy Wolf Pack AI

### 🎯 Objetivo
Implementar comportamiento de manada para lobos (pack hunting).

### 📁 Archivos a Crear
```
scripts/enemies/wolf_pack_controller.gd
```

### 📁 Archivos a Modificar
```
scripts/enemies/enemy_wolf.gd (añadir pack behavior)
```

### ✅ Requisitos
1. Lobos se coordinan para rodear al jugador
2. Alpha wolf lidera el ataque
3. Pack members atacan desde diferentes ángulos
4. Si Alpha muere, pack huye temporalmente
5. Regroup después de 5 segundos

### 🔌 Dependencias
- `scripts/enemies/enemy_wolf.gd` (modificar AI)
- `scripts/enemies/enemy.gd` (heredar)
- No afecta otros enemigos

### 💡 Pack Behaviors
```gdscript
# Formation: Semicircle around player
# Alpha: Front, attacks first
# Betas: Flanks, attack 1s after alpha
# Omega: Back, distracts player

# If Alpha dies:
1. Betas become aggressive (2x damage)
2. Omega howls (summon more wolves)
3. After 10s, new Alpha emerges
```

### 📊 Criterios de Aceptación
- [ ] 3-5 lobos coordinan ataques
- [ ] Alpha diferenciado visualmente
- [ ] Pack behavior no afecta otros enemies
- [ ] Performance optimizado (max 10 wolves)

---

## TASK-009: Weapon Repair Items

### 🎯 Objetivo
Items que reparan durabilidad de armas.

### 📁 Archivos a Crear
```
scripts/items/item.gd (clase base)
scripts/items/item_whetstone.gd (afila armas)
scripts/items/item_oil.gd (lubrica, previene desgaste)
scripts/items/item_toolkit.gd (repara completamente)
scenes/items/collectible_item.tscn
```

### 📁 Archivos a Modificar
```
scripts/player/player.gd (inventory array)
```

### ✅ Requisitos
1. Items coleccionables en niveles
2. Cada item tiene efecto específico:
   - Whetstone: +25 durability
   - Oil: -50% degradación por 60s
   - Toolkit: +100% durability
3. Inventario simple (max 5 items)
4. Uso con tecla asignada

### 🔌 Dependencias
- `scripts/weapons/weapon.gd` (usar repair method)
- `scripts/player/player.gd` (añadir inventory)
- No modifica managers

### 📦 Item Properties
```gdscript
class_name Item:
	var item_name: String
	var description: String
	var icon_texture: Texture2D
	var use_effect: Callable
	var consumable: bool = true
```

### 📊 Criterios de Aceptación
- [ ] 3 tipos de items funcionan
- [ ] Inventario UI simple
- [ ] Items spawneables en niveles
- [ ] Compatible con sistema de armas

---

## TASK-010: Combo Visual Effects

### 🎯 Objetivo
Efectos visuales espectaculares para diferentes niveles de combo.

### 📁 Archivos a Crear
```
scripts/vfx/combo_effect_manager.gd
scenes/vfx/combo_hit_effect.tscn
scenes/vfx/combo_milestone_effect.tscn
```

### 📁 Archivos a Modificar
```
scripts/ui/arcade_hud.gd (trigger effects)
```

### ✅ Requisitos
1. Effect al incrementar combo:
   - x2-4: Pequeño burst azul
   - x5-9: Burst dorado con partículas
   - x10+: Explosion rainbow con slowmo
2. Milestone effects (x5, x10, x15, x20)
3. Screen flash en milestones
4. Particle system placeholder (ColorRect animado)

### 🔌 Dependencias
- `ComboManager.combo_changed` signal (escuchar)
- No modifica ComboManager

### 🎨 Effect Progression
```
x2:  ⚡ Spark
x5:  ✨ Stars
x10: 💥 Explosion
x15: 🌈 Rainbow
x20: 🔥 Fire Ring
```

### 📊 Criterios de Aceptación
- [ ] Effects escalan con combo level
- [ ] No afecta gameplay (purely visual)
- [ ] Performance optimizado
- [ ] Fácil reemplazar con sprites finales

---

## 🔧 Guía para Agentes

### Antes de Empezar una Tarea

1. **Verificar dependencias**: Asegurar que archivos base existen
2. **Leer código existente**: Entender interfaces y señales
3. **Crear branch**: `agent/task-XXX-description`
4. **No modificar managers**: Solo usar sus APIs públicas

### Durante el Desarrollo

1. **Seguir SOLID**: Single Responsibility por archivo
2. **Usar signals**: Para comunicación entre sistemas
3. **Documentar código**: Docstrings en todas las funciones públicas
4. **Testing manual**: Probar en Godot antes de commit

### Al Finalizar

1. **Commit atómico**: Un commit por tarea
2. **Mensaje descriptivo**: Seguir convenciones del repo
3. **No push a main**: Usar branch específico
4. **Marcar tarea completa**: Actualizar este archivo

### Ejemplo de Workflow

```bash
# 1. Elegir tarea
# TASK-004: Virtue HUD Component

# 2. Crear branch
git checkout -b agent/task-004-virtue-hud

# 3. Crear archivos
# scripts/ui/virtue_display.gd
# scenes/ui/virtue_display.tscn

# 4. Implementar
# ... coding ...

# 5. Probar en Godot
# F5 para ejecutar

# 6. Commit
git add scripts/ui/virtue_display.gd scenes/ui/virtue_display.tscn
git commit -m "feat(ui): add Virtue HUD component

TASK-004 implementation:
- VirtueDisplay component with level indicators
- Color-coded levels (FALLEN to EXEMPLARY)
- Smooth animations on level change
- Connected to VirtueManager signals

No modifications to existing managers."

# 7. NO push (el humano hará merge)
```

## 📊 Estado de Tareas

| Task ID | Descripción | Estado | Agente | Branch |
|---------|-------------|--------|--------|--------|
| TASK-001 | Shield System | ⬜ TODO | - | - |
| TASK-002 | Monk Instances | ⬜ TODO | - | - |
| TASK-003 | Pilgrim Instances | ⬜ TODO | - | - |
| TASK-004 | Virtue HUD | ⬜ TODO | - | - |
| TASK-005 | Level Transitions | ⬜ TODO | - | - |
| TASK-006 | Audio Hooks | ⬜ TODO | - | - |
| TASK-007 | Quest System | ⬜ TODO | - | - |
| TASK-008 | Wolf Pack AI | ⬜ TODO | - | - |
| TASK-009 | Repair Items | ⬜ TODO | - | - |
| TASK-010 | Combo VFX | ⬜ TODO | - | - |

## 🎯 Prioridades Sugeridas

### Alta Prioridad (core gameplay)
1. TASK-001: Shield System
2. TASK-004: Virtue HUD
3. TASK-007: Quest System

### Media Prioridad (content)
4. TASK-002: Monk Instances
5. TASK-003: Pilgrim Instances
6. TASK-008: Wolf Pack AI

### Baja Prioridad (polish)
7. TASK-005: Level Transitions
8. TASK-009: Repair Items
9. TASK-010: Combo VFX
10. TASK-006: Audio Hooks

---

**Última actualización**: 2025-01-15
**Mantenedor**: Claude Code
**Para questions**: Ver CLAUDE.md
