import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qual_e_o_endereco/insereCEP.dart';



void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Cep(),
  ));
}
