import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapaScreen extends StatefulWidget {
  const MapaScreen({super.key});

  @override
  State<MapaScreen> createState() => _MapaScreenState();
}

class _MapaScreenState extends State<MapaScreen> {
  final MapController _mapController = MapController();

  // Coordenadas de ejemplo: reemplázalas por las del taller.
  final LatLng _ubicacionTaller = LatLng(19.3008, -70.2526);

  LatLng? _ubicacionUsuario;
  bool _buscandoUbicacion = false;

  Future<void> _mostrarMiUbicacion() async {
    if (_buscandoUbicacion) return;

    setState(() {
      _buscandoUbicacion = true;
    });

    try {
      final servicioActivo = await Geolocator.isLocationServiceEnabled();

      if (!servicioActivo) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Activa la ubicación del teléfono para continuar.',
            ),
          ),
        );
        return;
      }

      LocationPermission permiso = await Geolocator.checkPermission();

      if (permiso == LocationPermission.denied) {
        permiso = await Geolocator.requestPermission();
      }

      if (permiso == LocationPermission.denied ||
          permiso == LocationPermission.deniedForever) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Debes conceder permiso de ubicación para usar esta función.',
            ),
          ),
        );
        return;
      }

      final Position posicion = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      final nuevaUbicacion = LatLng(
        posicion.latitude,
        posicion.longitude,
      );

      if (!mounted) return;

      setState(() {
        _ubicacionUsuario = nuevaUbicacion;
      });

      _mapController.move(nuevaUbicacion, 16);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('No se pudo obtener la ubicación: $e'),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _buscandoUbicacion = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ubicación del taller'),
        centerTitle: true,
      ),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialCenter: _ubicacionTaller,
          initialZoom: 15,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.flutter_application_1',
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: _ubicacionTaller,
                width: 130,
                height: 80,
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.build_circle,
                      color: Colors.red,
                      size: 40,
                    ),
                    Text(
                      'Mi Taller RD',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        backgroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              if (_ubicacionUsuario != null)
                Marker(
                  point: _ubicacionUsuario!,
                  width: 110,
                  height: 70,
                  child: const Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.my_location,
                        color: Colors.blue,
                        size: 35,
                      ),
                      Text(
                        'Mi ubicación',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _buscandoUbicacion ? null : _mostrarMiUbicacion,
        tooltip: 'Mostrar mi ubicación',
        child: _buscandoUbicacion
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2,
                ),
              )
            : const Icon(Icons.my_location),
      ),
    );
  }
}