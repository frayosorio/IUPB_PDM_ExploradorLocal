import 'package:explorador_local/configuracion/config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapaVista extends StatefulWidget {
  const MapaVista({super.key, required this.titulo});

  final String titulo;

  @override
  State<MapaVista> createState() => _MapaVistaState();
}

class _MapaVistaState extends State<MapaVista> {
  String _categoriaSeleccionada = "cafe";

  final MapController _controladorMapa = MapController();
  LatLng? _posicionActual;

  @override
  void initState() {
    super.initState();
    _getUbicacionActual();
  }

  Future<void> _getUbicacionActual() async {
    setState(
      () => _posicionActual = LatLng(6.218358518277795, -75.57064224099965),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.titulo),
        actions: [
          DropdownButton<String>(
            value: _categoriaSeleccionada,
            items: ConfigMapa.categorias.map((categoria) {
              return DropdownMenuItem<String>(
                value: categoria["id"],
                child: Row(
                  children: [
                    Icon(
                      categoria["icono"],
                      color: ConfigMapa.colorOpcion,
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Text(categoria["nombre"]),
                  ],
                ),
              );
            }).toList(),
            onChanged: (opcion) {
              setState(() => _categoriaSeleccionada = opcion!);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _controladorMapa,
            options: MapOptions(
              initialZoom: 14,
              initialCenter: _posicionActual!,
            ),
            children: [
              TileLayer(
                urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                userAgentPackageName: "com.curso_moviles.explorador_local",
              ),
            ],
          ),
        ],
      ),
    );
  }
}
