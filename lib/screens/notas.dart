import 'package:ept_frontend/models/nota.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ept_frontend/services/businessdata.dart';

import '../models/curso.dart';
import '../models/usuario.dart';

class Notas extends StatelessWidget {
  Notas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notas'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: GrillaNotas(),
      ),
    );
  }
}

class GrillaNotas extends StatefulWidget {
  const GrillaNotas({super.key});

  @override
  State<GrillaNotas> createState() => _GrillaNotasState();
}

class _GrillaNotasState extends State<GrillaNotas> {
  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<Usuario?>(context);
    final servicio = BusinessData();

    Set<Map<Usuario, Nota>> notas = {};

    Curso? cursoSeleccionado;

    return Column(
      children: [
        // Selector de Cursos
        FutureBuilder(
          future: servicio.getCursosPorUsuario(usuario!),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                return DropdownMenu<Curso>(
                  hintText: 'Seleccione un curso',
                  onSelected: (value) {
                    setState(() {});
                  },
                  dropdownMenuEntries: snapshot.data!
                      .map(
                        (e) => DropdownMenuEntry<Curso>(
                          label: e.nombre,
                          value: e,
                        ),
                      )
                      .toList(),
                );
              } else {
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: const Text(
                      'No se encontraron cursos asociados al profesor'),
                );
              }
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        FutureBuilder(
          future: servicio.listarAlumnosPorCurso(cursoSeleccionado),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data != null && snapshot.data!.isNotEmpty) {
                return DataTable(
                  columns: const [
                    DataColumn(label: Text('Nombre')),
                    DataColumn(label: Text('Email')),
                    DataColumn(label: Text('Nota')),
                  ],
                  rows: snapshot.data!.map((e) {
                    return DataRow(
                      cells: [
                        DataCell(Text(e.nombre)),
                        DataCell(Text(e.correo)),
                        DataCell(TextField(
                          keyboardType: TextInputType.number,
                          onSubmitted: (value) {
                            if (notas
                                .any((element) => element.keys.first != e)) {
                              setState(() {
                                notas.add({
                                  e: Nota(
                                    DateTime.now(),
                                    int.parse(value),
                                  )
                                });
                              });
                            }
                          },
                        ))
                      ],
                    );
                  }).toList(),
                );
              } else {
                return Text('No se encontraron datos para mostrar');
              }
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
        TextButton(
          style: const ButtonStyle(
            backgroundColor: MaterialStatePropertyAll(Colors.blue),
            foregroundColor: MaterialStatePropertyAll(Colors.white),
          ),
          onPressed: () async {
            bool errorCarga = false;
            if (cursoSeleccionado != null && notas.isNotEmpty) {
              for (var nota in notas) {
                bool finalizacion = await servicio.cargarNota(
                  nota.keys.first,
                  cursoSeleccionado,
                  nota.values.first,
                );
                if (finalizacion == false) {
                  errorCarga = true;
                }
              }
            }
          },
          child: const Text('Agregar notas'),
        ),
      ],
    );
  }
}
