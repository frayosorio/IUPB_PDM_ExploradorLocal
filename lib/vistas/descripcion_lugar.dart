import 'package:explorador_local/modelos/Lugar.dart';
import 'package:flutter/material.dart';

class DescripcionLugar extends StatelessWidget {
  final Lugar lugar;
  final Map<String, IconData> iconos;

  const DescripcionLugar({
    super.key,
    required this.lugar,
    required this.iconos,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Text(
            lugar.nombre,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          ListTile(
            leading: Icon(
              iconos[lugar.tipo] ?? Icons.place,
              color: Colors.blue,
            ),
            title: Text("Categoría: ${lugar.tipo.toUpperCase()}"),
          ),
        ],
      ),
    );
  }
}
