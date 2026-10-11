class Consejo {
  final int id;
  final String title;
  final String body;

  const Consejo({
    required this.id,
    required this.title,
    required this.body,
  });

  factory Consejo.fromJson(Map<String, dynamic> json) {
    return Consejo(
      id: json['id'] as int,
      title: json['title'] as String,
      body: json['body'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
    };
  }
}