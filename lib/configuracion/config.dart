import 'package:flutter/material.dart';

class ConfigMapa {
  static const List<Map<String, dynamic>> categorias = [
    {"id": "bank", "nombre": "Bancos", "icono": Icons.account_balance},
    {"id": "cafe", "nombre": "Cafeterías", "icono": Icons.coffee},
    {"id": "restaurant", "nombre": "Restaurantes", "icono": Icons.restaurant},
    {"id": "pharmacy", "nombre": "Farmacias", "icono": Icons.local_pharmacy},
    {"id": "fuel", "nombre": "Gasolineras", "icono": Icons.local_gas_station},
  ];

  static const Color colorOpcion = Color.fromARGB(255, 196, 215, 231);
}
