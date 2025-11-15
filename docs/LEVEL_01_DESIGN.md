# Nivel 1: "El Inicio del Camino"

## 📍 Información General

- **Nombre**: El Inicio del Camino
- **Ubicación narrativa**: Saint-Jean-Pied-de-Port → Roncesvalles
- **Fase del jugador**: Niñez (Fase 1)
- **Dificultad**: Principiante (Tutorial)
- **Duración estimada**: 2-3 minutos
- **Archivo**: `scenes/levels/level_01.tscn`

---

## 🎯 Objetivos Pedagógicos

Este nivel funciona como **tutorial suave** donde el jugador aprende:

1. ✅ **Movimiento básico** (izquierda/derecha)
2. ✅ **Saltos** (timing y distancias)
3. ✅ **Combate básico** (ataque melee)
4. ✅ **Priorización de amenazas** (múltiples enemigos)
5. ✅ **Reconocimiento del Camino de Santiago** (elementos visuales)

---

## 🗺️ Estructura del Nivel

### Dimensiones Totales

- **Ancho total**: 4500 px (~4.2 pantallas en horizontal)
- **Alto**: 1920 px (resolución portrait iOS)
- **Resolución**: 1080×1920 portrait
- **Scroll**: Horizontal (izquierda → derecha)

### Mapa Visual

```
SECCIÓN 1 (0-1000px)       SECCIÓN 2 (1000-1800px)     SECCIÓN 3 (1800-3100px)      SECCIÓN 4 (3100-4500px)
Introducción Segura        Saltos Básicos              Combate + Plataformas         Mini-Desafío Final
════════════════════       ═══════════════════         ══════════════════════        ═══════════════════

    🏁START                      🪨                          🪨                           🏆
     👦                         👦                         👦🐺                         👦  FINAL
  ════════════                 ════   ══   ════           ════  🌉  ═══                ════   🪨   ═════
                                                                                                    LIGHT
     🐺                        🐺                          🐺                         🐺          🐺
  ══════════════════════   ══════════════════════    ═══════════════════════    ══════════════════════

    Lobo inicial               Lobo patrullando          2 lobos (alto+bajo)        2 lobos simultáneos
    (quieto, seguro)          (en plataforma)           (elección táctica)          (desafío final)
```

**Leyenda**:
- `👦` = Jugador (Player)
- `🐺` = Lobo (Wolf Enemy)
- `═` = Suelo / Plataforma
- `🌉` = Puente de tronco
- `🪨` = Plataforma elevada
- `🏁` = Punto de inicio
- `🏆` = Meta / Final

---

## 📐 Secciones Detalladas

### 🟦 SECCIÓN 1: Introducción Segura (0-25%)

**Posición X**: 0 - 1000 px

**Objetivo**: Aclimatación sin peligro

**Terreno**:
- Plataforma continua y segura (1000 px)
- Sin gaps ni huecos
- Altura: 1700 px

**Decoración**:
- 🏹 **Cartel con flecha amarilla** (Camino de Santiago) en X=250
- 🐚 **Concha de peregrino** colgada en X=500
- 🌲 Árbol decorativo en X=700

**Enemigos**:
- **1 Lobo** en X=650
- Aparece cuando jugador llega a X=500 (trigger)
- Distancia segura para reaccionar

**Atmósfera**:
- Cielo azul grisáceo (#3A4A5A)
- Montañas al fondo
- Bosque ligero

---

### 🟧 SECCIÓN 2: Saltos Básicos (25-50%)

**Posición X**: 1000 - 1800 px

**Objetivo**: Enseñar saltos y timing

**Terreno**:
- 3 plataformas flotantes:
  - Platform1: X=1200, Y=1600 (200px ancho)
  - Platform2: X=1500, Y=1550 (200px ancho, más alta)
  - Platform3: X=1800, Y=1650 (250px ancho)
- Gaps pequeños (~100-200px)

**Decoración**:
- 🌲 Árbol en X=1400
- ✝️ **Cruz de Santiago** en X=1900

**Enemigos**:
- **1 Lobo** patrullando en Platform2 (X=1600, Y=1480)
- Aparece cuando jugador llega a X=1300 (trigger)
- Movimiento lento y predecible

---

### 🟨 SECCIÓN 3: Combate + Plataformas (50-75%)

**Posición X**: 1800 - 3100 px

**Objetivo**: Primer momento de tensión controlada

**Terreno**:
- Suelo continuo X=2100-2700 (600px)
- 🌉 **Tronco caído como puente** en X=2750 (300px)
- 2 plataformas:
  - Platform4High: X=2400, Y=1500 (180px, elevada)
  - Platform4Low: X=2600, Y=1650 (180px, baja)

**Decoración**:
- 🌲 Árbol oscuro en X=2200
- 🪨 **Roca con símbolo templario** en X=2800

**Enemigos**:
- **Lobo A** en plataforma alta (X=2450, Y=1430)
- **Lobo B** en plataforma baja (X=2650, Y=1580)
- Aparecen con trigger en X=2300
- ⏱️ Delay de 0.8s entre activaciones

**Mecánica clave**:
- Primera **elección táctica**: ¿atacar o saltar?
- Enseña priorización de amenazas

---

### 🟥 SECCIÓN 4: Mini-Desafío Final (75-100%)

**Posición X**: 3100 - 4500 px

**Objetivo**: Cierre emocionante pero justo

**Terreno**:
- Suelo X=3100-3600 (500px)
- Plataforma elevada: X=3650, Y=1550 (250px)
- Suelo final X=3950-4500 (550px)

**Decoración**:
- 🌲 Árbol grande en X=3200
- 💡 **Luz cálida de Roncesvalles** en X=4100-4400 (efecto visual)

**Enemigos**:
- **Lobo A** desde la izquierda (X=3300, Y=1600)
- **Lobo B** desde la derecha (X=3850, Y=1600)
- Aparecen simultáneamente con trigger en X=3150
- NO atacan a la vez si el jugador no lo fuerza

**Recompensa**:
- Trigger de completado en X=4250
- Mensaje: "¡Nivel 1 completado!"

---

## 🎨 Paleta de Colores (Placeholders)

| Elemento | Color | Código Hex |
|----------|-------|------------|
| **Cielo** | Azul grisáceo | `#3A4A5A` |
| **Montañas** | Azul oscuro | `#2D3540` |
| **Bosque fondo** | Verde oscuro | `#2D5016` |
| **Suelo** | Marrón tierra | `#665544` |
| **Plataformas** | Piedra clara | `#887766` |
| **Flecha amarilla** | Amarillo Camino | `#CCC033` |
| **Concha** | Beige claro | `#EEDDBB` |
| **Cruz** | Marrón madera | `#996644` |
| **Luz final** | Naranja cálido | `#FFEEBBAA` |

---

## 🐺 Enemigos: Sistema de Triggers

### Configuración de Lobos

Todos los enemigos **empiezan desactivados** (invisibles, sin IA).

| Lobo | Posición (X, Y) | Trigger X | Tipo |
|------|----------------|-----------|------|
| **Wolf1** | (650, 1600) | 500 | Inicial - quieto |
| **Wolf2** | (1600, 1480) | 1300 | Patrulla |
| **Wolf3A** | (2450, 1430) | 2300 | Alto (0.0s) |
| **Wolf3B** | (2650, 1580) | 2300 | Bajo (0.8s delay) |
| **Wolf4A** | (3300, 1600) | 3150 | Izquierda |
| **Wolf4B** | (3850, 1600) | 3150 | Derecha |

### Sistema de Activación

```gdscript
# Cuando el jugador entra en trigger:
func _on_trigger_wolf1_entered(body: Node2D) -> void:
    if body.is_in_group("player"):
        wolf_1.set_active(true)  # Activa lobo
        trigger.queue_free()     # Elimina trigger
```

---

## 🎮 Controles del Jugador

| Acción | Tecla/Input |
|--------|-------------|
| **Mover izquierda/derecha** | ← → o A/D |
| **Saltar** | Espacio o W |
| **Atacar** | Z o J |

**Estadísticas Fase NIÑO**:
- Salud: 80 HP
- Daño: 8
- Arma: Madera
- Velocidad: 400 px/s
- Velocidad de salto: -800 px/s

---

## 🧪 Cómo Probar el Nivel

### Opción 1: Desde Godot Editor

1. Abrir proyecto en Godot 4.3+
2. Navegar a `scenes/levels/level_01.tscn`
3. Presionar **F6** (Run Current Scene)
4. Jugar con teclado

### Opción 2: Desde SceneManager

```gdscript
# En cualquier script con acceso a SceneManager:
SceneManager.load_level(1)
```

### Opción 3: Añadir al menú principal

Cuando se cree el menú de selección de niveles, incluir:
```gdscript
func _on_level_1_button_pressed():
    SceneManager.load_level(1)
```

---

## ✅ Elementos Implementados

### Sistemas Funcionales

- ✅ 4 secciones de terreno con progresión de dificultad
- ✅ 6 lobos con triggers de activación
- ✅ Sistema de plataformas con gaps
- ✅ Decoración del Camino de Santiago:
  - Flecha amarilla
  - Concha de peregrino
  - Cruz de Santiago
  - Roca con símbolo templario
- ✅ Cámara con scroll horizontal
- ✅ Death zone (caída = muerte)
- ✅ Trigger de finalización
- ✅ Capas de fondo (parallax básico)

### Sistemas por Implementar (Futuros)

- ⏳ Pantalla de transición al completar
- ⏳ Sistema de puntuación visible
- ⏳ Pickups (salud, puntos)
- ⏳ Efectos de partículas (polvo, luz)
- ⏳ Audio (música, efectos)
- ⏳ Animaciones de placeholders → pixel art
- ⏳ Parallax avanzado en fondos

---

## 🎯 Criterios de Éxito

Un jugador **completa exitosamente** el nivel si:

1. ✅ Aprende a moverse y saltar sin frustrarse
2. ✅ Derrota al menos 3 de los 6 lobos
3. ✅ Reconoce elementos del Camino de Santiago
4. ✅ Llega al trigger final (X=4250)

Un jugador **falla** si:

- ❌ Cae al abismo (death zone Y=2100)
- ❌ Pierde toda la vida (0 HP)

---

## 📊 Métricas de Diseño (Para Testing)

| Métrica | Valor Objetivo | Actual |
|---------|----------------|--------|
| **Duración promedio** | 2-3 minutos | Por medir |
| **Tasa de muerte** | <30% en 1er intento | Por medir |
| **Enemigos derrotados** | Mínimo 3/6 | Por medir |
| **Saltos exitosos** | >80% | Por medir |
| **Satisfacción** | Tutorial claro | Por medir |

---

## 🔧 Notas Técnicas

### Archivos Relacionados

```
scenes/levels/level_01.tscn       # Escena principal del nivel
scripts/levels/level_01.gd        # Lógica del nivel (triggers, eventos)
scripts/levels/level_controller.gd # Clase base para niveles (no usada aquí)
scenes/enemies/enemy_wolf.tscn    # Enemigo lobo
scripts/enemies/enemy.gd          # Clase base Enemy (con set_active())
scripts/player/player.gd          # Jugador (grupo "player")
```

### Capas de Colisión

- **Capa 1** (Player): Jugador
- **Capa 2** (Ground): Suelo y plataformas
- **Capa 0** (Triggers): Zonas de activación (sin colisión)

### Grupos

- `"player"` - Jugador (para detección de triggers)
- `"enemies"` - Todos los enemigos (para gestión del nivel)

---

## 🚀 Próximos Pasos (Post-Nivel 1)

1. **Crear niveles 2-8** (Fase Niñez restante)
2. **Implementar pantallas de transición** entre niveles
3. **Añadir sistema de guardado** (checkpoint entre niveles)
4. **Menú de selección de niveles**
5. **Reemplazar placeholders con pixel art** (según PLACEHOLDER_STRATEGY.md)
6. **Añadir audio y música**
7. **Testeo con jugadores reales**

---

## 📝 Changelog

| Fecha | Versión | Cambios |
|-------|---------|---------|
| 2025-11-15 | 1.0 | Nivel 1 completado con placeholders |

---

**Diseñado con principios retro de Maldita Castilla, Ghost'n'Goblins y Castlevania**
**Creado para**: Camino Maldito - La Cruz del Peregrino
**Plataforma**: iOS (Portrait 1080×1920)
