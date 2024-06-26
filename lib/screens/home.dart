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

  // Future<void> _loadPessoas() async {
  //   // final prefsService = SharedPreferencesService();
  //   // final loadedPessoas = await prefsService.loadPessoas();
  //   setState(() {
  //     // pessoas = loadedPessoas;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora de IMC'),
      ),
      drawer: const DrawerMenu(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Bem-vindo!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            const Padding(
              padding: EdgeInsets.only(left: 8, right: 8),
              child: Text(
                'O Índice de Massa Corporal (IMC) é uma medida internacional usada para calcular se uma pessoa está no peso ideal. '
                'Ele é determinado dividindo o peso da pessoa pela sua altura ao quadrado. Aqui voce consegue calcular '
                'seu IMC, ver o histórico dos cálculos realizados e entender melhor os resultados.',
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Como usar o App:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '1. Utilize o menu lateral para navegar entre as opções.\n'
              '2. Clique em "Calcular IMC" para fazer um novo cálculo.\n'
              '3. Veja seu histórico de cálculos na seção "Histórico de Cálculos".\n'
              '4. Entenda melhor os resultados na seção "Entenda os Resultados".\n',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 32),
            const Text("Vamos começar?"),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PersonScreen()),
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
    );
  }
}
