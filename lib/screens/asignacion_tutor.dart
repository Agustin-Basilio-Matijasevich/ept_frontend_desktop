import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../services/businessdata.dart';

// Ta enorme esta pantalla :(
class AsignacionTutor extends StatelessWidget {
  AsignacionTutor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Asignacion de tutores')),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.topCenter,
        child: Contenido(),
      ),
    );
  }
}

class Contenido extends StatefulWidget {
  Contenido({super.key});
  Usuario? estudianteSeleccionado;
  String? filtroEstudiante;
  Usuario? tutorSeleccionado;
  String? filtroTutor;
  final servicio = BusinessData();

  @override
  State<Contenido> createState() => _ContenidoState();
}

class _ContenidoState extends State<Contenido> {
  @override
  Widget build(BuildContext context) {
    // Fila para mostrar 2 columnas con grilla y filtro de busqueda
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Columna para estudiantes
            Container(
              height: MediaQuery.of(context).size.height - 100,
              width: MediaQuery.of(context).size.width / 2,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Filtro
                  SizedBox(
                    width: 100,
                    // height: 100,
                    child: TextField(
                      decoration:
                          const InputDecoration(hintText: 'Filtrar por nombre'),
                      autocorrect: false,
                      enabled: true,
                      onSubmitted: (value) {
                        setState(() {
                          widget.filtroEstudiante = value;
                        });
                      },
                    ),
                  ),
                  // Tabla
                  FutureBuilder(
                    future: widget.servicio
                        .listarUsuariosFiltroRol(UserRoles.estudiante),
                    builder: (context, snapshot) {
                      if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                        var dataset = (widget.filtroEstudiante == null)
                            ? snapshot.data
                            : snapshot.data!.where((element) => element.nombre
                                .toLowerCase()
                                .contains(
                                    widget.filtroEstudiante!.toLowerCase()));
                        if (dataset != null && dataset.isNotEmpty) {
                          return DataTable(
                            showCheckboxColumn: true,
                            onSelectAll: (value) {
                              setState(() {
                                widget.estudianteSeleccionado = null;
                              });
                            },
                            columns: const [
                              DataColumn(label: Text('Nombre')),
                              DataColumn(label: Text('Correo')),
                              DataColumn(label: Text('UID')),
                            ],
                            rows: dataset
                                .map(
                                  (e) => DataRow(
                                    selected:
                                        widget.estudianteSeleccionado?.uid ==
                                            e.uid,
                                    onSelectChanged: (value) {
                                      setState(() {
                                        widget.estudianteSeleccionado = e;
                                      });
                                      print(widget.estudianteSeleccionado);
                                    },
                                    cells: [
                                      DataCell(Text(e.nombre)),
                                      DataCell(Text(e.correo)),
                                      DataCell(Text(e.uid)),
                                    ],
                                  ),
                                )
                                .toList(),
                          );
                        } else {
                          return const Text(
                              'No se encontraron datos para mostrar');
                        }
                      } else if (snapshot.data != null &&
                          snapshot.data!.isEmpty) {
                        return const Text(
                            'No se encontraron datos para mostrar');
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else {
                        return const Text('Ocurrio un error :(');
                      }
                    },
                  ),
                ],
              ),
            ),

            // Columna para tutores
            Container(
              height: MediaQuery.of(context).size.height - 100,
              width: MediaQuery.of(context).size.width / 2,
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  // Filtro
                  SizedBox(
                    width: 100,
                    // height: 100,
                    child: TextField(
                      decoration:
                          const InputDecoration(hintText: 'Filtrar por nombre'),
                      autocorrect: false,
                      enabled: true,
                      onSubmitted: (value) {
                        setState(() {
                          widget.filtroEstudiante = value;
                        });
                      },
                    ),
                  ),
                  // Tabla
                  FutureBuilder(
                    future: widget.servicio
                        .listarUsuariosFiltroRol(UserRoles.padre),
                    builder: (context, snapshot) {
                      if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                        var dataset = (widget.filtroTutor == null)
                            ? snapshot.data
                            : snapshot.data!.where((element) => element.nombre
                                .toLowerCase()
                                .contains(widget.filtroTutor!.toLowerCase()));
                        if (dataset!.isNotEmpty) {
                          return DataTable(
                            showCheckboxColumn: true,
                            onSelectAll: (value) {
                              setState(() {
                                widget.tutorSeleccionado = null;
                              });
                            },
                            columns: const [
                              DataColumn(label: Text('Nombre')),
                              DataColumn(label: Text('Correo')),
                              DataColumn(label: Text('UID')),
                            ],
                            rows: dataset
                                .map(
                                  (e) => DataRow(
                                    selected:
                                        widget.tutorSeleccionado?.uid == e.uid,
                                    onSelectChanged: (value) {
                                      setState(() {
                                        widget.tutorSeleccionado = e;
                                      });
                                      print(widget.tutorSeleccionado);
                                    },
                                    cells: [
                                      DataCell(Text(e.nombre)),
                                      DataCell(Text(e.correo)),
                                      DataCell(Text(e.uid)),
                                    ],
                                  ),
                                )
                                .toList(),
                          );
                        } else {
                          return const Text(
                              'No se encontraron usuarios con ese nombre');
                        }
                      } else if (snapshot.data != null &&
                          snapshot.data!.isEmpty) {
                        return const Text(
                            'No se encontraron datos para mostrar');
                      } else if (snapshot.connectionState ==
                          ConnectionState.waiting) {
                        return const CircularProgressIndicator();
                      } else {
                        return const Text('Error');
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        TextButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.blue),
            foregroundColor: MaterialStatePropertyAll(Colors.white),
            textStyle: MaterialStatePropertyAll(TextStyle(fontSize: 24)),
          ),
          onPressed: () async {
            if (widget.estudianteSeleccionado != null &&
                widget.tutorSeleccionado != null) {
              var response = await widget.servicio.asignarHijo(
                widget.tutorSeleccionado!,
                widget.estudianteSeleccionado!,
              );
              print('Respuesta creacion: $response');
            }
          },
          child: const Text('Asignar hijo-tutor'),
        ),
      ],
    );
  }
}
