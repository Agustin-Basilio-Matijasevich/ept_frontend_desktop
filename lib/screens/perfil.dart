import 'dart:io';

import 'package:ept_frontend/services/businessdata.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:file_picker/file_picker.dart';
import '../models/usuario.dart';
import '../services/auth.dart';

class Perfil extends StatelessWidget {
  Perfil({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<Usuario?>(context);
    final auth = AuthService();
    return Scaffold(
      appBar: AppBar(
        title: Text('Perfil'),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        alignment: Alignment.center,
        child: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () async {
                        var result = await FilePicker.platform.pickFiles(
                          dialogTitle: 'Elija una imagen para su perfil',
                          type: FileType.image,
                          allowedExtensions: ['png', 'jpeg', 'jpg'],
                          lockParentWindow: true,
                          onFileLoading: (p0) {
                            if (p0 == FilePickerStatus.picking) {
                              showDialog(
                                context: context,
                                builder: (context) =>
                                    const CircularProgressIndicator(),
                              );
                            }
                          },
                        );

                        if (result != null && result.files[0].size > 4000000) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Error'),
                                content: Text(
                                    'El tamaño de la imagen es demasiado grande. El máximo es 4MB'),
                                actions: [
                                  TextButton(
                                    child: Text('Aceptar'),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  )
                                ],
                              );
                            },
                          );
                        } else if (result != null) {
                          auth.updateUserImg(
                            usuario.uid,
                            File(result.files[0].path!),
                          );
                        }
                      },
                      //padding: EdgeInsets.all(50),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            style: BorderStyle.solid,
                          ),
                        ),
                        child: Image.network(
                          usuario!.foto,
                          width: 256,
                          height: 256,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(50, 50, 0, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Nombre: ',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          usuario!.nombre,
                          style: TextStyle(
                            fontSize: 24,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                child: TextButton(
                  child: Text('Cambiar contraseña'),
                  style: ButtonStyle(
                    textStyle: MaterialStateProperty.all(
                      TextStyle(
                        fontSize: 24,
                      ),
                    ),
                  ),
                  onPressed: () {},
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
