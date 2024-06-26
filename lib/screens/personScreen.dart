// ignore_for_file: library_private_types_in_public_api

import 'package:calculadora_imc/components/menu.dart';
import 'package:flutter/material.dart';
import '../models/calculoIMCModel.dart';
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
  SharedPreferencesService _prefsService = SharedPreferencesService();

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

  void _editPessoa(PessoaModel pessoa) {
    _nomeController.text = pessoa.nome;
    _alturaController.text = pessoa.altura.toString();
    _sexoSelecionado = pessoa.sexo;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar Pessoa'),
        content: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Radio<Sexo>(
                    value: Sexo.homem,
                    activeColor: const Color.fromARGB(255, 16, 101, 171),
                    groupValue: _sexoSelecionado,
                    onChanged: (Sexo? value) {
                      _trocaSexoExibido(value);
                    },
                  ),
                  const Text('Homem'),
                  Radio<Sexo>(
                    activeColor: const Color.fromARGB(199, 188, 21, 77),
                    value: Sexo.mulher,
                    groupValue: _sexoSelecionado,
                    onChanged: (Sexo? value) {
                      _trocaSexoExibido(value);
                    },
                  ),
                  const Text('Mulher'),
                ],
              ),
              TextFormField(
                controller: _alturaController,
                decoration: const InputDecoration(labelText: 'Altura (m)'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a altura';
                  }
                  return null;
                },
              ),
            ],
          ),
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
              _saveEditPessoa(pessoa);
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
      pessoa.altura = double.parse(_alturaController.text);
      pessoa.sexo = _sexoSelecionado!;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Nova Pessoa'),
      ),
      drawer: const DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Form(
              key: _formKey,
              child: Column(
                children: [
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Radio<Sexo>(
                        value: Sexo.homem,
                        activeColor: const Color.fromARGB(255, 16, 101, 171),
                        groupValue: _sexoSelecionado,
                        onChanged: (Sexo? value) {
                          _trocaSexoExibido(value);
                        },
                      ),
                      const Text('Homem'),
                      Radio<Sexo>(
                        activeColor: const Color.fromARGB(199, 188, 21, 77),
                        value: Sexo.mulher,
                        groupValue: _sexoSelecionado,
                        onChanged: (Sexo? value) {
                          _trocaSexoExibido(value);
                        },
                      ),
                      const Text('Mulher'),
                    ],
                  ),
                  TextFormField(
                    controller: _alturaController,
                    decoration: const InputDecoration(labelText: 'Altura (m)'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Por favor, insira a altura';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    onPressed: _addPerson,
                    child: const Text('Cadastrar'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
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
                      subtitle: Text('Altura: ${pessoa.altura} m'),
                      trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          _editPessoa(pessoa);
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

  Future<void> _addPerson() async {
    if (_formKey.currentState!.validate()) {
      final newPerson = PessoaModel(
        id: DateTime.now().millisecondsSinceEpoch,
        nome: _nomeController.text,
        sexo: _sexoSelecionado!,
        altura: double.parse(_alturaController.text),
      );

      final prefsService = SharedPreferencesService();
      await prefsService.savePessoa(newPerson);

      _nomeController.clear();
      _alturaController.clear();
      _sexoSelecionado = Sexo.homem;

      _loadPessoas();
    }
  }
}
