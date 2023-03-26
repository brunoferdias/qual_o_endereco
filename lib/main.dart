import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qual_e_o_endereco/HomeCep.dart';



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
