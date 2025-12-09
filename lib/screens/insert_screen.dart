import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fiesta_pueblos_app/services/geocoding_service.dart';
import 'package:fiesta_pueblos_app/models/fiesta.dart';
import 'package:fiesta_pueblos_app/screens/location_picker_screen.dart';
import 'package:latlong2/latlong.dart';

class InsertScreen extends StatefulWidget {
  const InsertScreen({super.key});

  @override
  State<InsertScreen> createState() => _InsertScreenState();
}

class _InsertScreenState extends State<InsertScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  LatLng? _selectedLocation;

  bool _isLoading = false;
  List<Fiesta> _fiestas = [];
  bool _isLoadingList = true;

  @override
  void initState() {
    super.initState();
    _dateController.text = "${_selectedDate.toLocal()}".split(' ')[0];
    _loadFiestas();
  }

  Future<void> _loadFiestas() async {
    final userId = Supabase.instance.client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      final data = await Supabase.instance.client
          .from('fiestas')
          .select()
          .eq('user_id', userId)
          .order('date', ascending: true);

      if (mounted) {
        setState(() {
          _fiestas = (data as List).map((e) => Fiesta.fromMap(e)).toList();
          _isLoadingList = false;
        });
      }
    } catch (e) {
      if (mounted) {
        debugPrint('Error loading fiestas: $e');
        setState(() {
          _isLoadingList = false;
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  Future<void> _pickLocation(BuildContext context) async {
    final result = await Navigator.of(context).push<LatLng>(
      MaterialPageRoute(builder: (context) => const LocationPickerScreen()),
    );

    if (result != null) {
      setState(() {
        _selectedLocation = result;
      });
    }
  }

  Future<void> _saveFiesta() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;
      final name = _nameController.text.trim();

      double? lat;
      double? lon;

      if (_selectedLocation != null) {
        lat = _selectedLocation!.latitude;
        lon = _selectedLocation!.longitude;
      } else {
        try {
          final coords = await GeocodingService.getCoordinates(name);
          if (coords != null) {
            lat = coords[0];
            lon = coords[1];
          }
        } catch (e) {
          debugPrint('Geocoding failed: $e');
        }
      }

      final fiesta = Fiesta(
        userId: userId,
        name: name,
        description: _descriptionController.text.trim(),
        date: _selectedDate,
        latitude: lat,
        longitude: lon,
        createdAt: DateTime.now(),
      );

      final response = await Supabase.instance.client
          .from('fiestas')
          .insert(fiesta.toMap())
          .select()
          .single();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Fiesta guardada correctamente')),
        );
        _nameController.clear();
        _descriptionController.clear();
        setState(() {
          _selectedLocation = null;
          _fiestas.add(Fiesta.fromMap(response));
          _fiestas.sort((a, b) => a.date.compareTo(b.date));
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al guardar: $e')));
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteFiesta(int id) async {
    final backup = List<Fiesta>.from(_fiestas);
    setState(() {
      _fiestas.removeWhere((f) => f.id == id);
    });

    try {
      await Supabase.instance.client.from('fiestas').delete().eq('id', id);
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Fiesta eliminada')));
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _fiestas = backup;
        });
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error al eliminar: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Insertar Fiesta')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre del Pueblo',
                    ),
                    validator: (value) => value == null || value.isEmpty
                        ? 'Introduce el nombre'
                        : null,
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: const InputDecoration(
                      labelText: 'Descripción de la Fiesta',
                    ),
                    maxLines: 2,
                  ),
                  TextFormField(
                    controller: _dateController,
                    decoration: const InputDecoration(labelText: 'Fecha'),
                    readOnly: true,
                    onTap: () => _selectDate(context),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _pickLocation(context),
                    icon: Icon(
                      _selectedLocation != null
                          ? Icons.check_circle
                          : Icons.map,
                      color: _selectedLocation != null ? Colors.green : null,
                    ),
                    label: Text(
                      _selectedLocation != null
                          ? 'Ubicación seleccionada'
                          : 'Seleccionar en Mapa',
                    ),
                  ),
                  const SizedBox(height: 16),
                  _isLoading
                      ? const CircularProgressIndicator()
                      : ElevatedButton(
                          onPressed: _saveFiesta,
                          child: const Text('Guardar'),
                        ),
                ],
              ),
            ),
          ),
          const Divider(),
          Expanded(
            child: _isLoadingList
                ? const Center(child: CircularProgressIndicator())
                : _fiestas.isEmpty
                ? const Center(child: Text('No has añadido fiestas aún.'))
                : ListView.builder(
                    itemCount: _fiestas.length,
                    itemBuilder: (context, index) {
                      final fiesta = _fiestas[index];
                      return ListTile(
                        title: Text(fiesta.name),
                        subtitle: Text(
                          '${fiesta.date.day}/${fiesta.date.month}/${fiesta.date.year} - ${fiesta.description ?? ""}',
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => _deleteFiesta(fiesta.id!),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
