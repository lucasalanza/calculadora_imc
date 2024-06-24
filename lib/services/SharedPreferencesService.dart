import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import '../models/pessoaModel.dart';
import '../models/calculoIMCModel.dart';

class SharedPreferencesService {
  static const String pessoasKey = 'pessoas';
  static const String calculosKey = 'calculos';

  Future<void> savePessoa(PessoaModel pessoa) async {
    final prefs = await SharedPreferences.getInstance();
    final pessoasStringList = prefs.getStringList(pessoasKey) ?? [];
    pessoasStringList.add(jsonEncode(pessoa.toJson()));
    await prefs.setStringList(pessoasKey, pessoasStringList);
  }

  Future<List<PessoaModel>> loadPessoas() async {
    final prefs = await SharedPreferences.getInstance();
    final pessoasStringList = prefs.getStringList(pessoasKey) ?? [];
    return pessoasStringList
        .map((jsonString) => PessoaModel.fromJson(jsonDecode(jsonString)))
        .toList();
  }

  Future<void> deletePessoa(PessoaModel pessoa) async {
    final prefs = await SharedPreferences.getInstance();
    List<PessoaModel> pessoas = await loadPessoas();
    pessoas.remove(pessoa);
    final List<String> jsonStringList =
        pessoas.map((pessoa) => jsonEncode(pessoa.toJson())).toList();
    prefs.setStringList(pessoasKey, jsonStringList);
  }

  Future<void> saveCalculos(List<CalculoIMCModel> calculos) async {
    final prefs = await SharedPreferences.getInstance();
    final calculosJson = calculos.map((c) => c.toJson()).toList();
    final calculosStringList =
        calculosJson.map((json) => jsonEncode(json)).toList();
    await prefs.setStringList(calculosKey, calculosStringList);
  }

  Future<void> saveCalculo(CalculoIMCModel calculo) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? calculosStringList = prefs.getStringList(calculosKey);
    calculosStringList?.add(jsonEncode(calculo.toJson()));
    await prefs.setStringList(calculosKey, calculosStringList ?? []);
  }

  Future<List<CalculoIMCModel>> loadCalculos() async {
    final prefs = await SharedPreferences.getInstance();
    final calculosStringList = prefs.getStringList(calculosKey);
    if (calculosStringList != null) {
      return calculosStringList
          .map((jsonString) => CalculoIMCModel.fromJson(jsonDecode(jsonString)))
          .toList();
    }
    return [];
  }

  Future<void> deleteCalculo(CalculoIMCModel calculo) async {
    final prefs = await SharedPreferences.getInstance();
    List<CalculoIMCModel> calculos = await loadCalculos();
    calculos.remove(calculo);
    final List<String> jsonStringList =
        calculos.map((calculo) => jsonEncode(calculo.toJson())).toList();
    prefs.setStringList(calculosKey, jsonStringList);
  }
}
