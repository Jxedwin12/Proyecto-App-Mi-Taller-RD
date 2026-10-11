import 'package:flutter/material.dart';

import '../models/cita.dart';
import '../services/database_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';

class CitasScreen extends StatefulWidget {
  const CitasScreen({super.key});

  @override
  State<CitasScreen> createState() => _CitasScreenState();
}

class _CitasScreenState extends State<CitasScreen> {
  late Future<List<Cita>> _futureCitas;

  // Ids de las citas que se acaban de deslizar. Se ocultan de inmediato,
  // antes de que termine la actualización en la base de datos, porque
  // Dismissible exige que la tarjeta salga del árbol al instante.
  final Set<int> _ocultas = {};

  @override
  void initState() {
    super.initState();
    _futureCitas = DatabaseService.instance.obtenerCitas();
  }

  Future<void> _recargar() async {
    if (!mounted) return;

    setState(() {
      _futureCitas = DatabaseService.instance.obtenerCitas();
    });
  }

  // Cancela la cita sin eliminarla de la base de datos.
  Future<void> _cancelarCita(Cita cita) async {
    if (cita.id == null) return;

    try {
      await DatabaseService.instance.actualizarCita(
        cita.copyWith(estado: 'cancelada'),
      );

      if (!mounted) return;

      await _recargar();
      _ocultas.remove(cita.id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('La cita se canceló correctamente'),
          duration: const Duration(seconds: 5),
          action: SnackBarAction(
            label: 'Deshacer',
            onPressed: () {
              _deshacerCancelacion(cita);
            },
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      // Si falló la base de datos, la tarjeta vuelve a mostrarse.
      setState(() {
        _ocultas.remove(cita.id);
      });

      await _recargar();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo cancelar la cita'),
        ),
      );
    }
  }

  // Restaura la cita si el usuario pulsa Deshacer.
  Future<void> _deshacerCancelacion(Cita cita) async {
    if (cita.id == null) return;

    try {
      await DatabaseService.instance.actualizarCita(
        cita.copyWith(estado: 'pendiente'),
      );

      if (!mounted) return;

      await _recargar();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Se restauró la cita'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo restaurar la cita'),
        ),
      );
    }
  }

  // Permite seleccionar y guardar una nueva hora.
  Future<void> _reprogramarCita(Cita cita) async {
    final nuevaHora = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      helpText: 'Selecciona la nueva hora',
      cancelText: 'Cancelar',
      confirmText: 'Guardar',
    );

    if (nuevaHora == null || !mounted) return;

    final horaTexto = nuevaHora.format(context);

    try {
      await DatabaseService.instance.actualizarCita(
        cita.copyWith(
          hora: horaTexto,
          estado: 'pendiente',
        ),
      );

      if (!mounted) return;

      await _recargar();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Cita reprogramada para las $horaTexto'),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo reprogramar la cita'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Citas'),
      ),
      body: FutureBuilder<List<Cita>>(
        future: _futureCitas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'No se pudieron cargar las citas',
                style: appBody(size: 13),
              ),
            );
          }

          final citas = (snapshot.data ?? [])
              .where(
                (cita) =>
                    cita.estado.toLowerCase() != 'cancelada' &&
                    !_ocultas.contains(cita.id),
              )
              .toList();

          if (citas.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_month_outlined,
                      size: 70,
                      color: AppColors.charcoal.withOpacity(0.35),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'Aún no tienes citas',
                      style: appHeading(size: 17),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Cuando agendes una cita, aparecerá aquí.',
                      textAlign: TextAlign.center,
                      style: appBody(
                        size: 12,
                        color: AppColors.charcoal.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: citas.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, i) {
              final cita = citas[i];

              return Dismissible(
                key: ValueKey(cita.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.only(right: 22),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
                confirmDismiss: (_) async {
                  return await showDialog<bool>(
                        context: context,
                        builder: (dialogContext) => AlertDialog(
                          title: const Text('Cancelar cita'),
                          content: const Text(
                            '¿Deseas cancelar esta cita?',
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext, false);
                              },
                              child: const Text('Volver'),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.pop(dialogContext, true);
                              },
                              child: const Text('Sí, cancelar'),
                            ),
                          ],
                        ),
                      ) ??
                      false;
                },
                onDismissed: (_) {
                  // La tarjeta se oculta al instante y luego se actualiza la base.
                  setState(() {
                    if (cita.id != null) _ocultas.add(cita.id!);
                  });
                  _cancelarCita(cita);
                },
                child: InkWell(
                  borderRadius: BorderRadius.circular(14),
                  onTap: () => _reprogramarCita(cita),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 14,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: AppColors.charcoal.withOpacity(0.12),
                      ),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cita.servicio,
                                    style: appBody(
                                      size: 13.5,
                                      weight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Cita #${cita.id ?? '-'}',
                                    style: appBody(
                                      size: 11.5,
                                      color:
                                          AppColors.charcoal.withOpacity(0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 9,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.emerald.withOpacity(0.14),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                cita.estado.toUpperCase(),
                                style: appHeading(
                                  size: 10,
                                  color: AppColors.emerald,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 16,
                            ),
                            const SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                cita.dia,
                                style: appBody(size: 12),
                              ),
                            ),
                            const Icon(
                              Icons.access_time_outlined,
                              size: 16,
                            ),
                            const SizedBox(width: 7),
                            Text(
                              cita.hora,
                              style: appBody(size: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Toca la tarjeta para cambiar la hora',
                          style: appBody(
                            size: 10.5,
                            color: AppColors.charcoal.withOpacity(0.55),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: const AppBottomNav(
        currentIndex: 1,
      ),
    );
  }
}