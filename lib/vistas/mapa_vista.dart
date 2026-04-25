import 'dart:async';

import 'package:explorador_local/configuracion/config.dart';
import 'package:explorador_local/modelos/Lugar.dart';
import 'package:explorador_local/servicios/MapaServicio.dart';
import 'package:explorador_local/vistas/controladores/marcador_controlador.dart';
import 'package:explorador_local/vistas/descripcion_lugar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

class MapaVista extends StatefulWidget {
  const MapaVista({super.key, required this.titulo});

  final String titulo;

  @override
  State<MapaVista> createState() => _MapaVistaState();
}

class _MapaVistaState extends State<MapaVista> {
  String _categoriaSeleccionada = "cafe";

  StreamSubscription<Position>? _posicionStream;

  final MapController _controladorMapa = MapController();
  final MarcadorControlador _controladorMarcador = MarcadorControlador();

  LatLng? _posicionActual;
  List<Marker> _marcadores = [];

  @override
  void initState() {
    super.initState();
    _iniciarEscuchaUbicacion();
  }

  Future<void> _iniciarEscuchaUbicacion() async {
    // 1. Validar servicio
    bool servicioActivo = await Geolocator.isLocationServiceEnabled();
    if (!servicioActivo) {
      print("GPS desactivado");
      return;
    }

    // 2. Validar permisos
    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        print("Permiso denegado");
        return;
      }
    }

    if (permiso == LocationPermission.deniedForever) {
      print("Permiso denegado permanentemente");
      return;
    }

    // 3. Configuración del stream
    LocationSettings locationSettings = const LocationSettings(
      accuracy: LocationAccuracy.high,
      distanceFilter: 50,
    );

    // 4. Escuchar ubicación en tiempo real
    _posicionStream =
        Geolocator.getPositionStream(locationSettings: locationSettings).listen(
          (Position posicion) {
            final nuevaPosicion = LatLng(posicion.latitude, posicion.longitude);

            setState(() {
              _posicionActual = nuevaPosicion;
              print("Nueva posición: $nuevaPosicion");

              _marcadores = [
                _controladorMarcador.crearMarcadorUsuario(
                  nuevaPosicion.latitude,
                  nuevaPosicion.longitude,
                ),
                ..._marcadores.where((m) => m != _marcadores.first),
              ];
            });

            _controladorMapa.move(nuevaPosicion, 14);
          },
        );
  }

  @override
  void dispose() {
    _posicionStream?.cancel();
    super.dispose();
  }

  /*
  Future<void> _getUbicacionActual() async {
    //validar que el servicio de GEOLOCALIZACIÓN esté activo
    bool servicioActivo = await Geolocator.isLocationServiceEnabled();
    if (!servicioActivo) {
      print("GPS desactivado");
      return;
    }
    //validar que se tenga permiso para acceder a la ubicación
    LocationPermission permiso = await Geolocator.checkPermission();
    if (permiso == LocationPermission.denied) {
      permiso = await Geolocator.requestPermission();
      if (permiso == LocationPermission.denied) {
        print("Permiso denegado");
        return;
      }
    }

    Position posicion =
        await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: const Duration(seconds: 30),
        ).catchError((e) {
          print("GPS lento, tenga paciencia");
          print("ERROR REAL: $e");
          return Position(
            latitude: 6.2184357,
            longitude: -75.5736698,
            timestamp: DateTime.now(),
            accuracy: 0,
            altitude: 0,
            altitudeAccuracy: 0,
            heading: 0,
            headingAccuracy: 0,
            speed: 0,
            speedAccuracy: 0,
          );
        });

    setState(() {
      _posicionActual = LatLng(posicion.latitude, posicion.longitude);
      _marcadores = [
        _controladorMarcador.crearMarcadorUsuario(
          _posicionActual!.latitude,
          _posicionActual!.longitude,
        ),
      ];
    });
  }
*/

  Future<void> _buscarLugares() async {
    if (_posicionActual == null) return;

    try {
      final lugares = await MapaServicio().buscarLugares(
        posicion: _posicionActual!,
        categoria: _categoriaSeleccionada,
      );

      setState(() {
        _marcadores = [
          _controladorMarcador.crearMarcadorUsuario(
            _posicionActual!.latitude,
            _posicionActual!.longitude,
          ),
          ...lugares.map(
            (lugar) => _controladorMarcador.crearMarcadorLugar(
              lugar,
              ConfigMapa.obtenerIcono(_categoriaSeleccionada),
              _seleccionandoLugar,
            ),
          ),
        ];
      });
    } catch (e) {
      print(e);
    }
  }

  void _seleccionandoLugar(Lugar lugar) {
    showModalBottomSheet(
      context: context,
      builder: (_) => DescripcionLugar(lugar: lugar, iconos: ConfigMapa.iconos),
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
              _buscarLugares();
            },
          ),
        ],
      ),
      body: _posicionActual == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                FlutterMap(
                  mapController: _controladorMapa,
                  options: MapOptions(
                    initialZoom: 14,
                    initialCenter: _posicionActual!,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                      userAgentPackageName:
                          "com.curso_moviles.explorador_local",
                    ),
                    MarkerLayer(markers: _marcadores),
                  ],
                ),
              ],
            ),
    );
  }
}
