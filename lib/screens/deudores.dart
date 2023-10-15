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
      body: TablaDeudores(
        dataset: [],
      ),
    );
  }
}

class TablaDeudores extends StatefulWidget {
  List<Map<Usuario, double>>? dataset;
  TablaDeudores({super.key, required this.dataset});

  @override
  State<TablaDeudores> createState() => _TablaDeudoresState();
}

class _TablaDeudoresState extends State<TablaDeudores> {
  var ejemplo = [];
  final servicio = BusinessData();

  // Future<List<_fila>> getData() async {
  //   final servicio = BusinessData();
  //   List<Map<Usuario, double>> estudianteDeuda =
  //       await servicio.listarDeudores();
  //   var set = [];
  //   estudianteDeuda.forEach((element) async {
  //     set.add(Map(await servicio.getTutor(element.keys.first));
  //   });
  //   return estudianteDeuda.map(
  //     (e) {
  //       return _fila();
  //     },
  //   ).toList();
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: servicio.listarDeudores(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          return DataTable(
            columns: const [
              DataColumn(label: Text('Nombre del Alumno')),
              DataColumn(label: Text('Email del Alumno')),
              DataColumn(label: Text('Nombre del Tutor')),
              DataColumn(label: Text('Email del tutor')),
              DataColumn(label: Text('Monto de deuda')),
            ],
            rows: snapshot.data!.map((e) {
              var alumno = e.keys.first;
              var deuda = e.values.first;

              return DataRow(cells: []);
            }).toList(),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
}

class _fila {
  Usuario alumno;
  Usuario tutor;
  double deuda;
  _fila({
    required this.alumno,
    required this.tutor,
    required this.deuda,
  });
}
