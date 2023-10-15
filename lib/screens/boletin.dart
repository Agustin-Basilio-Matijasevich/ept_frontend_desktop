import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/usuario.dart';
import '../services/businessdata.dart';

class Boletin extends StatelessWidget {
  Boletin({Key? key}) : super(key: key);

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

  Usuario? usuarioSeleccionado;

  @override
  State<Contenido> createState() => _ContenidoState();
}

class _ContenidoState extends State<Contenido> {
  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<Usuario?>(context);
    final servicio = BusinessData();
    switch (usuario!.rol) {
      case UserRoles.estudiante:
        return Center(
          child: GrillaBoletin(estudiante: usuario),
        );

      case UserRoles.padre:
        Usuario? hijoSeleccionado;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Controles
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //Selector de hijo
                FutureBuilder(
                  future: servicio.getHijos(usuario),
                  builder: (context, snapshot) {
                    print(snapshot.connectionState);
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Container(
                        child: DropdownMenu<Usuario>(
                          onSelected: (value) {
                            setState(() {
                              this.widget.usuarioSeleccionado = value;
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
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      return Icon(Icons.do_not_disturb_alt);
                    }
                  },
                ),
              ],
            ),
            GrillaBoletin(estudiante: hijoSeleccionado),
          ],
        );
    }
    return Container();
  }
}

class GrillaBoletin extends StatefulWidget {
  Usuario? estudiante;
  GrillaBoletin({
    super.key,
    required this.estudiante,
  });

  @override
  State<GrillaBoletin> createState() => _GrillaBoletinState();
}

class _GrillaBoletinState extends State<GrillaBoletin> {
  @override
  Widget build(BuildContext context) {
    if (widget.estudiante == null) {
      return Text('Usted no tiene hijos asociados actualmente');
    } else {
      final servicio = BusinessData();
      return Container();
      // return FutureBuilder(future: servicio.getCursos(widget.estudiante));
    }
  }
}
