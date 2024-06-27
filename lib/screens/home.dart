import 'package:calculadora_imc/components/menu.dart';
import 'package:flutter/material.dart';
import 'package:calculadora_imc/screens/personScreen.dart';
import 'package:calculadora_imc/screens/CalculoIMCScreen.dart';
import 'package:calculadora_imc/screens/dadosIMC.dart';
import 'package:calculadora_imc/screens/HistoricoScreen.dart';
import 'package:calculadora_imc/screens/SobreScreen.dart';
import '../models/pessoaModel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<PessoaModel> pessoas = [];

  @override
  void initState() {
    super.initState();
    //  _loadPessoas();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
      ),
      drawer: const DrawerMenu(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Image.asset(
                        'assets/logoimc.png',
                        height: constraints.maxHeight / 5,
                        fit: BoxFit.contain,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Bem-vindo!',
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'O IMC é usado para calcular se uma pessoa está no peso ideal. '
                        'Ele é determinado dividindo o peso da pessoa pela sua altura ao quadrado. '
                        'Aqui você consegue fazer o cálculo, ver o histórico dos cálculos realizados e entender melhor os resultados.',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 20),
                      Container(
                        color: Colors.yellow.shade100,
                        padding: const EdgeInsets.all(8.0),
                        child: const Text(
                          'Atenção, as informações aqui apresentadas não substituem um acompanhamento médico. Consulte um profissional de saúde antes de tomar qualquer decisão baseada nos cálculos apresentados.',
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text("Vamos começar?"),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const PersonScreen()),
                        );
                      },
                      child: const Text('Cadastrar nova pessoa'),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const CalculoIMCScreen()),
                        );
                      },
                      child: const Text('Calcular IMC'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
