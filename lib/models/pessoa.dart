class Pessoa {
  String id;
  String nome;
  int idade;
  double peso;
  double altura;
  DateTime dataCriacao;
  String sexo;
  String nivel;
  String objetivo;

  Pessoa({
    required this.id,
    required this.nome,
    required this.idade,
    required this.peso,
    required this.altura,
    required this.dataCriacao,
    required this.sexo,
    required this.nivel,
    required this.objetivo,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'idade': idade,
      'peso': peso,
      'altura': altura,
      'dataCriacao': dataCriacao.toIso8601String(),
      'sexo': sexo,
      'nivel': nivel,
      'objetivo': objetivo,
    };
  }

  factory Pessoa.fromMap(Map<String, dynamic> map) {
    return Pessoa(
      id: map['id'] ?? '',
      nome: map['nome'] ?? '',
      idade: map['idade'] ?? 0,
      peso: map['peso']?.toDouble() ?? 0.0,
      altura: map['altura']?.toDouble() ?? 0.0,
      dataCriacao: DateTime.parse(map['dataCriacao'] ?? DateTime.now().toIso8601String()),
      sexo: map['sexo'] ?? '',
      nivel: map['nivel'] ?? '',
      objetivo: map['objetivo'] ?? '',
    );
  }

  Pessoa copyWith({
    String? id,
    String? nome,
    int? idade,
    double? peso,
    double? altura,
    DateTime? dataCriacao,
    String? sexo,
    String? nivel,
    String? objetivo,
  }) {
    return Pessoa(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      idade: idade ?? this.idade,
      peso: peso ?? this.peso,
      altura: altura ?? this.altura,
      dataCriacao: dataCriacao ?? this.dataCriacao,
      sexo: sexo ?? this.sexo,
      nivel: nivel ?? this.nivel,
      objetivo: objetivo ?? this.objetivo,
    );
  }
}