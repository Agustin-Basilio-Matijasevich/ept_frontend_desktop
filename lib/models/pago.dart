

enum TipoPago{
  credito,
  debito,
  efectivo,
  digital,
}

class Pago{
  final TipoPago tipoPago;
  final double monto;
  final DateTime fecha;

  Pago(this.tipoPago,this.monto,this.fecha);

  @override
  String toString(){
    return 'Tipo de Pago: $tipoPago, Monto: $monto, Fecha del Pago: $fecha';
  }

}