// ignore_for_file: file_names

import 'package:flutter/material.dart';
import '../models/faixaImcModel.dart';

class IMCCard extends StatelessWidget {
  final FaixaImcModel faixaImcModel;

  const IMCCard({
    super.key,
    required this.faixaImcModel,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(left: 18.0, right: 18, top: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 200,
            color: Colors.white,
            child: Image.asset(
              'assets/${faixaImcModel.id}.png',
              fit: BoxFit.contain,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(
              faixaImcModel.faixaFim != null
                  ? 'Entre ${faixaImcModel.faixaInicio} e ${faixaImcModel.faixaFim}'
                  : 'Acima de ${faixaImcModel.faixaInicio}',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              faixaImcModel.classificacao,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              faixaImcModel.descricao,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}
