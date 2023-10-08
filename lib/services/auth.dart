import 'dart:io';
import 'package:ept_frontend/firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ept_frontend/models/usuario.dart';
import 'package:firebase_for_all/firebase_for_all.dart';

class AuthService
{
  final FirebaseAuth _auth = FirebaseAuthForAll.instance; //Define la instancia de autenticacion para firebase
  final FirestoreItem _db = FirestoreForAll.instance; //Inicializo instancia de firestore
  final StorageRef _storageRef = FirebaseStorageForAll.instance.ref(DefaultStorageOption.rootfolder);

  //Metodo para obtener el usuario personalizado mediante la escucha de un stream
  Stream<Usuario?> get usuario
  {
    return _auth.authStateChanges().asyncMap((user) => _builduser(user)); //Retorna la escucha del servicio de estado de autenticacion de firebase que contiene el usuario de firebase, pero antes lo pasa por el costructor de usuario personalizado
  }

  //Metodo Constructor de usuario personalizado, recibe como parametro el usuario de firebase y devuelve el usuario personalizado, si el parametro es null, devuelve null.
  Future<Usuario>? _builduser(User? user)
  {
    if (user != null)
    {
      return UsuarioBuilder.build(user);
    }
    else
    {
      return null;
    }
  }

  //Metodo para loguear un usuario con email y password
  //Codigos de respuesta: Booleano. True para exito y false para error
  Future<bool> login(String email, String password) async
  {
    try //Usamos try para detectar si hay un error con la conexion al Backend
    {
      await _auth.signInWithEmailAndPassword(email: email, password: password); //Tiramos la request y esperamos que responda
      return true;
    }
    catch (e)
    {
      return false;
    }
  }

  //Metodo para desloguear usuario
  //Este metodo no tiene respuesta, solo debe esperarse a que termine con un await y luego el provider del contexto de la aplicacion actualiza la data de usuario a nulo quitando el acceso a los mismos a toda la app
  Future<void> logout() async
  {
      await _auth.signOut(); //Tiramos la reques de logout y esperamos que responda
  }


  //Crear Usuario
  Future<bool> createUser(String email, String password, UserRoles rol, String nombre, File? foto) async
  {
    User? nuevoUsuario = null;
    String uploadedFoto = '';
    Map<String,String> userdata;

    try {
      UserCredential credencial = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      nuevoUsuario = credencial.user;
    }
    catch (e){
      nuevoUsuario = null;
    }

    if (nuevoUsuario == null)
      {
        return false;
      }
    else{
      if (foto != null)
        {
          StorageRef fotoRef = _storageRef.child("usersdata").child(nuevoUsuario.uid).child("profileimage.jpg");
          UploadTaskForAll uploadTaskForAll = fotoRef.putFile(foto);
          uploadedFoto = await fotoRef.getDownloadURL();
        }

      userdata = {'foto':uploadedFoto,'nombre':nombre,'rol':rol.toString()};
      await _db.collection("usuarios").doc(nuevoUsuario.uid).set(userdata);
      return true;
    }

  }

}
