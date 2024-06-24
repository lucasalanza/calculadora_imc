// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import '../models/calculoIMCModel.dart';
import '../models/pessoaModel.dart';
import '../services/SharedPreferencesService.dart';

class AddPersonScreen extends StatefulWidget {
  const AddPersonScreen({super.key});

  @override
  _AddPersonScreenState createState() => _AddPersonScreenState();
}

class _AddPersonScreenState extends State<AddPersonScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _alturaController = TextEditingController();
  Sexo? _sexoSelecionado = Sexo.homem;

  void _trocaSexoExibido(Sexo? sexo) {
    setState(() {
      _sexoSelecionado = sexo;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastrar Nova Pessoa'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
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

      Navigator.pop(context);
    }
  }
}
