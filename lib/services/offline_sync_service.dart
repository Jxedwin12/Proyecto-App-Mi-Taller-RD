import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'network_service.dart';
 
/// Dirección base de la API. Cuando exista un backend propio, solo se cambia aquí.
const String _baseUrl = 'https://jsonplaceholder.typicode.com';
 
/// Una acción del usuario que no se pudo enviar aún al servidor.
class PendingRequest {
  final String id;
  final String endpoint;
  final String method;
  final Map<String, dynamic>? body;
 
  PendingRequest({required this.id, required this.endpoint, required this.method, this.body});
 
  Map<String, dynamic> toJson() => {'id': id, 'endpoint': endpoint, 'method': method, 'body': body};
 
  factory PendingRequest.fromJson(Map<String, dynamic> json) => PendingRequest(
        id: json['id'],
        endpoint: json['endpoint'],
        method: json['method'],
        body: json['body'] as Map<String, dynamic>?,
      );
}
 
/// OfflineSyncService
/// ---------------------------------------------------------------------
/// Equivalente en Flutter al OfflineSyncService de la versión Ionic:
/// decide si una acción se envía directo al servidor o se guarda en una
/// cola local (con shared_preferences), y sincroniza esa cola sola en
/// cuanto NetworkService detecta que la conexión volvió.
/// ---------------------------------------------------------------------
class OfflineSyncService {
  OfflineSyncService._internal() {
    NetworkService.instance.onStatusChange.listen((online) {
      if (online) syncPendingRequests();
    });
  }
 
  static final OfflineSyncService instance = OfflineSyncService._internal();
 
  static const _queueKey = 'pending_requests';
 
  /// Punto de entrada único para guardar o enviar una acción del usuario
  /// (por ejemplo, confirmar una cita). Devuelve si quedó en cola o no.
  Future<bool> save(String endpoint, String method, Map<String, dynamic>? body) async {
    if (NetworkService.instance.isOnline) {
      final sentOk = await _sendToServer(endpoint, method, body);
      if (sentOk) return false; // false = no quedó en cola, se envió
      await _enqueue(endpoint, method, body);
      return true;
    }
    await _enqueue(endpoint, method, body);
    return true;
  }
 
  /// Envía la acción al servidor con http.post.
  /// Devuelve true si el servidor respondió 201 (creado).
  Future<bool> _sendToServer(String endpoint, String method, Map<String, dynamic>? body) async {
    try {
      final url = Uri.parse('$_baseUrl$endpoint');
      final response = await http
          .post(
            url,
            headers: {'Content-Type': 'application/json; charset=UTF-8'},
            body: jsonEncode(body),
          )
          .timeout(const Duration(seconds: 10));
 
      debugPrint('Respuesta del servidor: ${response.statusCode}');
      debugPrint('Datos recibidos: ${response.body}');
      return response.statusCode == 201;
    } catch (e) {
      debugPrint('Error al enviar al servidor: $e');
      return false;
    }
  }
 
  Future<void> _enqueue(String endpoint, String method, Map<String, dynamic>? body) async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_queueKey) ?? [];
    final req = PendingRequest(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      endpoint: endpoint,
      method: method,
      body: body,
    );
    list.add(jsonEncode(req.toJson()));
    await prefs.setStringList(_queueKey, list);
  }
 
  /// Recorre la cola guardada y reintenta cada acción pendiente.
  /// Las que sigan fallando se quedan en la cola para el próximo intento.
  Future<void> syncPendingRequests() async {
    final prefs = await SharedPreferences.getInstance();
    final list = prefs.getStringList(_queueKey) ?? [];
    if (list.isEmpty) return;
 
    final stillPending = <String>[];
    for (final item in list) {
      final req = PendingRequest.fromJson(jsonDecode(item));
      final ok = await _sendToServer(req.endpoint, req.method, req.body);
      if (!ok) stillPending.add(item);
    }
    await prefs.setStringList(_queueKey, stillPending);
  }
 
  Future<int> pendingCount() async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_queueKey) ?? []).length;
  }
}