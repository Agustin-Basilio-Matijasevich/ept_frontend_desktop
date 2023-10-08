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
  String? email = '';
  String? password = '';
  UserRoles? rol = null;
  String? nombre = '';
  String? error = '';

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
          // EMAIL
          TextFormField(
            validator: (String? value) {
              if (emailValidator(value) == null) {
                setState(() {
                  email = value;
                });
              } else {
                return emailValidator(email);
              }

              return null;
            },
            onChanged: (val) {
              setState(() => email = val);
            },
            decoration: const InputDecoration(
              labelText: 'Email',
              hintText: 'Ingrese un email',
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
          ),
          _gap(),
          // Contraseña
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'La contraseña no puede estar vacía';
              }

              if (value.length < 6) {
                return 'La contraseña debe tener al menos 6 caracteres';
              }

              return null;
            },
            onChanged: (String? val) {
              setState(() => password = val);
            },
            obscureText: !esVisible,
            decoration: InputDecoration(
              labelText: 'Contraseña',
              hintText: 'Ingrese una contraseña',
              prefixIcon: const Icon(Icons.lock),
              border: const OutlineInputBorder(),
              suffixIcon: IconButton(
                icon: Icon(esVisible ? Icons.visibility_off : Icons.visibility),
                onPressed: () {
                  setState(() {
                    esVisible = !esVisible;
                  });
                },
              ),
            ),
          ),
          _gap(),
          TextFormField(
            validator: (String? value) {
              if (value != null) {
                setState(() {
                  email = value;
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
              prefixIcon: Icon(Icons.email),
              border: OutlineInputBorder(),
            ),
          ),
          _gap(),
          DropdownMenu<UserRoles>(
            width: MediaQuery.of(context).size.width > 600
                ? 600
                : MediaQuery.of(context).size.width,
            onSelected: (UserRoles? value) {
              setState(() {
                this.rol = value;
              });
            },
            dropdownMenuEntries: UserRoles.values
                .map<DropdownMenuEntry<UserRoles>>((UserRoles value) {
              String label = '';
              switch (value) {
                case UserRoles.nodocente:
                  label = 'No Docente';
                  break;
                case UserRoles.estudiante:
                  label = 'Estudiante';
                  break;
                case UserRoles.padre:
                  label = 'Tutor';
                  break;
                case UserRoles.docente:
                  label = 'Docente';
                  break;
              }
              return DropdownMenuEntry<UserRoles>(
                value: value,
                label: label,
              );
            }).toList(),
            hintText: 'Rol',
          ),
          _gap(),
          // Enviar
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)),
              ),
              child: const Padding(
                padding: EdgeInsets.all(10.0),
                child: Text(
                  'Crear Usuario',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              onPressed: () async {
                final bool userCreationResponse;
                if (_formKey.currentState!.validate()) {
                  userCreationResponse =
                      await auth.createUser(email!, password!, rol!, nombre!);
                  if (userCreationResponse) {
                    showDialog(
                      context: navigatorKey.currentContext!,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Respuesta Creación"),
                          content: const Text("Usuario creado con éxito"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Aceptar"))
                          ],
                        );
                      },
                    );
                    email = '';
                    password = '';
                    rol = null;
                    nombre = '';
                  } else {
                    showDialog(
                      context: navigatorKey.currentContext!,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text("Respuesta Creación"),
                          content: const Text(
                              "Ocurrió un error y no se pudo crear el usuario"),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: const Text("Aceptar"))
                          ],
                        );
                      },
                    );
                  }
                }

                //Falta vformKeyficar por las cuentas guardadas en firebase.
              },
            ),
          ),
        ],
      ),
    );
  }
}
