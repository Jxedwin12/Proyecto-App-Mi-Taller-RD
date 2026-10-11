import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';
import 'login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Widget _menuItem(BuildContext context, String label, {bool danger = false, VoidCallback? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(border: Border(top: BorderSide(color: AppColors.charcoal.withOpacity(0.08)))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: appBody(size: 13, weight: FontWeight.w600, color: danger ? AppColors.orange : AppColors.charcoal)),
            Icon(Icons.chevron_right, color: AppColors.charcoal.withOpacity(0.3)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil')),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(color: AppColors.asphalt, shape: BoxShape.circle),
                  child: Center(child: Text('RP', style: appHeading(size: 16, color: AppColors.paper))),
                ),
                const SizedBox(width: 14),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Edwin Tejada Nuñez', style: appHeading(size: 16)),
                    Text('809 693 5331', style: appBody(size: 12, color: AppColors.charcoal.withOpacity(0.5))),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('MIS VEHÍCULOS', style: appHeading(size: 12, color: AppColors.charcoal.withOpacity(0.55))),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                Expanded(child: _vehicleCard('Elantra 2019', 'A628714')),
                const SizedBox(width: 8),
                Expanded(child: _vehicleCard('Kia K5 2021', 'A902341')),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _menuItem(context, 'Mis vehículos'),
          _menuItem(context, 'Métodos de pago'),
          _menuItem(context, 'Notificaciones'),
          _menuItem(context, 'Ayuda y soporte'),
          const Spacer(),
          _menuItem(
            context,
            'Cerrar sesión',
            danger: true,
            onTap: () => Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
              (route) => false,
            ),
          ),
        ],
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 3),
    );
  }

  Widget _vehicleCard(String model, String plate) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.charcoal.withOpacity(0.12)),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(model, style: appBody(size: 11.5, weight: FontWeight.w700)),
          Text(plate, style: appBody(size: 10.5, color: AppColors.charcoal.withOpacity(0.5))),
        ],
      ),
    );
  }
}
