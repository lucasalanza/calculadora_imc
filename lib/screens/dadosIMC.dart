// ignore_for_file: file_names, camel_case_types, constant_identifier_names

import 'package:calculadora_imc/components/IMCCard.dart';
import 'package:lottie/lottie.dart';
import 'package:flutter/material.dart';

import '../models/calculoIMCModel.dart';
import '../models/faixaImcModel.dart';
import '../services/imcService.dart';

class dadosImcScreen extends StatefulWidget {
  const dadosImcScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _dadosImcScreenState createState() => _dadosImcScreenState();
}

class _dadosImcScreenState extends State<dadosImcScreen> {
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
        title: const Text('Sobre o IMC'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              'Entenda o resultado',
              style: TextStyle(fontSize: 22),
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
            Expanded(
                child: ListView(
              children: _sexoSelecionado == Sexo.homem
                  ? _buildCardsForMen()
                  : _buildCardsForWomen(),
            )),
          ],
        ),
      ),
    );
  }
}

List<Widget> _buildCardsForMen() {
  List<FaixaImcModel> faixaImcList =
      ImcService.getFaixaImcList().where((imc) => imc.sexo == 'h').toList();
  return [
    Column(
      children: [
        const Text(
          "Medida de risco da circunferência abdominal",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Lottie.asset('assets/gender_h.json'),
            ),
            const SizedBox(
              height: 10,
              width: 10,
            ),
            const Text(
              "94cm",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 16, 101, 171),
              ),
            )
          ],
        ),
      ],
    ),
    ...faixaImcList.map((imc) => IMCCard(faixaImcModel: imc)),
  ];
}

List<Widget> _buildCardsForWomen() {
  List<FaixaImcModel> faixaImcList =
      ImcService.getFaixaImcList().where((imc) => imc.sexo == 'm').toList();
  return [
    Column(
      children: [
        const Text(
          "Medida de risco da circunferência abdominal",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: 50,
              width: 50,
              child: Lottie.asset('assets/gender_m.json'),
            ),
            const SizedBox(
              height: 10,
              width: 10,
            ),
            const Text(
              "80cm",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(199, 188, 21, 77),
              ),
            )
          ],
        ),
      ],
    ),
    ...faixaImcList.map((imc) => IMCCard(faixaImcModel: imc)),
  ];
}
