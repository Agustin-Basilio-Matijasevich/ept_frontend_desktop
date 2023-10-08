

class Nota{
  final DateTime fecha;
  final int nota;

  Nota(this.fecha,this.nota);

  @override
  String toString(){
    return 'Fecha: $fecha, Nota: $nota';
  }
}