import 'package:ept_frontend/models/nota.dart';
import 'package:ept_frontend/models/pago.dart';
import 'package:ept_frontend/models/usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
    try
    {
      Map<String, dynamic>? usuario = await _db.collection("usuarios").doc(uid).get().then((value) => value.map);

      if (usuario == null)
      {
        throw Exception("Documento Vacio");
      }

      return UserRoles.values.firstWhere((element) => element.toString() == usuario['rol']);
    }
    catch (e)
    {
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

  double calcularDeuda(Pago? pago) {

    if (pago == null)
      {
        return 15000;
      }

    double pagofinal = 0;
    const double cuota = 10000;
    final DateTime fechapago = pago.fecha;
    final DateTime fechaact = DateTime.now();

    if (fechapago.month == fechaact.month)
      {
        return 0;
      }
    else
      {
        int mesesatraso = (fechaact.month - fechapago.month) - 1;

        for (int i = 0; i < mesesatraso; i++)
          {
            pagofinal += cuota * 1.2;
          }

        if (fechaact.day > 15)
          {
            pagofinal += cuota * 1.1;
          }
        else
          {
            pagofinal += cuota;
          }

        return pagofinal;

      }

  }

  Future<Pago?> getUltPago(String uid) async {
    try
    {
      List<DocumentSnapshotForAll<Map<String, Object?>>> documentos = await _db.collection('usuarios').doc(uid).collection('pagos').orderBy('fecha', descending: true).limit(1).get().then((value) => value.docs);

      Map<String,dynamic>? pago = documentos.first.map;

      if (pago == null)
        {
          throw Exception('No tiene Pagos Realizados.');
        }

      return Pago.fromJson(pago);

    }
    catch (e)
    {
      print("Error al recuperar ultimo Pago. Exeption: $e");
      return null;
    }
  }

  Future<bool> esDeudor(String uid) async {
    Pago? pago = await getUltPago(uid);

    if (pago != null)
      {
        if (pago!.fecha.month == DateTime.now().month)
          {
            return false;
          }
        else
          {
            return true;
          }
      }
    else
      {
        return true;
      }

  }

  Future<bool> esHijo (String padre, String hijo) async {

    try
    {
      await _db.collection("usuarios").doc(padre).collection("hijos").doc(hijo).get();
      await _db.collection("usuarios").doc(hijo).collection("padres").doc(padre).get();
      return true;
    }
    catch (e)
    {
      return false;
    }
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

    //validaciones Negocio
    if (await getUserRol(usuario.uid) != UserRoles.estudiante || !await esDeudor(usuario.uid))
      {
        print("El usuario no es estudiante o no es deudor.");
        return false;
      }

    //Tarea
    ColRef coleccion = _db.collection("usuarios").doc(usuario.uid).collection("pagos");

    Map<String, dynamic> json = pago.toJson();

    try
    {
      await coleccion.add(json);
    }
    catch (e)
    {
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

    //Tarea
    ColRef coleccion = _db.collection("usuarios").doc(usuario.uid).collection("cursos").doc(curso.nombre).collection("notas");

    Map<String, dynamic> json = nota.toJson();

    try {
      await coleccion.add(json);
    } catch (e) {
      print("Error Grabando Nota. Exeption: $e");
      return false;
    }

    return true;
  }

  Future<bool> adherirCurso(Usuario usuario, Curso curso) async {
    //Validaciones Negocio
    UserRoles? rol = await getUserRol(usuario.uid);

    if (rol != UserRoles.estudiante && rol != UserRoles.docente) {
      print("El usuario debe ser docente o profesor");
      return false;
    }

    if (await getCurso(curso.nombre) == null) {
      print("El curso no existe");
      return false;
    }

    if (await esCursoyUsuario(usuario.uid, curso.nombre)) {
      print("El curso ya esta vinculado al usuario");
      return false;
    }

    //Tarea
    DocRef documento = _db.collection("usuarios").doc(usuario.uid).collection("cursos").doc(curso.nombre);

    try {
      await documento.set({});
    } catch (e) {
      print("Error adiriendo curso al usuario. Exeption: $e");
      return false;
    }

    return true;
  }

  Future<bool> asignarHijo(Usuario padre, Usuario hijo) async {

    //Validaciones Negocio
    UserRoles? rolpadre = await getUserRol(padre.uid);
    UserRoles? rolhijo = await getUserRol(hijo.uid);

    if (rolpadre != UserRoles.padre || rolhijo != UserRoles.estudiante) {
      print("El padre debe ser un usuario de tipo padre y el hijo debe ser estudiante");
      return false;
    }

    if (await esHijo(padre.uid, hijo.uid))
      {
        print("Ya estan vinculados como padre e hijo");
        return false;
      }

    //Tarea
    DocRef documento1 = _db.collection("usuarios").doc(padre.uid).collection("hijos").doc(hijo.uid);
    DocRef documento2 = _db.collection("usuarios").doc(hijo.uid).collection("padres").doc(padre.uid);

    try {
      await documento1.set({});
      await documento2.set({});
    } catch (e) {
      print("Error asignando hijos. Exeption: $e");
      return false;
    }

    return true;
  }

  Future<double> getDeuda(Usuario estudiante) async {
    return calcularDeuda(await getUltPago(estudiante.uid));
  }




  //Listadores
  Future<List<Curso>> getCursos() async {
    List<DocumentSnapshotForAll<Map<String, Object?>>> documentos;
    List<Curso> cursos = [];

    try
    {
      documentos = await _db.collection('cursos').get().then((value) => value.docs);
    }
    catch (e)
    {
      print("No se pudieron obtener los cursos de la DB. Exeption: $e");
      return [];
    }

    for (var element in documentos) {
      Map<String,dynamic>? json = element.map;

      if (json != null)
        {
          Curso? curso = Curso.fromJson(json);

          if (curso != null)
            {
              cursos.add(curso);
            }

        }

    }

    return cursos;

  }

  //Lista todos los usuarios que deben y te los devuelve con el monto de la deuda
  Future<List<Map<Usuario, double>>> listarDeudores() async {
    List<Usuario> usuarios = await listarUsuariosFiltroRol(UserRoles.estudiante);
    List<Map<Usuario, double>> deudores = [];

    for (var usuario in usuarios)
      {
        double deuda = await getDeuda(usuario);
        if (deuda > 0)
        {
          deudores.add({usuario:deuda});
        }

      }

    return deudores;
  }

  // Para agregar pantalla para no docentes. El filtrado lo hago del lado del front
  Future<List<Usuario>> listarUsuarios() async {
    List<Usuario> usuarios = [];
    List<DocumentSnapshotForAll<Map<String, Object?>>> documentos;

    try
    {
      documentos = await _db.collection('usuarios').get().then((value) => value.docs);
    }
    catch (e)
    {
      print("Error obteniendo usuarios de DB. Exeption: $e");
      return [];
    }

    for (var documento in documentos)
      {
        Map<String,dynamic>? json = documento.map;

        if (json != null)
          {
            json['uid'] = documento.id;
            Usuario? usuario = Usuario.fromJson(json);

            if (usuario != null)
              {
                usuarios.add(usuario);
              }

          }

      }

    return usuarios;
  }

  Future<List<Usuario>> listarUsuariosFiltroRol(UserRoles rol) async {
    List<Usuario> usuarios = [];
    List<DocumentSnapshotForAll<Map<String, Object?>>> documentos;

    try
    {
      documentos = await _db.collection('usuarios').where('rol', isEqualTo: rol.toString()).get().then((value) => value.docs);
    }
    catch (e)
    {
      print("Error obteniendo usuarios de DB. Exeption: $e");
      return [];
    }

    for (var documento in documentos)
    {
      Map<String,dynamic>? json = documento.map;

      if (json != null)
      {
        json['uid'] = documento.id;
        Usuario? usuario = Usuario.fromJson(json);

        if (usuario != null)
        {
          usuarios.add(usuario);
        }

      }

    }

    return usuarios;
  }

  Future<List<Usuario>> listarAlumnosPorCurso(Curso curso) async {
    List<Usuario> retorno = [];
    List<Usuario> estudiantes = await listarUsuariosFiltroRol(UserRoles.estudiante);

    for (var estudiante in estudiantes)
      {
        if (await esCursoyUsuario(estudiante.uid, curso.nombre))
          {
            retorno.add(estudiante);
          }
      }

    return retorno;
  }

  Future<List<Map<Curso,List<Usuario>>>> listarAlumnosPorCursoFull() async {
    List<Map<Curso,List<Usuario>>> retorno = [];
    List<Curso> cursos = await getCursos();

    for (var curso in cursos)
      {
        List<Usuario> cursantes = await listarAlumnosPorCurso(curso);
        if (cursantes.isNotEmpty)
          {
            retorno.add({curso:cursantes});
          }
      }

    return retorno;
  }

  Future<Map<Curso, List<Nota>>> getNotasPorCurso(Usuario usuario, int anio) async {
    

    return {};
  }




  //Usar Try pueden dar exeption

  //Pasame el padre y te devuelvo los hijos, ahi vas a poder buscar notas y deudas, fijate si necesitas la vuelta
  Future<List<Usuario>> getHijos(Usuario padre) async {
    return [];
  }


}
