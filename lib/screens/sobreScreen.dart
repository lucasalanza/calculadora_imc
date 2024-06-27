// ignore_for_file: file_names, camel_case_types, constant_identifier_names

import 'package:calculadora_imc/components/IMCCard.dart';
import 'package:calculadora_imc/components/menu.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre'),
      ),
      drawer: const DrawerMenu(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  const Text(
                    'Este aplicativo foi desenvolvido para calcular o Índice de Massa Corporal (IMC) e fornecer informações sobre a saúde com base nos resultados obtidos. É importante lembrar que as informações apresentadas aqui não substituem o acompanhamento médico. Consulte um profissional de saúde para orientações específicas.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Desenvolvido por LLanza',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Veja nossos outros aplicativos',
                    style: TextStyle(fontSize: 20),
                  ),
                  InkWell(
                    onTap: () => _launchURL(
                        'https://play.google.com/store/apps/dev?id=8697736861741816576'),
                    child: Image.asset(
                      "assets/logogoogleplay.png",
                      height: 100,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Todas as informações do aplicativo foram retiradas do Site da Abeso ',
                    style: TextStyle(fontSize: 16),
                  ),
                  InkWell(
                    onTap: () => _launchURL(
                        'https://abeso.org.br/obesidade-e-sindrome-metabolica/calculadora-imc/'),
                    child: Image.asset(
                      "assets/abeso.png",
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Aplicativo desenvolvido em Junho 2024.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _launchURL(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }
}
