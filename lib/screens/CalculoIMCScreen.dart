import 'package:calculadora_imc/components/IMCCard.dart';
import 'package:calculadora_imc/components/menu.dart';
import 'package:calculadora_imc/models/faixaImcModel.dart';
import 'package:calculadora_imc/screens/HistoricoScreen.dart';
import 'package:calculadora_imc/screens/dadosIMC.dart';
import 'package:calculadora_imc/services/imcService.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

import '../models/pessoaModel.dart';
import '../models/calculoIMCModel.dart';
import '../services/SharedPreferencesService.dart';
import 'personScreen.dart';

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
  late CalculoIMCModel calculo, novoCalculo;

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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Escolha a pessoa',
                style: TextStyle(fontSize: 18),
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
                              '${item.nome.split(' ').first} - ${item.altura.toString().replaceAll('.', ',')}m'),
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
                            builder: (context) => const PersonScreen()),
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
                        Text(
                            'Altura: ${selectedPessoa!.altura.toString().replaceAll('.', ',')}m'),
                      ],
                    ),
                  ],
                ),
              ],
              TextField(
                controller: _pesoController,
                decoration: const InputDecoration(labelText: 'Peso (kg)'),
                keyboardType: TextInputType.numberWithOptions(decimal: true),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\,?\d*$')),
                ],
              ),
              const SizedBox(
                height: 22,
              ),
              ElevatedButton(
                onPressed: () {
                  _calculateIMC();
                },
                child: const Text('Calcular IMC'),
              ),
              if (imcResultado != null) ...[
                const SizedBox(height: 20),
                Column(
                  children: [
                    Text(novoCalculo.sexo.toString().split('.')[1]),
                    Text(
                        ' Peso: ${novoCalculo.peso}  Altura: ${novoCalculo.altura.toString().replaceAll('.', ',')}m'),
                  ],
                ),
                Text(
                  'IMC calculado: $imcResultado',
                  style: const TextStyle(fontSize: 22),
                ),
                IMCCard(
                  faixaImcModel: faixaImcList
                      .where((x) => x.id == calculo.faixaImcId)
                      .first,
                ),
                const SizedBox(
                  height: 22,
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
              const SizedBox(
                height: 22,
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          HistoricoScreen(pessoaId: selectedPessoa?.id ?? 0),
                    ),
                  );
                },
                child: const Text('Ver Histórico'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _calculateIMC() async {
    if (selectedPessoa != null && _pesoController.text.isNotEmpty) {
      final peso = double.parse(_pesoController.text);
      final altura = selectedPessoa!.altura;

      final prefsService = SharedPreferencesService();
      novoCalculo = CalculoIMCModel(
        pessoaId: selectedPessoa!.id,
        altura: altura,
        sexo: selectedPessoa!.sexo,
        peso: peso,
        dataCalculo: DateTime.now(),
      );
      novoCalculo.calculaImc();
      prefsService.saveCalculo(novoCalculo);

      setState(() {
        calculo = novoCalculo;
        imcResultado = novoCalculo.imcResultado!.toStringAsFixed(2);
        _pesoController.text = '';
        selectedPessoa = null;
      });
    }
  }
}
