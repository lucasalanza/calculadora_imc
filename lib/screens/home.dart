import 'package:calculadora_imc/screens/AddPersonScreen.dart';
import 'package:calculadora_imc/screens/CalculoIMCScreen.dart';
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
                  MaterialPageRoute(builder: (context) => CalculoIMCScreen()),
                );
              },
              child: const Text('Calcular IMC'),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(builder: (context) => AddPersonScreen()),
            //     ).then((_) {
            //       _loadPessoas();
            //     });
            //   },
            //   child: const Text('Cadastrar Nova Pessoa'),
            // ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => HistoricoScreen(
                            pessoaId: 0,
                          )),
                );
              },
              child: const Text('Histórico de Cálculos'),
            ),
          ],
        ),
      ),
    );
  }
}
