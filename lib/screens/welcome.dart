import 'package:ept_frontend/screens/asignacion_tutor.dart';
import 'package:ept_frontend/screens/boletin_estudiante.dart';
import 'package:ept_frontend/screens/horarios_estudiante.dart';
import 'package:ept_frontend/screens/horarios_tutor.dart';
import 'package:ept_frontend/screens/pago_cuotas.dart';
import 'package:ept_frontend/screens/perfil.dart';
import 'package:ept_frontend/widgets/footer.dart';
import 'package:ept_frontend/widgets/login_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/usuario.dart';
import 'alumnos.dart';
import 'asignacion_docentes.dart';
import 'asignacion_estudiantes.dart';
import 'boletin_tutor.dart';
import 'creacion_curso.dart';
import 'creacion_usuario.dart';
import 'deudores.dart';
import 'listado_cursos.dart';
import 'listado_usuarios.dart';
import 'notas.dart';

class Welcome extends StatelessWidget {
  Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    bool esPantallaChica = MediaQuery.of(context).size.width < 600;
    final usuario = Provider.of<Usuario?>(context);

    Widget _gap() => SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 42.0,
          child: const DecoratedBox(
            decoration: BoxDecoration(color: Colors.blue),
          ),
        );
    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenido a Educar Para Trasformar',
            style: esPantallaChica
                ? const TextStyle(fontSize: 17)
                : const TextStyle(fontSize: null)),
        backgroundColor: Colors.lightBlue.shade300,
        foregroundColor: Colors.white,
        elevation: 0.0,
        actions: <Widget>[
          LoginButton(),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: SeccionesAccesibles(context, usuario!),
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 600) {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: Image.asset(
                                "assets/images/backgroundWhiteBlur.jpeg")
                            .image,
                        fit: BoxFit.cover,
                        alignment: AlignmentDirectional.bottomCenter,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const <Widget>[
                        _Logo(),
                        _CompanyDescription(),
                      ],
                    ),
                  ),
                  const PageFooter(),
                ],
              ),
            );
          } else {
            return SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: Image.asset(
                                "assets/images/backgroundWhiteBlur.jpeg")
                            .image,
                        fit: BoxFit.cover,
                        alignment: AlignmentDirectional.bottomCenter,
                      ),
                    ),
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        const _Logo(),
                        Container(
                          width: MediaQuery.of(context).size.width - 700,
                          child: const _CompanyDescription(),
                        ),
                      ],
                    ),
                  ),
                  const PageFooter(),
                ],
              ),
            );
          }
        },
      ),
    );
  }

  List<Widget> SeccionesAccesibles(BuildContext context, Usuario usuario) {
    const header = DrawerHeader(
      decoration: BoxDecoration(
        color: Colors.blue,
      ),
      child: Text(
        'Secciones',
        style: TextStyle(
          color: Colors.white,
          fontSize: 24,
        ),
      ),
    );

    final profile = Seccion(context, 'Perfil', Perfil(), Icons.person);

    switch (usuario.rol) {
      case UserRoles.docente:
        return [
          header,
          profile,
          Seccion(context, 'Lista de alumnos', Alumnos(), Icons.list),
          Seccion(
              context, 'Horarios', HorariosTutor(), Icons.watch_later_outlined),
          Seccion(context, 'Carga de notas', Notas(), Icons.grade),
        ];
      case UserRoles.estudiante:
        return [
          header,
          profile,
          Seccion(context, 'Horarios', HorariosEstudiante(),
              Icons.watch_later_outlined),
          Seccion(context, 'Boletin', BoletinEstudiante(), Icons.grade),
        ];
      case UserRoles.padre:
        return [
          header,
          profile,
          Seccion(context, 'Pago de cuotas', PagoCuotas(), Icons.receipt),
          Seccion(
              context, 'Horarios', HorariosTutor(), Icons.watch_later_outlined),
          Seccion(context, 'Boletin', BoletinTutor(), Icons.grade),
        ];
      case UserRoles.nodocente:
        return [
          header,
          profile,
          Seccion(context, 'Deudores', Deudores(), Icons.money_off),
          Seccion(context, 'Alumnos', Alumnos(), Icons.school),
          // Seccion(
          //     context, 'Horarios', HorariosTutor(), Icons.watch_later_outlined),
          Seccion(context, 'Asignación de estudiantes', AsignacionEstudiantes(),
              Icons.room),
          Seccion(context, 'Asignación de docentes', AsignacionDocentes(),
              Icons.room),
          Seccion(context, 'Asignacion de tutores', AsignacionTutor(),
              Icons.people),
          Seccion(context, 'Creación de Usuarios', CreacionUsuario(),
              Icons.people_outline_sharp),
          Seccion(context, 'Creación de Curso', CreacionCurso(),
              Icons.location_pin),
          Seccion(context, 'Listado de cursos', ListadoCursos(), Icons.list),
          Seccion(
              context, 'Listado de usuarios', ListadoUsuarios(), Icons.person),
        ];
      default:
        return [
          header,
          profile,
        ];
    }
  }

  ListTile Seccion(BuildContext context, String nombre,
      StatelessWidget pantalla, IconData icono) {
    return ListTile(
      leading: Icon(icono),
      title: Text(nombre),
      onTap: () => {
        Navigator.push<void>(
          context,
          MaterialPageRoute<void>(
            builder: (BuildContext context) => pantalla,
          ),
        ),
      },
    );
  }
}

class _CompanyDescription extends StatelessWidget {
  const _CompanyDescription({super.key});

  @override
  Widget build(BuildContext context) {
    bool esPantallaChica = MediaQuery.of(context).size.width < 600;

    return Text(
      'Inspiramos, desafiamos y empoderamos a todos '
      'nuestros alumnos a ser miembros comprometidos '
      'y éticos de una comunidad global, para que se '
      'conviertan en agentes de cambio conscientes de '
      'sí mismos,seguros, innovadores y colaborativos.',
      softWrap: true,
      style: esPantallaChica
          ? const TextStyle(
              //fontFamily:
              color: Color(0xFF0c245e),
              fontSize: 30,
              //fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            )
          : const TextStyle(
              //fontFamily:
              color: Color(0xFF0c245e),
              fontSize: 32,
              //fontStyle: FontStyle.italic,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
            ),
      textAlign: esPantallaChica ? TextAlign.center : TextAlign.left,
    );
  }
}

class _Logo extends StatelessWidget {
  const _Logo({super.key});

  @override
  Widget build(BuildContext context) {
    bool esPantallaChica = MediaQuery.of(context).size.width < 600;

    return Center(
      child: Image.asset("assets/images/logo.png",
          scale: 1, width: esPantallaChica ? 350 : null),
    );
  }
}
