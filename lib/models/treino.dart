class Treino {
  String id;
  String pessoaId;
  String nomeExercicio;
  int series;
  int repeticoes;
  double carga;
  String grupoMuscular;
  String? observacoes;
  bool realizado;
  DateTime dataTreino;

  Treino({
    required this.id,
    required this.pessoaId,
    required this.nomeExercicio,
    required this.series,
    required this.repeticoes,
    required this.carga,
    required this.grupoMuscular,
    this.observacoes,
    required this.realizado,
    required this.dataTreino,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pessoaId': pessoaId,
      'nomeExercicio': nomeExercicio,
      'series': series,
      'repeticoes': repeticoes,
      'carga': carga,
      'grupoMuscular': grupoMuscular,
      'observacoes': observacoes,
      'realizado': realizado,
      'dataTreino': dataTreino.toIso8601String(),
    };
  }

  factory Treino.fromMap(Map<String, dynamic> map) {
    return Treino(
      id: map['id'] ?? '',
      pessoaId: map['pessoaId'] ?? '',
      nomeExercicio: map['nomeExercicio'] ?? '',
      series: map['series'] ?? 0,
      repeticoes: map['repeticoes'] ?? 0,
      carga: map['carga']?.toDouble() ?? 0.0,
      grupoMuscular: map['grupoMuscular'] ?? '',
      observacoes: map['observacoes'],
      realizado: map['realizado'] ?? false,
      dataTreino: DateTime.parse(map['dataTreino'] ?? DateTime.now().toIso8601String()),
    );
  }

  Treino copyWith({
    String? id,
    String? pessoaId,
    String? nomeExercicio,
    int? series,
    int? repeticoes,
    double? carga,
    String? grupoMuscular,
    String? observacoes,
    bool? realizado,
    DateTime? dataTreino,
  }) {
    return Treino(
      id: id ?? this.id,
      pessoaId: pessoaId ?? this.pessoaId,
      nomeExercicio: nomeExercicio ?? this.nomeExercicio,
      series: series ?? this.series,
      repeticoes: repeticoes ?? this.repeticoes,
      carga: carga ?? this.carga,
      grupoMuscular: grupoMuscular ?? this.grupoMuscular,
      observacoes: observacoes ?? this.observacoes,
      realizado: realizado ?? this.realizado,
      dataTreino: dataTreino ?? this.dataTreino,
    );
  }
}