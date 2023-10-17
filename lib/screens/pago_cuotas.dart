import 'package:ept_frontend/models/pago.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../models/usuario.dart';
import '../services/businessdata.dart';

class PagoCuotas extends StatelessWidget {
  PagoCuotas({Key? key, required this.deudor, required this.deuda})
      : super(key: key);

  Usuario deudor;
  double deuda;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pago de Cuotas'),
      ),
      body: PagoCuotasContenido(
        deudor: deudor,
        deuda: deuda,
      ),
    );
  }
}

class PagoCuotasContenido extends StatefulWidget {
  PagoCuotasContenido({super.key, required this.deudor, required this.deuda});

  Usuario deudor;
  double deuda;

  @override
  State<PagoCuotasContenido> createState() => _PagoCuotasContenidoState();
}

class _PagoCuotasContenidoState extends State<PagoCuotasContenido> {
  TipoPago? tipoPago;

  final servicio = BusinessData();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DropdownMenu<TipoPago>(
          onSelected: (value) {
            setState(() {
              tipoPago = value;
            });
          },
          dropdownMenuEntries: const [
            DropdownMenuEntry(
              label: 'Tarjeta de Credito',
              value: TipoPago.credito,
            ),
            DropdownMenuEntry(
              label: 'Tarjeta de Debito',
              value: TipoPago.debito,
            ),
            DropdownMenuEntry(
              label: 'Efectivo',
              value: TipoPago.efectivo,
            ),
            DropdownMenuEntry(
              label: 'Digital',
              value: TipoPago.digital,
            ),
          ],
        ),
        TextButton(
          child: const Text('Pagar'),
          onPressed: () {
            if (tipoPago != null) {
              showDialog(
                context: context,
                builder: (context) => FutureBuilder(
                  future: servicio.pagar(widget.deudor,
                      Pago(tipoPago!, widget.deuda, DateTime.now())),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      if (snapshot.data!) {
                        return AlertDialog(
                          title: const Text('Respuesta creacion pago'),
                          content: const Text(
                              'Exito en la generacion del pago. ¿Desea generar un comprobante?'),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                var fileOutput =
                                    await FilePicker.platform.saveFile(
                                  allowedExtensions: ['pdf'],
                                  dialogTitle: 'Guardar comprobante factura',
                                  type: FileType.custom,
                                );
                                Navigator.of(context).pop();
                              },
                              child: const Text('Si'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: const Text('No'),
                            ),
                          ],
                        );
                      } else {
                        return AlertDialog(
                          title: const Text('Respuesta creacion pago'),
                          content: const Text(
                              'Ocurrio un error en la generacion del pago'),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Aceptar'),
                            ),
                          ],
                        );
                      }
                    } else if (snapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else {
                      return const Text('Ocurrio un error');
                    }
                  },
                ),
              );
            }
          },
        )
      ],
    );
  }
}
