// import 'package:ept_frontend/models/nota.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// import '../models/curso.dart';
import '../models/usuario.dart';
import '../services/businessdata.dart';

class BoletinEstudiante extends StatelessWidget {
  BoletinEstudiante({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boletin'),
      ),
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

  @override
  State<Contenido> createState() => _ContenidoState();
}

class _ContenidoState extends State<Contenido> {
  Usuario? usuarioSeleccionado;
  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<Usuario?>(context);
    final servicio = BusinessData();
    switch (usuario!.rol) {
      case UserRoles.estudiante:
        return Center(
          child: GrillaBoletin(estudiante: usuario),
        );

      case UserRoles.padre:
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Controles
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Selector de hijo
                FutureBuilder(
                  future: servicio.getHijos(usuario),
                  builder: (context, snapshot) {
                    print(snapshot.connectionState);
                    if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                      return SizedBox(
                        child: DropdownMenu<Usuario>(
                          label: (usuarioSeleccionado != null)
                              ? Text(usuarioSeleccionado!.nombre)
                              : const Text(''),
                          onSelected: (value) {
                            setState(() {
                              usuarioSeleccionado = value;
                            });
                          },
                          dropdownMenuEntries: snapshot.data!.map(
                            (e) {
                              return DropdownMenuEntry<Usuario>(
                                value: e,
                                label: e.nombre,
                              );
                            },
                          ).toList(),
                        ),
                      );
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      return const Icon(Icons.do_not_disturb_alt);
                    }
                  },
                ),
              ],
            ),
            GrillaBoletin(estudiante: usuarioSeleccionado),
          ],
        );
      default:
        return Container();
    }
  }
}

class GrillaBoletin extends StatefulWidget {
  Usuario? estudiante;
  GrillaBoletin({
    super.key,
    required this.estudiante,
  });
  final servicio = BusinessData();

  @override
  State<GrillaBoletin> createState() => _GrillaBoletinState();
}

class _GrillaBoletinState extends State<GrillaBoletin> {
  @override
  Widget build(BuildContext context) {
    if (widget.estudiante == null) {
      return const Text('No se encontraron estudiantes para mostrar');
    } else {
      return FutureBuilder(
        future: widget.servicio.getPromedioPorCurso(widget.estudiante!, 2023),
        builder: (context, snapshot) {
          if (snapshot.data != null && snapshot.data!.isNotEmpty) {
            var columns = const [
              DataColumn(label: Text('Cursos')),
              DataColumn(label: Text('1er trimestre')),
              DataColumn(label: Text('2do trimestre')),
              DataColumn(label: Text('3er cuatrimestre')),
              DataColumn(label: Text('Promedio')),
            ];

            var rows = <DataRow>[];
            // Itera por curso
            for (var curso in snapshot.data!) {
              var nombreCurso = curso.keys.first.nombre;
              var notas = curso.values.first;
              int sumatoria = 0;
              int cantNotas = 0;
              for (var nota in notas) {
                cantNotas++;
                sumatoria += (nota == null) ? 0 : nota;
              }

              int promedio = (sumatoria / cantNotas).round();

              rows.add(
                DataRow(
                  cells: [
                    DataCell(Text(nombreCurso)),
                    DataCell(
                        Text((notas[0] != null) ? notas[0].toString() : '')),
                    DataCell(
                        Text((notas[1] != null) ? notas[1].toString() : '')),
                    DataCell(
                        Text((notas[2] != null) ? notas[2].toString() : '')),
                    DataCell(Text(promedio.toString())),
                  ],
                ),
              );
            }

            return DataTable(columns: columns, rows: rows);
          } else if (snapshot.data != null && snapshot.data!.isEmpty) {
            return const Text('No se encontraron datos para mostrar');
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else {
            return const Text('Ocurrio un error');
          }
        },
      );
      // return FutureBuilder(future: servicio.getCursos(widget.estudiante));
    }
  }
}
