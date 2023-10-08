

class Nota{
  final String nombrecurso;
  final int nota;

  Nota(this.nombrecurso,this.nota);

  @override
  String toString(){
    return 'Nombre del Curso: $nombrecurso, Nota: $nota';
  }
}