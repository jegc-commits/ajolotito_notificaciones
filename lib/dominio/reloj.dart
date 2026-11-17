abstract class Reloj {
  DateTime ahora();
}

class RelojSistema implements Reloj {
  const RelojSistema();
  @override
  DateTime ahora() => DateTime.now();
}

class RelojFalso implements Reloj {
  RelojFalso(this._t);
  DateTime _t;
  @override
  DateTime ahora() => _t;
  void avanzar(Duration d) => _t = _t.add(d);
  void fijar(DateTime t) => _t = t;
}
