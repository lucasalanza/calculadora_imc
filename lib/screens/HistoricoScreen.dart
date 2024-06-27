import 'package:calculadora_imc/components/bannerAdmob.dart';
import 'package:calculadora_imc/components/menu.dart';
import 'package:calculadora_imc/screens/CalculoIMCScreen.dart';
import 'package:calculadora_imc/screens/personScreen.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  }

  Future<void> _loadData() async {
    final prefsService = SharedPreferencesService();
    final pessoas = await prefsService.loadPessoas();
    if (pessoas.isNotEmpty) {
      setState(() {
        listaPessoas = pessoas;
        selectedPessoa = pessoas.firstWhere(
            (pessoa) => pessoa.id == widget.pessoaId,
            orElse: () => pessoas.first);
      });
      await _loadCalculos();
    }
  }

  Future<void> _loadCalculos() async {
    if (selectedPessoa != null) {
      final prefsService = SharedPreferencesService();
      final loadedCalculos = await prefsService.loadCalculos();
      setState(() {
        calculos = loadedCalculos
            .where((c) => c.pessoaId == selectedPessoa!.id)
            .toList();
        calculos.sort((a, b) => b.dataCalculo.compareTo(a.dataCalculo));
      });
    }
  }

  Future<bool?> _confirmDeleteCalculo(CalculoIMCModel calculo) async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content:
            const Text('Você tem certeza que deseja excluir este cálculo?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context, true);
            },
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmDelete == true) {
      setState(() {
        _deleteCalculo(calculo);
        calculos.remove(calculo);
      });
    }
    return confirmDelete;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Histórico de Cálculos'),
      ),
      drawer: const DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PersonScreen()),
                    );
                  },
                  child: const Text('Adicionar Pessoa'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CalculoIMCScreen()),
                    );
                  },
                  child: const Text('Novo Cálculo'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            if (listaPessoas != null) ...[
              DropdownButtonFormField<PessoaModel>(
                value: selectedPessoa,
                items: listaPessoas?.map((item) {
                  return DropdownMenuItem<PessoaModel>(
                    value: item,
                    child: Text(item.nome),
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
                      padding: const EdgeInsets.only(right: 20.0),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) =>
                        _confirmDeleteCalculo(calculo),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Cálculo feito em: ${_formatDate(calculo.dataCalculo)}',
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text(calculo.sexo.toString().split('.')[1]),
                          Text(
                              'Altura: ${calculo.altura.toString().replaceAll('.', ',')} m - Peso: ${calculo.peso} kg '),
                          Text(
                            'IMC: ${calculo.imcResultado?.toStringAsFixed(2)} - ${_getFaixaIMC(calculo.faixaImcId!)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Divider(thickness: 1, height: 20),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            const BannerAds(),
          ],
        ),
      ),
    );
  }

  String _getFaixaIMC(String idfaixa) {
    return ImcService.retornaClassificacaoFaixaIMC(idfaixa);
  }

  Future<void> _deleteCalculo(CalculoIMCModel calculo) async {
    final prefsService = SharedPreferencesService();
    await prefsService.deleteCalculo(calculo);
  }

  String _formatDate(DateTime date) {
    final DateFormat formatter = DateFormat('dd/MM/yyyy HH:mm:ss');
    return formatter.format(date);
  }
}
