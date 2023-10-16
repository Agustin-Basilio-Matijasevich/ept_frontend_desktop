import 'package:ept_frontend/services/businessdata.dart';
import 'package:flutter/material.dart';

import '../models/curso.dart';
import '../models/usuario.dart';

class AsignacionDocentes extends StatelessWidget {
  AsignacionDocentes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Asignacion de docentes'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.topCenter,
        child: const Contenido(),
      ),
    );
  }
}

class Contenido extends StatefulWidget {
  const Contenido({super.key});

  @override
  State<Contenido> createState() => _ContenidoState();
}

class _ContenidoState extends State<Contenido> {
  Usuario? docenteSeleccionado;
  Set<Curso> cursosSeleccionados = {};
  final servicio = BusinessData();

  List<Usuario>? docentes;
  List<Curso>? cursos;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Row(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: const Text('Seleccione un docente'),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height - 200,
                  padding: const EdgeInsets.all(20),
                  child: FutureBuilder(
                    future: servicio.listarUsuariosFiltroRol(UserRoles.docente),
                    builder: (context, snapshot) {
                      if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                        return DataTable(
                          showCheckboxColumn: true,
                          onSelectAll: (value) {
                            setState(() {
                              docenteSeleccionado = null;
                            });
                          },
                          columns: const [
                            DataColumn(label: Text('Nombre')),
                            DataColumn(label: Text('Correo')),
                          ],
                          rows: snapshot.data!
                              .map(
                                (e) => DataRow(
                                    selected: e.uid == docenteSeleccionado?.uid,
                                    onSelectChanged: (value) {
                                      setState(() {
                                        docenteSeleccionado = e;
                                      });
                                    },
                                    cells: [
                                      DataCell(Text(e.nombre)),
                                      DataCell(Text(e.correo)),
                                    ]),
                              )
                              .toList(),
                        );
                      } else {
                        return const Text('No se encontraron profesores');
                      }
                    },
                  ),
                ),
              ],
            ),
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  child: const Text('Seleccione varios cursos'),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  height: MediaQuery.of(context).size.height - 200,
                  padding: const EdgeInsets.all(20),
                  child: FutureBuilder(
                    future: servicio.getCursos(),
                    builder: (context, snapshot) {
                      if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                        return DataTable(
                            columns: const [
                              DataColumn(label: Text('Curso')),
                              DataColumn(label: Text('Aula')),
                              DataColumn(label: Text('Dia')),
                              DataColumn(label: Text('Hora inicio')),
                              DataColumn(label: Text('Hora fin')),
                            ],
                            rows: snapshot.data!
                                .map(
                                  (e) => DataRow(
                                      selected: cursosSeleccionados.any(
                                          (element) =>
                                              element.nombre == e.nombre),
                                      onSelectChanged: (value) {
                                        print(value);
                                        if (value!) {
                                          setState(() {
                                            cursosSeleccionados.add(e);
                                          });
                                        } else {
                                          setState(() {
                                            cursosSeleccionados.removeWhere(
                                              (element) =>
                                                  element.nombre == e.nombre,
                                            );
                                          });
                                        }
                                      },
                                      cells: [
                                        DataCell(Text(e.nombre)),
                                        DataCell(Text(e.aula)),
                                        DataCell(Text(e.dia.name)),
                                        DataCell(Text(
                                            '${e.horainicio.hour}:${e.horainicio.minute.toString().padLeft(2, '0')}')),
                                        DataCell(Text(
                                            '${e.horafin.hour}:${e.horafin.minute.toString().padLeft(2, '0')}')),
                                      ]),
                                )
                                .toList());
                      } else {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else {
                          return const Text('No se encontraron cursos');
                        }
                      }
                    },
                  ),
                ),
              ],
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
            bool error = false;
            if (docenteSeleccionado != null && cursosSeleccionados.isNotEmpty) {
              for (var curso in cursosSeleccionados) {
                bool fin =
                    await servicio.adherirCurso(docenteSeleccionado!, curso);
                if (!fin) error = true;
              }
              if (!error) {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Asignacion de curso'),
                    content: const Text(
                        'Se asignaron los cursos al usuario con exito'),
                    actions: [
                      TextButton(
                        child: const Text('Aceptar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                );
              } else {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Asignacion de curso'),
                    content: const Text(
                        'Ocurrio un error en la asignacion de cursos'),
                    actions: [
                      TextButton(
                        child: const Text('Aceptar'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      )
                    ],
                  ),
                );
              }
            }
          },
          child: const Text('Asignar docente'),
        ),
      ],
    );
  }
}
