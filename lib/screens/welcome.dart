import 'package:ept_frontend/widgets/footer.dart';
import 'package:ept_frontend/widgets/login_button.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  Welcome({super.key});

  List<String> images = [];

  @override
  Widget build(BuildContext context) {
    bool esPantallaChica = MediaQuery.of(context).size.width < 600;

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
          children: <Widget>[
            const DrawerHeader(
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
            ),
          ],
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
          }
        },
      ),
    );
  }
}

class _CompanyDescription extends StatelessWidget {
  const _CompanyDescription({super.key});

  @override
  Widget build(BuildContext context) {
    bool esPantallaChica = MediaQuery.of(context).size.width < 600;

    return Text(
        'Inspiramos, desafiamos y empoderamos a todos\n'
        'nuestros alumnos a ser miembros comprometidos\n'
        'y éticos de una comunidad global, para que se\n'
        'conviertan en agentes de cambio conscientes de\n '
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
                fontSize: 42,
                //fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
        textAlign: esPantallaChica ? TextAlign.center : null);
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
