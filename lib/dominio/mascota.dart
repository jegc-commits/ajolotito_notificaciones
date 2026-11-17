import 'dart:convert';
import 'dart:math';

/// Estado de ánimo de la mascota según su saciedad.
enum Humor { feliz, hambriento, famelico }

/// Se lanza al intentar alimentar a una mascota que ya está llena.
class YaEstaLlena implements Exception {
  const YaEstaLlena(this.nombre);
  final String nombre;
  @override
  String toString() => '$nombre ya no puede comer más';
}

/// Modelo de dominio de una mascota hambrienta.
///
/// La saciedad (0..100) baja linealmente con el tiempo según
/// [puntosPorHora]. Todas las operaciones son puras: devuelven una nueva
/// instancia en lugar de mutar el estado.
class Mascota {
  const Mascota({
    required this.nombre,
    required this.saciedadBase,
    required this.desde,
    this.puntosPorHora = 10,
  }) : assert(puntosPorHora > 0);

  /// Crea una mascota llena (saciedad 100) en el instante [ahora].
  factory Mascota.nueva(
    String nombre,
    DateTime ahora, {
    double puntosPorHora = 10,
  }) => Mascota(
    nombre: nombre,
    saciedadBase: maxSaciedad,
    desde: ahora,
    puntosPorHora: puntosPorHora,
  );

  static const double maxSaciedad = 100;
  static const double umbralHambre = 40;
  static const double umbralCritico = 15;
  static const double limiteParaComer = 90;
  static const double porcion = 35;

  final String nombre;
  final double saciedadBase;
  final DateTime desde;
  final double puntosPorHora;

  /// Saciedad en el instante [t], acotada al rango 0..100.
  double saciedadEn(DateTime t) {
    if (!t.isAfter(desde)) return saciedadBase;
    final horas =
        t.difference(desde).inMicroseconds / Duration.microsecondsPerHour;
    return max(0.0, saciedadBase - horas * puntosPorHora);
  }

  /// Humor según la saciedad en [t].
  Humor humorEn(DateTime t) {
    final s = saciedadEn(t);
    if (s <= umbralCritico) return Humor.famelico;
    if (s <= umbralHambre) return Humor.hambriento;
    return Humor.feliz;
  }

  /// Instante en que la saciedad baja a [umbral]; si ya está debajo,
  /// devuelve el punto de partida [desde].
  DateTime momentoEnQueBajaA(double umbral) {
    if (saciedadBase <= umbral) return desde;
    final horas = (saciedadBase - umbral) / puntosPorHora;
    return desde.add(
      Duration(microseconds: (horas * Duration.microsecondsPerHour).round()),
    );
  }

  /// Devuelve una mascota alimentada en [t]. Lanza [YaEstaLlena] si la
  /// saciedad ya es de [limiteParaComer] o más.
  Mascota alimentar(DateTime t) {
    final actual = saciedadEn(t);
    if (actual >= limiteParaComer) throw YaEstaLlena(nombre);
    return Mascota(
      nombre: nombre,
      saciedadBase: min(maxSaciedad, actual + porcion),
      desde: t,
      puntosPorHora: puntosPorHora,
    );
  }

  /// Devuelve una mascota con otro ritmo, sin saltos de saciedad.
  Mascota conRitmo(DateTime t, double nuevoRitmo) => Mascota(
    nombre: nombre,
    saciedadBase: saciedadEn(t),
    desde: t,
    puntosPorHora: nuevoRitmo,
  );

  Map<String, Object> toJson() => <String, Object>{
    'nombre': nombre,
    'saciedadBase': saciedadBase,
    'desde': desde.toIso8601String(),
    'puntosPorHora': puntosPorHora,
  };

  String aTexto() => json.encode(toJson());

  /// Reconstruye una [Mascota] desde JSON. Devuelve `null` ante cualquier
  /// dato inválido; nunca lanza.
  static Mascota? desdeTexto(String? texto) {
    if (texto == null || texto.isEmpty) return null;
    try {
      final data = json.decode(texto);
      if (data is! Map) return null;

      final nombre = data['nombre'];
      final saciedadBase = data['saciedadBase'];
      final desdeBruto = data['desde'];
      final puntosPorHora = data['puntosPorHora'];

      if (nombre is! String || nombre.isEmpty) return null;
      if (saciedadBase is! num ||
          saciedadBase < 0 ||
          saciedadBase > maxSaciedad) {
        return null;
      }
      if (desdeBruto is! String) return null;
      if (puntosPorHora is! num || puntosPorHora <= 0) return null;

      final desde = DateTime.tryParse(desdeBruto);
      if (desde == null) return null;

      return Mascota(
        nombre: nombre,
        saciedadBase: saciedadBase.toDouble(),
        desde: desde,
        puntosPorHora: puntosPorHora.toDouble(),
      );
    } catch (_) {
      return null;
    }
  }
}
