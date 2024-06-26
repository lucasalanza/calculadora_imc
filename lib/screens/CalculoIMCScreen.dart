import 'package:calculadora_imc/components/IMCCard.dart';
import 'package:calculadora_imc/components/menu.dart';
import 'package:calculadora_imc/models/faixaImcModel.dart';
import 'package:calculadora_imc/screens/HistoricoScreen.dart';
import 'package:calculadora_imc/screens/dadosIMC.dart';
import 'package:calculadora_imc/services/imcService.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import '../models/pessoaModel.dart';
import '../models/calculoIMCModel.dart';
import '../services/SharedPreferencesService.dart';
import '../screens/AddPersonScreen.dart';

class CalculoIMCScreen extends StatefulWidget {
  const CalculoIMCScreen({Key? key}) : super(key: key);

  @override
  _CalculoIMCScreenState createState() => _CalculoIMCScreenState();
}

class _CalculoIMCScreenState extends State<CalculoIMCScreen> {
  List<PessoaModel>? listaPessoas = [];
  List<FaixaImcModel> faixaImcList = ImcService.getFaixaImcList();
  PessoaModel? selectedPessoa;
  final _pesoController = TextEditingController();
  String? imcResultado, imcResultadoFaixa;
  List<CalculoIMCModel> calculos = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final prefsService = SharedPreferencesService();
    final pessoas = await prefsService.loadPessoas();
    if (pessoas.isNotEmpty) {
      setState(() {
        listaPessoas = pessoas;
        selectedPessoa = pessoas.first;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calcular IMC'),
      ),
      drawer: const DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Calcular IMC para ',
              style: TextStyle(fontSize: 22),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: DropdownButtonFormField<PessoaModel>(
                    value: selectedPessoa,
                    items: listaPessoas?.map((item) {
                      return DropdownMenuItem<PessoaModel>(
                        value: item,
                        child: Text(
                            '${item.nome.split(' ').first} - ${item.altura}'),
                      );
                    }).toList(),
                    onChanged: (PessoaModel? newValue) {
                      setState(() {
                        selectedPessoa = newValue;
                        _pesoController.text = "";
                      });
                    },
                    hint: const Text('Selecione uma pessoa'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const AddPersonScreen()),
                    ).then((_) {
                      _loadData();
                    });
                  },
                  child: const Text('+ Pessoa'),
                ),
              ],
            ),
            if (selectedPessoa != null) ...[
              const SizedBox(height: 20),
              Row(
                children: [
                  const Text(
                    'Selecionado:',
                    style: TextStyle(fontSize: 18),
                  ),
                  const SizedBox(
                    height: 20,
                    width: 20,
                  ),
                  Column(
                    children: [
                      Text(
                          '${selectedPessoa!.nome} (${selectedPessoa!.sexo.toString().split('.')[1]})'),
                      Text('Altura: ${selectedPessoa!.altura}m'),
                    ],
                  ),
                ],
              ),
            ],
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _pesoController,
                    decoration: const InputDecoration(labelText: 'Peso (kg)'),
                    keyboardType: TextInputType.number,
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    _calculateIMC();
                  },
                  child: const Text('Calcular'),
                ),
              ],
            ),
            if (imcResultado != null) ...[
              const SizedBox(height: 20),
              Text(
                'IMC calculado: $imcResultado',
                style: const TextStyle(fontSize: 22),
              ),
              IMCCard(
                faixaImcModel: faixaImcList
                    .where((x) => x.id == calculos.first.faixaImcId)
                    .first,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const dadosImcScreen()),
                  );
                },
                child: const Text('Entenda os Resultados'),
              ),
            ],
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HistoricoScreen(pessoaId: selectedPessoa!.id),
                  ),
                );
              },
              child: const Text('Ver Histórico'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _calculateIMC() async {
    if (selectedPessoa != null && _pesoController.text.isNotEmpty) {
      final peso = double.parse(_pesoController.text);
      final altura = selectedPessoa!.altura;

      final prefsService = SharedPreferencesService();
      final novoCalculo = CalculoIMCModel(
        pessoaId: selectedPessoa!.id,
        altura: altura,
        sexo: selectedPessoa!.sexo,
        peso: peso,
        dataCalculo: DateTime.now(),
      );
      novoCalculo.calculaImc();

      setState(() {
        imcResultado = novoCalculo.imcResultado!.toStringAsFixed(2);
      });

      await prefsService.saveCalculo(novoCalculo);
    }
  }
}
