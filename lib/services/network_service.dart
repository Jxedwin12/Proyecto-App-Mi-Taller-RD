import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

/// NetworkService
/// ---------------------------------------------------------------------
/// Equivalente en Flutter al NetworkService que hicimos en la versión
/// Ionic/Angular, pero usando el paquete connectivity_plus (el
/// equivalente Flutter del plugin @capacitor/network).
///
/// Es un singleton (una sola instancia para toda la app) que expone:
///   - isOnline: el último estado conocido, para lectura rápida.
///   - onStatusChange: un Stream al que cualquier widget se suscribe
///     (con StreamBuilder) para actualizarse solo cuando cambia la red.
/// ---------------------------------------------------------------------
class NetworkService {
  NetworkService._internal() {
    _init();
  }

  static final NetworkService instance = NetworkService._internal();

  final _controller = StreamController<bool>.broadcast();
  bool _isOnline = true;

  Stream<bool> get onStatusChange => _controller.stream;
  bool get isOnline => _isOnline;

  Future<void> _init() async {
    // 1. Estado inicial (por si la app arranca ya sin conexión)
    final initial = await Connectivity().checkConnectivity();
    _updateStatus(initial);

    // 2. Escucha de cambios en tiempo real (equivalente a
    //    Network.addListener('networkStatusChange', ...) de Capacitor)
    Connectivity().onConnectivityChanged.listen(_updateStatus);
  }

  void _updateStatus(List<ConnectivityResult> results) {
    final connected = results.isNotEmpty && !results.contains(ConnectivityResult.none);
    if (connected != _isOnline) {
      _isOnline = connected;
      _controller.add(_isOnline);
    }
  }

  void dispose() => _controller.close();
}
