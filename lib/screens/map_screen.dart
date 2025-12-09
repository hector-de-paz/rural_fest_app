import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fiesta_pueblos_app/models/fiesta.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  List<Marker> _markers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFiestas();
  }

  Future<void> _fetchFiestas() async {
    try {
      final data = await Supabase.instance.client
          .from('fiestas')
          .select()
          .order('date');

      final List<Marker> markers = [];
      for (final map in data) {
        final fiesta = Fiesta.fromMap(map);
        if (fiesta.latitude != null && fiesta.longitude != null) {
          markers.add(
            Marker(
              point: LatLng(fiesta.latitude!, fiesta.longitude!),
              width: 80,
              height: 80,
              child: GestureDetector(
                onTap: () => _showFiestaDetails(fiesta),
                child: const Icon(
                  Icons.location_on,
                  color: Colors.red,
                  size: 40,
                ),
              ),
            ),
          );
        }
      }

      if (mounted) {
        setState(() {
          _markers = markers;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error cargando mapa: $e')));
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showFiestaDetails(Fiesta fiesta) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(fiesta.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Fecha: ${fiesta.date.day}/${fiesta.date.month}/${fiesta.date.year}',
            ),
            const SizedBox(height: 8),
            Text(fiesta.description ?? 'Sin descripción'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cerrar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Mapa de Fiestas')),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : FlutterMap(
              options: const MapOptions(
                initialCenter: LatLng(40.4168, -3.7038), // Madrid center
                initialZoom: 6.0,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.hectorpazmul.fiestapueblos',
                ),
                MarkerLayer(markers: _markers),
              ],
            ),
    );
  }
}
