import 'dart:async';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class BluetoothService {
  StreamSubscription<List<ScanResult>>? _scanSubscription;

  final StreamController<List<ScanResult>> _devicesController =
      StreamController<List<ScanResult>>.broadcast();

  Stream<List<ScanResult>> get devices => _devicesController.stream;

  bool get isScanning => FlutterBluePlus.isScanningNow;

  Future<void> startScan() async {
    await stopScan();

    final devices = <ScanResult>[];

    _scanSubscription = FlutterBluePlus.onScanResults.listen((results) {
      devices
        ..clear()
        ..addAll(results);

      _devicesController.add(List.unmodifiable(devices));
    });

    await FlutterBluePlus.startScan(
      timeout: const Duration(seconds: 10),
    );
  }

  Future<void> stopScan() async {
    if (FlutterBluePlus.isScanningNow) {
      await FlutterBluePlus.stopScan();
    }

    await _scanSubscription?.cancel();
    _scanSubscription = null;
  }

  Future<void> connect(BluetoothDevice device) async {
    await device.connect(
      license: License.nonprofit,
      timeout: const Duration(seconds: 10),
      autoConnect: false,
    );
  }

  Future<void> disconnect(BluetoothDevice device) async {
    await device.disconnect();
  }

  Future<bool> isBluetoothAvailable() async {
    return FlutterBluePlus.isSupported;
  }

  Future<void> dispose() async {
    await stopScan();
    await _devicesController.close();
  }
}