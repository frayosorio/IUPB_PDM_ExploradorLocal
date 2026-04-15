import 'package:explorador_local/configuracion/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MarcadorControlador {
  Marker _construir({
    required double latitud,
    required double longitud,
    required IconData icono,
    required Color color,
    VoidCallback? evento,
  }) {
    return Marker(
      point: LatLng(latitud, longitud),
      width: 50,
      height: 50,
      child: GestureDetector(
        onTap: evento,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(blurRadius: 6, color: Colors.black26)],
          ),
          child: Icon(icono, color: color, size: 35),
        ),
      ),
    );
  }

  Marker crearMarcadorUsuario(double latitud, double longitud) {
    return _construir(
      latitud: latitud,
      longitud: longitud,
      icono: Icons.location_pin,
      color: ConfigMapa.colorUbicacionActual,
    );
  }
}
