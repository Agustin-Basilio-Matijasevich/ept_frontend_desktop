import 'package:flutter/material.dart';

import '../services/businessdata.dart';

class ListadoCursos extends StatelessWidget {
  ListadoCursos({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Listado de cursos'),
      ),
      body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: GrillaCursos()),
    );
  }
}

class GrillaCursos extends StatefulWidget {
  GrillaCursos({super.key});
  final servicio = BusinessData();

  @override
  State<GrillaCursos> createState() => GrillaCursosState();
}

class GrillaCursosState extends State<GrillaCursos> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: widget.servicio.getCursos(),
      builder: (context, snapshot) {
        print('Iniciando builder');
        if (snapshot.connectionState == ConnectionState.done) {
          print('Conexion establecida');
          if (snapshot.data!.isEmpty) {
            print('Datos vacios');
            return Icon(Icons.cancel_presentation_sharp);
          } else {
            print('Cargando tabla');
            return DataTable(
              columns: const [
                DataColumn(label: Text('Nombre')),
                DataColumn(label: Text('Dia de la semana')),
                DataColumn(label: Text('Hora de inicio')),
                DataColumn(label: Text('Hora de fin')),
                DataColumn(label: Text('Aula')),
              ],
              rows: snapshot.data!.map(
                (e) {
                  return DataRow(cells: [
                    DataCell(Text(e.nombre)),
                    DataCell(Text(e.dia.name)),
                    DataCell(
                        Text('${e.horainicio.hour}:${e.horainicio.minute}')),
                    DataCell(Text('${e.horafin.hour}:${e.horafin.minute}')),
                    DataCell(Text(e.aula)),
                  ]);
                },
              ).toList(),
            );
          }
        } else {
          print(snapshot.connectionState);
          return const SizedBox(
            height: 32,
            width: 32,
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}


// final String nombre = json['nombre'];
//       final DiaSemana dia = DiaSemana.values.firstWhere((element) => element.toString() == json['dia']);
//       final TimeOfDay horainicio = TimeOfDay(hour: int.parse(json['horainicio'].toString()), minute: int.parse(json['minutoinicio'].toString()));
//       final TimeOfDay horafin = TimeOfDay(hour: int.parse(json['horafin'].toString()), minute: int.parse(json['minutofin'].toString()));
//       final String aula = json['aula'];