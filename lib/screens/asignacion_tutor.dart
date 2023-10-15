import 'package:flutter/material.dart';

import '../services/businessdata.dart';

class AsignacionTutor extends StatelessWidget {
  AsignacionTutor({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
      ),
    );
  }
}

class Contenido extends StatefulWidget {
  const Contenido({super.key});

  @override
  State<Contenido> createState() => _ContenidoState();
}

class _ContenidoState extends State<Contenido> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class GrillaTutores extends StatefulWidget {
  GrillaTutores({super.key});
  final servicio = BusinessData();

  @override
  State<GrillaTutores> createState() => _GrillaTutoresState();
}

class _GrillaTutoresState extends State<GrillaTutores> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class GrillaEstudiantes extends StatefulWidget {
  const GrillaEstudiantes({super.key});

  @override
  State<GrillaEstudiantes> createState() => _GrillaEstudiantesState();
}

class _GrillaEstudiantesState extends State<GrillaEstudiantes> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
