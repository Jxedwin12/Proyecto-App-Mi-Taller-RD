import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

import '../bluetooth/bluetooth_service.dart' as bluetooth_service;

class BluetoothScreen extends StatefulWidget {
  const BluetoothScreen({super.key});

  @override
  State<BluetoothScreen> createState() => _BluetoothScreenState();
}

class _BluetoothScreenState extends State<BluetoothScreen> {
  final bluetooth_service.BluetoothService _bluetoothService =
      bluetooth_service.BluetoothService();

  List<ScanResult> _devices = [];
  BluetoothDevice? _connectedDevice;

  bool _isScanning = false;
  bool _isConnecting = false;

  String _status = 'Bluetooth listo para buscar dispositivos';

  // DATOS SIMULADOS DEL VEHÍCULO
  double _batteryVoltage = 12.6;
  double _engineTemperature = 89.0;
  int _engineRpm = 850;
  String _vehicleStatus = 'Normal';

  @override
  void initState() {
    super.initState();

    _bluetoothService.devices.listen((devices) {
      if (!mounted) return;

      setState(() {
        _devices = devices;
      });
    });
  }

  Future<void> _searchDevices() async {
    try {
      setState(() {
        _isScanning = true;
        _status = 'Buscando dispositivos Bluetooth...';
        _devices = [];
      });

      await _bluetoothService.startScan();

      if (!mounted) return;

      setState(() {
        _isScanning = false;
        _status = _devices.isEmpty
            ? 'No se encontraron dispositivos'
            : 'Selecciona un dispositivo para conectarte';
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isScanning = false;
        _status = 'No se pudo iniciar la búsqueda';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error de Bluetooth: $e'),
        ),
      );
    }
  }

  Future<void> _connectToDevice(BluetoothDevice device) async {
    if (_isConnecting) return;

    try {
      setState(() {
        _isConnecting = true;
        _status = 'Conectando con ${_deviceName(device)}...';
      });

      await _bluetoothService.connect(device);

      if (!mounted) return;

      setState(() {
        _connectedDevice = device;
        _isConnecting = false;
        _status = 'Dispositivo conectado correctamente';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Conectado a ${_deviceName(device)}',
          ),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isConnecting = false;
        _status = 'No se pudo conectar al dispositivo';
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'No se pudo conectar a ${_deviceName(device)}',
          ),
        ),
      );
    }
  }

  Future<void> _disconnectDevice() async {
    final device = _connectedDevice;

    if (device == null) return;

    try {
      await _bluetoothService.disconnect(device);

      if (!mounted) return;

      setState(() {
        _connectedDevice = null;
        _status = 'Dispositivo desconectado';
      });
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No se pudo desconectar el dispositivo'),
        ),
      );
    }
  }

  String _deviceName(BluetoothDevice device) {
    final name = device.platformName.trim();

    if (name.isNotEmpty) {
      return name;
    }

    return 'Dispositivo desconocido';
  }

  @override
  void dispose() {
    _bluetoothService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isConnected = _connectedDevice != null;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Conectar por Bluetooth'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // TARJETA PRINCIPAL DE ESTADO
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: isConnected
                    ? Colors.green.withValues(alpha: 0.10)
                    : Theme.of(context)
                        .colorScheme
                        .primary
                        .withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: isConnected
                      ? Colors.green.withValues(alpha: 0.35)
                      : Colors.transparent,
                ),
              ),
              child: Column(
                children: [
                  Icon(
                    isConnected
                        ? Icons.bluetooth_connected
                        : Icons.bluetooth,
                    size: 58,
                    color: isConnected
                        ? Colors.green
                        : Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    isConnected
                        ? 'DISPOSITIVO CONECTADO'
                        : 'Conexión Bluetooth',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: isConnected
                          ? Colors.green.shade700
                          : null,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    isConnected
                        ? _deviceName(_connectedDevice!)
                        : _status,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            // INFORMACIÓN DE LA CONEXIÓN
            if (isConnected) ...[
              const SizedBox(height: 15),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  children: [
                    _infoRow(
                      Icons.bluetooth,
                      'Tecnología',
                      'Bluetooth Low Energy (BLE)',
                    ),
                    const SizedBox(height: 12),
                    _infoRow(
                      Icons.devices,
                      'Dispositivo',
                      _deviceName(_connectedDevice!),
                    ),
                    const SizedBox(height: 12),
                    _infoRow(
                      Icons.check_circle,
                      'Estado',
                      'Conexión activa',
                    ),
                  ],
                ),
              ),
            ],

            // DATOS DE DIAGNÓSTICO
            if (isConnected) ...[
              const SizedBox(height: 15),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Datos del vehículo',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
              const SizedBox(height: 10),

              // BATERÍA Y TEMPERATURA
              Row(
                children: [
                  Expanded(
                    child: _diagnosticCard(
                      Icons.battery_full,
                      'Batería',
                      '${_batteryVoltage.toStringAsFixed(1)} V',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _diagnosticCard(
                      Icons.thermostat,
                      'Temperatura',
                      '${_engineTemperature.toStringAsFixed(0)} °C',
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              // RPM Y ESTADO
              Row(
                children: [
                  Expanded(
                    child: _diagnosticCard(
                      Icons.speed,
                      'RPM',
                      '$_engineRpm',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _diagnosticCard(
                      Icons.check_circle,
                      'Estado',
                      _vehicleStatus,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 15),
            ],

            // BOTÓN DE BÚSQUEDA
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _isScanning || isConnected
                    ? null
                    : _searchDevices,
                icon: Icon(
                  _isScanning
                      ? Icons.sync
                      : Icons.bluetooth_searching,
                ),
                label: Text(
                  _isScanning
                      ? 'Buscando...'
                      : 'Buscar dispositivos',
                ),
              ),
            ),

            // BOTÓN DE DESCONECTAR
            if (isConnected) ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: OutlinedButton.icon(
                  onPressed: _disconnectDevice,
                  icon: const Icon(Icons.bluetooth_disabled),
                  label: const Text('Desconectar dispositivo'),
                ),
              ),
            ],

            const SizedBox(height: 20),

            // LISTA DE DISPOSITIVOS
            Expanded(
              child: _devices.isEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isConnected
                                ? Icons.bluetooth_connected
                                : Icons.bluetooth_disabled,
                            size: 60,
                            color: isConnected
                                ? Colors.green
                                : Colors.grey.shade400,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            isConnected
                                ? 'Conexión establecida'
                                : 'No hay dispositivos encontrados',
                            style: TextStyle(
                              color: isConnected
                                  ? Colors.green.shade700
                                  : Colors.grey.shade600,
                              fontSize: 16,
                              fontWeight: isConnected
                                  ? FontWeight.w600
                                  : FontWeight.normal,
                            ),
                          ),
                          const SizedBox(height: 6),
                          if (!isConnected)
                            Text(
                              'Pulsa "Buscar dispositivos" para comenzar.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.grey.shade500,
                              ),
                            ),
                        ],
                      ),
                    )
                  : ListView.builder(
                      itemCount: _devices.length,
                      itemBuilder: (context, index) {
                        final result = _devices[index];
                        final device = result.device;

                        final isDeviceConnected =
                            _connectedDevice?.remoteId ==
                                device.remoteId;

                        return Card(
                          margin: const EdgeInsets.only(bottom: 10),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: isDeviceConnected
                                  ? Colors.green.withValues(alpha: 0.15)
                                  : null,
                              child: Icon(
                                isDeviceConnected
                                    ? Icons.bluetooth_connected
                                    : Icons.bluetooth,
                                color: isDeviceConnected
                                    ? Colors.green
                                    : null,
                              ),
                            ),
                            title: Text(
                              _deviceName(device),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            subtitle: Text(
                              isDeviceConnected
                                  ? 'Conectado'
                                  : device.remoteId.toString(),
                              style: TextStyle(
                                color: isDeviceConnected
                                    ? Colors.green.shade700
                                    : null,
                                fontWeight: isDeviceConnected
                                    ? FontWeight.w600
                                    : null,
                              ),
                            ),
                            trailing: isDeviceConnected
                                ? ElevatedButton(
                                    onPressed: _disconnectDevice,
                                    child: const Text('Desconectar'),
                                  )
                                : ElevatedButton(
                                    onPressed: _isConnecting
                                        ? null
                                        : () =>
                                            _connectToDevice(device),
                                    child: Text(
                                      _isConnecting
                                          ? 'Conectando...'
                                          : 'Conectar',
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  // INFORMACIÓN DE LA CONEXIÓN
  Widget _infoRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          size: 22,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // TARJETA DE DATOS DEL VEHÍCULO
  Widget _diagnosticCard(
    IconData icon,
    String title,
    String value,
  ) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.grey.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 28,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}