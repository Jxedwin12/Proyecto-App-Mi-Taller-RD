import 'package:flutter/material.dart';
import '../services/network_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// NetworkBadge
/// ---------------------------------------------------------------------
/// Mismo concepto que el NetworkStatusComponent de la versión Ionic:
/// un badge chiquito que muestra "En línea" / "Sin conexión" y se
/// actualiza solo, en tiempo real, sin que la pantalla tenga que
/// preguntar manualmente el estado.
///
/// Uso: colócalo en cualquier AppBar o header, por ejemplo:
///   Row(children: [Spacer(), NetworkBadge()])
/// ---------------------------------------------------------------------
class NetworkBadge extends StatelessWidget {
  const NetworkBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<bool>(
      stream: NetworkService.instance.onStatusChange,
      initialData: NetworkService.instance.isOnline,
      builder: (context, snapshot) {
        final online = snapshot.data ?? true;
        final color = online ? AppColors.emerald : AppColors.orange;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withOpacity(0.14),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(online ? Icons.wifi : Icons.cloud_off, size: 14, color: color),
              const SizedBox(width: 5),
              Text(
                online ? 'En línea' : 'Sin conexión',
                style: appBody(size: 11, weight: FontWeight.w700, color: color),
              ),
            ],
          ),
        );
      },
    );
  }
}
