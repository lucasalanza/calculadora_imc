// ignore_for_file: file_names

import 'dart:convert';
import 'package:calculadora_imc/models/calculoIMCModel.dart';
import 'package:flutter/services.dart';

import '../models/faixaImcModel.dart';

class ImcService {
  static List<FaixaImcModel> _faixaImcList = [];

  static Future<void> loadImcData() async {
    final String response = await rootBundle.loadString('assets/imc_data.json');
    final List<dynamic> data = jsonDecode(response);
    _faixaImcList = data.map((json) => FaixaImcModel.fromJson(json)).toList();
  }

  static List<FaixaImcModel> getFaixaImcList() {
    return _faixaImcList;
  }

  String retornaFaixaIMC(double d, String sexo) {
    if (_faixaImcList == []) loadImcData();

    return _faixaImcList
        .where((x) =>
            d > x.faixaInicio &&
            (x.faixaFim == null || x.faixaFim! > d) &&
            sexo == sexo)
        .first
        .id;
  }

  static String retornaDescricaoFaixaIMC(String idfaixa) {
    if (_faixaImcList == []) loadImcData();
    return _faixaImcList.where((x) => idfaixa == x.id).first.descricao;
  }

  static String retornaClassificacaoFaixaIMC(String idfaixa) {
    if (_faixaImcList == []) loadImcData();
    return _faixaImcList.where((x) => idfaixa == x.id).first.classificacao;
  }
}
