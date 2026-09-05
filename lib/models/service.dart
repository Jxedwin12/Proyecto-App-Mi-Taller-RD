class Service {
  final String name;
  final String meta;
  final int price;

  const Service({required this.name, required this.meta, required this.price});

  String get priceLabel => 'RD\$${price.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (m) => '${m[1]},',
      )}';
}

/// Los mismos servicios del boceto.
const List<Service> demoServices = [
  Service(name: 'Cambio de aceite', meta: 'Incluye filtro · 30 min', price: 1800),
  Service(name: 'Frenos delanteros', meta: 'Pastillas + revisión · 1 h', price: 3200),
  Service(name: 'Alineación y balanceo', meta: '4 ruedas · 45 min', price: 2500),
  Service(name: 'Cambio de batería', meta: 'Instalación incluida · 20 min', price: 3500),
  Service(name: 'Aire acondicionado', meta: 'Recarga de gas + revisión · 1 h', price: 2200),
  Service(name: 'Suspensión', meta: 'Amortiguadores y rótulas · 2 h', price: 4800),
  Service(name: 'Diagnóstico computarizado', meta: 'Escaneo de fallas · 25 min', price: 1200),
  Service(name: 'Cambio de correa de tiempo', meta: 'Con kit completo · 3 h', price: 6500),
];
