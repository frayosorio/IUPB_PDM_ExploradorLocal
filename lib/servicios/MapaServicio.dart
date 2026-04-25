import 'dart:convert';

import 'package:explorador_local/modelos/Lugar.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

class MapaServicio {
  final String _urlBase = "https://overpass-api.de/api/interpreter";
  //final String _urlBase = "https://overpass.kumi.systems/api/interpreter";
  //final String _urlBase ="https://lz4.overpass-api.de/api/interpreter";

  Future<List<Lugar>> buscarLugares({
    required LatLng posicion,
    required String categoria,
  }) async {
    final consulta =
        "[out:json][timeout:30];node['amenity'='$categoria'](around:1500,${posicion.latitude},${posicion.longitude});out;";
    final url = Uri.parse("$_urlBase?data=${Uri.encodeComponent(consulta)}");
    try {
      final respuesta = await http
          .get(url, headers: {"User-Agent": "ExploradorLocalIUPB"})
          .timeout(const Duration(seconds: 30));

      if (respuesta.statusCode == 200) {
        final datos = json.decode(respuesta.body);
        final lugares = datos["elements"] as List;
        return lugares.map((json) => Lugar.fromJson(json)).toList();
      } else {
        throw 'Error del servidor: ${respuesta.statusCode}';
      }
    } catch (e) {
      throw 'Error de conexión: $e';
    }
  }
}
