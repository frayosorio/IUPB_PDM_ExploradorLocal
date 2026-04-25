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
  static const Color colorUbicacionActual = Color.fromARGB(255, 46, 123, 185);
  static const Color colorLugar = Color.fromARGB(255, 237, 82, 15);

  static IconData obtenerIcono(String idCategoria) {
    for (final cat in categorias) {
      if (cat["id"] == idCategoria) {
        return cat["icono"] as IconData;
      }
    }
    return Icons.place; // icono por defecto
  }

  static const Map<String, IconData> iconos = {
    'bank': Icons.account_balance,
    'cafe': Icons.coffee,
    'restaurant': Icons.restaurant,
    'pharmacy': Icons.local_pharmacy,
    'fuel': Icons.local_gas_station,
  };
}
