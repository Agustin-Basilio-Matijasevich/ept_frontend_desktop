import 'package:flutter/material.dart';

class Horarios extends StatelessWidget {
  Horarios({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(), body: Table());
  }
}

class TablaHorarios extends StatelessWidget {
  TablaHorarios({super.key});

  // Object horarios = {
  //   'Lunes': {
  //     'Inicio': TimeOfDay(
  //       hour: 07,
  //       minute: 30,
  //     ),
  //     'Fin': TimeOfDay(hour: 8, minute: 10),
  //   }
  // };

  @override
  Widget build(BuildContext context) {
    return Table(
        border: TableBorder.all(),
        columnWidths: const <int, TableColumnWidth>{
          0: IntrinsicColumnWidth(),
        },
        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
        children: <TableRow>[]);
  }
}
