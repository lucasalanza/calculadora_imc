import 'package:calculadora_imc/screens/AddPersonScreen.dart';
import 'package:calculadora_imc/screens/CalculoIMCScreen.dart';
import 'package:calculadora_imc/screens/dadosIMC.dart';
import 'package:flutter/material.dart';
import 'HistoricoScreen.dart';
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
    // _loadPessoas();
  }

  Future<void> _loadPessoas() async {
    // final prefsService = SharedPreferencesService();
    // final loadedPessoas = await prefsService.loadPessoas();
    setState(() {
      // pessoas = loadedPessoas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('IMC Calculator'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const HistoricoScreen(
                            pessoaId: 0,
                          )),
                );
              },
              child: const Text('Histórico de Cálculos'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const dadosImcScreen()),
                );
              },
              child: const Text('Entenda os Resultados'),
            ),
          ],
        ),
      ),
    );
  }
}
