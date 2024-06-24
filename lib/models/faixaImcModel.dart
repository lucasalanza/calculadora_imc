// ignore_for_file: file_names

class FaixaImcModel {
  final String id;
  final String sexo;
  final double faixaInicio;
  final double? faixaFim;
  final String classificacao;
  final String descricao;

  FaixaImcModel({
    required this.id,
    required this.sexo,
    required this.faixaInicio,
    this.faixaFim,
    required this.classificacao,
    required this.descricao,
  });

  factory FaixaImcModel.fromJson(Map<String, dynamic> json) {
    return FaixaImcModel(
      id: json['id'],
      sexo: json['sexo'],
      faixaInicio: json['faixa_inicio'],
      faixaFim: json['faixa_fim'],
      classificacao: json['classificacao'],
      descricao: json['descricao'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sexo': sexo,
      'faixa_inicio': faixaInicio,
      'faixa_fim': faixaFim,
      'classificacao': classificacao,
      'descricao': descricao,
    };
  }
}
