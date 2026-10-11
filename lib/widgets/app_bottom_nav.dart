import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../screens/home_screen.dart';
import '../screens/citas_screen.dart';
import '../screens/history_screen.dart';
import '../screens/profile_screen.dart';

/// Barra inferior con las 4 secciones: Inicio, Citas, Historial, Perfil.
/// currentIndex marca cuál pantalla está activa.
class AppBottomNav extends StatelessWidget {
  final int currentIndex;

  const AppBottomNav({super.key, required this.currentIndex});

  void _goTo(BuildContext context, int index) {
    if (index == currentIndex) return;
    Widget screen;
    switch (index) {
      case 0:
        screen = const HomeScreen();
        break;
      case 1:
        screen = const CitasScreen();
        break;
      case 2:
        screen = const HistoryScreen();
        break;
      case 3:
        screen = const ProfileScreen();
        break;
      default:
        return;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => screen));
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (i) => _goTo(context, i),
      selectedItemColor: AppColors.asphalt,
      unselectedItemColor: AppColors.charcoal.withOpacity(0.4),
      showUnselectedLabels: true,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: 'Inicio'),
        BottomNavigationBarItem(icon: Icon(Icons.event_note_outlined), label: 'Citas'),
        BottomNavigationBarItem(icon: Icon(Icons.history), label: 'Historial'),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Perfil'),
      ],
    );
  }
}