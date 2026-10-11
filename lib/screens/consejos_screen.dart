import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/consejo.dart';
import '../services/api_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

class ConsejosScreen extends StatefulWidget {
  const ConsejosScreen({super.key});

  @override
  State<ConsejosScreen> createState() => _ConsejosScreenState();
}

class _ConsejosScreenState extends State<ConsejosScreen> {
  final ApiService _apiService = ApiService();

  late Future<List<Consejo>> _futureConsejos;

  static const String _cacheKey = 'consejos_cache';

  @override
  void initState() {
    super.initState();
    _futureConsejos = _loadConsejos();
  }

  Future<List<Consejo>> _loadConsejos() async {
    try {
      final consejos = await _apiService.fetchConsejos();

      await _saveCache(consejos);

      return consejos;
    } catch (e) {
      final cachedConsejos = await _loadCache();

      if (cachedConsejos != null && cachedConsejos.isNotEmpty) {
        return cachedConsejos;
      }

      rethrow;
    }
  }

  Future<void> _saveCache(List<Consejo> consejos) async {
    final prefs = await SharedPreferences.getInstance();

    final data = consejos
        .map((consejo) => consejo.toJson())
        .toList();

    await prefs.setString(
      _cacheKey,
      jsonEncode(data),
    );
  }

  Future<List<Consejo>?> _loadCache() async {
    final prefs = await SharedPreferences.getInstance();

    final cachedData = prefs.getString(_cacheKey);

    if (cachedData == null) {
      return null;
    }

    try {
      final List<dynamic> data = jsonDecode(cachedData);

      return data
          .map(
            (json) => Consejo.fromJson(
              Map<String, dynamic>.from(json),
            ),
          )
          .toList();
    } catch (_) {
      return null;
    }
  }

  void _retry() {
    setState(() {
      _futureConsejos = _loadConsejos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consejos'),
      ),
      body: FutureBuilder<List<Consejo>>(
        future: _futureConsejos,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.cloud_off_outlined,
                      size: 55,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'No pudimos cargar los consejos',
                      textAlign: TextAlign.center,
                      style: appHeading(size: 17),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Revisa tu conexión a Internet e inténtalo nuevamente.',
                      textAlign: TextAlign.center,
                      style: appBody(
                        size: 13,
                        color: AppColors.charcoal.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _retry,
                      child: const Text('Reintentar'),
                    ),
                  ],
                ),
              ),
            );
          }

          final consejos = snapshot.data ?? [];

          if (consejos.isEmpty) {
            return Center(
              child: Text(
                'No hay consejos disponibles.',
                style: appBody(size: 14),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            itemCount: consejos.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final consejo = consejos[index];

              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppColors.charcoal.withOpacity(0.12),
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      consejo.title,
                      style: appBody(
                        size: 14,
                        weight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      consejo.body,
                      style: appBody(
                        size: 12.5,
                        color: AppColors.charcoal.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}