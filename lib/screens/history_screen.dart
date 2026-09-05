import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/app_bottom_nav.dart';

class _HistoryItem {
  final String name;
  final String date;
  final String price;
  final bool done;
  const _HistoryItem(this.name, this.date, this.price, this.done);
}

const _history = [
  _HistoryItem('Frenos delanteros', '15 mar · Elantra A628714', 'RD\$3,200', true),
  _HistoryItem('Cambio de aceite', '2 feb · Elantra A628714', 'RD\$1,800', true),
  _HistoryItem('Diagnóstico computarizado', '20 ene · Elantra A628714', 'RD\$1,200', false),
  _HistoryItem('Alineación y balanceo', '8 dic · Elantra A628714', 'RD\$2,500', true),
];

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Historial')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: _history.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (context, i) {
          final h = _history[i];
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.charcoal.withOpacity(0.12)),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(h.name, style: appBody(size: 13.5, weight: FontWeight.w700)),
                          const SizedBox(height: 3),
                          Text(h.date, style: appBody(size: 11.5, color: AppColors.charcoal.withOpacity(0.5))),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                      decoration: BoxDecoration(
                        color: h.done ? AppColors.emerald.withOpacity(0.14) : AppColors.charcoal.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        h.done ? 'COMPLETADO' : 'CANCELADA',
                        style: appHeading(
                          size: 10,
                          color: h.done ? AppColors.emerald : AppColors.charcoal.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(h.price, style: appHeading(size: 15)),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: const AppBottomNav(currentIndex: 2),
    );
  }
}
