import 'package:flutter/material.dart';

enum DiaSemana{
  lunes,
  martes,
  miercoles,
  jueves,
  viernes,
}

class Curso {
  final String nombre;
  final DiaSemana dia;
  final TimeOfDay horainicio;
  final TimeOfDay horafin;
  final String aula;

  Curso(this.nombre,this.dia,this.horainicio,this.horafin,this.aula);

  @override
  String toString(){
    return 'Curso: $nombre, Dia: $dia, Hora de Inicio: $horainicio, Hora de Finalizacion: $horafin, Aula: $aula';
  }
}