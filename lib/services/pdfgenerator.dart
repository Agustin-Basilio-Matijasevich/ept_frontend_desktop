// ignore_for_file: avoid_print

import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:ept_frontend/models/usuario.dart';

class PDFGenerator {
  static Future<bool> listarAlumnosPorCursoPDF(
      List<Usuario> listaUsuarios, String rutaSalida) async {
    final pdf = pw.Document();
    final file = File(rutaSalida);

    if (listaUsuarios.isEmpty) {
      return false;
    }

    //Añade Paginas

    try {
      await file.writeAsBytes(await pdf.save());
    } catch (e) {
      print("Error escribiendo archivo. Exeption: $e");
      return false;
    }

    return true;
  }
}
