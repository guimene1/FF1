class Prontuario {
  String? id;
  final String paciente;
  final String descricao;
  final DateTime data;

  Prontuario({
    this.id,
    required this.paciente,
    required this.descricao,
    required this.data,
  });

  Prontuario copyWith({
    String? id,
    String? paciente,
    String? descricao,
    DateTime? data,
  }) {
    return Prontuario(
      id: id ?? this.id,
      paciente: paciente ?? this.paciente,
      descricao: descricao ?? this.descricao,
      data: data ?? this.data,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'paciente': paciente,
      'descricao': descricao,
      'data': data.toIso8601String(),
    };
  }

  factory Prontuario.fromMap(String id, Map<String, dynamic> map) {
    return Prontuario(
      id: id,
      paciente: map['paciente'],
      descricao: map['descricao'],
      data: DateTime.parse(map['data']),
    );
  }
}