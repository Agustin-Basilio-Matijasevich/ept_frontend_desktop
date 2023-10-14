import 'package:ept_frontend/models/nota.dart';
import 'package:ept_frontend/models/pago.dart';
import 'package:ept_frontend/models/usuario.dart';
import 'package:firebase_for_all/firebase_for_all.dart';
import 'package:ept_frontend/models/curso.dart';
import 'package:flutter/material.dart';

class BusinessData {
  final FirestoreItem _db =
      FirestoreForAll.instance; //Inicializo instancia de firestore
  final StorageRef _cloud = FirebaseStorageForAll.instance
      .ref(); //Inicializo la instancia de Firebase Cloud

  //Para mi (Usa si te sirve)
  Future<UserRoles?> getUserRol(String uid) async {
    try {
      Map<String, dynamic>? usuario = await _db
          .collection("usuarios")
          .doc(uid)
          .get()
          .then((value) => value.map);

      if (usuario == null) {
        throw Exception("Documento Vacio");
      }

      return UserRoles.values
          .firstWhere((element) => element.toString() == usuario['rol']);
    } catch (e) {
      print("Error obteniendo rol de usuario. Exeption: $e");
      return null;
    }
  }

  Future<bool> esCursoyUsuario(String uid, String curso) async {
    try {
      await _db
          .collection("usuarios")
          .doc(uid)
          .collection("cursos")
          .doc(curso)
          .get();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<Curso?> getCurso(String nombre) async {
    DocRef documento = _db.collection("cursos").doc(nombre);
    Map<String,dynamic>? json;

    try {
      json = await documento.get().then((value) => value.map);
      if (json == null) {
        throw Exception('JSON NULO');
      }
    } catch (e) {
      print("No se encontro el curso. Exeption: $e");
      return null;
    }

    return Curso.fromJson(json);

  }

  double calcularDeuda(Pago pago) {
    return 10;
  }

  //Para vos Master Carter Estos Metodos Jamas Fallan
  Future<bool> crearCurso(Curso curso) async {

    //Validaciones de Negocio
    if (null != await getCurso(curso.nombre))
    {
      print("El curso ya existe.");
      return false;
    }

    //Tarea
    DocRef documento = _db.collection("cursos").doc(curso.nombre);

    try
    {
      await documento.set(curso.toJson());
    }
    catch (e)
    {
      print("Error grabando curso en la BD. Exeption: $e");
      return false;
    }

    return true;
  }

  Future<bool> pagar(Usuario usuario, Pago pago) async {
    UserRoles? flag = await getUserRol(usuario.uid);

    if (flag != UserRoles.estudiante) {
      print("El Usuario debe ser Estudiante.");
      return false;
    }

    ColRef coleccion =
        _db.collection("usuarios").doc(usuario.uid).collection("pagos");

    Map<String, String> json = {
      'tipoPago': pago.toString(),
      'monto': pago.monto.toString(),
      'fecha': pago.fecha.toIso8601String(),
    };

    try {
      await coleccion.add(json);
    } catch (e) {
      print("Error grabando Pago. Exeption: $e");
      return false;
    }

    return true;
  }

  Future<bool> cargarNota(Usuario usuario, Curso curso, Nota nota) async {
    if (!await esCursoyUsuario(usuario.uid, curso.nombre)) {
      print("El curso no esta vinculado al usuario");
      return false;
    }

    if (UserRoles.estudiante != await getUserRol(usuario.uid)) {
      print("El usuario debe ser estudiante");
      return false;
    }

    ColRef coleccion = _db
        .collection("usuarios")
        .doc(usuario.uid)
        .collection("cursos")
        .doc(curso.nombre)
        .collection("notas");

    Map<String, String> json = {
      'fecha': nota.fecha.toIso8601String(),
      'nota': nota.nota.toString(),
    };

    try {
      await coleccion.add(json);
    } catch (e) {
      print("Error Grabando Nota. Exeption: $e");
      return false;
    }

    return true;
  }

  Future<bool> adherirCurso(Usuario usuario, Curso curso) async {
    UserRoles? rol = await getUserRol(usuario.uid);

    if (rol != UserRoles.estudiante && rol != UserRoles.docente) {
      print("El usuario debe ser docente o profesor");
      return false;
    }

    if (await getCurso(curso.nombre) == null) {
      print("El curso no existe");
      return false;
    }

    DocRef documento = _db
        .collection("usuarios")
        .doc(usuario.uid)
        .collection("cursos")
        .doc(curso.nombre);

    try {
      await documento.set({});
    } catch (e) {
      print("Error adiriendo curso al usuario. Exeption: $e");
      return false;
    }

    return true;
  }

  Future<bool> esDeudor(Usuario estudiante) async {
    return true;
  }

  Future<double> getDeuda(Usuario estudiante) async {
    return 10;
  }

  Future<List<Curso>> getCursos() async {
    return [];
  }

  //Lista todos los usuarios que deben y te los devuelve con el monto de la deuda
  //Determina la deuda viendo si registran un pago en el mes corriente
  Future<List<Map<Usuario, double>>> listarDeudores() async {
    return [];
  }

  // Para agregar pantalla para no docentes. El filtrado lo hago del lado del front
  Future<List<Usuario>> listarUsuarios() async {
    return [];
  }

  Future<bool> asignarHijo(Usuario padre, Usuario hijo) async {
    UserRoles? rolpadre = await getUserRol(padre.uid);
    UserRoles? rolhijo = await getUserRol(hijo.uid);

    if (rolpadre != UserRoles.padre || rolhijo != UserRoles.estudiante) {
      print(
          "El padre debe ser un usuario de tipo padre y el hijo debe ser estudiante");
      return false;
    }

    DocRef documento1 = _db
        .collection("usuarios")
        .doc(padre.uid)
        .collection("hijos")
        .doc(hijo.uid);
    DocRef documento2 = _db
        .collection("usuarios")
        .doc(hijo.uid)
        .collection("padres")
        .doc(padre.uid);

    try {
      await documento1.set({});
      await documento2.set({});
    } catch (e) {
      print("Error asignando hijos. Exeption: $e");
      return false;
    }

    return true;
  }

  //Guarda que estos si revientan ponele un try pue
  Future<List<Usuario>> listarAlumnosPorCurso(Curso curso) async {
    return [];
  }

  //Pasame el padre y te devuelvo los hijos, ahi vas a poder buscar notas y deudas, fijate si necesitas la vuelta
  Future<List<Usuario>> getHijos(Usuario padre) async {
    return [];
  }

  Future<Map<Curso, List<Nota>>> getNotasPorCurso(
      Usuario usuario, int anio) async {
    return {};
  }
}
