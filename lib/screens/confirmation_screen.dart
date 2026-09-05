import 'package:flutter/material.dart';
import '../models/service.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'home_screen.dart';

class ConfirmationScreen extends StatelessWidget {
  final Service service;
  final String day;
  final String time;

  const ConfirmationScreen({super.key, required this.service, required this.day, required this.time});

  Widget _row(String k, String v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: appBody(size: 12.5, color: AppColors.charcoal.withOpacity(0.5))),
          Text(v, style: appBody(size: 12.5, weight: FontWeight.w700)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(color: AppColors.orange, shape: BoxShape.circle),
                child: const Icon(Icons.check, color: AppColors.paper, size: 30),
              ),
              const SizedBox(height: 16),
              Text('Cita confirmada', style: appHeading(size: 21)),
              const SizedBox(height: 6),
              Text(
                'Te avisamos por WhatsApp una hora antes.\nPuedes reprogramar hasta 3 horas antes.',
                textAlign: TextAlign.center,
                style: appBody(size: 12.5, color: AppColors.charcoal.withOpacity(0.55)),
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.charcoal.withOpacity(0.14)),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _row('Servicio', service.name),
                    _row('Vehículo', 'Elantra · A628714'),
                    _row('Fecha', '$day, $time pm'),
                    _row('Taller', 'San Francisco de Macorís'),
                    _row('Total', service.priceLabel),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.asphalt, width: 1.5),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text('AÑADIR AL CALENDARIO', style: appHeading(size: 12.5, color: AppColors.asphalt)),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                  (route) => false,
                ),
                child: Text('Volver al inicio', style: appBody(size: 12.5, color: AppColors.charcoal.withOpacity(0.55))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
