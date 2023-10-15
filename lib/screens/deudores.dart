import 'package:ept_frontend/services/businessdata.dart';
import 'package:flutter/material.dart';

import '../models/usuario.dart';
// import 'package:pdf/widgets.dart';

class Deudores extends StatelessWidget {
  Deudores({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Deudores'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: TablaDeudores(),
      ),
    );
  }
}

class TablaDeudores extends StatefulWidget {
  TablaDeudores({super.key});

  @override
  State<TablaDeudores> createState() => _TablaDeudoresState();
}

class _TablaDeudoresState extends State<TablaDeudores> {
  var ejemplo = [];
  final servicio = BusinessData();

  Future<List<_fila>> getData() async {
    final servicio = BusinessData();
    List<Map<Usuario, double>> estudianteDeuda =
        await servicio.listarDeudores();
    var dataset = <_fila>[];

    for (var deudor in estudianteDeuda) {
      var alumno = deudor.keys.first;
      var deuda = deudor.values.first;
      var tutor;
      try {
        tutor = await servicio.getPadres(alumno).then((value) => value.first);
      } catch (e) {
        tutor = null;
      }
      dataset.add(_fila(alumno: alumno, tutor: tutor, deuda: deuda));
    }
    return dataset;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          if (snapshot.data!.isNotEmpty) {
            return DataTable(
              columns: const [
                DataColumn(label: Text('Nombre del Alumno')),
                DataColumn(label: Text('Email del Alumno')),
                DataColumn(label: Text('Nombre del Tutor')),
                DataColumn(label: Text('Email del tutor')),
                DataColumn(label: Text('Monto de deuda')),
              ],
              rows: snapshot.data!.map((e) {
                return DataRow(cells: [
                  DataCell(Text(e.alumno.nombre)),
                  DataCell(Text(e.alumno.correo)),
                  DataCell(Text((e.tutor != null) ? e.tutor!.nombre : '')),
                  DataCell(Text((e.tutor != null) ? e.tutor!.correo : '')),
                  DataCell(Text(e.deuda.toString())),
                ]);
              }).toList(),
            );
          }
          return Text('No hay deudores para mostrar');
        } else {
          return Container(
            child: CircularProgressIndicator(),
            alignment: Alignment.center,
          );
        }
      },
    );
  }
}

class _fila {
  Usuario alumno;
  Usuario? tutor;
  double deuda;
  _fila({
    required this.alumno,
    this.tutor,
    required this.deuda,
  });
}
