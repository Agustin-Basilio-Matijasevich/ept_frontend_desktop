import 'package:flutter/material.dart';

class Deudores extends StatelessWidget {
  Deudores({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: TablaDeudores(),
    );
  }
}

class TablaDeudores extends StatefulWidget {
  const TablaDeudores({super.key});

  @override
  State<TablaDeudores> createState() => _TablaDeudoresState();
}

class _TablaDeudoresState extends State<TablaDeudores> {
  var ejemplo = <AlumnoCuota>[
    AlumnoCuota(
        'Avril', '43887449', 'Daniel', '22687430', '3624171960', 'Febrero 23')
  ];
  @override
  Widget build(BuildContext context) {
    return DataTable(
      columns: const [
        DataColumn(label: Text('Nombre del Alumno')),
        DataColumn(label: Text('DNI del Alumno')),
        DataColumn(label: Text('Nombre del Tutor')),
        DataColumn(label: Text('DNI del tutor')),
        DataColumn(label: Text('Telefono de Contacto')),
        DataColumn(label: Text('Mes de deuda')),
      ],
      rows: ejemplo
          .map(
            (alumno) => DataRow(
              cells: [
                DataCell(Text(alumno.nombreAlumno)),
                DataCell(Text(alumno.dniAlumno)),
                DataCell(Text(alumno.nombrePadre)),
                DataCell(Text(alumno.dniPadre)),
                DataCell(Text(alumno.numeroContacto)),
                DataCell(Text(alumno.mesDeuda)),
              ],
            ),
          )
          .toList(),
    );
  }
}

class AlumnoCuota {
  String nombreAlumno;
  String dniAlumno;
  String nombrePadre;
  String dniPadre;
  String numeroContacto;
  String mesDeuda;

  AlumnoCuota(this.nombreAlumno, this.dniAlumno, this.nombrePadre,
      this.dniPadre, this.numeroContacto, this.mesDeuda);
}
