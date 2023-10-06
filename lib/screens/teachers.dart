import 'package:ept_frontend/main.dart';
import 'package:flutter/material.dart';
import 'package:ept_frontend/screens/cuotas.dart';
import 'package:ept_frontend/screens/alumnos.dart';
import 'package:ept_frontend/screens/horarios.dart';
import 'package:ept_frontend/screens/aulas.dart';
import 'package:flutter/rendering.dart';

class Staff extends StatelessWidget{
  Staff({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.blue,
        title: const Text('Perfil de Docente'),
        elevation: 0.0,
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            child: Text('Funciones',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.face),
              title: const Text('Alumnos'),
              onTap: () => {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => Alumnos(),
                  ),
                ),
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Horarios'),
              onTap: () => {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => Horarios(),
                  ),
                ),
              },
            ),
            ListTile(
              leading: const Icon(Icons.meeting_room),
              title: const Text('Aulas'),
              onTap: () => {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => Aulas(),
                  ),
                ),
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text('Cargar Notas'),
              onTap: () => {
                Navigator.push<void>(
                  context,
                  MaterialPageRoute<void>(
                    builder: (BuildContext context) => Horarios(),
                  ),
                ),
              },
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: Image.asset("assets/images/backgroundWhiteBlur.jpeg").image,
                      fit: BoxFit.cover,
                      alignment: AlignmentDirectional.bottomCenter,
                    ),
                  ),
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Center(
                        child: Image.asset("assets/images/logo.png"),
                      ),
                       const Text("Bienvenido/a al perfil de Docente",
                        style: TextStyle(
                          color: Color(0xFF0c245e),
                          fontSize: 42,
                          fontWeight: FontWeight.bold
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        }
      ),
    );
  }
}