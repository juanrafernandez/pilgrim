# 🚀 Guía de Instalación Rápida - Godot 4.x para iOS

## ⏱️ Tiempo estimado: 30-60 minutos

---

## ✅ Checklist Antes de Empezar

Verifica que tienes:
- [ ] **Mac** con macOS 12.0 o superior
- [ ] **Conexión a Internet** (para descargas)
- [ ] **Espacio en disco:** ~5 GB libres
- [ ] **(Opcional) Apple Developer Account** - $99/año (solo necesario para publicar, no para desarrollar)

---

## 📥 Paso 1: Instalar Xcode (OBLIGATORIO para iOS)

### Opción A: Desde App Store (recomendado)
1. Abre **App Store**
2. Busca "Xcode"
3. Click en **Obtener/Descargar** (es gratis)
4. Espera a que instale (~12 GB, tarda 30-60 minutos)

### Opción B: Desde línea de comandos
```bash
# Instalar Command Line Tools (más rápido, pero Xcode completo es mejor)
xcode-select --install
```

### Verificar instalación:
```bash
xcode-select -p
# Debería mostrar: /Applications/Xcode.app/Contents/Developer

xcodebuild -version
# Debería mostrar: Xcode 14.x o superior
```

---

## 🎮 Paso 2: Descargar Godot 4.3+

### Descarga Directa:
1. Ve a: **https://godotengine.org/download/macos/**
2. Descarga **Godot Engine - Standard Version** (NO .NET)
   - Archivo: `Godot_v4.3-stable_macos.universal.zip` (~100 MB)

### Instalación:
```bash
# 1. Descomprimir el .zip (doble click o desde terminal)
cd ~/Downloads
unzip Godot_v4.3-stable_macos.universal.zip

# 2. Mover a Aplicaciones
mv Godot.app /Applications/

# 3. Primera ejecución (macOS pedirá permiso)
open /Applications/Godot.app
```

**⚠️ Problema común en macOS:**
Si aparece "Godot no se puede abrir porque es de un desarrollador no identificado":

```bash
# Solución:
xattr -cr /Applications/Godot.app
```

O manualmente:
1. System Preferences → Security & Privacy
2. Click "Open Anyway"

---

## 📂 Paso 3: Crear Proyecto Godot

### Opción A: Desde Godot Editor (GUI)

1. Abre **Godot**
2. Click en **New Project**
3. Configura:
   - **Project Name:** `Camino Maldito`
   - **Project Path:** Selecciona la carpeta `pilgrim` de tu repositorio
   - **Renderer:** Forward+ (mejor calidad) o Mobile (mejor rendimiento)
   - **Version Control:** Git
4. Click **Create & Edit**

### Opción B: Desde Terminal

```bash
# Navegar al repositorio
cd /ruta/a/pilgrim

# Crear proyecto.godot manualmente
touch project.godot

# Abrir con Godot
open -a Godot .
```

---

## 📱 Paso 4: Configurar Exportación iOS

### Dentro de Godot Editor:

1. **Descargar Export Templates:**
   - Editor → Manage Export Templates
   - Click **Download and Install**
   - Espera a que descargue (~400 MB)

2. **Configurar iOS Export:**
   - Project → Export
   - Click **Add...** → iOS
   - Configura:
     ```
     App Name: Camino Maldito
     Bundle Identifier: com.tudominio.caminomaldito
     Display Name: Camino Maldito

     Orientation:
     ✅ Portrait
     ❌ Landscape Left
     ❌ Landscape Right

     Screen:
     Width: 1080
     Height: 1920
     ```

3. **Configurar Opciones Avanzadas:**
   - Required Icons: Dejar por defecto (configuraremos después)
   - Capabilities: Por ahora ninguna
   - Privacy: Dejar vacío

---

## 🎨 Paso 5: Configurar Proyecto para Portrait 1080×1920

### En Godot Editor:

1. **Project → Project Settings**
2. **Display → Window:**
   ```
   Width: 1080
   Height: 1920
   Mode: Windowed (para desarrollo en Mac)
   Resizable: On

   Stretch:
   Mode: viewport
   Aspect: keep
   ```

3. **Rendering → Textures:**
   ```
   Default Texture Filter: Nearest (para pixel art)
   ```

---

## ✅ Paso 6: Verificar que Todo Funciona

### Test 1: Crear escena simple

```gdscript
# 1. En Godot: Scene → New Scene → 2D Scene
# 2. Agregar un Sprite2D como hijo
# 3. En Inspector, Sprite2D → Texture → crear ColorRect simple
# 4. Guardar: scenes/test.tscn
# 5. Presionar F5 para correr

# Si ves ventana 1080×1920 con tu sprite: ✅ FUNCIONA
```

### Test 2: Exportar para iOS (opcional, requiere Xcode)

```bash
# Desde Godot:
# Project → Export → iOS → Export Project
# Elige carpeta: builds/ios
# Click Export

# Si genera carpeta con .xcodeproj: ✅ FUNCIONA
```

---

## 🐛 Troubleshooting

### Problema: "Godot no abre"
**Solución:**
```bash
xattr -cr /Applications/Godot.app
```

### Problema: "Export templates not found"
**Solución:**
- Editor → Manage Export Templates → Download and Install
- O descargar manualmente de: https://godotengine.org/download

### Problema: "iOS export failed"
**Solución:**
- Verifica que Xcode esté instalado: `xcodebuild -version`
- Verifica Command Line Tools: `xcode-select -p`
- Reinstala: `xcode-select --install`

### Problema: "Code signing error"
**Solución:**
- Por ahora ignóralo (solo necesario para dispositivo real)
- Puedes testear en simulador sin firma

---

## 📚 Recursos Útiles

### Documentación Oficial:
- **Godot Docs:** https://docs.godotengine.org/en/stable/
- **iOS Export:** https://docs.godotengine.org/en/stable/tutorials/export/exporting_for_ios.html
- **GDScript:** https://docs.godotengine.org/en/stable/tutorials/scripting/gdscript/

### Tutoriales Recomendados:
- **Godot 2D Platformer Tutorial:** https://www.youtube.com/watch?v=LOhfqjmasi0
- **Pixel Art in Godot:** https://www.youtube.com/watch?v=vnEhhFM0JGw

### Comunidad:
- **Discord Godot:** https://discord.gg/godotengine
- **Reddit:** r/godot
- **Forum:** https://forum.godotengine.org

---

## ✅ Checklist Final

Antes de continuar al desarrollo, verifica:

- [ ] Godot 4.3+ instalado y abre correctamente
- [ ] Xcode instalado (verificado con `xcodebuild -version`)
- [ ] Proyecto Godot creado en carpeta `pilgrim`
- [ ] Export templates descargados
- [ ] iOS export configurado (aunque no funcione aún)
- [ ] Proyecto configurado para 1080×1920 portrait
- [ ] Puedes correr proyecto presionando F5

---

## 🎯 ¿Todo Listo?

Si todos los checks están ✅, estás listo para que **AGENTE 1** empiece a crear la arquitectura del juego.

**Siguiente paso:** Notifica que has completado la instalación y podemos empezar con el desarrollo.

---

## 💡 Notas Importantes

### Apple Developer Account (NO necesario ahora):
- **Costo:** $99/año
- **Necesario para:**
  - Testear en iPhone/iPad real
  - Publicar en App Store
- **NO necesario para:**
  - Desarrollo en Mac
  - Testear en simulador
  - Exportar el proyecto

**Recomendación:** Espera a tener prototipo funcional antes de pagar.

### Versiones:
- Godot 4.3+ (estable)
- Xcode 14.0+
- macOS 12.0+

Si tienes versiones más antiguas, actualiza.

---

**¿Problemas durante instalación?** Documenta el error exacto y pide ayuda.
