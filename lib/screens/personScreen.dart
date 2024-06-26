// ignore_for_file: library_private_types_in_public_api

import 'package:calculadora_imc/components/menu.dart';
import 'package:calculadora_imc/models/calculoIMCModel.dart';
import 'package:calculadora_imc/screens/CalculoIMCScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/pessoaModel.dart';
import '../services/SharedPreferencesService.dart';

class PersonScreen extends StatefulWidget {
  const PersonScreen({super.key});

  @override
  _PersonScreenState createState() => _PersonScreenState();
}

class _PersonScreenState extends State<PersonScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _alturaController = TextEditingController();
  Sexo? _sexoSelecionado = Sexo.homem;

  List<PessoaModel> _pessoas = [];
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  @override
  void initState() {
    super.initState();
    _loadPessoas();
  }

  Future<void> _loadPessoas() async {
    final pessoas = await _prefsService.loadPessoas();
    setState(() {
      _pessoas = pessoas;
    });
  }

  void _trocaSexoExibido(Sexo? sexo) {
    setState(() {
      _sexoSelecionado = sexo;
    });
  }

  void _showModal({PessoaModel? pessoa}) {
    if (pessoa != null) {
      _nomeController.text = pessoa.nome;
      _alturaController.text = pessoa.altura.toString().replaceAll('.', ',');
      _sexoSelecionado = pessoa.sexo;
    } else {
      _nomeController.clear();
      _alturaController.clear();
      _sexoSelecionado = Sexo.homem;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(pessoa != null ? 'Editar Pessoa' : 'Adicionar Pessoa'),
        content: StatefulBuilder(
          builder: (context, setState) {
            return Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Text("Sexo"),
                      IconButton(
                        icon: const Icon(Icons.help_outline),
                        onPressed: _showSexoInfo,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio<Sexo>(
                        value: Sexo.homem,
                        activeColor: const Color.fromARGB(255, 16, 101, 171),
                        groupValue: _sexoSelecionado,
                        onChanged: (Sexo? value) {
                          setState(() {
                            _trocaSexoExibido(value);
                          });
                        },
                      ),
                      const Text('Homem'),
                      Radio<Sexo>(
                        activeColor: const Color.fromARGB(199, 188, 21, 77),
                        value: Sexo.mulher,
                        groupValue: _sexoSelecionado,
                        onChanged: (Sexo? value) {
                          setState(() {
                            _trocaSexoExibido(value);
                          });
                        },
                      ),
                      const Text('Mulher'),
                    ],
                  ),
                  TextFormField(
                    controller: _nomeController,
                    decoration: const InputDecoration(labelText: 'Nome'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira o nome';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _alturaController,
                    decoration: const InputDecoration(labelText: 'Altura (m)'),
                    keyboardType:
                        TextInputType.numberWithOptions(decimal: true),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d*\,?\d*$')),
                    ],
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a altura';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            );
          },
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () {
              if (pessoa != null) {
                _saveEditPessoa(pessoa);
              } else {
                _addPerson();
              }
            },
            child: const Text('Salvar'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveEditPessoa(PessoaModel pessoa) async {
    if (_formKey.currentState!.validate()) {
      pessoa.nome = _nomeController.text;
      pessoa.altura = double.parse(_alturaController.text.replaceAll(',', '.'));
      pessoa.sexo = _sexoSelecionado!;

      await _prefsService.savePessoas(_pessoas);
      _loadPessoas();
      Navigator.pop(context);
    }
  }

  Future<void> _addPerson() async {
    if (_formKey.currentState!.validate()) {
      final newPerson = PessoaModel(
        id: DateTime.now().millisecondsSinceEpoch,
        nome: _nomeController.text,
        sexo: _sexoSelecionado!,
        altura: double.parse(_alturaController.text.replaceAll(',', '.')),
      );

      _pessoas.add(newPerson);
      await _prefsService.savePessoas(_pessoas);

      _loadPessoas();
      Navigator.pop(context);
    }
  }

  Future<bool?> _confirmDeletePessoa(PessoaModel pessoa) async {
    final confirmDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar Exclusão'),
        content: const Text('Você tem certeza que deseja excluir esta pessoa?'),
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
      await _prefsService.deletePessoa(pessoa);
      _loadPessoas();
    }
    return confirmDelete;
  }

  void _showSexoInfo() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Informação'),
        content: const Text(
          'A escolha do sexo é utilizada para definir em qual faixa o resultado deve ser enquadrado. '
          'Saiba mais na tela "Entenda os Resultados" ',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text('Fechar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pessoas'),
      ),
      drawer: const DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  onPressed: () {
                    _showModal();
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
            const Text("Pessoas cadastradas"),
            Expanded(
              child: ListView.builder(
                itemCount: _pessoas.length,
                itemBuilder: (context, index) {
                  final pessoa = _pessoas[index];
                  return Dismissible(
                    key: Key(pessoa.id.toString()),
                    direction: DismissDirection.endToStart,
                    confirmDismiss: (direction) => _confirmDeletePessoa(pessoa),
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(
                        Icons.delete,
                        color: Colors.white,
                      ),
                    ),
                    child: ListTile(
                      title: Text(pessoa.nome),
                      subtitle: Text(
                        'Altura: ${pessoa.altura.toString().replaceAll('.', ',')}\nSexo: ${pessoa.sexo == Sexo.homem ? 'Homem' : 'Mulher'}',
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _showModal(pessoa: pessoa);
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
