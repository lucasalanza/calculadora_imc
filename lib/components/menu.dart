import 'package:calculadora_imc/screens/home.dart';
import 'package:calculadora_imc/screens/personScreen.dart';
import 'package:flutter/material.dart';
import 'package:calculadora_imc/screens/CalculoIMCScreen.dart';
import 'package:calculadora_imc/screens/dadosIMC.dart';
import 'package:calculadora_imc/screens/HistoricoScreen.dart';
import 'package:calculadora_imc/screens/SobreScreen.dart';

class DrawerMenu extends StatelessWidget {
  const DrawerMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Color.fromRGBO(167, 171, 171, 0.612),
              //      color: Color.fromRGBO(235, 241, 241, 100),
            ),
            child: Center(
              child: Image(
                image: AssetImage("assets/logoimc.png"),
                height: 200,
                width: 200,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Inicio'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.calculate),
            title: const Text('Calcular IMC'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const CalculoIMCScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.person),
            title: const Text('Cadastrar pessoa'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const PersonScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Histórico de Cálculos'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const HistoricoScreen(pessoaId: 0)),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.info),
            title: const Text('Entenda os Resultados'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const dadosImcScreen()),
              );
            },
          ),
          const Spacer(), // Adiciona um espaçador para empurrar os itens para cima
          ListTile(
            leading: const Icon(Icons.help),
            title: const Text('Sobre o App'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const sobreScreen()),
              );
            },
          ),
        ],
      ),
    );
  }
}
