// ignore_for_file: unnecessary_this

import 'package:ept_frontend/main.dart';
import 'package:ept_frontend/models/usuario.dart';
import 'package:flutter/material.dart';

import '../services/auth.dart';

class CreacionUsuario extends StatelessWidget {
  const CreacionUsuario({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Formulario(),
    );
  }
}

class Formulario extends StatefulWidget {
  const Formulario({super.key});

  @override
  State<Formulario> createState() => FormularioState();
}

class FormularioState extends State<Formulario> {
  final _formKey = GlobalKey<FormState>();

  bool esVisible = false;
  String? nombre = '';
  String? aula = '';
  TimeOfDay? horaInicio = null;
  TimeOfDay? horaFin = null;

  String? emailValidator(String? email) {
    // validacion email
    if (email == null || email.isEmpty) {
      return 'El email no puede estar vacío';
    }
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (!emailValid) {
      return 'Email invalido';
    }
    return null;
  }

  final AuthService auth = AuthService();

  Widget _gap() => const SizedBox(height: 16);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Nombre
          TextFormField(
            validator: (String? value) {
              if (value != null) {
                setState(() {
                  nombre = value;
                });
              } else {
                return 'El nombre no puede estar vacío';
              }
              return null;
            },
            onChanged: (val) {
              setState(() => nombre = val);
            },
            decoration: const InputDecoration(
              labelText: 'Nombre',
              hintText: 'Ingrese un nombre',
              prefixIcon: Icon(Icons.person),
              border: OutlineInputBorder(),
            ),
          ),
          _gap(),
          // Aula
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value) {
              final formatoAula = RegExp(r'^[A-Z]+\-[0-9]$');
              if (value == null) {
                return 'El nombre del aula no puede ser nulo';
              } else if (value.isEmpty) {
                return 'El nombre del aula no puede ser vacío';
              } else if (!formatoAula.hasMatch(value)) {
                return 'El nombre del aula no cumple con el formato establecido';
              } else {
                return null;
              }
            },
            onChanged: (value) {
              setState(() => aula = value);
            },
            decoration: const InputDecoration(
              labelText: 'Aula',
              hintText: 'Ingrese un aula',
              prefixIcon: Icon(Icons.room),
              border: OutlineInputBorder(),
            ),
          ),
          _gap(),
          _gap(),
          // Enviar
          // SizedBox(
          //   width: double.infinity,
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       shape: RoundedRectangleBorder(
          //           borderRadius: BorderRadius.circular(4)),
          //     ),
          //     child: const Padding(
          //       padding: EdgeInsets.all(10.0),
          //       child: Text(
          //         'Crear Usuario',
          //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          //       ),
          //     ),
          //     onPressed: () async {
          //       final bool userCreationResponse;
          //       if (_formKey.currentState!.validate()) {
          //         userCreationResponse =
          //             await auth.createUser(email!, password!, rol!, nombre!);
          //         if (userCreationResponse) {
          //           showDialog(
          //             context: navigatorKey.currentContext!,
          //             builder: (context) {
          //               return AlertDialog(
          //                 title: const Text("Respuesta Creación"),
          //                 content: const Text("Usuario creado con éxito"),
          //                 actions: [
          //                   TextButton(
          //                     onPressed: () {
          //                       Navigator.of(context).pop();
          //                     },
          //                     child: const Text("Aceptar"),
          //                   ),
          //                 ],
          //               );
          //             },
          //           );
          //           email = '';
          //           password = '';
          //           rol = null;
          //           nombre = '';
          //         } else {
          //           showDialog(
          //             context: navigatorKey.currentContext!,
          //             builder: (context) {
          //               return AlertDialog(
          //                 title: const Text("Respuesta Creación"),
          //                 content: const Text(
          //                     "Ocurrió un error y no se pudo crear el usuario"),
          //                 actions: [
          //                   TextButton(
          //                       onPressed: () {
          //                         Navigator.of(context).pop();
          //                       },
          //                       child: const Text("Aceptar"))
          //                 ],
          //               );
          //             },
          //           );
          //         }
          //       }

          //       //Falta vformKeyficar por las cuentas guardadas en firebase.
          //     },
          //   ),
          // ),
        ],
      ),
    );
  }
}
