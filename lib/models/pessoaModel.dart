import 'calculoIMCModel.dart';

// enum Sexo { homem, mulher }

class PessoaModel {
  late int id;
  late String nome;
  late Sexo sexo;
  late double altura;

  PessoaModel({
    required this.id,
    required this.nome,
    required this.sexo,
    required this.altura,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'sexo': sexo.toString().split('.').last, // Convertendo enum para string
      'altura': altura,
    };
  }

  factory PessoaModel.fromJson(Map<String, dynamic> json) {
    return PessoaModel(
      id: json['id'],
      nome: json['nome'],
      sexo: json['sexo'] == 'homem'
          ? Sexo.homem
          : Sexo.mulher, // Convertendo string para enum
      altura: json['altura'],
    );
  }
}
