import 'package:flutter/material.dart';
import '../models/service.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/logo_badge.dart';
import '../widgets/offline_banner.dart';
import '../widgets/network_badge.dart';
import 'schedule_screen.dart';
import 'bluetooth_screen.dart';
import 'consejos_screen.dart';
import 'mapa_screen.dart';
import 'fotos_screen.dart';
import 'audio_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const OfflineBanner(),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Buenas, Edwin',
                        style: appBody(
                          size: 12,
                          color: AppColors.charcoal.withOpacity(0.55),
                        ),
                      ),
                      Text(
                        '¿Qué le hacemos hoy?',
                        style: appHeading(size: 20),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: const [
                      NetworkBadge(),
                      SizedBox(width: 10),
                      LogoBadge(size: 40),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 10,
              ),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: AppColors.steel,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Hyundai Elantra 2019',
                      style: appBody(
                        size: 12.5,
                        color: AppColors.paper,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.caution,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'A628714',
                        style: appHeading(
                          size: 11,
                          color: AppColors.charcoal,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'SERVICIOS DISPONIBLES',
                  style: appHeading(size: 13),
                ),
              ),
            ),

            // ACCESOS RÁPIDOS: Bluetooth, consejos (API), mapa (GPS), fotos (cámara) y audio
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
              child: Row(
                children: [
                  Expanded(
                    child: _AccesoRapido(
                      icon: Icons.bluetooth,
                      label: 'Vehículo',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const BluetoothScreen(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _AccesoRapido(
                      icon: Icons.lightbulb_outline,
                      label: 'Consejos',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ConsejosScreen(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _AccesoRapido(
                      icon: Icons.map_outlined,
                      label: 'Taller',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MapaScreen(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _AccesoRapido(
                      icon: Icons.photo_camera_outlined,
                      label: 'Fotos',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const FotosScreen(),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: _AccesoRapido(
                      icon: Icons.headphones_outlined,
                      label: 'Audio',
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AudioScreen(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                itemCount: demoServices.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final s = demoServices[i];

                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ScheduleScreen(service: s),
                      ),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.charcoal.withOpacity(0.12),
                        ),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Text(
                                  s.name,
                                  style: appBody(
                                    size: 13.5,
                                    weight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  s.meta,
                                  style: appBody(
                                    size: 11.5,
                                    color: AppColors.charcoal
                                        .withOpacity(0.55),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            s.priceLabel,
                            style: appHeading(
                              size: 15,
                              color: AppColors.orange,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar:
          const AppBottomNav(currentIndex: 0),
    );
  }
}

/// Botón compacto de acceso rápido: ícono arriba y nombre debajo.
class _AccesoRapido extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _AccesoRapido({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.steel,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                color: AppColors.caution,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: AppColors.charcoal, size: 22),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: appBody(
                size: 10.5,
                color: AppColors.paper,
                weight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}