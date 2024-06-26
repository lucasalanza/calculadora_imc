// ignore_for_file: file_names, camel_case_types, constant_identifier_names

import 'package:calculadora_imc/components/IMCCard.dart';
import 'package:calculadora_imc/components/menu.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

import '../models/calculoIMCModel.dart';
import '../models/faixaImcModel.dart';
import '../services/imcService.dart';

class sobreScreen extends StatefulWidget {
  const sobreScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _sobreScreenState createState() => _sobreScreenState();
}

class _sobreScreenState extends State<sobreScreen> {
  Sexo _sexoSelecionado = Sexo.homem;

  void _trocaSexoExibido(Sexo? sexo) {
    setState(() {
      _sexoSelecionado = sexo!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
      ),
      drawer: const DrawerMenu(),
      body: Center(
        child: Column(
          children: [Text('Dados do app e do desenvolvedor')],
        ),
      ),
    );
  }
}
