import 'package:flutter/material.dart';
import '../services/network_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// OfflineBanner
/// ---------------------------------------------------------------------
/// Equivalente al OfflineBannerComponent de la versión Ionic: aparece
/// solo (sin ocupar espacio cuando no hace falta) explicándole al
/// usuario, sin tecnicismos, que sus cambios no se van a perder.
///
/// Uso: colócalo una sola vez arriba del todo en el layout principal
/// de la app (por ejemplo en el Scaffold de cada pantalla, o en un
/// widget compartido si tienes uno).
/// ---------------------------------------------------------------------
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: NetworkService.instance.onStatusChange,
      initialData: NetworkService.instance.isOnline,
      builder: (context, snapshot) {
        final online = snapshot.data ?? true;

        // Cuando hay conexión, el banner no ocupa espacio en absoluto.
        if (online) return const SizedBox.shrink();

        return Container(
          width: double.infinity,
          color: AppColors.orange,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Text(
            'Estás sin conexión. Tus cambios se guardan en el teléfono y se enviarán solos en cuanto vuelvas a tener internet.',
            style: appBody(size: 11.5, color: AppColors.paper, weight: FontWeight.w600),
          ),
        );
      },
    );
  }
}
