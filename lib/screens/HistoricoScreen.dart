import 'package:calculadora_imc/components/menu.dart';
import 'package:flutter/material.dart';
import '../models/calculoIMCModel.dart';
import '../services/SharedPreferencesService.dart';
import '../models/pessoaModel.dart';
import '../services/imcService.dart';

class HistoricoScreen extends StatefulWidget {
  final int pessoaId;

  const HistoricoScreen({Key? key, required this.pessoaId}) : super(key: key);

  @override
  _HistoricoScreenState createState() => _HistoricoScreenState();
}

class _HistoricoScreenState extends State<HistoricoScreen> {
  List<CalculoIMCModel> calculos = [];

  List<PessoaModel>? listaPessoas;
  PessoaModel? selectedPessoa;

  @override
  void initState() {
    super.initState();
    _loadData();
    _loadCalculos();
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

  Future<void> _loadCalculos() async {
    final prefsService = SharedPreferencesService();
    final loadedCalculos = await prefsService.loadCalculos();
    setState(() {
      calculos =
          loadedCalculos.where((c) => c.pessoaId == widget.pessoaId).toList();
      calculos.sort((a, b) => b.dataCalculo.compareTo(a.dataCalculo));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Cálculos'),
      ),
      drawer: const DrawerMenu(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (listaPessoas != null) ...[
            DropdownButtonFormField<PessoaModel>(
              value: selectedPessoa,
              items: listaPessoas?.map((item) {
                return DropdownMenuItem<PessoaModel>(
                  value: item,
                  child: Text('${item.nome}'),
                );
              }).toList(),
              onChanged: (PessoaModel? newValue) {
                setState(() {
                  selectedPessoa = newValue;
                  _loadCalculos();
                });
              },
              hint: const Text('Selecione uma pessoa'),
            ),
            const SizedBox(height: 10),
          ],
          Expanded(
            child: ListView.builder(
              itemCount: calculos.length,
              itemBuilder: (context, index) {
                final calculo = calculos[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: EdgeInsets.only(right: 20.0),
                    child: Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (direction) {
                    setState(() {
                      _deleteCalculo(calculo);
                      calculos.removeAt(index);
                    });
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Data da Realização: ${calculo.dataCalculo.toLocal()}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Peso: ${calculo.peso} kg'),
                                Text('Altura: ${calculo.altura} m'),
                              ],
                            ),
                          ),
                          SizedBox(width: 10),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  'Resultado IMC: ${calculo.imcResultado!.toStringAsFixed(2)}'),
                              Text(
                                  'Faixa de IMC: ${_getFaixaIMC(calculo.faixaImcId!)}'),
                            ],
                          ),
                        ],
                      ),
                      Divider(thickness: 1, height: 20),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _getFaixaIMC(String idfaixa) {
    return ImcService.retornaDescricaoFaixaIMC(idfaixa);
  }

  Future<void> _deleteCalculo(CalculoIMCModel calculo) async {
    final prefsService = SharedPreferencesService();
    await prefsService.deleteCalculo(calculo);
  }
}
