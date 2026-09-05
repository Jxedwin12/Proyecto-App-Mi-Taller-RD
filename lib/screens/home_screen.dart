import 'package:flutter/material.dart';
import '../models/service.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';
import '../widgets/logo_badge.dart';
import 'schedule_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Buenas, Ramón', style: appBody(size: 12, color: AppColors.charcoal.withOpacity(0.55))),
                      Text('¿Qué le hacemos hoy?', style: appHeading(size: 20)),
                    ],
                  ),
                  const LogoBadge(size: 40),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(color: AppColors.steel, borderRadius: BorderRadius.circular(12)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Hyundai Elantra 2019', style: appBody(size: 12.5, color: AppColors.paper)),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(color: AppColors.caution, borderRadius: BorderRadius.circular(6)),
                      child: Text('A628714', style: appHeading(size: 11, color: AppColors.charcoal)),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text('SERVICIOS DISPONIBLES', style: appHeading(size: 13)),
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                itemCount: demoServices.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final s = demoServices[i];
                  return InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => ScheduleScreen(service: s)),
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.charcoal.withOpacity(0.12)),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(s.name, style: appBody(size: 13.5, weight: FontWeight.w700)),
                                const SizedBox(height: 3),
                                Text(s.meta, style: appBody(size: 11.5, color: AppColors.charcoal.withOpacity(0.55))),
                              ],
                            ),
                          ),
                          Text(s.priceLabel, style: appHeading(size: 15, color: AppColors.orange)),
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
      bottomNavigationBar: const AppBottomNav(currentIndex: 0),
    );
  }
}
