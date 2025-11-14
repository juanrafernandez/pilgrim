# Controles del Juego - Camino Maldito

## Controles de Teclado (para pruebas en PC)

### Movimiento Básico
- **← (Flecha Izquierda)**: Mover a la izquierda
- **→ (Flecha Derecha)**: Mover a la derecha
- **A**: Saltar
- **S**: Atacar

### Habilidades Especiales (Próximamente)
- **D**: Dash / Evasión rápida
- **W**: Habilidad especial (varía por fase de vida)
- **E**: Interactuar con NPCs y objetos

### Sistema
- **ESC**: Pausa / Volver al menú

### Controles de Prueba (Solo en escenas de test)
- **K**: Recibir daño (test de sistema de vida)
- **L**: Cambiar fase de vida (test de progresión)

---

## Controles Táctiles (iOS - En Desarrollo)

Los controles táctiles se implementarán en una fase posterior:

### Controles Virtuales
- **Joystick virtual izquierdo**: Movimiento (izquierda/derecha)
- **Botón A (derecha inferior)**: Saltar
- **Botón S (derecha centro)**: Atacar
- **Botón D (derecha superior)**: Dash
- **Botón W (derecha superior-izquierda)**: Habilidad especial
- **Icono pausa (superior derecha)**: Menú de pausa

### Gestos (Opcional)
- **Swipe hacia arriba**: Saltar
- **Tap en enemigo**: Atacar en esa dirección
- **Double tap**: Dash en la dirección de movimiento

---

## Notas de Diseño

1. **Simplicidad**: El juego está diseñado para ser jugable con una sola mano en móvil
2. **Feedback táctil**: Se usará vibración en iOS para reforzar acciones (ataque, daño recibido)
3. **Accesibilidad**: Los botones táctiles serán configurables en tamaño y posición
4. **Auto-ataque (Opcional)**: Modo para jugadores casuales que ataca automáticamente al enemigo más cercano

---

## Mapeo de Acciones en Godot

Las acciones definidas en `project.godot`:

```gdscript
move_left      -> Flecha Izquierda (4194319)
move_right     -> Flecha Derecha (4194321)
jump           -> A (65)
attack         -> S (83)
dash           -> D (68) [Próximamente]
special        -> W (87) [Próximamente]
interact       -> E (69)
pause          -> ESC (4194305)
```

---

**Última actualización**: 2025-11-14
**Versión**: v0.1.0 - Prototipo
