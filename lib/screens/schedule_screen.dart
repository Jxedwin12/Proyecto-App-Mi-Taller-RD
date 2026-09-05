import 'package:flutter/material.dart';
import '../models/service.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import 'confirmation_screen.dart';

class ScheduleScreen extends StatefulWidget {
  final Service service;

  const ScheduleScreen({super.key, required this.service});

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final days = const [
    {'label': 'LUN', 'num': '14'},
    {'label': 'MAR', 'num': '15'},
    {'label': 'MIÉ', 'num': '16'},
    {'label': 'JUE', 'num': '17'},
    {'label': 'VIE', 'num': '18'},
  ];
  final slots = const ['8:00', '9:00', '10:00', '1:00', '2:00', '3:00'];
  final fullSlots = const ['9:00', '3:00'];

  int selectedDay = 1;
  String selectedSlot = '1:00';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.service.name)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              children: List.generate(days.length, (i) {
                final selected = i == selectedDay;
                return Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedDay = i),
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: selected ? AppColors.asphalt : AppColors.charcoal.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(days[i]['label']!, style: appBody(size: 11, color: selected ? AppColors.paper : AppColors.charcoal)),
                          const SizedBox(height: 2),
                          Text(days[i]['num']!, style: appHeading(size: 15, color: selected ? AppColors.caution : AppColors.charcoal)),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 6, 20, 6),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text('HORARIOS · MARTES 15', style: appHeading(size: 13)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: GridView.count(
              crossAxisCount: 3,
              shrinkWrap: true,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 2.1,
              children: slots.map((slot) {
                final isFull = fullSlots.contains(slot);
                final isChosen = slot == selectedSlot;
                return GestureDetector(
                  onTap: isFull ? null : () => setState(() => selectedSlot = slot),
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: isChosen ? AppColors.orange : Colors.transparent,
                      border: Border.all(
                        color: isChosen ? AppColors.orange : AppColors.charcoal.withOpacity(0.15),
                        style: isFull ? BorderStyle.solid : BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      slot,
                      style: appBody(
                        size: 12,
                        weight: FontWeight.w700,
                        color: isFull
                            ? AppColors.charcoal.withOpacity(0.25)
                            : (isChosen ? AppColors.paper : AppColors.charcoal.withOpacity(0.65)),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Text('Bahía 2 · mecánico: Frank Peña', style: appBody(size: 11.5, color: AppColors.charcoal.withOpacity(0.5))),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConfirmationScreen(
                      service: widget.service,
                      day: '${days[selectedDay]['label']} ${days[selectedDay]['num']}',
                      time: selectedSlot,
                    ),
                  ),
                ),
                child: Text('CONFIRMAR $selectedSlot PM'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
