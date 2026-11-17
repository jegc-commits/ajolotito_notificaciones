import 'package:flutter_test/flutter_test.dart';
import 'package:ajolotito/dominio/mascota.dart';

void main() {
  final t0 = DateTime(2026, 11, 12, 10, 0);
  // Mascota de referencia: empieza llena (100) y pierde 10 puntos por hora.
  final m = Mascota.nueva('X', t0);

  group('saciedad', () {
    test('empieza en 100 y baja 10 puntos por hora', () {
      expect(m.saciedadEn(t0), 100);
      expect(m.saciedadEn(t0.add(const Duration(hours: 3))), 70);
    });

    test('nunca baja de 0', () {
      expect(m.saciedadEn(t0.add(const Duration(days: 5))), 0);
    });

    test('antes del punto de partida devuelve la base (sin valores raros)', () {
      expect(m.saciedadEn(t0.subtract(const Duration(hours: 2))), 100);
    });
  });

  group('humor (pruebas de frontera)', () {
    Humor aLas(double h) =>
        m.humorEn(t0.add(Duration(minutes: (h * 60).round())));

    test('feliz mientras la saciedad sea mayor a 40', () {
      expect(aLas(5.9), Humor.feliz);
    });

    test('hambriento justo en 40', () {
      expect(aLas(6), Humor.hambriento);
    });

    test('hambriento hasta pasar 15', () {
      expect(aLas(8), Humor.hambriento);
    });

    test('famélico justo en 15', () {
      expect(aLas(8.5), Humor.famelico);
    });
  });

  group('predicción: ¿cuándo tendrá hambre?', () {
    test('llega a 40 a las 6 horas y a 15 a las 8.5 horas', () {
      expect(m.momentoEnQueBajaA(40), t0.add(const Duration(hours: 6)));
      expect(
        m.momentoEnQueBajaA(15),
        t0.add(const Duration(hours: 8, minutes: 30)),
      );
    });

    test('si ya estaba por debajo, devuelve el punto de partida', () {
      final baja = Mascota(nombre: 'X', saciedadBase: 30, desde: t0);
      expect(baja.momentoEnQueBajaA(40), t0);
    });

    test('la predicción coincide con el cálculo de saciedad', () {
      final m77 = Mascota(
        nombre: 'X',
        saciedadBase: 77,
        desde: t0,
        puntosPorHora: 7,
      );
      expect(m77.saciedadEn(m77.momentoEnQueBajaA(40)), closeTo(40, 0.001));
    });
  });

  group('alimentar', () {
    test('suma una porción (35) a lo que tenga en ese momento', () {
      final t = t0.add(const Duration(hours: 6)); // saciedad 40
      final comida = m.alimentar(t);
      expect(comida.saciedadEn(t), 75);
      expect(comida.desde, t);
    });

    test('no pasa de 100', () {
      final t = t0.add(const Duration(hours: 3)); // saciedad 70
      final comida = m.alimentar(t);
      expect(comida.saciedadEn(t), 100);
    });

    test('con 90 o más ya no quiere comer', () {
      expect(() => m.alimentar(t0), throwsA(isA<YaEstaLlena>()));
    });
  });

  test('cambiar el ritmo no produce saltos en la saciedad', () {
    final t = t0.add(const Duration(hours: 2));
    final r = m.conRitmo(t, 600);
    expect(r.saciedadEn(t), 80);
    expect(r.saciedadEn(t.add(const Duration(minutes: 1))), closeTo(70, 0.001));
  });

  group('guardar y leer (JSON)', () {
    test('ida y vuelta conserva todo', () {
      final original = Mascota(
        nombre: 'Xólotl',
        saciedadBase: 63.5,
        desde: t0,
        puntosPorHora: 12,
      );
      final copia = Mascota.desdeTexto(original.aTexto());
      expect(copia, isNotNull);
      expect(copia!.nombre, 'Xólotl');
      expect(copia.saciedadBase, 63.5);
      expect(copia.desde, t0);
      expect(copia.puntosPorHora, 12);
    });

    test('datos dañados o raros devuelven null, no truenan', () {
      expect(Mascota.desdeTexto(null), isNull);
      expect(Mascota.desdeTexto('esto no es json'), isNull);
      expect(Mascota.desdeTexto('{1,2,3}'), isNull);
      expect(Mascota.desdeTexto('{"nombre":"X"}'), isNull);
      expect(
        Mascota.desdeTexto(
          '{"nombre":"X","saciedadBase":500,"desde":"2026-01-01T00:00:00","puntosPorHora":10}',
        ),
        isNull,
      );
      expect(
        Mascota.desdeTexto(
          '{"nombre":"X","saciedadBase":50,"desde":"ayer","puntosPorHora":10}',
        ),
        isNull,
      );
      expect(
        Mascota.desdeTexto(
          '{"nombre":"X","saciedadBase":50,"desde":"2026-01-01T00:00:00","puntosPorHora":0}',
        ),
        isNull,
      );
    });
  });
}
