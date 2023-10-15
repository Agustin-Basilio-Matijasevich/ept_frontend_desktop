import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/usuario.dart';
import '../services/businessdata.dart';

class Horarios extends StatelessWidget {
  Horarios({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Horarios'),
      ),
      body: GrillaHorarios(),
    );
  }
}

class GrillaHorarios extends StatefulWidget {
  GrillaHorarios({super.key});
  Usuario? estudiante;
  final servicio = BusinessData();

  @override
  State<GrillaHorarios> createState() => GrillaHorariosState();
}

class GrillaHorariosState extends State<GrillaHorarios> {
  var widgets = <Widget>[];

  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<Usuario?>(context);

    // Determina que widgets debe mostrar al usuario segun el rol

    if (usuario!.rol == UserRoles.estudiante) {
      widget.estudiante = usuario;
    } else if (usuario!.rol == UserRoles.docente) {
      widgets.add(FutureBuilder(
        future: widget.servicio.getHijos(usuario),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return DropdownMenu(
              dropdownMenuEntries: snapshot.data!
                  .map((e) => DropdownMenuEntry(label: e.nombre, value: e))
                  .toList(),
              onSelected: (value) {
                setState(() {
                  widget.estudiante = value;
                });
              },
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ));
    } else {
      return Text('Usted no deberia estar aqui :/');
    }

    widgets.add(
      FutureBuilder(
        future: widget.servicio.getCursos(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return DataTable(
              columns: [
                DataColumn(label: Text('Materia')),
                DataColumn(label: Text('Aula')),
                DataColumn(label: Text('Hora inicio')),
                DataColumn(label: Text('Hora fin')),
              ],
              rows: snapshot.data!
                  .map(
                    (e) => DataRow(cells: [
                      DataCell(Text(e.nombre)),
                      DataCell(Text(e.aula)),
                      DataCell(Text(
                          '${e.horainicio.hour}:${e.horainicio.minute.toString().padLeft(2, '0')}')),
                      DataCell(Text(
                          '${e.horafin.hour}:${e.horafin.minute.toString().padLeft(2, '0')}')),
                    ]),
                  )
                  .toList(),
            );
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else {
            return Text('Ocurrio un error :(');
          }
        },
      ),
    );
    return Column(
      children: widgets,
    );
  }
}
