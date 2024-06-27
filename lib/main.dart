import 'package:calculadora_imc/screens/dadosIMC.dart';
import 'package:calculadora_imc/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'services/imcService.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ImcService.loadImcData();
  await MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Calculadora de Imc',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromRGBO(195, 200, 200, 0.612)),
        //const Color.fromARGB(255, 194, 191, 11)),
        useMaterial3: true,
      ),
      // home: const dadosImcScreen(),
      home: const HomeScreen(),
      // home: const MyHomePage(title: 'Cálculo do IMC'),
    );
  }
}
