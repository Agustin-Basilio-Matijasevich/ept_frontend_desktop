import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ept_frontend/services/businessdata.dart';

import '../models/usuario.dart';

class Notas extends StatelessWidget {
  Notas({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notas'),
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

    return Container();
    // if (usuario?.rol == UserRoles.estudiante) {
    //   return FutureBuilder(
    //     future: servicio.getNotas(usuario!),
    //     builder: (context, snapshot) {
    //       return DataTable(
    //         columns: [],
    //         rows: [],
    //       );
    //     },
    //   );
    // } else if (usuario?.rol == UserRoles.padre) {
    //   return FutureBuilder(
    //     future: servicio.getHijos(usuario!),
    //     builder: (context, snapshot) {
    //       return Column(
    //         children: [
    //           DataTable(
    //             columns: [],
    //             rows: [],
    //           ),
    //         ],
    //       );
    //     },
    //   );
    // } else if (usuario?.rol == UserRoles.docente) {
    //   return FutureBuilder(
    //     future: servicio.getNotas(usuario!),
    //     builder: (context, snapshot) {
    //       return DataTable(
    //         columns: [],
    //         rows: [],
    //       );
    //     },
    //   );
    // } else {
    //   return Container();
    // }
  }
}
