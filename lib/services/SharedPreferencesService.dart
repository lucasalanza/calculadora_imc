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

  Future<void> savePessoas(List<PessoaModel> pessoas) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> jsonStringList =
        pessoas.map((pessoa) => jsonEncode(pessoa.toJson())).toList();
    await prefs.setStringList(pessoasKey, jsonStringList);
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
    pessoas.removeWhere((p) => p.id == pessoa.id);
    await savePessoas(pessoas);
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
    final newCalculoString = jsonEncode(calculo.toJson());
    if (calculosStringList != null) {
      calculosStringList.add(newCalculoString);
      await prefs.setStringList(calculosKey, calculosStringList);
    } else {
      await prefs.setStringList(calculosKey, [newCalculoString]);
    }
  }

  Future<List<CalculoIMCModel>> loadCalculos() async {
    final prefs = await SharedPreferences.getInstance();
    final calculosStringList = prefs.getStringList(calculosKey) ?? [];
    return calculosStringList
        .map((jsonString) => CalculoIMCModel.fromJson(jsonDecode(jsonString)))
        .toList();
  }

  Future<void> deleteCalculo(CalculoIMCModel calculo) async {
    final prefs = await SharedPreferences.getInstance();
    List<CalculoIMCModel> calculos = await loadCalculos();
    calculos.removeWhere((c) => c.imcResultado == calculo.imcResultado);
    await saveCalculos(calculos);
  }
}
