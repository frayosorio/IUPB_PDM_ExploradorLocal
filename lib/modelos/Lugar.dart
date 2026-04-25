import 'package:latlong2/latlong.dart';

class Lugar {
  final String nombre;
  final String tipo;
  final String horario;
  final LatLng ubicacion;

  Lugar({
    required this.nombre,
    required this.tipo,
    required this.horario,
    required this.ubicacion,
  });

  factory Lugar.fromJson(Map<String, dynamic> json) {
    return Lugar(
      nombre: json["tags"]?["name"] ?? "Sin nombre",
      tipo: json["tags"]?["amenity"] ?? "Sin tipo",
      horario: json["tags"]?["opening_hours"] ?? "Sin horario",
      ubicacion: LatLng(
        (json["lat"] as num).toDouble(),
        (json["lon"] as num).toDouble(),
      ),
    );
  }
}
