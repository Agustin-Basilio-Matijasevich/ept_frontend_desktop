import 'package:ept_frontend/models/nota.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/curso.dart';
import '../models/usuario.dart';
import '../services/businessdata.dart';

class Boletin extends StatelessWidget {
  Boletin({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Boletin'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Contenido(),
      ),
    );
  }
}

class Contenido extends StatefulWidget {
  Contenido({super.key});

  Usuario? usuarioSeleccionado;

  @override
  State<Contenido> createState() => _ContenidoState();
}

class _ContenidoState extends State<Contenido> {
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
        Usuario? hijoSeleccionado;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Controles
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Selector de hijo
                FutureBuilder(
                  future: servicio.getHijos(usuario),
                  builder: (context, snapshot) {
                    print(snapshot.connectionState);
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Container(
                        child: DropdownMenu<Usuario>(
                          onSelected: (value) {
                            setState(() {
                              this.widget.usuarioSeleccionado = value;
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
                      return CircularProgressIndicator();
                    } else {
                      return Icon(Icons.do_not_disturb_alt);
                    }
                  },
                ),
              ],
            ),
            GrillaBoletin(estudiante: hijoSeleccionado),
          ],
        );
    }
    return Container();
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
      return Text('No se encontraron estudiantes para mostrar');
    } else {
      return FutureBuilder(
        future: widget.servicio.getNotasPorCurso(widget.estudiante!, 2023),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.data!.isNotEmpty) {
              var columns = [
                DataColumn(label: Text('Cursos')),
                DataColumn(label: Text('1er trimestre')),
                DataColumn(label: Text('2do trimestre')),
                DataColumn(label: Text('3er cuatrimestre')),
                DataColumn(label: Text('Promedio')),
              ];

              var rows = <DataRow>[];
              // Itera por curso
              for (var curso in snapshot.data!.keys) {
                var nombreCurso = curso.nombre;
                var notas = <Nota>[];
                for (int i = 0;
                    i < 3 && i < snapshot.data![curso]!.length;
                    i++) {
                  notas.add(snapshot.data![curso]![i]);
                }

                var promedio;

                rows.add(
                  DataRow(
                    cells: [
                      DataCell(Text(curso.nombre)),
                      DataCell(Text(
                          (notas[0] != null) ? notas[0].nota.toString() : '')),
                      DataCell(Text(
                          (notas[1] != null) ? notas[1].nota.toString() : '')),
                      DataCell(Text(
                          (notas[2] != null) ? notas[2].nota.toString() : '')),
                    ],
                  ),
                );
              }

              return DataTable(columns: columns, rows: rows);
            } else {
              return Text('No se encontraron datos para mostrar');
            }
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return Text('Ocurrio un error :(');
          }
        },
      );
      // return FutureBuilder(future: servicio.getCursos(widget.estudiante));
    }
  }
}
