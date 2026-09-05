import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// El "sello" de la marca: fondo asfalto, tuerca ámbar y llave naranja.
class LogoBadge extends StatelessWidget {
  final double size;

  const LogoBadge({super.key, this.size = 56});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: AppColors.asphalt,
        borderRadius: BorderRadius.circular(size * 0.32),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.hexagon_outlined, color: AppColors.caution, size: size * 0.6),
          Transform.rotate(
            angle: -0.78,
            child: Icon(Icons.build_rounded, color: AppColors.orange, size: size * 0.42),
          ),
        ],
      ),
    );
  }
}
