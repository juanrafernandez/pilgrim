# 🧪 Guía Rápida: Probar Nivel 1

## ⚡ Inicio Rápido

### En Godot Editor

1. **Abrir proyecto**:
   ```bash
   # Abrir Godot 4.3+
   # File → Open Project → Seleccionar carpeta pilgrim/
   ```

2. **Ejecutar el nivel**:
   - Navegar a `scenes/levels/level_01.tscn` en el FileSystem
   - Hacer doble clic para abrir la escena
   - Presionar **F6** o clic en "Run Current Scene"

3. **Controles**:
   - **← →** o **A/D**: Mover
   - **Espacio** o **W**: Saltar
   - **Z** o **J**: Atacar

---

## 🎮 Qué Observar Durante la Prueba

### ✅ Checklist de Funcionalidad

- [ ] **Jugador aparece** en la posición inicial (X=150, Y=1600)
- [ ] **Cámara sigue** al jugador correctamente
- [ ] **Primer lobo NO aparece** hasta pasar X=500
- [ ] **Lobo se activa** cuando jugador se acerca (mensaje en consola)
- [ ] **Saltos funcionan** correctamente entre plataformas
- [ ] **Combate funciona** (lobo recibe daño)
- [ ] **Lobos se activan progresivamente** (no todos a la vez)
- [ ] **Decoración visible**: flecha amarilla, concha, cruz
- [ ] **Trigger final** detecta al jugador en X=4250

### 🐛 Bugs Comunes a Verificar

- [ ] Jugador **no cae** a través de plataformas
- [ ] Lobos **no quedan flotando** en el aire
- [ ] Cámara **no se sale** de los límites del nivel
- [ ] Triggers **se eliminan** después de activarse (no se repiten)
- [ ] **Death zone** funciona si el jugador cae

---

## 📝 Consola de Debug

Al ejecutar, deberías ver en la consola:

```
Player initialized - Phase: CHILD
Wolf1 spawned at (650, 1600)
Wolf2 spawned at (1600, 1480)
Wolf3A spawned at (2450, 1430)
Wolf3B spawned at (2650, 1580)
Wolf4A spawned at (3300, 1600)
Wolf4B spawned at (3850, 1600)

# Cuando jugador avanza:
Wolf1 activated!
Wolf1 detected player
Wolf1 attacking player for 15 damage
...
¡Nivel 1 completado!
```

---

## 🔍 Aspectos a Evaluar

### 1. Dificultad (Principiante)

- **¿Es demasiado fácil?** → Añadir más lobos o gaps más grandes
- **¿Es demasiado difícil?** → Reducir enemigos o dar más espacio
- **¿Se siente tutorial?** → Debería haber tiempo para aprender sin frustración

### 2. Ritmo (Pacing)

- **Sección 1**: Debe sentirse segura y exploratoria (~20 segundos)
- **Sección 2**: Introducción gradual de saltos (~30 segundos)
- **Sección 3**: Primera tensión real (~40 segundos)
- **Sección 4**: Clímax emocionante (~30 segundos)

### 3. Narrativa Visual

- **¿Se reconoce el Camino de Santiago?** (flecha, concha, cruz)
- **¿La atmósfera es de "inicio de viaje"?**
- **¿La luz final transmite esperanza/llegada?**

---

## 🎯 Objetivos de Jugabilidad

| Objetivo | ¿Cumplido? | Notas |
|----------|-----------|-------|
| Jugador aprende movimiento | ☐ | |
| Jugador aprende saltos | ☐ | |
| Jugador aprende combate | ☐ | |
| Jugador reconoce Camino | ☐ | |
| Nivel completable sin morir | ☐ | |

---

## 🛠️ Ajustes Rápidos (Si Necesario)

### Si los lobos son muy difíciles:

```gdscript
# En scripts/enemies/enemy_wolf.gd
move_speed = 150.0  # Reducir de 200
attack_damage = 10  # Reducir de 15
```

### Si los saltos son muy difíciles:

```gdscript
# En scripts/player/player.gd
JUMP_VELOCITY = -900.0  # Aumentar de -800
```

### Si el nivel es muy largo:

- Eliminar Wolf3A y Wolf3B (dejar solo 4 lobos)
- Acortar Sección 4

---

## 🚨 Errores Conocidos

### Error: "Invalid call. Nonexistent function 'set_phase'"

**Causa**: GameManager no está cargado como AutoLoad

**Solución**:
```
Project → Project Settings → AutoLoad
Añadir: scripts/core/game_manager.gd como "GameManager"
```

### Error: "Trigger no detecta al jugador"

**Causa**: Player no está en grupo "player"

**Solución**: Ya implementado en `player.gd:76`

### Error: "Lobos no se desactivan al inicio"

**Causa**: Enemigos no están en grupo "enemies"

**Solución**: Ya implementado en `enemy.gd:68`

---

## 📊 Datos a Recolectar (Testing Formal)

Si haces playtest con usuarios:

1. **Tiempo de completado**: _____ minutos
2. **Número de muertes**: _____ veces
3. **Lobos derrotados**: _____ de 6
4. **Dificultad percibida** (1-10): _____
5. **¿Entendió que es el Camino de Santiago?**: SÍ / NO
6. **Comentarios libres**:
   ________________________________

---

## ✅ Nivel Listo para Producción Cuando:

- [ ] No hay bugs de colisión
- [ ] Todos los triggers funcionan
- [ ] Dificultad apropiada para principiantes
- [ ] Duración entre 2-3 minutos
- [ ] Elementos del Camino visibles
- [ ] Transiciones suaves entre secciones

---

**Siguiente paso**: Una vez validado el diseño con placeholders, crear niveles 2-8 y luego reemplazar gráficos con pixel art.
