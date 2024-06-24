// ignore_for_file: file_names

import 'package:calculadora_imc/services/imcService.dart';

enum Sexo { homem, mulher }

class CalculoIMCModel {
  late int pessoaId;
  late double altura;
  late Sexo sexo;
  late double peso;
  late double? imcResultado;
  late String? faixaImcId;
  late DateTime dataCalculo;

  CalculoIMCModel({
    required this.pessoaId,
    required this.altura,
    required this.sexo,
    required this.peso,
    this.imcResultado,
    this.faixaImcId,
    required this.dataCalculo,
  });

  Map<String, dynamic> toJson() {
    return {
      'pessoaId': pessoaId,
      'altura': altura,
      'sexo': sexo.toString().split('.').last,
      'peso': peso,
      'imcResultado': imcResultado,
      'faixaImcId': faixaImcId,
      'dataCalculo': dataCalculo.toIso8601String(),
    };
  }

  factory CalculoIMCModel.fromJson(Map<String, dynamic> json) {
    return CalculoIMCModel(
      pessoaId: json['pessoaId'],
      altura: json['altura'],
      sexo: json['sexo'] == 'homem' ? Sexo.homem : Sexo.mulher,
      peso: json['peso'],
      imcResultado: json['imcResultado'],
      faixaImcId: json['faixaImcId'],
      dataCalculo: DateTime.parse(json['dataCalculo']),
    );
  }

  bool calculaImc() {
    imcResultado = peso / (altura * altura);
    faixaImcId = ImcService().retornaFaixaIMC(imcResultado!, sexo.name);
    return imcResultado! > 0;
  }
}
