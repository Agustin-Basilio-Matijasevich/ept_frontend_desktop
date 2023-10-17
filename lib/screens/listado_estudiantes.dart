import 'package:ept_frontend/services/businessdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/curso.dart';
import '../models/usuario.dart';
// import 'package:pdf/widgets.dart';

// Para mostrar estudiantes que tiene un profesor por cada materia
class ListadoEstudiantes extends StatelessWidget {
  const ListadoEstudiantes({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Listado de estudiantes'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.topCenter,
        child: const TablaUsuarios(),
      ),
    );
  }
}

class TablaUsuarios extends StatefulWidget {
  const TablaUsuarios({super.key});

  @override
  State<TablaUsuarios> createState() => _TablaUsuariosState();
}

class _TablaUsuariosState extends State<TablaUsuarios> {
  Curso? cursoSeleccionado;
  final servicio = BusinessData();

  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<Usuario?>(context);
    return Column(
      // mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(30),
          child: FutureBuilder(
            future: servicio.getCursosPorUsuario(usuario!),
            builder: (context, snapshot) {
              if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                return DropdownMenu(
                  label: const Text('Seleccione un curso'),
                  onSelected: (value) {
                    setState(() {
                      cursoSeleccionado = value;
                    });
                  },
                  dropdownMenuEntries: snapshot.data!
                      .map(
                        (e) => DropdownMenuEntry(
                          value: e,
                          label: e.nombre,
                        ),
                      )
                      .toList(),
                );
              } else if (snapshot.hasData && snapshot.data!.isEmpty) {
                return const Text('No se encontraron cursos');
              } else if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else {
                return const Text('Ocurrio un error');
              }
            },
          ),
        ),
        FutureBuilder(
          future: servicio.listarAlumnosPorCurso(cursoSeleccionado),
          builder: (context, snapshot) {
            if (cursoSeleccionado == null) {
              return const SizedBox();
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return DataTable(
                columns: const [
                  DataColumn(label: Text('Nombre del usuario')),
                  DataColumn(label: Text('Email del usuario')),
                  DataColumn(label: Text('Foto de perfil')),
                  DataColumn(label: Text('ID del usuario')),
                ],
                rows: snapshot.data!.map((e) {
                  return DataRow(cells: [
                    DataCell(Text(e.nombre)),
                    DataCell(Text(e.correo)),
                    DataCell(
                      Center(
                        child: (e.foto != '')
                            ? MouseRegion(
                                cursor: SystemMouseCursors.click,
                                child: GestureDetector(
                                  onTap: () {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: true,
                                      builder: (context) {
                                        return GestureDetector(
                                          onTap: () {
                                            Navigator.pop(context);
                                          },
                                          child: Image.network(
                                            e.foto,
                                            width: 256,
                                            height: 256,
                                          ),
                                        );
                                      },
                                    );
                                  },
                                  child: Image.network(
                                    e.foto,
                                    width: 32,
                                    height: 32,
                                  ),
                                ),
                              )
                            : const Icon(Icons.person),
                      ),
                    ),
                    DataCell(Text(e.uid)),
                  ]);
                }).toList(),
              );
            } else if (snapshot.hasData && snapshot.data!.isEmpty) {
              return const Text('No se encontraron alumnos para el curso');
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return Container(
                alignment: Alignment.center,
                child: const CircularProgressIndicator(),
              );
            } else {
              return const Text('Ocurrio un error');
            }
          },
        ),
      ],
    );
  }
}

class Fila {
  Usuario alumno;
  Usuario? tutor;
  double deuda;
  Fila({
    required this.alumno,
    this.tutor,
    required this.deuda,
  });
}
