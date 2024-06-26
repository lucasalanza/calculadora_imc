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
              color: Colors.blue,
            ),
            child: Text(
              'Menu',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
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
