import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/consejo.dart';

class ApiService {
  static const String base = 'https://jsonplaceholder.typicode.com';

  Future<List<Consejo>> fetchConsejos() async {
    final response = await http
        .get(
          Uri.parse('$base/posts?_limit=5'),
        )
        .timeout(
          const Duration(seconds: 10),
        );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);

      final List<Map<String, String>> consejosEnEspanol = [
        {
          'title': 'Cuida el aceite del motor',
          'body':
              'Revisa el nivel de aceite con regularidad y cámbialo según las indicaciones del fabricante. Un mantenimiento adecuado ayuda a proteger el motor y prolongar su vida útil.',
        },
        {
          'title': 'Revisa el sistema de frenos',
          'body':
              'Si escuchas ruidos al frenar, sientes vibraciones o notas que el vehículo tarda más en detenerse, acude a un taller para revisar el sistema de frenos.',
        },
        {
          'title': 'Mantén las gomas en buen estado',
          'body':
              'Comprueba la presión de las gomas al menos una vez al mes, cuando estén frías. También revisa el desgaste y busca grietas o bultos que puedan afectar la seguridad.',
        },
        {
          'title': 'Verifica el nivel del refrigerante',
          'body':
              'Revisa el nivel del refrigerante con el motor frío y sigue las recomendaciones del fabricante. Nunca abras la tapa del sistema de refrigeración cuando el motor esté caliente.',
        },
        {
          'title': 'No ignores las luces del tablero',
          'body':
              'Si se enciende una luz de advertencia en el tablero, consulta el manual del vehículo para identificar su significado. Si indica un problema grave, detente en un lugar seguro y solicita asistencia.',
        },
      ];

      return List.generate(5, (index) {
        final original = data[index] as Map<String, dynamic>;
        final consejo = consejosEnEspanol[index];

        return Consejo(
          id: original['id'] as int,
          title: consejo['title']!,
          body: consejo['body']!,
        );
      });
    } else {
      throw Exception(
        'Error al cargar los consejos: ${response.statusCode}',
      );
    }
  }
}