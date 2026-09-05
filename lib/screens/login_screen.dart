import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';
import '../widgets/logo_badge.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() {
    // Aquí iría la llamada real a tu backend / Firebase Auth / etc.
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const LogoBadge(size: 64),
              const SizedBox(height: 16),
              Text('Mi Taller RD', style: appHeading(size: 22)),
              const SizedBox(height: 4),
              Text('Tu cita, sin vueltas.', style: appBody(size: 12.5, color: AppColors.charcoal.withOpacity(0.55))),
              const SizedBox(height: 32),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Teléfono',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  border: OutlineInputBorder(borderRadius: BorderRadius.all(Radius.circular(12))),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _login,
                  child: const Text('INICIAR SESIÓN'),
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text('¿Olvidaste tu contraseña?', style: appBody(size: 12, color: AppColors.charcoal.withOpacity(0.55))),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('¿No tienes cuenta? ', style: appBody(size: 12.5, color: AppColors.charcoal.withOpacity(0.6))),
                  GestureDetector(
                    onTap: () {},
                    child: Text('Regístrate', style: appBody(size: 12.5, color: AppColors.orange, weight: FontWeight.w700)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
