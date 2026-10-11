class Cita {
  final int? id;
  final String servicio;
  final String dia;
  final String hora;
  final String estado;

  const Cita({
    this.id,
    required this.servicio,
    required this.dia,
    required this.hora,
    required this.estado,
  });

  Map<String, dynamic> toMap() {
    return {
      if (id != null) 'id': id,
      'servicio': servicio,
      'dia': dia,
      'hora': hora,
      'estado': estado,
    };
  }

  factory Cita.fromMap(Map<String, dynamic> map) {
    return Cita(
      id: map['id'] as int?,
      servicio: map['servicio'] as String,
      dia: map['dia'] as String,
      hora: map['hora'] as String,
      estado: map['estado'] as String,
    );
  }

  Cita copyWith({
    int? id,
    String? servicio,
    String? dia,
    String? hora,
    String? estado,
  }) {
    return Cita(
      id: id ?? this.id,
      servicio: servicio ?? this.servicio,
      dia: dia ?? this.dia,
      hora: hora ?? this.hora,
      estado: estado ?? this.estado,
    );
  }
}