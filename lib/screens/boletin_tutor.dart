import 'package:ept_frontend/models/nota.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/curso.dart';
import '../models/usuario.dart';
import '../services/businessdata.dart';

class BoletinTutor extends StatelessWidget {
  BoletinTutor({Key? key}) : super(key: key);

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

  @override
  State<Contenido> createState() => _ContenidoState();
}

class _ContenidoState extends State<Contenido> {
  Usuario? usuarioSeleccionado;
  final servicio = BusinessData();
  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<Usuario?>(context);
    final servicio = BusinessData();
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        // Controles
        FutureBuilder(
          future: servicio.getHijos(usuario!),
          builder: (context, snapshot) {
            print(snapshot.connectionState);
            if (snapshot.data != null && snapshot.data!.isNotEmpty) {
              return Container(
                child: DropdownMenu<Usuario>(
                  label: (usuarioSeleccionado != null)
                      ? Text(usuarioSeleccionado!.nombre)
                      : Text(''),
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
            } else if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else {
              return const Icon(Icons.do_not_disturb_alt);
            }
          },
        ),
        FutureBuilder(
          future: servicio.getPromedioPorCurso(usuarioSeleccionado!, 2023),
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
        ),
      ],
    );
  }
}
