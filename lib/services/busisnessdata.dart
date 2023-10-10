import 'package:ept_frontend/models/nota.dart';
import 'package:ept_frontend/models/pago.dart';
import 'package:ept_frontend/models/usuario.dart';
import 'package:firebase_for_all/firebase_for_all.dart';
import 'package:ept_frontend/models/curso.dart';

class BusisnessData{
  final FirestoreItem _db = FirestoreForAll.instance; //Inicializo instancia de firestore
  final StorageRef _cloud = FirebaseStorageForAll.instance.ref(); //Inicializo la instancia de Firebase Cloud

  Future<bool> crearCurso(Curso curso) async {
    return true;
  }

  Future<bool> pagar(Usuario usuario, Pago pago) async {
    return true;
  }

  Future<bool> cargarNota(Usuario usuario, Curso curso, Nota nota) async {
    return true;
  }

  Future<bool> adherirCurso(Usuario usuario, Curso curso) async {
    return true;
  }

  Future<List<Usuario>> listarAlumnosPorCurso(Curso curso) async{
    return [];
  }

  double calcularDeuda(Pago pago){
    return 10;
  }

  //Lista todos los usuarios que deben y te los devuelve con el monto de la deuda
  //Determina la deuda viendo si registran un pago en el mes corriente
  Future<List<Map<Usuario,double>>> listarDeudores() async {
    return [];
  }

  Future<bool> esDeudor(Usuario estudiante) async{
    return true;
  }

  Future<double> getDeuda(Usuario estudiante) async {
    return 10;
  }

  Future<List<Curso>> getCursos() async {
    return [];
  }

  // Para agregar pantalla para no docentes. El filtrado lo hago del lado del front
  Future<List<Usuario>> listarUsuarios() async {
    return [];
  }

  //Pasame el padre y te devuelvo los hijos, ahi vas a poder buscar notas y deudas, fijate si necesitas la vuelta
  Future<List<Usuario>> getHijos(Usuario padre) async {
    return [];
  }

  Future<bool> asignarHijo(Usuario padre,Usuario hijo) async {
    return true;
  }

  Future<List<Nota>> getNotas(Usuario estudiante) async {
    return [];
  }

}