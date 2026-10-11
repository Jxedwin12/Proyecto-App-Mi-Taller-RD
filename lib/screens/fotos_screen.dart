import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class FotosScreen extends StatefulWidget {
  const FotosScreen({super.key});

  @override
  State<FotosScreen> createState() => _FotosScreenState();
}

class _FotosScreenState extends State<FotosScreen> {
  final ImagePicker _picker = ImagePicker();

  List<File> _fotos = [];
  bool _cargando = true;

  @override
  void initState() {
    super.initState();
    _cargarFotos();
  }

  // Obtiene o crea la carpeta donde se guardarán las fotos.
  Future<Directory> _obtenerCarpeta() async {
    final documentos = await getApplicationDocumentsDirectory();
    final carpeta = Directory('${documentos.path}/fotos');

    if (!await carpeta.exists()) {
      await carpeta.create(recursive: true);
    }

    return carpeta;
  }

  // Lee la carpeta y conserva solamente los archivos .jpg.
  Future<void> _cargarFotos() async {
    try {
      final carpeta = await _obtenerCarpeta();

      final archivos = carpeta
          .listSync()
          .whereType<File>()
          .where(
            (archivo) => archivo.path.toLowerCase().endsWith('.jpg'),
          )
          .toList();

      // El nombre lleva la hora, así que ordenar por nombre deja las
      // fotos más recientes primero.
      archivos.sort((a, b) => b.path.compareTo(a.path));

      if (!mounted) return;

      setState(() {
        _fotos = archivos;
        _cargando = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _cargando = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudieron cargar las fotos.'),
        ),
      );
    }
  }

  // Abre la cámara, guarda la foto y actualiza la cuadrícula.
  Future<void> _tomarFoto() async {
    try {
      final XFile? foto = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 85,
      );

      // La cámara puede tardar y el usuario puede salir de la pantalla.
      if (!mounted) return;
      if (foto == null) return;

      final carpeta = await _obtenerCarpeta();

      final nombre = 'foto_${DateTime.now().microsecondsSinceEpoch}.jpg';
      final destino = File('${carpeta.path}/$nombre');

      await File(foto.path).copy(destino.path);

      if (!mounted) return;

      await _cargarFotos();
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo tomar o guardar la foto.'),
        ),
      );
    }
  }

  // Pide confirmación antes de eliminar una foto.
  Future<void> _eliminarFoto(File archivo) async {
    final confirmar = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar foto'),
        content: const Text(
          '¿Estás seguro de que deseas eliminar esta foto?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (!mounted || confirmar != true) return;

    try {
      await archivo.delete();

      if (!mounted) return;

      await _cargarFotos();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Foto eliminada correctamente.'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo eliminar la foto.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mis fotos'),
        centerTitle: true,
      ),
      body: _cargando
          ? const Center(child: CircularProgressIndicator())
          : _fotos.isEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.photo_library_outlined,
                          size: 70,
                          color: AppColors.charcoal.withOpacity(0.35),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'Aún no hay fotos',
                          style: appHeading(size: 17),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Pulsa "Tomar foto" para comenzar.',
                          textAlign: TextAlign.center,
                          style: appBody(
                            size: 12,
                            color: AppColors.charcoal.withOpacity(0.6),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : GridView.builder(
                  // El espacio de abajo evita que el botón tape la última fila.
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 90),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: _fotos.length,
                  itemBuilder: (context, index) {
                    final archivo = _fotos[index];

                    return GestureDetector(
                      onLongPress: () => _eliminarFoto(archivo),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(
                              archivo,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const ColoredBox(
                                  color: Colors.black12,
                                  child: Center(
                                    child: Icon(
                                      Icons.broken_image,
                                      size: 40,
                                    ),
                                  ),
                                );
                              },
                            ),
                            const Positioned(
                              right: 8,
                              bottom: 8,
                              child: Icon(
                                Icons.touch_app,
                                color: Colors.white,
                                shadows: [
                                  Shadow(
                                    blurRadius: 5,
                                    color: Colors.black,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _tomarFoto,
        icon: const Icon(Icons.camera_alt),
        label: const Text('Tomar foto'),
      ),
    );
  }
}