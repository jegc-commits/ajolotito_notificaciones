# Ajolotito Notificaciones — TDD (Rondas 1 y 2)

Repositorio de evidencia del ciclo **TDD ROJO → VERDE → REFACTOR** para el proyecto
**Ajolotito hambriento**, con el código de las **Rondas 1 y 2** tomado **literalmente**
del `Manual_TDD_AjolotitoNotificaciones.docx`.

- **Stack:** Flutter 3.47.6 · Dart 3.13.5 · `flutter_test`
- **Carpeta de pruebas:** `test/` (convención Flutter, **no** `tests/`)
- **Dominio:** `lib/dominio/` (**no** `lib/models/`)

## Alcance

El manual completo abarca **Ronda 0 a Ronda 13** (categorías, política, payload,
planificador, permisos, servicio, ViewModel, pantalla, push, etc.). Esta entrega
cubre **Ronda 1 (Setup)** y **Ronda 2 (Reloj + Mascota)** conforme a la instrucción
recibida. Las Rondas 3–13 **no** están implementadas en este repositorio.

---

## Estructura del proyecto

```
ajolotito_notificaciones/
├── pubspec.yaml
├── lib/
│   ├── main.dart
│   └── dominio/
│       ├── reloj.dart          # Reloj, RelojSistema, RelojFalso (literal del manual)
│       └── mascota.dart        # Humor, YaEstaLlena, Mascota (literal del manual)
├── test/
│   └── mascota_test.dart       # 16 pruebas (literal del manual)
├── android/app/
│   ├── src/main/AndroidManifest.xml   # 2 permisos + 2 receivers
│   └── build.gradle.kts               # desugaring
├── ios/Runner/AppDelegate.swift        # delegate de notificaciones
├── evidence/
│   ├── ronda1/
│   │   ├── 01_setup_config.txt
│   │   └── captura_ronda1_setup.png
│   └── ronda2/
│       ├── 01_red_test_failing.txt
│       ├── captura_ronda2_rojo.png
│       ├── 02_green_test_passing.txt
│       ├── captura_ronda2_verde.png
│       ├── 03_refactor_test_passing.txt
│       └── captura_ronda2_refactor.png
└── reports/
    └── RONDA2_RESULTS.md
```

---

## Ronda 1 — Setup

| Archivo | Cambio (según el manual) |
|---------|--------------------------|
| `pubspec.yaml` | `flutter_local_notifications ">=20.1.0 <24.0.0"`, `timezone: ^0.10.0`, `shared_preferences: ^2.3.0`, `app_settings: ^5.1.1`; dev: `flutter_lints: ^5.0.0` |
| `android/app/src/main/AndroidManifest.xml` | `POST_NOTIFICATIONS`, `RECEIVE_BOOT_COMPLETED`; `ScheduledNotificationReceiver` y `ScheduledNotificationBootReceiver` con intent-filters `BOOT_COMPLETED`, `MY_PACKAGE_REPLACED`, `QUICKBOOT_POWERON`, `com.htc.intent.action.QUICKBOOT_POWERON` |
| `android/app/build.gradle.kts` | `isCoreLibraryDesugaringEnabled = true` + `coreLibraryDesugaring("com.android.tools:desugar_jdk_libs:2.1.4")` |
| `ios/Runner/AppDelegate.swift` | `UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate` antes del `return` |

**Captura de la ronda:**

![Ronda 1 - Setup](evidence/ronda1/captura_ronda1_setup.png)

---

## Ronda 2 — Reloj + Mascota (TDD)

### 🔴 ROJO — el test falla primero

Se escribió `test/mascota_test.dart` **antes** de la implementación y se ejecutó
`flutter test`. Resultado real: `Some tests failed` con
`Error: Undefined name 'Mascota'`, `'Humor' isn't a type` y
`'YaEstaLlena' isn't a type`.

Log: [`evidence/ronda2/01_red_test_failing.txt`](evidence/ronda2/01_red_test_failing.txt)

![Ronda 2 - ROJO](evidence/ronda2/captura_ronda2_rojo.png)

### 🟢 VERDE — código mínimo para pasar

Se implementaron `lib/dominio/reloj.dart` y `lib/dominio/mascota.dart` con el
código del manual. Resultado real: **`00:00 +16: All tests passed!`**

Log: [`evidence/ronda2/02_green_test_passing.txt`](evidence/ronda2/02_green_test_passing.txt)

![Ronda 2 - VERDE](evidence/ronda2/captura_ronda2_verde.png)

### 🔵 REFACTOR — limpieza sin romper

`dart format lib/dominio test/mascota_test.dart` (solo formato). Resultado real:
**sigue `00:00 +16: All tests passed!`**

Log: [`evidence/ronda2/03_refactor_test_passing.txt`](evidence/ronda2/03_refactor_test_passing.txt)

![Ronda 2 - REFACTOR](evidence/ronda2/captura_ronda2_refactor.png)

### Resultado de las 16 pruebas

| Grupo | Tests | Verde |
|-------|-------|-------|
| `saciedad` | 3 | ✅ |
| `humor (pruebas de frontera)` | 4 | ✅ |
| `predicción: ¿cuándo tendrá hambre?` | 3 | ✅ |
| `alimentar` | 3 | ✅ |
| `cambiar el ritmo no produce saltos en la saciedad` | 1 | ✅ |
| `guardar y leer (JSON)` | 2 | ✅ |
| **Total** | **16** | **16/16** |

Detalle completo con estado RED/GREEN por test: [`reports/RONDA2_RESULTS.md`](reports/RONDA2_RESULTS.md)

---

## Fórmula de saciedad implementada

```dart
double saciedadEn(DateTime t) {
  if (!t.isAfter(desde)) return saciedadBase;
  final horas =
      t.difference(desde).inMicroseconds / Duration.microsecondsPerHour;
  return math.max(0.0, saciedadBase - horas * puntosPorHora);
}
```

- **Humor:** `<= 15` famélico · `<= 40` hambriento · resto feliz.
- **Predicción:** `desde + (saciedadBase - umbral) / puntosPorHora` horas.
- **Alimentar:** `+35`, tope 100; lanza `YaEstaLlena` si la saciedad es `>= 90`.
- **conRitmo:** conserva la saciedad actual y cambia el ritmo (sin saltos).
- **JSON:** `aTexto()` / `desdeTexto()` con round-trip y validación total.

---

## Verificación contra el documento real

El `.docx` se extrajo y se comparó bloque por bloque. **El documento real ya trae
las versiones correctas**; las 5 "erratas" que se habían reportado estaban en una
transcripción previa, no en el `.docx`. Estado frente al documento:

| Punto | Documento real | Repositorio |
|-------|----------------|-------------|
| `throwsA(isA<YaEstaLlena>())` | completo | ✅ completo |
| `momentoEnQueBajaA` con `Duration(...)` cerrado | cerrado | ✅ cerrado |
| Cierre de `class Mascota` | una sola llave | ✅ correcto |
| `mensajes.dart` (Ronda 3) | `List<(String, String)>` | N/A (Ronda 3 fuera de alcance) |
| Carpeta de pruebas | `test/` | ✅ `test/` |
| Coordenada Gradle | `com.android.tools:desugar_jdk_libs:2.1.4` | ✅ idéntica |

**Diferencia de alcance:** las Rondas 3–13 del documento **no** se implementaron,
porque la instrucción fue hacer únicamente Rondas 1 y 2.

---

## Cómo ejecutar

```bash
flutter pub get
flutter test
```

Salida esperada:

```
00:00 +16: All tests passed!
```
