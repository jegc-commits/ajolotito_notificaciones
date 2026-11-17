# RONDA 2 — Resultados TDD (Reloj + Mascota)

**Fecha:** 2026-11-16
**Stack:** Flutter 3.47.6 / Dart 3.13.5 · `flutter_test`
**Comando ejecutado:** `flutter test`
**Archivo de pruebas:** `test/mascota_test.dart`
**Implementación:** `lib/dominio/mascota.dart`, `lib/dominio/reloj.dart`

## Resumen del ciclo

| Fase | Resultado | Evidencia |
|------|-----------|-----------|
| 🔴 ROJO | `Some tests failed` — `Error: Undefined name 'Mascota'`, `'Humor' isn't a type`, `'YaEstaLlena' isn't a type` | `evidence/ronda2/01_red_test_failing.txt` + `captura_ronda2_rojo.png` |
| 🟢 VERDE | `00:00 +16: All tests passed!` | `evidence/ronda2/02_green_test_passing.txt` + `captura_ronda2_verde.png` |
| 🔵 REFACTOR | `00:00 +16: All tests passed!` (sin romper nada) | `evidence/ronda2/03_refactor_test_passing.txt` + `captura_ronda2_refactor.png` |

## Tabla de tests (16)

| # | Grupo | Test | Estado RED | Estado GREEN | Estado REFACTOR |
|---|-------|------|------------|--------------|-----------------|
| 1 | saciedad | empieza en 100 y baja 10 puntos por hora | ❌ FAIL (no compila) | ✅ PASS | ✅ PASS |
| 2 | saciedad | nunca baja de 0 | ❌ FAIL (no compila) | ✅ PASS | ✅ PASS |
| 3 | saciedad | antes del punto de partida devuelve la base (sin valores raros) | ❌ FAIL (no compila) | ✅ PASS | ✅ PASS |
| 4 | humor | feliz mientras la saciedad sea mayor a 40 | ❌ FAIL (no compila) | ✅ PASS | ✅ PASS |
| 5 | humor | hambriento justo en 40 | ❌ FAIL (no compila) | ✅ PASS | ✅ PASS |
| 6 | humor | hambriento hasta pasar 15 | ❌ FAIL (no compila) | ✅ PASS | ✅ PASS |
| 7 | humor | famélico justo en 15 | ❌ FAIL (no compila) | ✅ PASS | ✅ PASS |
| 8 | predicción | llega a 40 a las 6 horas y a 15 a las 8.5 horas | ❌ FAIL (no compila) | ✅ PASS | ✅ PASS |
| 9 | predicción | si ya estaba por debajo, devuelve el punto de partida | ❌ FAIL (no compila) | ✅ PASS | ✅ PASS |
| 10 | predicción | la predicción coincide con el cálculo de saciedad | ❌ FAIL (no compila) | ✅ PASS | ✅ PASS |
| 11 | alimentar | suma una porción (35) a lo que tenga en ese momento | ❌ FAIL (no compila) | ✅ PASS | ✅ PASS |
| 12 | alimentar | no pasa de 100 | ❌ FAIL (no compila) | ✅ PASS | ✅ PASS |
| 13 | alimentar | con 90 o más ya no quiere comer | ❌ FAIL (no compila) | ✅ PASS | ✅ PASS |
| 14 | conRitmo | cambiar el ritmo no produce saltos en la saciedad | ❌ FAIL (no compila) | ✅ PASS | ✅ PASS |
| 15 | JSON | ida y vuelta conserva todo | ❌ FAIL (no compila) | ✅ PASS | ✅ PASS |
| 16 | JSON | datos dañados o raros devuelven null, no truenan | ❌ FAIL (no compila) | ✅ PASS | ✅ PASS |

**Totales:** RED 0/16 · GREEN 16/16 · REFACTOR 16/16

## Salida VERBATIM — 🟢 VERDE

```
00:00 +0: loading /home/tahg/Documentos/GitHub/ajolotito_notificaciones/test/mascota_test.dart
00:00 +0: saciedad empieza en 100 y baja 10 puntos por hora
00:00 +1: saciedad nunca baja de 0
00:00 +2: saciedad antes del punto de partida devuelve la base (sin valores raros)
00:00 +3: humor (pruebas de frontera) feliz mientras la saciedad sea mayor a 40
00:00 +4: humor (pruebas de frontera) hambriento justo en 40
00:00 +5: humor (pruebas de frontera) hambriento hasta pasar 15
00:00 +6: humor (pruebas de frontera) famélico justo en 15
00:00 +7: predicción: ¿cuándo tendrá hambre? llega a 40 a las 6 horas y a 15 a las 8.5 horas
00:00 +8: predicción: ¿cuándo tendrá hambre? si ya estaba por debajo, devuelve el punto de partida
00:00 +9: predicción: ¿cuándo tendrá hambre? la predicción coincide con el cálculo de saciedad
00:00 +10: alimentar suma una porción (35) a lo que tenga en ese momento
00:00 +11: alimentar no pasa de 100
00:00 +12: alimentar con 90 o más ya no quiere comer
00:00 +13: cambiar el ritmo no produce saltos en la saciedad
00:00 +14: guardar y leer (JSON) ida y vuelta conserva todo
00:00 +15: guardar y leer (JSON) datos dañados o raros devuelven null, no truenan
00:00 +16: All tests passed!
```

## Erratas del manual corregidas

| # | Errata | Corrección aplicada |
|---|--------|---------------------|
| 1 | `throwsA(isA<YaEstaLlena>()` truncado | Se cerró el paréntesis: `throwsA(isA<YaEstaLlena>())` |
| 2 | `Duration(` sin cerrar en `momentoEnQueBajaA` | Se cerró con `Duration(microseconds: ...)` |
| 3 | 3 llaves `}` extra al final de `Mascota` | Bloque de clase cerrado una sola vez |
| 4 | `List<String,String>` en `mensajes.dart` (Ronda 3) | Se usará `List<(String,String)>` (records de Dart 3) |
| 5 | `tests/` | Se usa `test/` (convención Flutter); `tests/` eliminado |
| 6 | `com.android.tools.desugar_jdk_libs:2.1.4` | Coordenada Gradle válida: `com.android.tools:desugar_jdk_libs:2.1.4` |

## Notas de implementación

- `saciedadEn` usa `inMicroseconds / Duration.microsecondsPerHour` y `max(0.0, ...)` — no es un stub.
- `momentoEnQueBajaA` redondea microsegundos, por lo que `saciedadEn(momentoEnQueBajaA(40)) ≈ 40`.
- `alimentar` lanza `YaEstaLlena` con saciedad `>= 90` y limita a `maxSaciedad` (100).
- `conRitmo` conserva la saciedad actual, evitando saltos.
- `desdeTexto` valida tipo por tipo (`is`) y atrapa cualquier excepción devolviendo `null`; nunca truena.
